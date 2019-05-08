//
//  OCMEndPoint.h
//  OCMoya
//
//  Created by KeithXi on 24/03/2017.
//  Copyright © 2017 KeithXi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCMTargetType.h"
#import "OCMoyaTargetTask.h"
#import "OCMRequestTask.h"
#import "OCMoyaTargetUploadTask.h"

@interface OCMEndpointSampleResponse : NSObject

@property (nonatomic,assign) NSInteger statusCode;

@property (nonatomic,strong) NSHTTPURLResponse *response;

@property (nonatomic,strong) NSData *data;

@property (nonatomic,strong) NSError *error;

- (instancetype)initWithStatusCode:(NSInteger)statusCode data:(NSData *)data error:(NSError *)error;

@end

typedef OCMEndpointSampleResponse*(^OCMEndpointSampleResponseClosure)(void);
typedef NSDictionary<NSString *,id> parameterType;
typedef NSDictionary<NSString *,NSString *> httpHeaderType;

@interface OCMEndpoint : NSObject

@property (nonatomic,copy,readonly) NSString *url;

@property (nonatomic,assign,readonly) OCMMethod method;

@property (nonatomic,copy,readonly) OCMEndpointSampleResponseClosure sampleResponseClosure;

@property (nonatomic,copy,readonly) parameterType *parameters;

@property (nonatomic,assign,readonly) OCMParameterEncoding parameterEncoding;

@property (nonatomic,copy,readonly) httpHeaderType *httpHeaderFields;

@property (nonatomic,strong,readonly) NSURLRequest *urlRequest;

- (instancetype)initWithURL:(nonnull NSString *)url
      sampleResponseClosure:(nullable OCMEndpointSampleResponseClosure)closure
                     method:(OCMMethod)method
                 parameters:(nullable NSDictionary<NSString *,id> *)parameters
          parameterEncoding:(OCMParameterEncoding)encoding
           httpHeaderFields:(nullable NSDictionary<NSString *,NSString *> *)httpHeaderFields;

- (nonnull OCMEndpoint *)addingHttpHeaderFields:(nullable httpHeaderType *)httpHeaderFields;

- (nonnull OCMEndpoint *)addingParameters:(nullable parameterType *)parameters
                         httpHeaderFields:(nullable httpHeaderType *)httpHeaders;

- (nonnull OCMEndpoint *)addingUpload:(nonnull OCMoyaTargetUploadMultipartTask *)targetTask;


@end
