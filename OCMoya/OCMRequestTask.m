//
//  OCMRequest.m
//  OCMoya
//
//  Created by KeithXi on 05/04/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import "OCMRequestTask.h"



@interface OCMRequestTask()

@property (nonatomic, strong) NSURLSessionTask *task;

@property (nonatomic, strong) NSURLRequest *request;

@property (nonatomic, strong) NSHTTPURLResponse *response;

@property (nonatomic, strong) id<OCMTargetType> orignalTarget;

@property (nonatomic, weak) NSURLSession *session;

@property (nonatomic,assign) NSInteger retryCount;

@property (nonatomic,assign) CFAbsoluteTime startTime;

@property (nonatomic,strong) NSRecursiveLock *lock;

@end

@implementation OCMRequestTask

- (instancetype)initWithSession:(NSURLSession *)session
                    requestTask:(NSURLSessionTask *)task
                  orginalTarget:(id<OCMTargetType>)orignalTarget{
    
    if (self = [super init]) {
        _session = session;
        _task = task;
        _retryCount = 0;
        _orignalTarget = orignalTarget;
        _lock = [NSRecursiveLock new];
    }
    
    return self;
}

- (void)resume{
    
    //TODO: resume need check the sessionManager queue satus
    
    if (self.task) {
        [self.task resume];
        if (self.startTime == -1) {
            self.startTime = CFAbsoluteTimeGetCurrent();
        }
    }

}

- (void)suspend{
    if (self.task) {
        [self.task suspend];
    }
}

- (void)cancel{
    if (self.task) {
        [self.task cancel];
    }
}

- (void)increaseRertyCount{
    [self.lock lock];
    self.retryCount++;
    [self.lock unlock];
}

- (NSURLRequest *)request{
    return self.task.originalRequest;
}

- (NSURLResponse *)response{
    return self.task.response;
}

- (void)updateTask:(NSURLSessionTask *)task{
    [self.lock lock];
    self.task = task;
    self.startTime = -1;
    self.endTime = -1;
    [self.lock unlock];
}

@end
