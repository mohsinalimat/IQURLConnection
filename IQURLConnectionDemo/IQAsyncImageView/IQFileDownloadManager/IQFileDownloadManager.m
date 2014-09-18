//
// IQFileDownloadManager.m
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

#import "IQFileDownloadManager.h"

@implementation IQFileDownloadManager
{
    NSMutableSet *downloadTasks;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        downloadTasks = [[NSMutableSet alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadTaskDidFinishNotification:) name:IQDownloadTaskDidFinishNotification object:nil];
    }
    return self;
}

-(NSArray*)tasks
{
    return [downloadTasks allObjects];
}

+(IQFileDownloadManager*)sharedManager
{
    static IQFileDownloadManager *manager;
    
    if (manager == nil)
    {
        manager = [[self alloc] init];
    }
    
    return manager;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(IQDownloadTask*)downloadTaskForURL:(NSURL*)url
{
    IQDownloadTask *task = [self existingTaskForURL:url];
    
    if (task == nil)
    {
        task = [[IQDownloadTask alloc] init];
        
        [downloadTasks addObject:task];
        
        task.fileURL = url;
        [task startDownload];
    }
    
    return task;
}

-(void)cancelDownloadTaskForURL:(NSURL*)url
{
    IQDownloadTask *task = [self existingTaskForURL:url];
    [task cancelDownload];
    [downloadTasks removeObject:task];
}

-(void)removeDownloadTask:(IQDownloadTask*)task
{
    [task cancelDownload];
    [downloadTasks removeObject:task];
}

-(IQDownloadTask*)existingTaskForURL:(NSURL*)url
{
    for (IQDownloadTask *task in downloadTasks)
        if ([task.fileURL isEqual:url])
            return task;
    
    return nil;
}

-(void)downloadTaskDidFinishNotification:(NSNotification*)notification
{
    [downloadTasks removeObject:notification.object];
}

@end
