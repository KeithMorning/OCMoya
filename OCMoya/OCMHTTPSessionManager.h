//
//  OCMHTTPManager.h
//  OCMoya
//
//  Created by KeithXi on 05/04/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCMDefination.h"
#import "OCMDataRequestTask.h"
#import "OCMProgressResponse.h"
#import "OCMResponse.h"
#import "OCMoyaError.h"

typedef void(^completionClosure)(BOOL success, id _Nullable responseObject, OCMoyaError * _Nullable error);
typedef void(^progressClosure)(OCMProgressResponse *_Nullable uploadProgress);

@interface OCMHTTPSessionManager : OCMURLSessionManager


/**
 Responses sent from the server in data tasks created with `dataTaskWithRequest:success:failure:` and run using the `GET` / `POST` / et al. convenience methods are automatically validated and serialized by the response serializer. By default, this property is set to an instance of `AFJSONResponseSerializer`.
 
 @warning `responseSerializer` must not be `nil`.
 */
@property (nonatomic, strong,nonnull) OCMHTTPResponseSerializer <OCMURLResponseSerialization> * responseSerializer;

//if you
@property (nonatomic,weak,nullable) id<OCMRequestRetrier> retrier;


/**
 whether to start requests immediately after being constructed, default is NO
 */
@property (nonatomic,assign) BOOL startRequestsImmediately;



- (nullable OCMDataRequestTask *)dataTaskWithRequest:(nonnull NSURLRequest *)request
                             uploadProgress:(nullable void (^)(OCMProgressResponse * _Nullable uploadProgress)) uploadProgress
                           downloadProgress:(nullable void (^)(OCMProgressResponse * _Nullable downloadProgress)) downloadProgress
                                          completion:(nullable void(^)(BOOL success, id _Nullable responseObject, OCMoyaError * _Nullable error))completionClosure;

- (void)retryWithTask:(nonnull OCMRequestTask *)task
                error:(nullable OCMoyaError *)error
       uploadProgress:(nullable progressClosure) uploadProgressClosure
     downloadProgress:(nullable progressClosure) downloadProgressClosure
           completion:(nullable completionClosure)completionClosure;

@end
