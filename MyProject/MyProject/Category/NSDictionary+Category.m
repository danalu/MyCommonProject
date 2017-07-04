//
//  NSDictionary+wengu.m
//  wengu
//
//  Created by Dana on 15/6/2.
//  Copyright (c) 2015年 wengutech. All rights reserved.
//

#import "NSDictionary+Category.h"

@implementation NSDictionary (Category)

- (NSString *)jsonString{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (jsonData == nil) {
#ifdef DEBUG
        NSLog(@"fail to get JSON from dictionary: %@, error: %@", self, error);
#endif
        return nil;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (id)hs_getSafeValueWithKey:(NSString*)key {
    if (key != nil) {
        id value = self[key];
        
        if (value && ![value isKindOfClass:[NSNull class]]) {
            return value;
        }
    }
    
    return nil;
}

- (id)hs_getSafeValueWithKeyPath:(NSString*)keyPath {
    if (keyPath != nil) {
        id value = [self valueForKeyPath:keyPath];
        
        if (value && ![value isKindOfClass:[NSNull class]]) {
            return value;
        }
    }
    
    return nil;
}

- (NSString*)stringForKey:(id)key {
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null])
    {
        return @"";
    }
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString*)value;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    
    return nil;
}

- (NSNumber*)numberForKey:(id)key {
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber*)value;
    }
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        return [f numberFromString:(NSString*)value];
    }
    return nil;
}

- (NSArray*)arrayForKey:(id)key {
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    if ([value isKindOfClass:[NSArray class]])
    {
        return value;
    }
    return nil;
}

- (NSDictionary*)dictionaryForKey:(id)key {
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    if ([value isKindOfClass:[NSDictionary class]])
    {
        return value;
    }
    return nil;
}

- (NSInteger)integerForKey:(id)key {
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
    {
        return [value integerValue];
    }
    return 0;
}

- (BOOL)boolForKey:(id)key {
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null])
    {
        return NO;
    }
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value boolValue];
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return [value boolValue];
    }
    return NO;
}

- (float)floatForKey:(id)key {
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value floatValue];
    }
    return 0;
}


@end

@implementation NSMutableDictionary(wengu)

- (void)hs_setSafeValue:(id)value forKey:(NSString*)key {
    if(value != nil)
    {
        [self setValue:value forKey:key];
    }
}

- (void)hs_setSafeValue:(id)value withDefault:(id)defaultForUnsafeValues forKey:(NSString*)key {
    NSParameterAssert(defaultForUnsafeValues);
    [self setValue:value ? value : defaultForUnsafeValues forKey:key];
}

@end
