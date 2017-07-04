//
//  UIButton+Category.h
//  wengu
//
//  Created by Dana on 16/8/21.
//  Copyright © 2016年 wengutech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIButton+WebCache.h>

typedef enum
{
    BIPButtonImageLeft,             //!< The button image appears to the left of the title.
    BIPButtonImageRight,            //!< The button image appears to the right of the title.
    BIPButtonImageAboveText,        //!< The button image appears above the title.
    BIPButtonImageBelowText,        //!< The button image appears below the title.
    BIPButtonImageCenterAboveText,  //!< The button image appears between the title and the top.
    BIPButtonImageIgnored           //!< The button image and title are not adjusted.
} BIPButtonImageAlignment;

typedef NS_ENUM(NSInteger, ButtonImageTitleStyle ) {
    ButtonImageTitleStyleDefault = 0,       //图片在左，文字在右，整体居中。
    ButtonImageTitleStyleLeft  = 1,         //图片在左，文字在右，整体居中。
    ButtonImageTitleStyleRight     = 2,     //图片在右，文字在左，整体居中。
    ButtonImageTitleStyleTop  = 3,          //图片在上，文字在下，整体居中。
    ButtonImageTitleStyleBottom    = 4,     //图片在下，文字在上，整体居中。
    ButtonImageTitleStyleCenterTop = 5,     //图片居中，文字在上距离按钮顶部。
    ButtonImageTitleStyleCenterBottom = 6,  //图片居中，文字在下距离按钮底部。
    ButtonImageTitleStyleCenterUp = 7,      //图片居中，文字在图片上面。
    ButtonImageTitleStyleCenterDown = 8,    //图片居中，文字在图片下面。
    ButtonImageTitleStyleRightLeft = 9,     //图片在右，文字在左，距离按钮两边边距
    ButtonImageTitleStyleLeftRight = 10,    //图片在左，文字在右，距离按钮两边边距
    
    ButtonImageTitleStyleLeftRightOffsetLeft = 11, //图片字左，文字在右，距离左边间距
    ButtonImageTilteStyleRightLeftOffsetRight = 12, // 图片在右，文字在左，距离右边间距
    ButtonImageTilteStyleRightLeftOffsetLeft = 13, // 图片在右，文字在左，距离左边间距
    ButtonImageTitleStyleTitleBottom = 14  //图片在上，文字在下，文字距离底部间距，图片与文字中间间距
};


@interface UIButton (Category)

- (void)applyAlignment:(BIPButtonImageAlignment)alignment withMargin:(CGSize)margin;

- (void)addBeatAnimation;

/*
 调整按钮的文本和image的布局，前提是title和image同时存在才会调整。
 padding是调整布局时整个按钮和图文的间隔。
 
 */
-(void)setButtonImageTitleStyle:(ButtonImageTitleStyle)style padding:(CGFloat)padding itemGap:(CGFloat)gap;

//得到一个共同的button
+ (UIButton*)getCommonButtonWithTitle:(NSString*)title
                           titleColor:(UIColor*)titleColor
                                 font:(UIFont*)font
                               target:(id)target
                                  sel:(SEL)sel
                                image:(UIImage*)image;

- (void)setGoodButtonStatusAnimated:(BOOL)animated isSelected:(BOOL)isSelected;

- (void)setRoundImageWithButtonWidth:(CGFloat)width;

- (void)setUserIconWithIconURL:(NSString*)iconURL;

@end
