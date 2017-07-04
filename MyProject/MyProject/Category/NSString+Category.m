//
//  NSString+Category.m
//  wengu
//
//  Created by Dana on 16/8/15.
//  Copyright © 2016年 wengutech. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

#pragma mark 计算字符串大小
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName: font};
    CGSize textSize = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}

+ (CGFloat)getOneLineHeightWithFont:(UIFont*)font maxWidth:(CGFloat)maxWidth {
    return [@"一行高度" sizeWithFont:font maxSize:CGSizeMake(maxWidth, 1000)].height;
}

- (CGSize)stringSizeWithFont:(UIFont*)font size:(CGSize)size lineSpace:(CGFloat)lineSpace {
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:lineSpace > 0 ? lineSpace : 0];
    NSDictionary *attribute = @{NSFontAttributeName: font,NSParagraphStyleAttributeName:paragraphStyle1};
    CGRect rect = [self boundingRectWithSize:size options:
                   NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    
    return CGSizeMake(ceil(rect.size.width), ceil(rect.size.height));
}

+ (NSAttributedString*)getAttributedStringWithContentString:(NSString*)contentString
                                                       font:(UIFont*)font
                                                  lineSpace:(NSInteger)lineSpace  {
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:lineSpace];
    font = font ? font : [UIFont getCommonFontWithFontType:MiddleFontType];
    NSDictionary *attribute = @{NSFontAttributeName: font,NSParagraphStyleAttributeName:paragraphStyle1};
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:contentString];
    [attributeString setAttributes:attribute range:NSMakeRange(0, contentString.length)];
    
    return attributeString;
}

+ (NSString*)getTimeDescWithDate:(NSDate*)date formatString:(NSString*)formatString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatString];
    NSString *timeString = [formatter stringFromDate:date];

    return timeString;
}

- (BOOL)isContainsEmoji {
    __block BOOL returnValue = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    
    return returnValue;
}

//汉字的拼音
- (NSString *)pinyin{
    NSMutableString *str = [self mutableCopy];
    CFStringTransform(( CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

@end
