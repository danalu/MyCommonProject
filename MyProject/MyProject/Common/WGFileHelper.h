//
//  FileHelper.h
//  TemplateDemo
//
//  Created by Dana on 15/5/18.
//  Copyright (c) 2015年 wengutech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WGFileHelper : NSObject

//在UserDefault中存储对象
+ (void)storeObjectInUserDefaultWithObject:(id)object key:(NSString*)key;
//在UserDefault中获取对象
+ (id)getObjectFromUserDefaultWithObject:(NSString*)key;

+ (id)decodeContentFromFile:(NSString*)pFileName key:(NSString*)key;
+ (BOOL)encodeContent:(id)pContent toFile:(NSString*)pFileName key:(NSString*)key;

@end
