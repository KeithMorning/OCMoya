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

@interface OCMRequestTask : NSObject

@property (nonatomic, strong,readonly) NSURLSessionTask *task;

@property (nonatomic, strong,readonly) NSURLRequest *request;

@property (nonatomic, strong,readonly) NSURLResponse *response;

@property (nonatomic, weak,readonly) NSURLSession *session;

@property (nonatomic,assign,readonly) NSInteger retryCount;

@property (nonatomic,assign,readonly) CFAbsoluteTime startTime;

@property (nonatomic,assign,readonly) CFAbsoluteTime endTime;



- (instancetype)initWithSession:(NSURLSession *)session
                    requestTask:(NSURLSessionTask *)task;

- (void)resume;

- (void)suspend;

- (void)cancel;

- (void)increaseRertyCount;

//when retry, we may need to make a new task
- (void)updateTask:(NSURLSessionTask *)task;

@end
