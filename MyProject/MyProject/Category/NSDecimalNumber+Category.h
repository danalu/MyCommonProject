//
//  NSDecimalNumber+Category.h
//  wengu
//
//  Created by Dana on 17/3/6.
//  Copyright © 2017年 wengutech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, OperatorType) {
    AddType,        //+
    SubtarctType,   //-
    MultiplyType,   //*
    DividType       ///
};

@interface NSDecimalNumber (Category)

- (NSDecimalNumber*)calculateDecimalNumberWithDecimalNumber:(NSDecimalNumber*)decimalNumber
                                               operatorType:(OperatorType)type;

- (NSDecimalNumber*)decimalNumberWithDigitCount:(NSInteger)count
                                   roundingMode:(NSRoundingMode)mode;

@end


@interface NSNumber (Category)

// 转成123,456.02格式字符串(小数点后保留2位）
- (NSString*)decimalStringFromNumber;

@end
