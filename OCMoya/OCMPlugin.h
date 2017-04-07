//
//  OCMPlugin.h
//  OCMoya
//
//  Created by KeithXi on 01/04/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCMTargetType.h"
#import "OCMResponse.h"
#import "OCMoyaError.h"
#import "OCMResult.h"


@protocol OCMRequestType <NSObject>

@property (nonatomic,strong,readonly) NSURLRequest *request;

@optional
- (id<OCMRequestType>) authenticateWithUserName:(NSString *)user
                                 password:(NSString *)password
                              persistence:(NSURLCredentialPersistence) persistence;

- (id<OCMRequestType>) authenticateWithCredential:(NSURLCredential *)credential;


@end

@protocol OCMPlugin <NSObject>

- (NSURLRequest *) prepareRequest:(NSURLRequest *)request;

- (void)willSendWithRequestType:(id<OCMRequestType>)requestType
                         target:(id<OCMTargetType>)target;

- (void)didRecevice:(OCMResponse *)response
              error:(OCMoyaError *)error
         targetType:(id<OCMTargetType>)target;

//change the response before call complete
- (OCMResult<OCMResponse *,OCMoyaError *> *)process:(OCMResponse *)response
          error:(OCMoyaError *)error
     targetType:(id<OCMTargetType>)target;



@end
