//
//  FileHelper.m
//  TemplateDemo
//
//  Created by Dana on 15/5/18.
//  Copyright (c) 2015年 wengutech. All rights reserved.
//

#import "WGFileHelper.h"

static NSString *const SFileSaveDirectory = @"Archive";

@implementation WGFileHelper

//在UserDefault中存储对象
+ (void)storeObjectInUserDefaultWithObject:(id)object key:(NSString*)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:object forKey:key];
    [userDefaults synchronize];
}

//在UserDefault中获取对象
+ (id)getObjectFromUserDefaultWithObject:(NSString*)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

+ (id)decodeContentFromFile:(NSString*)pFileName key:(NSString*)key {
    NSData* data = [NSData dataWithContentsOfFile:pFileName];
    
    if ([data length] <= 0) {
        return nil;
    }
    
    NSKeyedUnarchiver* unArchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    id content = [unArchiver decodeObjectForKey:key];
    
    [unArchiver finishDecoding];
    
    return content;
}

+ (BOOL)encodeContent:(id)pContent toFile:(NSString*)pFileName key:(NSString*)key {
    BOOL result;
    
    NSMutableData* data = [NSMutableData data];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    
    [archiver encodeObject:pContent forKey:key];
    [archiver finishEncoding];
    
    [[self class] createFolderIfNotExistForFile:pFileName];
    result = [data writeToFile:pFileName atomically:YES];
    
    return result;
}


#pragma mark tool methods
+ (NSString*)getDocumentDirectory {
    NSArray* documentsDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (documentsDirectories.count > 0) {
        NSString *documentsDirectory = [documentsDirectories objectAtIndex:0];
        return documentsDirectory;
    }
    return nil;
}

+ (void)deletePersistenceFileForFile:(NSString*)pFileName {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:pFileName]) {
        [fileManager removeItemAtPath:pFileName error:nil];
    }
}

+ (void)deletePersistenceFileForDirectory:(NSString*)pDirectoryPath {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    BOOL isDirectoryPath;
    if ([fileManager fileExistsAtPath:pDirectoryPath isDirectory:&isDirectoryPath]) {
        [fileManager removeItemAtPath:pDirectoryPath error:nil];
    }
}

+ (void)createFolderIfNotExistForFile:(NSString*)pFileName {
    NSString* fileFolder = [pFileName stringByDeletingLastPathComponent];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:fileFolder]) {
        [fileManager createDirectoryAtPath:fileFolder
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
    
}

@end
