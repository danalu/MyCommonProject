//
//  ZLUtility.h
//  EYEE
//
//  Created by Dana on 15/10/12.
//  Copyright © 2015年 wengutech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 *  一些工具类方法
 */

@interface WGUtility : NSObject

//获取系统语言
+ (NSString*)getLocaleLanguageCode;

//生成设备标识
+ (NSString*)getDeviceUDID;

/** 是否合法数字 */
+ (BOOL)isValidateNumber:(NSString *)number;

/** 验证手机号是否合法 */
+ (BOOL)isValiPhoneNumber:(NSString *)phoneNumber;

/** 验证邮箱是否合法*/
+ (BOOL)isValidateEmail:(NSString *)email;

/** 判断是否含有表情 */
+ (BOOL)isStringContainsEmoji:(NSString *)string;

/** 是否获得用户相册权限 */
+ (BOOL)isVisiablePhotoAlbum;

/** 是否获得相机权限 */
+ (BOOL)isVisiableCamera;

/** 是否是自然数 **/
+ (BOOL)isNaturalNumberWithNumString:(NSString*)numString;

///** 手机号加星号 **/
+ (NSString*)getNewNickNameWhickContainsPhoneNum:(NSString*)nickname;

+ (BOOL)hasNetWork;

//判断中英混合的的字符串长度
+ (NSUInteger)getStringCharLengthWithString:(NSString *)text;

//获取合适范围内的字符
+ (NSString*)getAllowedLengthStringWithString:(NSString*)strtemp allowedLength:(NSInteger)length;

//判断最大长度是否已经超出
+ (void)handleInputStringAllowLengthWithInputTextField:(UIResponder<UITextInput>*)textField
                                           containView:(UIView*)view
                                   allowCharcterLength:(NSInteger)length;

//判断是金额，匹配0，0.00~9999999999.99
+ (BOOL)isValidWithAmountString:(NSString*)amountString;

/*
 *  fromAmount > toAmount返回YES，<=返回NO.
 */
+ (BOOL)compireAmountString:(NSString*)fromAmount
             toAmountString:(NSString*)toAmount;

@end
