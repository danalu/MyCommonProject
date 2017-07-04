//
//  NSObject+Category.m
//  TemplateDemo
//
//  Created by Dana on 15/5/18.
//  Copyright (c) 2015年 wengutech. All rights reserved.
//

#import "NSObject+Category.h"
#import <dispatch/dispatch.h>
#import "AppDelegate.h"

@implementation NSObject (WG)

+ (instancetype)wySharedInstance {
    //实现原理：创建单例对象，然后放到单例字典存储起来，key和value都是当前的对象实例，这就保证了所有NSObject的子类都可以通过此方法创建自己的单例
    static NSMutableDictionary *instancesByClass = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instancesByClass = [[NSMutableDictionary alloc] init];
    });
    id wySharedInstance = nil;
    @synchronized(self) {
        wySharedInstance = instancesByClass[(id<NSCopying>)self];
        if (!wySharedInstance) {
            wySharedInstance = [[self alloc] init];
            instancesByClass[(id<NSCopying>)self] = wySharedInstance;
        }
    }
    return wySharedInstance;
}

@end

static inline dispatch_time_t dTimeDelay(NSTimeInterval time) {
    int64_t delta = (int64_t)(NSEC_PER_SEC * time);
    return dispatch_time(DISPATCH_TIME_NOW, delta);
}

@implementation NSObject (Blocks)

+ (id)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay {
    if (!block) return nil;
    
    __block BOOL cancelled = NO;
    
    void (^wrappingBlock)(BOOL) = ^(BOOL cancel) {
        if (cancel) {
            cancelled = YES;
            return;
        }
        if (!cancelled)block();
    };
    
    wrappingBlock = [wrappingBlock copy];
    
    dispatch_after(dTimeDelay(delay), dispatch_get_main_queue(), ^{  wrappingBlock(NO); });
    
    return wrappingBlock;
}

+ (id)performBlock:(void (^)(id arg))block withObject:(id)anObject afterDelay:(NSTimeInterval)delay {
    if (!block) return nil;
    
    __block BOOL cancelled = NO;
    
    void (^wrappingBlock)(BOOL, id) = ^(BOOL cancel, id arg) {
        if (cancel) {
            cancelled = YES;
            return;
        }
        if (!cancelled) block(arg);
    };
    
    wrappingBlock = [wrappingBlock copy];
    
    dispatch_after(dTimeDelay(delay), dispatch_get_main_queue(), ^{  wrappingBlock(NO, anObject); });
    
    return wrappingBlock;
}

- (id)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay {
    
    if (!block) return nil;
    
    __block BOOL cancelled = NO;
    
    void (^wrappingBlock)(BOOL) = ^(BOOL cancel) {
        if (cancel) {
            cancelled = YES;
            return;
        }
        if (!cancelled) block();
    };
    
    wrappingBlock = [wrappingBlock copy];
    
    dispatch_after(dTimeDelay(delay), dispatch_get_main_queue(), ^{  wrappingBlock(NO); });
    
    return wrappingBlock;
}

- (id)performBlock:(void (^)(id arg))block withObject:(id)anObject afterDelay:(NSTimeInterval)delay {
    if (!block) return nil;
    
    __block BOOL cancelled = NO;
    
    void (^wrappingBlock)(BOOL, id) = ^(BOOL cancel, id arg) {
        if (cancel) {
            cancelled = YES;
            return;
        }
        if (!cancelled) block(arg);
    };
    
    wrappingBlock = [wrappingBlock copy];
    
    dispatch_after(dTimeDelay(delay), dispatch_get_main_queue(), ^{  wrappingBlock(NO, anObject); });
    
    return wrappingBlock;
}

+ (void)cancelBlock:(id)block {
    if (!block) return;
    void (^aWrappingBlock)(BOOL) = (void(^)(BOOL))block;
    aWrappingBlock(YES);
}

+ (void)cancelPreviousPerformBlock:(id)aWrappingBlockHandle {
    [self cancelBlock:aWrappingBlockHandle];
}



+ (BOOL)encodeContent:(id)pContent toFile:(NSString*)pFileName key:(NSString*)key
{
    BOOL result = NO;
    NSMutableData* data = [NSMutableData data];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:pContent forKey:key];
    [archiver finishEncoding];
    
    NSString *path = [[self getDocumentDirectory] stringByAppendingPathComponent:pFileName];
    [self createFolderIfNotExistForFile:path];
    
    result = [data writeToFile:path atomically:YES];
    
    return result;
}

+ (id)decodeContentFromFile:(NSString*)pFileName key:(NSString*)key
{
    NSString *path = [[self getDocumentDirectory] stringByAppendingPathComponent:pFileName];
    NSData* data = [NSData dataWithContentsOfFile:path];
    
    if ([data length] <= 0) {
        return nil;
    }
    
    NSKeyedUnarchiver* unArchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    id content = [unArchiver decodeObjectForKey:key];
    //
    [unArchiver finishDecoding];
    return content;
}

+ (void)createFolderIfNotExistForFile:(NSString*)fPath
{
    NSString* fileFolder = [fPath stringByDeletingLastPathComponent];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:fileFolder]) {
        NSError *error = nil;
        BOOL success = [fileManager createDirectoryAtPath:fileFolder
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:&error];
        NSLog(@"%@", error);
    }
    
}



+ (NSString*)getDocumentDirectory
{
    NSArray* documentsDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (documentsDirectories.count > 0) {
        NSString *documentsDirectory = [documentsDirectories objectAtIndex:0];
        return documentsDirectory;
    }
    return nil;
}

+ (void)deleteLocalFileWithFileName:(NSString*)pFileName {
     NSString *path = [[self getDocumentDirectory] stringByAppendingPathComponent:pFileName];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    BOOL isDirectoryPath;
    if ([fileManager fileExistsAtPath:path isDirectory:&isDirectoryPath]) {
        [fileManager removeItemAtPath:path error:nil];
    }
}

+ (void)performBlockInThread:(void (^)(void))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            block();
        } @catch (NSException *exception) {
            
        } @finally {
             
        }
    });
}

+ (void)performBlockInMainThread:(void (^)(void))block {
    dispatch_async(dispatch_get_main_queue(), ^{
        block();
    });
}

+ (void)showInTempWindow:(void(^)(UIWindow *window))block {
    UIWindow *tempWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.tempWindow =tempWindow;
    tempWindow.hidden = NO;
    
    block(tempWindow);
}

+ (void)hiddenTempWindowWithDuration:(CGFloat)duration completedBlock:(void(^)(void))block {
    [NSObject performBlock:^{
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.tempWindow.hidden = YES;
        appDelegate.tempWindow = nil;
    } afterDelay:duration];
}


@end
