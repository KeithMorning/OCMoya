//
//  OCMRequest.h
//  OCMoya
//
//  Created by KeithXi on 05/04/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCMDefination.h"
#import "OCMoyaError.h"
#import "OCMPlugin.h"
#import "OCMTargetType.h"

@class OCMRequestTask;

typedef void(^requestRetryCompletion)(BOOL shouldRetry, NSTimeInterval timeDelay);

//Give user a chance to know if need to make a retry
@protocol OCMRequestRetrier <NSObject>

- (void)shouldretryRequest:(OCMRequestTask *)task
                    target:(id<OCMTargetType>)target
                   manager:(OCMURLSessionManager *)sessionManager
                  response:(id)responseObj
                     error:(OCMoyaError *)error
                completion:(requestRetryCompletion)completion;


@end

@protocol OCMTaskConvertible <NSObject>

- (NSURLSessionTask *)taskWithTask:(NSURLSessionTask *)task target:(id<OCMTargetType>)target;


@end

@interface OCMRequestTask : NSObject<OCMRequestType>

@property (nonatomic, strong,readonly) NSURLSessionTask *task;

@property (nonatomic, strong,readonly) NSURLRequest *request;

@property (nonatomic, strong, readonly) id<OCMTargetType> orignalTarget;

@property (nonatomic, strong,readonly) NSURLResponse *response;

@property (nonatomic, weak,readonly) NSURLSession *session;

@property (nonatomic,assign,readonly) NSInteger retryCount;

@property (nonatomic,assign,readonly) CFAbsoluteTime startTime;

@property (nonatomic,assign) CFAbsoluteTime endTime;



/**
Make a task

 @param session the NSURLSession we use to make request
 @param task the request task when session return a datatask or downloadtask or uploadtask
 @param orignalTarget the orignal target
 @return the instance of a requestTask
 */
- (instancetype)initWithSession:(NSURLSession *)session
                    requestTask:(NSURLSessionTask *)task
                  orginalTarget:(id<OCMTargetType>)orignalTarget;

- (void)resume;

- (void)suspend;

- (void)cancel;

- (void)increaseRertyCount;

//when retry, we may need to make a new task
- (void)updateTask:(NSURLSessionTask *)task;

@end
