//
//  UIColor+Category.h
//  EYEE
//
//  Created by Dana on 15/10/14.
//  Copyright © 2015年 wengutech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Category)

/*
 *  16进制颜色值
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

+ (UIColor *)randomColor;

+ (UIColor*)getCommonBackgroundColor;

+ (UIColor*)getCommonSeperaterViewColor;

@end
