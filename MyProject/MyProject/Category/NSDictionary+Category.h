//
//  NSDictionary+wengu.h
//  wengu
//
//  Created by Dana on 15/6/2.
//  Copyright (c) 2015年 wengutech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Category)

- (NSString *)jsonString;

- (id)hs_getSafeValueWithKey:(NSString*)key;

- (id)hs_getSafeValueWithKeyPath:(NSString*)keyPath;

- (NSString*)stringForKey:(id)key;

- (NSNumber*)numberForKey:(id)key;

- (NSArray*)arrayForKey:(id)key;

- (NSDictionary*)dictionaryForKey:(id)key;

- (NSInteger)integerForKey:(id)key;

- (BOOL)boolForKey:(id)key;

- (float)floatForKey:(id)key;

@end

@interface NSMutableDictionary(wengu)

- (void)hs_setSafeValue:(id)value forKey:(NSString*)key;

- (void)hs_setSafeValue:(id)value withDefault:(id)defaultForUnsafeValues forKey:(NSString*)key;

@end
