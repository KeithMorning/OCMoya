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

@interface OCMHTTPSessionManager : OCMURLSessionManager


/**
 Responses sent from the server in data tasks created with `dataTaskWithRequest:success:failure:` and run using the `GET` / `POST` / et al. convenience methods are automatically validated and serialized by the response serializer. By default, this property is set to an instance of `AFJSONResponseSerializer`.
 
 @warning `responseSerializer` must not be `nil`.
 */
@property (nonatomic, strong) OCMHTTPResponseSerializer <OCMURLResponseSerialization> * responseSerializer;



- (OCMDataRequestTask *)dataTaskWithRequest:(NSURLRequest *)request
                               uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadProgress
                             downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadProgress
                                      success:(void (^)(NSURLSessionDataTask *, id))success
                                      failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

- (void)retryWithTask:(OCMRequestTask *)task error:(OCMoyaError *)error;

@end
