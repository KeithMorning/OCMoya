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
#import "OCMoyaTask.h"

@protocol OCMTargetType <NSObject>

@property (nonatomic,copy,readonly) NSString *baseURL;

@property (nonatomic,copy) NSString *path;

@property (nonatomic,assign) OCMMethod meathod;

@property (nonatomic,copy) NSDictionary<NSString *,id> *bodyParameters;

@property (nonatomic,copy) NSDictionary<NSString *,id> *urlParameters;

@property (nonatomic,assign) OCMParameterEncoding parameterEncoding;

@property (nonatomic,copy) NSData *sampleData;

@property (nonatomic,strong) OCMoyaTask *taskType;

@end


#endif /* OCMTargetType_h */
