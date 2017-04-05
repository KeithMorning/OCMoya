//
//  OCMResult.m
//  OCMoya
//
//  Created by KeithXi on 05/04/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import "OCMResult.h"

@interface OCMResult<ObjectType,ErrorType>()

@end

@implementation OCMResult

- (instancetype)initWithSuccess:(id)success{
    if (self = [super init]) {
        _success = success;
    }
    return self;
}

- (instancetype)initWithFailure:(id)error{
    if (self = [super init]) {
        _error = error;
    }
    
    return self;
}

@end
