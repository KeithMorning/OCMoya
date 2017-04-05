//
//  OCMProvider+default.h
//  OCMoya
//
//  Created by KeithXi on 05/04/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import "OCMProvider.h"
#import "OCMTargetType.h"
#import "OCMEndpoint.h"
#import "OCMDefination.h"

@interface OCMProvider (defaultProvider)

+ (OCMEndpoint *)defaultEndpointMapping:(id<OCMTargetType>) target;

+ (void)defaultRquestMapping:(OCMEndpoint *)endpoint closure:(RequestResultClosure)closure;

+ (OCMHTTPSessionManager *)defaultHTTPManager;

@end
