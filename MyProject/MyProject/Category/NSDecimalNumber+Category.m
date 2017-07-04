//
//  NSDecimalNumber+Category.m
//  wengu
//
//  Created by Dana on 17/3/6.
//  Copyright © 2017年 wengutech. All rights reserved.
//

#import "NSDecimalNumber+Category.h"

@implementation NSDecimalNumber (Category)

- (NSDecimalNumber*)calculateDecimalNumberWithDecimalNumber:(NSDecimalNumber*)decimalNumber operatorType:(OperatorType)type {
    NSDecimalNumber *resultDecimalNumber = nil;
    switch (type) {
        case AddType: {
            resultDecimalNumber = [self decimalNumberByAdding:decimalNumber];
            break;
        }
        case SubtarctType: {
            resultDecimalNumber = [self decimalNumberBySubtracting:decimalNumber];
            break;
        }
        case MultiplyType: {
            resultDecimalNumber = [self decimalNumberByMultiplyingBy:decimalNumber];
            break;
        }
        case DividType: {
            resultDecimalNumber = [self decimalNumberByDividingBy:decimalNumber];
            break;
        }
    }
    
    return resultDecimalNumber;
}

- (NSDecimalNumber*)decimalNumberWithDigitCount:(NSInteger)count
                                   roundingMode:(NSRoundingMode)mode {
    NSDecimalNumberHandler *handler = [[NSDecimalNumberHandler alloc] initWithRoundingMode:mode scale:count raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    return [self decimalNumberByRoundingAccordingToBehavior:handler];
}

@end

@implementation NSNumber (Category)

- (NSString*)decimalStringFromNumber {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"0.00;"];
    formatter.roundingMode = NSNumberFormatterRoundHalfUp;
    NSString *string = [formatter stringFromNumber:self];
    
    return string;
}

@end
