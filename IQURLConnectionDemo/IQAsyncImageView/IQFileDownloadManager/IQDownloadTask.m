//
// IQDownloadTask.m
// https://github.com/hackiftekhar/IQAsyncImageView
// Copyright (c) 2013-14 Iftekhar Qurashi.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "IQDownloadTask.h"
#import "IQURLConnection.h"
#import "IQDataCache.h"

NSString *const IQDownloadTaskDidFinishNotification      =   @"IQDownloadTaskDidFinishNotification";

@implementation IQDownloadTask
{
    NSMutableSet *progressTargets;
    NSMutableSet *completionTargets;
    
    __block IQURLConnection *_connection;
    
    NSData *_dataToResume;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        progressTargets = [[NSMutableSet alloc] init];
        completionTargets = [[NSMutableSet alloc] init];
    }
    return self;
}

-(void)startDownload
{
    _status = IQDownloadTaskStatusPrepareDownloading;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.fileURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:300];

    _connection = [[IQURLConnection alloc] initWithRequest:request resumeData:_dataToResume responseBlock:NULL uploadProgressBlock:NULL downloadProgressBlock:^(CGFloat progress) {
        _progress = progress;
        _status = IQDownloadTaskStatusDownloading;
        
        for (NSInvocation *invocation in progressTargets)
        {
            [invocation setArgument:&progress atIndex:2];
            [invocation invoke];
        }
    } completionBlock:^(NSData *result, NSError *error) {
        if ([error code] == kIQUserCancelErrorCode)
        {
            _status = IQDownloadTaskStatusPaused;
            _dataToResume = result;
        }
        else
        {
            if (result && error == nil)
            {
                _status = IQDownloadTaskStatusDownloaded;
                [[IQDataCache sharedCache] storeData:result forURL:self.fileURL.absoluteString];
            }
            else
            {
                _status = IQDownloadTaskStatusFailed;
            }
            
            _connection = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:IQDownloadTaskDidFinishNotification object:self];
        }
        
        for (NSInvocation *invocation in completionTargets)
        {
            [invocation setArgument:&result atIndex:2];
            [invocation setArgument:&error atIndex:3];
            [invocation invoke];
        }
    }];

    [_connection start];
}

-(void)pauseDownload
{
    [_connection cancel];
}

-(void)resumeDownload
{
    [self startDownload];
    
    for (NSInvocation *invocation in progressTargets)
    {
        [invocation setArgument:&_progress atIndex:2];
        [invocation invoke];
    }
}

-(void)cancelDownload
{
    [_connection cancel];
    _connection = nil;
    _dataToResume = nil;
    [progressTargets removeAllObjects];
    [completionTargets removeAllObjects];
}

- (void)addProgressTarget:(id)target action:(SEL)action
{
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:action]];
    invocation.target = target;
    invocation.selector = action;
    
    [progressTargets addObject:invocation];
}

- (void)removeProgressTarget:(id)target action:(SEL)action
{
    NSInvocation *invocation = nil;
    
    for (NSInvocation *progressInvocation in progressTargets)
    {
        if ([progressInvocation.target isEqual:target] && progressInvocation.selector == action)
        {
            invocation = progressInvocation;
            break;
        }
    }
    
    if (invocation)
    {
        [progressTargets removeObject:invocation];
    }
}

- (void)addCompletionTarget:(id)target action:(SEL)action
{
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:action]];
    invocation.target = target;
    invocation.selector = action;
    [completionTargets addObject:invocation];
}

- (void)removeCompletionTarget:(id)target action:(SEL)action
{
    NSInvocation *invocation = nil;
    
    for (NSInvocation *completionInvocation in completionTargets)
    {
        if ([completionInvocation.target isEqual:target] && completionInvocation.selector == action)
        {
            invocation = completionInvocation;
            break;
        }
    }
    
    if (invocation)
    {
        [completionTargets removeObject:invocation];
    }
}

@end
