//
//  OCMProgressReponse.m
//  OCMoya
//
//  Created by KeithXi on 05/04/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import "OCMProgressReponse.h"

@implementation OCMProgressReponse

- (instancetype)initWith:(NSProgress *)progress response:(OCMResponse *)response{
    if (self = [super init]) {
        _progressObject = progress;
        _response = response;
    }
    
    return self;
}

- (double)progress{
    return self.progressObject.fractionCompleted?:1.0;
}

- (BOOL)completed{
    return self.progress == 1.0 && self.response != nil;
}

@end
