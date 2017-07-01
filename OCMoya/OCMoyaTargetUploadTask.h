//
//  OCMUploadTask.h
//  OCMoya
//
//  Created by keith on 26/03/2017.
//  Copyright © 2017 keithxi. All rights reserved.
//

#import "OCMoyaTargetTask.h"
@class OCMUploadFormProvider,OCMUploadFormDataProvider,OCMUploadFormFileProvider,OCMUploadFormStreamProvider;


@interface OCMoyaTargetUploadMultipartTask : OCMoyaTargetTask

@property (nonatomic,strong,readonly) NSArray<OCMUploadFormProvider *> *providers;

- (instancetype)initWithFormProviders:(NSArray<OCMUploadFormProvider *> *)providers;

@end

@interface OCMUploadFormProvider : NSObject

@property (nonatomic,copy,readonly) NSString *name;

@property (nonatomic,copy,readonly) NSString *fileName;

@property (nonatomic,copy,readonly) NSString *mineType;

- (instancetype)initWithName:(NSString *)name
                    fileName:(NSString *)fileName
                    mineType:(NSString *)mineType;

@end

@interface OCMUploadFormDataProvider : OCMUploadFormProvider

@property (nonatomic,strong,readonly) NSData *data;

- (instancetype)initWithData:(NSData *)data
                        name:(NSString *)name
                    fileName:(NSString *)fileName
                    mineType:(NSString *)mineType;

@end

@interface OCMUploadFormFileProvider : OCMUploadFormProvider

@property (nonatomic,strong,readonly) NSURL *file;

- (instancetype)initWithFile:(NSURL *)url
                        name:(NSString *)name
                    fileName:(NSString *)fileName
                    mineType:(NSString *)mineType;

@end

@interface OCMUploadFormStreamProvider : OCMUploadFormProvider

@property (nonatomic,strong,readonly) NSInputStream *inputStream;

@property (nonatomic,assign,readonly) uint64_t offset;

- (instancetype)initWithSream:(NSInputStream *)inputStream
                       offset:(uint64_t)offset
                         name:(NSString *)name
                     fileName:(NSString *)fileName
                     mineType:(NSString *)mineType;


@end
