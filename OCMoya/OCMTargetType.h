//
//  OCMTargetType.h
//  OCMoya
//
//  Created by KeithXi on 23/03/2017.
//  Copyright © 2017 KeithXi. All rights reserved.
//

#ifndef OCMTargetType_h
#define OCMTargetType_h

#import <Foundation/Foundation.h>
#import "OCMDefination.h"
#import "OCMoyaTargetTask.h"

@protocol OCMTargetType <NSObject>

@property (nonatomic,copy,readonly) NSString *baseURL;

@property (nonatomic,copy) NSString *path;

@property (nonatomic,assign) OCMMethod method;

@property (nonatomic,copy) NSDictionary<NSString *,id> *bodyParameters;

@property (nonatomic,copy) NSDictionary<NSString *,id> *urlParameters;

@property (nonatomic,assign) OCMParameterEncoding parameterEncoding;

@property (nonatomic,copy) NSData *sampleData;

@property (nonatomic,strong) OCMoyaTargetTask *taskType;

@property (nonatomic,assign) NSUInteger retryMaxCount;

@property (nonatomic,assign) NSTimeInterval retryDelay;

@end


#endif /* OCMTargetType_h */
