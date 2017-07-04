//
//  NSObject+Category.h
//  TemplateDemo
//
//  Created by Dana on 15/5/18.
//  Copyright (c) 2015年 wengutech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (WG)

+ (instancetype)wySharedInstance;

@end


@interface NSObject (Blocks)

+ (id)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;
+ (id)performBlock:(void (^)(id arg))block withObject:(id)anObject afterDelay:(NSTimeInterval)delay;

+ (void)cancelBlock:(id)block;
+ (void)cancelPreviousPerformBlock:(id)aWrappingBlockHandle __attribute__ ((deprecated));

+ (void)performBlockInThread:(void (^)(void))block;
+ (void)performBlockInMainThread:(void (^)(void))block;

+ (void)showInTempWindow:(void(^)(UIWindow *window))block;
+ (void)hiddenTempWindowWithDuration:(CGFloat)duration completedBlock:(void(^)(void))block;

//encode model
+ (BOOL)encodeContent:(id)pContent toFile:(NSString*)pFileName key:(NSString*)key;

//decode model
+ (id)decodeContentFromFile:(NSString*)pFileName key:(NSString*)key;

+ (void)createFolderIfNotExistForFile:(NSString*)fPath;

+ (NSString*)getDocumentDirectory;

+ (void)deleteLocalFileWithFileName:(NSString*)pFileName;

@end