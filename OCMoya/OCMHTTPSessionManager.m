//
//  OCMHTTPManager.m
//  OCMoya
//
//  Created by KeithXi on 05/04/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import "OCMHTTPSessionManager.h"



@interface OCMHTTPSessionManager()


@end

@implementation OCMHTTPSessionManager
@dynamic responseSerializer;


- (void)setResponseSerializer:(OCMHTTPResponseSerializer <OCMURLResponseSerialization> *)responseSerializer {
    NSParameterAssert(responseSerializer);
    
    [super setResponseSerializer:responseSerializer];
}

- (OCMDataRequestTask *)dataTaskWithRequest:(NSURLRequest *)request
                             uploadProgress:(nullable progressClosure) uploadProgressClosure
                           downloadProgress:(nullable progressClosure) downloadProgressClosure
                                 completion:(nullable completionClosure)completionClosure{
    
    __block OCMDataRequestTask *task = [[OCMDataRequestTask alloc] initWithSession:self.session requestTask:nil];
    [self sessionDataTaskWithRequest:request uploadProgress:uploadProgressClosure downloadProgress:downloadProgressClosure completion:^(BOOL success, id  _Nullable responseObject, OCMoyaError * _Nullable error) {
        task.endTime = CFAbsoluteTimeGetCurrent();
        if (completionClosure) {
            completionClosure(success,responseObject,error);
        }
    }];
    
    if (self.startRequestsImmediately) {
        [task resume];
    }
    return task;
}


- (NSURLSessionDataTask *)sessionDataTaskWithRequest:(NSURLRequest *)request
                                  uploadProgress:(nullable progressClosure) uploadProgressClosure
                                downloadProgress:(nullable progressClosure) downloadProgressClosure
                                    completion:(nullable completionClosure)completionClosure
{
    
    __block NSURLSessionDataTask *dataTask = nil;

    dataTask = [self dataTaskWithRequest:request
                          uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
                              
                              if (!uploadProgressClosure) {
                                  return;
                              }
                              OCMProgressResponse  *progress = [[OCMProgressResponse alloc] initWith:uploadProgress];
                              uploadProgressClosure(progress);
    }
                
                        downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
                            
                            if (!downloadProgressClosure) {
                                return ;
                            }
                            OCMProgressResponse *progress = [[OCMProgressResponse alloc] initWith:downloadProgress];
                            downloadProgressClosure(progress);
    }
                
                       completionHandler:^(NSURLResponse * _Nonnull urlresponse, id  _Nullable responseObject, NSError * _Nullable error) {
                           
                           NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)urlresponse;
                           OCMResponse *response = [[OCMResponse alloc] initWithStatusCode:httpResponse.statusCode
                                                                                      data:responseObject
                                                                                   request:request
                                                                                  response:httpResponse];
                           
                           if (completionClosure) {
                               if (error) {
                                   OCMoyaError *aError = [[OCMoyaError alloc] initWithError:error
                                                                                  errorType:OCMoyaErrorTypeHttpFailed
                                                                                   response:response];
                                   completionClosure(NO,response,aError);
                               }else{
                                   completionClosure(YES,response,nil);
                               }
                           }
                           
        
    }];
    
    return dataTask;
}

- (void)retryWithTask:(OCMRequestTask *)task
                error:(OCMoyaError *)error
       uploadProgress:(nullable progressClosure) uploadProgressClosure
     downloadProgress:(nullable progressClosure) downloadProgressClosure
           completion:(nullable completionClosure)completionClosure{
    
    if (![self.retrier respondsToSelector:@selector(shouldretryRequest:manager:error:completion:)]) {
        return;
    }
    
    __weak typeof(self) weakself = self;
    [self.retrier shouldretryRequest:task
                                 manager:self
                                   error:error
                              completion:^(BOOL shouldRetry, NSTimeInterval timeDelay) {
                                  __strong typeof(self) strongself = weakself;
                                  if (!shouldRetry) {
                                      return;
                                  }
                                  
                                  void(^excute)() = ^{
                                  
                                      NSURLSessionDataTask  * newDataTask = [strongself convertTask:task
                                                                                     uploadProgress:uploadProgressClosure
                                                                                   downloadProgress:downloadProgressClosure
                                                                                         completion:^(BOOL success, id  _Nullable responseObject, OCMoyaError * _Nullable error) {
                                                                                             
                                                                                             task.endTime = CFAbsoluteTimeGetCurrent();
                                                                                             completionClosure(success,responseObject,error);
                                                                                             
                                                                                         }];
                                      
                                      [task updateTask:newDataTask];
                                      [task resume];
                                  };
                                  
                                  if(timeDelay>0){
                                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                          excute();
                                      });
                                  }else{
                                      excute();
                                  }
        
                              }];
    
}

- (NSURLSessionDataTask *)convertTask:(OCMRequestTask *)orignalTask
                              uploadProgress:(nullable progressClosure) uploadProgressClosure
                            downloadProgress:(nullable progressClosure) downloadProgressClosure
                                  completion:(nullable completionClosure)completionClosure{
    if(!orignalTask){
        return nil;
    };
    
    NSURLRequest *newrequest = nil;
    if ([orignalTask.requestAdapter respondsToSelector:@selector(adapt:)]) {
        newrequest = [orignalTask.requestAdapter adapt:orignalTask.request];
        
    }else{
        newrequest = [orignalTask.request copy];
    }
    
    NSURLSessionDataTask *task = [self sessionDataTaskWithRequest:newrequest
                                                   uploadProgress:uploadProgressClosure
                                                 downloadProgress:downloadProgressClosure
                                                       completion:completionClosure];
    return task;
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {

    NSURLSessionConfiguration *configuration = [decoder decodeObjectOfClass:[NSURLSessionConfiguration class] forKey:@"sessionConfiguration"];
    if (!configuration) {
        NSString *configurationIdentifier = [decoder decodeObjectOfClass:[NSString class] forKey:@"identifier"];
        if (configurationIdentifier) {
#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (defined(__MAC_OS_X_VERSION_MIN_REQUIRED) && __MAC_OS_X_VERSION_MIN_REQUIRED >= 1100)
            configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:configurationIdentifier];
#else
            configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:configurationIdentifier];
#endif
        }
    }
    
    self = [self initWithSessionConfiguration:configuration];
    if (!self) {
        return nil;
    }
    
    self.responseSerializer = [decoder decodeObjectOfClass:[AFHTTPResponseSerializer class] forKey:NSStringFromSelector(@selector(responseSerializer))];
    AFSecurityPolicy *decodedPolicy = [decoder decodeObjectOfClass:[AFSecurityPolicy class] forKey:NSStringFromSelector(@selector(securityPolicy))];
    if (decodedPolicy) {
        self.securityPolicy = decodedPolicy;
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    if ([self.session.configuration conformsToProtocol:@protocol(NSCoding)]) {
        [coder encodeObject:self.session.configuration forKey:@"sessionConfiguration"];
    } else {
        [coder encodeObject:self.session.configuration.identifier forKey:@"identifier"];
    }
    [coder encodeObject:self.responseSerializer forKey:NSStringFromSelector(@selector(responseSerializer))];
    [coder encodeObject:self.securityPolicy forKey:NSStringFromSelector(@selector(securityPolicy))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    OCMHTTPSessionManager *HTTPClient = [[[self class] allocWithZone:zone] initWithSessionConfiguration:self.session.configuration];
    
    HTTPClient.responseSerializer = [self.responseSerializer copyWithZone:zone];
    HTTPClient.securityPolicy = [self.securityPolicy copyWithZone:zone];
    return HTTPClient;
}


@end
