//
//  OCMProgressReponse.m
//  OCMoya
//
//  Created by KeithXi on 05/04/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import "OCMProgressResponse.h"

@implementation OCMProgressResponse

- (instancetype)initWith:(NSProgress *)progress{
    if (self = [super init]) {
        _progressObject = progress;
    }
    
    return self;
}

- (double)progress{
    return self.progressObject.fractionCompleted?:1.0;
}

- (BOOL)completed{
    return self.progress == 1.0;
}

@end
