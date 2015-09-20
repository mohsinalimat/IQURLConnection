//
//  IQURLConnection.h
// https://github.com/hackiftekhar/IQURLConnection
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

/*! @abstract Downloadeded NSData will return through IQDataCompletionBlock */
typedef void (^IQDataCompletionBlock)(NSData * result, NSError *error);
typedef void (^IQResponseBlock)(NSHTTPURLResponse* response);
typedef void (^IQProgressBlock)(CGFloat progress);

#import <Foundation/NSURLConnection.h>

@interface IQURLConnection : NSURLConnection

@property(nonatomic, strong, readonly) NSHTTPURLResponse *response;
@property(nonatomic, assign, readonly) CGFloat downloadProgress;
@property(nonatomic, assign, readonly) CGFloat uploadProgress;
@property(nonatomic, strong, readonly) NSData *responseData;
@property(nonatomic, strong, readonly) NSError *error;

@property(nonatomic, strong) IQProgressBlock         uploadProgressBlock;
@property(nonatomic, strong) IQProgressBlock         downloadProgressBlock;
@property(nonatomic, strong) IQResponseBlock         responseBlock;

@property(nonatomic, strong, readonly) NSCachedURLResponse *cachedURLResponse;

//It automatically fires `start` method.
+ (instancetype)sendAsynchronousRequest:(NSURLRequest *)request responseBlock:(IQResponseBlock)responseBlock uploadProgressBlock:(IQProgressBlock)uploadProgress downloadProgressBlock:(IQProgressBlock)downloadProgress completionHandler:(IQDataCompletionBlock)completion;

- (instancetype)initWithRequest:(NSURLRequest *)request responseBlock:(IQResponseBlock*)responseBlock uploadProgressBlock:(IQProgressBlock*)uploadProgress downloadProgressBlock:(IQProgressBlock*)downloadProgress completionBlock:(IQDataCompletionBlock*)completion;

////Functions of IQURLConnection start and cancel
//- (void)start;
//- (void)cancel;

@end
