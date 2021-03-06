//
// IQURLConnectionTask.h
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

#import <Foundation/Foundation.h>

typedef enum IQURLConnectionTaskStatus
{
    IQURLConnectionTaskStatusNotStarted = 0,
    IQURLConnectionTaskStatusPreparing,
    IQURLConnectionTaskStatusUploading,
    IQURLConnectionTaskStatusDownloading,
    IQURLConnectionTaskStatusPaused,
    IQURLConnectionTaskStatusDownloaded,
    IQURLConnectionTaskStatusFailed,
}IQURLConnectionTaskStatus;


typedef enum IQTaskEvents
{
    /*  Method signature should be similar to `-(void)uploadProgress:(CGFloat)progress`    */
    IQTaskEventUploadProgress,

    /*  Method signature should be similar to `-(void)downloadProgress:(CGFloat)progress`    */
    IQTaskEventDownloadProgress,
    
    /*  Method signature should be similar to `-(void)finishWithData:(NSData*)result error:(NSError*)error`    */
    IQTaskEventFinish,
    
}IQTaskEvents;

extern NSString *const IQURLConnectionTaskDidFinishNotification;

@interface IQURLConnectionTask : NSObject

@property(nonatomic, readonly) IQURLConnectionTaskStatus status;
@property(nonatomic, copy) NSURL *fileURL;
@property(nonatomic, assign) CGFloat downloadProgress;
@property(nonatomic, assign) CGFloat uploadProgress;
@property(nonatomic, getter = isPaused, readonly) BOOL paused;

- (void)addTarget:(id)target action:(SEL)action forTaskEvents:(IQTaskEvents)taskEvents;

- (void)removeTarget:(id)target action:(SEL)action forTaskEvents:(IQTaskEvents)taskEvents;


-(void)start;
-(void)pause;
-(void)resume;
-(void)cancel;

@end
