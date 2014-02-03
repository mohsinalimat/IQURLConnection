//
//  IQAsynchronousRequest.h
//  Synchronize Manager
//
//  Created by Mohd Iftekhar Qurashi on 29/12/13.
//  Copyright (c) 2013 Iftekhar. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^CompletionBlock)(id result, NSError *error);
typedef void (^ResponseBlock)(NSURLResponse* response);
typedef void (^ProgressBlock)(CGFloat progress);


@interface IQURLConnection : NSURLConnection

+ (IQURLConnection*)sendAsynchronousRequest:(NSURLRequest *)request responseBlock:(ResponseBlock)responseBlock progressBlock:(ProgressBlock)progressBlock completionHandler:(CompletionBlock)completion;

@end
