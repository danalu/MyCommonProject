//
//  WGFunctionMacro.h
//  EYEE
//
//  Created by Dana on 15/10/12.
//  Copyright © 2015年 wengutech. All rights reserved.
//

#ifndef WGFunctionMacro_h
#define WGFunctionMacro_h

//app版本号
#define WGAppVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

//获取图片
#define WGImageNamed(imagename) [UIImage imageNamed:imagename]

//获取Localizable string.
#define WGString(a) NSLocalizedString(a, @"IT IS A TEXT")

// 屏幕宽高
#define kWidth   ([UIScreen mainScreen].bounds.size.width)
#define kHeight  ([UIScreen mainScreen].bounds.size.height)

//从bundle中获取xib
#define WGAwakeFromNib(xibname) [[NSBundle mainBundle] loadNibNamed:xibname owner:nil options:nil][0]

#define WGNotNullString(string) ([string isKindOfClass:[NSString class]] && string.length > 0)
#define WGNotNullArray(array) (array && [array isKindOfClass:[NSArray class]]) ? array : @[]
#define WYGetNotNullString(string) (string.length > 0 ? string : @"")
#define WYGetNotNullDictionary(obj, key) (                                                                        [NSDictionary dictionaryWithObject:obj ? obj : @"" forKey:WYGetNotNullString(key)])

#define is6P (kWidth >= 375.0 ? YES : NO)

#define isPad ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))


#ifdef DEBUG
#define WGWLog(...) NSLog(__VA_ARGS__)
#else
#define WGWLog(...)
#endif

// 判别是否iOS7或以上版本系统
#define iOS7 ([UIDevice currentDevice].systemVersion.doubleValue >= 7.0)

// 判别是否iOS8或以上版本系统
#define iOS8 ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0)


#define     kCOLOR(a)               [UIColor colorWithRed:a/255.0f green:a/255.0f blue:a/255.0f alpha:1.0f]

#define     kCustomColor(a,b,c)     [UIColor colorWithRed:a/255.0f green:b/255.0f blue:c/255.0f alpha:1.0f]

#define     kRandomColor            [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.0]



#define kColorRGBA(c,a) [UIColor colorWithRed:((c>>16)&0xFF)/255.0	\
green:((c>>8)&0xFF)/255.0	\
blue:(c&0xFF)/255.0         \
alpha:a]
#define kColorRGB(c)    [UIColor colorWithRed:((c>>16)&0xFF)/255.0	\
green:((c>>8)&0xFF)/255.0	\
blue:(c&0xFF)/255.0         \
alpha:1.0]


#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
#define StrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;

#endif /* WGFunctionMacro_h */
