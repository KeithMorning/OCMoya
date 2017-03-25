//
//  OCMEndPoint.h
//  OCMoya
//
//  Created by KeithXi on 24/03/2017.
//  Copyright © 2017 KeithXi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCMTargetType.h"

@interface OCMEndpointSampleResponse : NSObject

@property (nonatomic,strong) NSHTTPURLResponse *response;

@property (nonatomic,strong) NSData *data;

@property (nonatomic,strong) NSError *error;

@end

typedef OCMEndpointSampleResponse*(^OCMEndpointSampleResponseClosure)(void);


@interface OCMEndpoint : NSObject

@property (nonatomic,copy,readonly) NSString *url;

@property (nonatomic,assign,readonly) OCMMethod method;

@property (nonatomic,copy,readonly) OCMEndpointSampleResponseClosure sampleResponseClosure;

@property (nonatomic,copy,readonly) NSDictionary<NSString *,id> *parameters;

@property (nonatomic,assign,readonly) OCMParameterEncoding parameterEncoding;

@property (nonatomic,copy,readonly) NSDictionary<NSString *,NSString *> *httpHeaderFields;

- (instancetype)initWithURL:(nonnull NSString *)url
      sampleResponseClosure:(nullable OCMEndpointSampleResponseClosure)closure
                     method:(OCMMethod)method
                 parameters:(nullable NSDictionary<NSString *,NSString *> *)parameters
          parameterEncoding:(OCMParameterEncoding)encoding
           httpHeaderFields:(nullable NSDictionary<NSString *,NSString *> *)httpHeaderFields;

@end
