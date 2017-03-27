//
//  OCMUploadTask.h
//  OCMoya
//
//  Created by keith on 26/03/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import "OCMoyaTask.h"
@class OCMUploadFromProvider,OCMUploadFromDataProvider,OCMUploadFromFileProvider,OCMUploadFromStreamProvider;

@interface OCMUploadTask : OCMoyaTask

@property (nonatomic,strong) NSURL *file;

@end

@interface OCMUploadMultipartTask : OCMoyaTask

@property (nonatomic,strong,readonly) OCMUploadFromProvider *provider;

@property (nonatomic,copy,readonly) NSString *name;

@property (nonatomic,copy,readonly) NSString *fileName;

@property (nonatomic,copy,readonly) NSString *mineType;

- (instancetype)initWithFromProvider:(OCMUploadFromProvider *)provider
                                name:(NSString *)name
                            fileName:(NSString *)fileName
                            mimeType:(NSString *)miniType;



@end

@interface OCMUploadFromProvider : NSObject



@end

@interface OCMUploadFromDataProvider : OCMUploadFromProvider

@property (nonatomic,strong,readonly) NSData *data;

- (instancetype)initWithData:(NSData *)data;

@end

@interface OCMUploadFromFileProvider : OCMUploadFromProvider

@property (nonatomic,strong,readonly) NSURL *file;

- (instancetype)initWithFile:(NSURL *)file;

@end

@interface OCMUploadFromStreamProvider : OCMUploadFromProvider

@property (nonatomic,strong,readonly) NSInputStream *inputStream;

@property (nonatomic,assign,readonly) uint64_t offset;

- (instancetype)initWithStream:(NSInputStream *)inputStream
                        offset:(uint64_t)offset;

@end
