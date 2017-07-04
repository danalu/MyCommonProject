//
//  NSString+Category.h
//  wengu
//
//  Created by Dana on 16/8/15.
//  Copyright © 2016年 wengutech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

- (CGSize)stringSizeWithFont:(UIFont*)font size:(CGSize)size lineSpace:(CGFloat)lineSpace;

+ (CGFloat)getOneLineHeightWithFont:(UIFont*)font maxWidth:(CGFloat)maxWidth;

+ (NSAttributedString*)getAttributedStringWithContentString:(NSString*)contentString
                                                       font:(UIFont*)font
                                                  lineSpace:(NSInteger)lineSpace;

+ (NSString*)getTimeDescWithDate:(NSDate*)date formatString:(NSString*)date;

- (BOOL)isContainsEmoji;

/**
 *  汉字的拼音
 *
 *  @return 拼音
 */
- (NSString *)pinyin;


@end
