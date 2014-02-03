//
//  IQAsynchronousRequest.m
//  Synchronize Manager
//
//  Created by Mohd Iftekhar Qurashi on 29/12/13.
//  Copyright (c) 2013 Iftekhar. All rights reserved.
//

#import "IQURLConnection.h"

@interface IQURLConnection ()
{
    CompletionBlock         _completion;
    ProgressBlock           _progress;
    ResponseBlock           _responseBlock;
    
    NSURLResponse* _response;
    NSMutableData* _data;
}

@end

@implementation IQURLConnection

static NSOperationQueue *operationQueue;

+(void)initialize
{
    [super initialize];
    operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue setMaxConcurrentOperationCount:1];
}

+ (IQURLConnection*)sendAsynchronousRequest:(NSURLRequest *)request responseBlock:(ResponseBlock)responseBlock progressBlock:(ProgressBlock)progressBlock completionHandler:(CompletionBlock)completion
{
    IQURLConnection *asyncRequest = [[IQURLConnection alloc] initWithRequest:request responseBlock:&responseBlock progressBlock:&progressBlock completionBlock:&completion];
    [asyncRequest start];

    return asyncRequest;
}

-(id)initWithRequest:(NSURLRequest *)request responseBlock:(ResponseBlock*)responseBlock progressBlock:(ProgressBlock*)progresBlock completionBlock:(CompletionBlock*)completion
{
    if (self = [super initWithRequest:request delegate:self startImmediately:NO])
    {
        [self setDelegateQueue:operationQueue];
        _progress = *progresBlock;
        _completion = *completion;
        _responseBlock = *responseBlock;
        
        _data = [[NSMutableData alloc] init];
    }
    return self;
}

-(void)sendProgress:(CGFloat)progress
{
    if (_progress && _response.expectedContentLength>0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            _progress(progress);
        });
    }
}

-(void)sendCompletionData:(NSData*)data error:(NSError*)error
{
    if (_completion)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            _completion(data,error);
        });
    }
}

-(void)sendResponse:(NSURLResponse*)response
{
    if (_responseBlock)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            _responseBlock(response);
        });
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _response = response;
    [self sendResponse:_response];
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    if (![httpResponse isKindOfClass:[NSHTTPURLResponse class]]) {
        // I don't know what kind of request this is!
        return;
    }
    
    NSLog(@"%@",httpResponse.allHeaderFields);
    NSLog(@"%d",httpResponse.statusCode);
    NSLog(@"%@",[NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode]);

    

    
    switch (httpResponse.statusCode) {
        case 206: {
            NSString *range = [httpResponse.allHeaderFields valueForKey:@"Content-Range"];
            NSError *error = nil;
            NSRegularExpression *regex = nil;
            
            // Check to see if the server returned a valid byte-range
            regex = [NSRegularExpression regularExpressionWithPattern:@"bytes (\\d+)-\\d+/\\d+"
                                                              options:NSRegularExpressionCaseInsensitive
                                                                error:&error];
            if (error) {
                break;
            }
            
            // If the regex didn't match the number of bytes, start the download from the beginning
            NSTextCheckingResult *match = [regex firstMatchInString:range
                                                            options:NSMatchingAnchored
                                                              range:NSMakeRange(0, range.length)];
            if (match.numberOfRanges < 2) {
                break;
            }
            
            // Extract the byte offset the server reported to us, and truncate our
            // file if it is starting us at "0".  Otherwise, seek our file to the
            // appropriate offset.
            NSString *byteStr = [range substringWithRange:[match rangeAtIndex:1]];
            NSInteger bytes = [byteStr integerValue];
            if (bytes <= 0) {
                break;
            } else {
            }
            break;
        }
            
        default:
            break;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
    [self sendProgress:((CGFloat)_data.length/(CGFloat)_response.expectedContentLength)];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self sendCompletionData:_data error:error];
}

-(void)cancel
{
    [super cancel];
    [self sendCompletionData:_data error:[NSError errorWithDomain:@"UserCancelDomain" code:100 userInfo:nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self sendCompletionData:_data error:nil];
}

- (void)connectionDidResumeDownloading:(NSURLConnection *)connection totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long) expectedTotalBytes
{
    NSLog(@"Resuming");
}

- (void)connection:(NSURLConnection *)connection didWriteData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long) expectedTotalBytes
{
//    [_data appendData:data];
    [self sendProgress:((CGFloat)_data.length/(CGFloat)_response.expectedContentLength)];
}


- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    [self sendProgress:(float)totalBytesWritten/(float)totalBytesExpectedToWrite];
}

@end
