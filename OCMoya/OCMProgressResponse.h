//
//  OCMProgressReponse.h
//  OCMoya
//
//  Created by KeithXi on 05/04/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCMResponse.h"

@interface OCMProgressResponse : NSObject

@property (nonatomic,strong,readonly) NSProgress *progressObject;

@property (nonatomic,assign,readonly) double progress;

@property (nonatomic,assign,readonly) BOOL completed;

- (instancetype)initWith:(NSProgress *)progress;

@end
