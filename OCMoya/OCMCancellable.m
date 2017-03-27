//
//  OCMCancellable.m
//  OCMoya
//
//  Created by KeithXi on 27/03/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import "OCMCancellable.h"


@implementation OCMSimpleCancellable

- (void)cancel{
    self.isCancelled = YES;
}

@end

@interface OCMCancellableWrapper()

@property (nonatomic,strong) id<OCMCancellable> innerCancellable;

@end

@implementation OCMCancellableWrapper

- (instancetype)init{
    if (self = [super init]) {
        _innerCancellable = [OCMSimpleCancellable new];
    }
    
    return self;
}

- (void)cancel{
    [self.innerCancellable cancel];
}

@end
