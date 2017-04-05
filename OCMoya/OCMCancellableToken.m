//
//  OCMCancellableToken.m
//  OCMoya
//
//  Created by KeithXi on 05/04/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import "OCMCancellableToken.h"


@implementation OCMCancellableToken


- (void)cancel{
    [self.requestTask cancel];
    if (self.cancelAction) {
        self.cancelAction();
    }
}

- (void)retryIfneedWithError:(OCMoyaError *)error{
    
    if (self.requestTask.task.state != NSURLSessionTaskStateCanceling
       || self.requestTask.task.state != NSURLSessionTaskStateCompleted) {
        return;
    }
    
    if (!self.retrier) {
        return;
    }
    
    if (![self.retrier respondsToSelector:@selector(shouldretryRequest:error:)]) {
        return;
    }
    
    BOOL needRetry = [self.retrier shouldretryRequest:self.target error:error];
    
    if (!needRetry) {
        return;
    }
    
    if ([self.adapter respondsToSelector:@selector(adapt:)]) {
       NSURLRequest *request = [self.adapter adapt:self.requestTask.request];
        
    }
    
    
    
    
}

@end
