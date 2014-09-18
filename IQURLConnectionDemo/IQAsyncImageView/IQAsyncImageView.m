//
// IQAsyncImageView.m
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

#import "IQAsyncImageView.h"
#import "IQDataCache.h"
#import "IQURLConnection.h"
#import "UAProgressView.h"
#import "IQFileDownloadManager.h"

@interface IQAsyncImageView ()

@property(nonatomic, strong) UAProgressView *progressView;
@property(nonatomic, strong) IQImageCompletionBlock completion;

@end

@implementation IQAsyncImageView
{
    IQDownloadTask *downloadTask;
    UIButton *buttonPauseResume;
}

-(void)loadImage:(NSString *)urlString
{
    [self loadImage:urlString completionHandler:NULL];
}

-(void)loadImage:(NSString *)urlString completionHandler:(IQImageCompletionBlock)completion
{
    _completion = completion;
    
    if ([urlString isKindOfClass:[NSNull class]] || [NSURL URLWithString:urlString] == nil)
    {
        [self progress:1.0];
        [self downloadingFinishWithData:nil error:[NSError errorWithDomain:NSStringFromClass([self class]) code:kIQInvalidURLErrorCode userInfo:nil]];
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSData *data = [[IQDataCache sharedCache] dataForURL:urlString];
            
            if (data)
            {
                [self progress:1.0];
                [self downloadingFinishWithData:data error:nil];
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = nil;
                    self.progressView.hidden = NO;

                    //Removing old callbacks
                    [self removeCallbacks];
                    
                    downloadTask = [[IQFileDownloadManager sharedManager] downloadTaskForURL:[NSURL URLWithString:urlString]];
                    [self.progressView setProgress:downloadTask.progress animated:NO];
                    
                    [downloadTask addProgressTarget:self action:@selector(progress:)];
                    [downloadTask addCompletionTarget:self action:@selector(downloadingFinishWithData:error:)];
                    
                    [self updateUI];
                });
            }
        });
    }
}

-(void)updateUI
{
    if (downloadTask.status == IQDownloadTaskStatusPaused)
    {
        buttonPauseResume.tag = 1;
        [buttonPauseResume setImage:[UIImage imageNamed:@"paused"] forState:UIControlStateNormal];
    }
    else
    {
        buttonPauseResume.tag = 0;
        [buttonPauseResume setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    }
}

-(void)progress:(CGFloat)progress
{
    _progress = progress;
    [self.progressView setProgress:progress animated:YES];
    
    [self updateUI];
}

-(void)downloadingFinishWithData:(NSData*)result error:(NSError*)error
{
    if (downloadTask.status == IQDownloadTaskStatusPaused)
    {
        buttonPauseResume.tag = 1;
        [buttonPauseResume setImage:[UIImage imageNamed:@"paused"] forState:UIControlStateNormal];
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UIImage *image = [[UIImage alloc] initWithData:result];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.image = image;
                self.progressView.hidden = YES;
                
                //Animation
                {
                    CATransition *transition = [CATransition animation];
                    transition.duration = 0.3f;
                    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                    transition.type = kCATransitionFade;
                    transition.removedOnCompletion = YES;
                    
                    [self.layer addAnimation:transition forKey:nil];
                }
                
                if (self.completion)
                {
                    self.completion(self.image, error);
                }
            });
        });
    }
}

-(UAProgressView *)progressView
{
    if (_progressView == nil)
    {
        _progressView = [[UAProgressView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        buttonPauseResume = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonPauseResume setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
       [buttonPauseResume setFrame:CGRectMake(0, 0, 32, 32)];
        [buttonPauseResume addTarget:self action:@selector(pauseResumeTapped:) forControlEvents:UIControlEventTouchUpInside];
        _progressView.centralView = buttonPauseResume;
        
        [self addSubview:_progressView];
    }
    
    return _progressView;
}

-(void)pauseResumeTapped:(UIButton*)button
{
    //Animation
    {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        transition.removedOnCompletion = YES;
        
        [button.layer addAnimation:transition forKey:nil];
    }

    if (button.tag == 0)
    {
        button.tag = 1;
        [button setImage:[UIImage imageNamed:@"paused"] forState:UIControlStateNormal];
        [downloadTask pauseDownload];
    }
    else
    {
        button.tag = 0;
        [button setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
        [downloadTask resumeDownload];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _progressView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

-(void)setImage:(UIImage *)image
{
    [super setImage:image];
    
    if (image)
    {
        self.progressView.hidden = YES;
    }
}

-(void)cancel
{
    [self removeCallbacks];
}

-(void)removeCallbacks
{
    self.completion = NULL;
    [downloadTask removeProgressTarget:self action:@selector(progress:)];
    [downloadTask removeCompletionTarget:self action:@selector(downloadingFinishWithData:error:)];
}

-(void)dealloc
{
    [self removeCallbacks];
}

@end
