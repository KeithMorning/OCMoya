//
//  OCMCancellableToken.m
//  OCMoya
//
//  Created by KeithXi on 05/04/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import "OCMCancellableToken.h"

@interface OCMCancellableToken ()

@property (nonatomic,strong) dispatch_semaphore_t semaphore;

@property (nonatomic,strong) OCMRequestTask *requestTask;

@end


@implementation OCMCancellableToken

- (instancetype)init{
    if (self = [super init]) {
        _semaphore =  dispatch_semaphore_create(1);
    }
    
    return self;
}

- (instancetype)initWithRequestTask:(OCMRequestTask *)requestTask{
    if (self = [self init]) {
        _requestTask = requestTask;
    }
    
    return self;
}


- (void)cancel{
    

    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    
    if (self.isCancelled) {
        return;
    }
    
    [self.requestTask cancel];
    self.isCancelled = YES;
    dispatch_semaphore_signal(self.semaphore);
}



@end
