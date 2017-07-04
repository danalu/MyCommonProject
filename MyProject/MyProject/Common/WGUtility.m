//
//  WGUtility.m
//  EYEE
//
//  Created by Dana on 15/10/12.
//  Copyright © 2015年 wengutech. All rights reserved.
//

#import "WGUtility.h"
#import <AssetsLibrary/AssetsLibrary.h> // 判断相册需要
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>


#import <AVFoundation/AVFoundation.h>
 #import <AdSupport/AdSupport.h>
#import <Photos/Photos.h>

@implementation WGUtility

+ (NSString*)getLocaleLanguageCode {
    NSLocale *currentLocale = [NSLocale currentLocale];
    return [currentLocale objectForKey:NSLocaleLanguageCode];
}

+ (NSString*)getDeviceUDID {
    NSString *uuid = [WGFileHelper getObjectFromUserDefaultWithObject:@"DeviceUUIDKey"];
    if (!uuid) {
        uuid = [self createDeviceUUID];
        
        [WGFileHelper storeObjectInUserDefaultWithObject:uuid key:@"DeviceUUIDKey"];
    }
    
    return uuid;
}

+ (NSString*)createDeviceUUID {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;;
}


+ (BOOL)isValidUserName:(NSString*)userNmae {
    NSString *regex = @"^(?![_-])(?!.*[_-]$)[a-zA-Z0-9_-]{6,20}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:userNmae];
}

+ (BOOL)isValidPassword:(NSString*)password {
//    NSString *regex = @"^(?![\\d]+$)(?![a-zA-Z]+$)(?![^\\da-zA-Z]+$).{8,15}$";
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
//    return [predicate evaluateWithObject:password];

    if (password.length >= 6 && password.length <= 15) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isValidateNumber:(NSString *)number {
    NSString *regex = @"^[0-9]*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:number];
}

+ (BOOL)isNaturalNumberWithNumString:(NSString*)numString {
    NSString *regex = @"^[1-9]\\d*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:numString];
}

+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isValiPhoneNumber:(NSString *)phoneNumber {
    //中国大陆有效的手机号码：长度必须为11位，且是有效数字
    if (phoneNumber.length == 11 &&[WGUtility isValidateNumber:phoneNumber])
    {
        return YES;
    }else{
        return NO;
    }
}

//判断是否含有表情
+ (BOOL)isStringContainsEmoji:(NSString *)string{
    
    __block BOOL returnValue = NO;

    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
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


/*
 ALAuthorizationStatus author = [ALAssetsLibraryauthorizationStatus];
 if (author == kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
 //无权限
 }
 */
/** 是否获得用户相册权限 */
+ (BOOL)isVisiablePhotoAlbum {
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 9.0) {
        // 9.0之前
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusDenied || author == ALAuthorizationStatusRestricted) {
            return NO;
        }else {
            return YES;
        }
    }else {
        // 9.0之后
        PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
        if (author == PHAuthorizationStatusDenied || author == PHAuthorizationStatusRestricted) {
            return NO;
        }else {
            return YES;
        }
    }
}

/** 是否获得相机权限 */
+ (BOOL)isVisiableCamera {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        return NO;
    }else {
        return YES;
    }
}

+ (NSString*)getUserIDFA {
    if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
        return [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;
    }
    
    return nil;
}

///** 手机号加星号 **/
//+ (NSString*)getStarMobileNum {
//    
//        NSArray *mobileArray = [[WGUserManager wySharedInstance].userInfo.regMobile componentsSeparatedByString:@"-"];
//        NSString *phoneString;
//        if (mobileArray) {
//            phoneString = mobileArray.lastObject;
//        }
//
//        //用*号替换String中的部分字符
//        NSUInteger hiddenCharNum = phoneString.length - 3 - 3;
//        if (hiddenCharNum < 15) {
//            NSMutableString *replaceCharString = NSMutableString.new;
//            for (NSInteger i = 0 ; i < hiddenCharNum; i++) {
//                [replaceCharString appendString:@"*"];
//            }
//            return  [phoneString stringByReplacingCharactersInRange:NSMakeRange(3, phoneString.length - 3 - 3) withString:replaceCharString];
//        }
//        return phoneString;
//}

+ (NSString*)getNewNickNameWhickContainsPhoneNum:(NSString*)nickname {
    if ([WGUtility isNormalPhoneNumber:nickname]) {
        return [nickname stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    
    return nickname;
}

+ (BOOL)isNormalPhoneNumber:(NSString *)phoneNumber {
    if (phoneNumber.length < 11) {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        
        
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:phoneNumber];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:phoneNumber];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:phoneNumber];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}

//判断中英混合的的字符串长度
+ (NSUInteger)getStringCharLengthWithString:(NSString *)text{
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    NSUInteger unicodeLength = asciiLength;
    return unicodeLength;
}

//超出指定字符串长度后，截成规定长度的大小
+ (NSString*)getAllowedLengthStringWithString:(NSString*)strtemp allowedLength:(NSInteger)length {
    if ([self getStringCharLengthWithString:strtemp] <= length) {
        return strtemp;
    }
    
    NSUInteger asciiLength = 0, endIndex = 0;
    for (NSUInteger i = 0; i < strtemp.length; i++) {
        unichar uc = [strtemp characterAtIndex:i];
        asciiLength += isascii(uc) ? 1 : 2;
        
        if (asciiLength > length) {
            //在该位置已经超出了，返回该未知之前的字符即可.
            endIndex = i;
            break;
        }
    }

    //需要处理.
    NSString *correctString = [strtemp substringToIndex:endIndex];
    
    return correctString;
}

+ (void)handleInputStringAllowLengthWithInputTextField:(UIResponder<UITextInput>*)textField
                                           containView:(UIView*)view
                                   allowCharcterLength:(NSInteger)length {
    NSString *key = @"text";
    void(^HandleInputStringBlock)(void) = ^ {
        if ([textField respondsToSelector:@selector(text)]) {
            NSString *inputString = [textField valueForKey:key];
            NSInteger num  = [WGUtility getStringCharLengthWithString:inputString];
            if(num > length) {
                if (view) {
//                    [view showNoticeViewWithTitle:[NSString stringWithFormat:@"最多不能超过%ld个字",(long)length / 2] message:nil duration:0];
                }
                inputString = [WGUtility getAllowedLengthStringWithString:inputString allowedLength:length];
                if ([textField respondsToSelector:@selector(setText:)]) {
                    [textField setValue:inputString forKey:key];
                }
            }
        }
    };
    
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            HandleInputStringBlock();
        }
        //有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        HandleInputStringBlock();
    }
}

+ (BOOL)hasNetWork {
//    return [AFNetworkReachabilityManager sharedManager].isReachable;
}

+ (BOOL)isValidWithAmountString:(NSString*)amountString {
    NSString *regex = @"^([1-9]\\d{0,9}|0)([.]?|(\\.\\d{1,2})?)$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:amountString];
}

+ (BOOL)compireAmountString:(NSString*)fromAmount
             toAmountString:(NSString*)toAmount {
    NSDecimalNumber *theDecimalNum = [[NSDecimalNumber alloc] initWithString:fromAmount];
    NSDecimalNumber *withDecimalNum = [[NSDecimalNumber alloc] initWithString:toAmount];
    
    NSComparisonResult result = [theDecimalNum compare:withDecimalNum];
    return result == NSOrderedDescending;

}

@end
