//
//  OCMCancellableToken.h
//  OCMoya
//
//  Created by KeithXi on 05/04/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCMCancellable.h"
#import "OCMTargetType.h"
#import "OCMEndpoint.h"
#import "OCMRequestTask.h"


typedef void(^requestRetryCompletion)(BOOL shouldRetry, NSTimeInterval timeDelay);

@protocol OCMRequestAdapter <NSObject>

- (NSURLRequest *)adapt:(NSURLRequest *)request;

@end

//Give user a chance to know if need to make a retry
@protocol OCMRequestRetrier <NSObject>

- (BOOL)shouldretryRequest:(id<OCMTargetType>)target
                     error:(OCMoyaError *)error;

@end

@protocol OCMTaskConvertible <NSObject>

- (NSURLSessionTask *)taskWithAdapter:(id<OCMRequestAdapter>)adapter;

- (NSURLSessionTask *)taskWithOrignalTarget:(id<OCMTargetType>)target;

- (NSURLSessionTask *)taskwithURLRequest:(NSURLRequest *)request;

@end

@interface OCMCancellableToken : NSObject<OCMCancellable>

@property (nonatomic,assign) BOOL isCancelled;

@property (nonatomic,copy) void(^cancelAction)(void);

@property (nonatomic,strong) OCMRequestTask *requestTask;

@property (nonatomic,weak) id<OCMRequestAdapter> adapter;

/**
 the orginal target can re-create new endpoit-> new task
 */
@property (nonatomic,weak) id<OCMTargetType> target;


/**
 create a new task
 */
@property (nonatomic,weak) id<OCMTaskConvertible> updateTask;

@property (nonatomic,weak) id<OCMRequestRetrier> retrier;

- (void)retryIfneedWithError:(OCMoyaError *)error;


@end
