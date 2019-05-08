//
//  OCMResponse.h
//  OCMoya
//
//  Created by KeithXi on 27/03/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCMDefination.h"
#import "OCMoyaError.h"
#import "NSObject+HS_Coding.h"

@interface OCMResponse : NSObject

@property(nonatomic,assign,readonly) NSInteger statusCode;

@property (nonatomic,strong,readonly) NSData *data;

@property (nonatomic,strong,readonly) NSURLRequest *request;

@property (nonatomic,strong,readonly) NSURLResponse *response;

- (instancetype)initWithStatusCode:(NSInteger)statusCode
                              data:(NSData *)data
                           request:(NSURLRequest *)request
                          response:(NSURLResponse *)response;



@end


@interface OCMResponse (OCMDataMapping)

- (OCMImage *)mapImage:(OCMoyaError **)error;

- (id)mappJSON:(OCMoyaError **)error;

- (NSString *)mappStringWithKeyPath:(NSString *)keyPath error:(OCMoyaError **)error;

@end
