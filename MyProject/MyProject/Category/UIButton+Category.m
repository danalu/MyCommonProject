//
//  UIButton+Category.m
//  wengu
//
//  Created by Dana on 16/8/21.
//  Copyright © 2016年 wengutech. All rights reserved.
//

#import "UIButton+Category.h"

@implementation UIButton (Category)

UIEdgeInsets BIPInvertEdgeInsets(UIEdgeInsets insets)
{
    return UIEdgeInsetsMake(-insets.top, -insets.left, -insets.bottom, -insets.right);
}


- (void)applyAlignment:(BIPButtonImageAlignment)alignment withMargin:(CGSize)margin
{
    const CGRect contentFrame = [self contentRectForBounds:self.bounds];
    const CGRect imageFrame = UIEdgeInsetsInsetRect([self imageRectForContentRect:contentFrame], BIPInvertEdgeInsets(self.imageEdgeInsets));
    const CGRect titleFrame = UIEdgeInsetsInsetRect([self titleRectForContentRect:contentFrame], BIPInvertEdgeInsets(self.titleEdgeInsets));
    
    CGPoint titleShift = CGPointZero;
    CGPoint imageShift = CGPointZero;
    switch (alignment)
    {
        case BIPButtonImageLeft:
        {
            titleShift.x = CGRectGetMaxX(contentFrame) - margin.width - CGRectGetMaxX(titleFrame);
            imageShift.x = CGRectGetMinX(contentFrame) + margin.width - CGRectGetMinX(imageFrame);
        }
            break;
            
        case BIPButtonImageRight:
        {
            titleShift.x = CGRectGetMinX(contentFrame) + margin.width - CGRectGetMinX(titleFrame);
            imageShift.x = CGRectGetMaxX(contentFrame) - margin.width - CGRectGetMaxX(imageFrame);
        }
            break;
            
        case BIPButtonImageBelowText:
        {
            titleShift.x = CGRectGetMidX(contentFrame) - CGRectGetMidX(titleFrame);
            titleShift.y = CGRectGetMinY(contentFrame) + margin.height - CGRectGetMinY(titleFrame);
            imageShift.x = CGRectGetMidX(contentFrame) - CGRectGetMidX(imageFrame);
            imageShift.y = CGRectGetMaxY(contentFrame) - margin.height - CGRectGetMaxY(imageFrame);
        }
            break;
            
        case BIPButtonImageAboveText:
        {
            titleShift.x = CGRectGetMidX(contentFrame) - CGRectGetMidX(titleFrame);
            titleShift.y = CGRectGetMaxY(contentFrame) - margin.height - CGRectGetMaxY(titleFrame);
            imageShift.x = CGRectGetMidX(contentFrame) - CGRectGetMidX(imageFrame);
            imageShift.y = CGRectGetMinY(titleFrame) + titleShift.y - margin.height - CGRectGetMaxY(imageFrame);
        }
            break;
            
        case BIPButtonImageCenterAboveText:
        {
            titleShift.x = CGRectGetMidX(contentFrame) - CGRectGetMidX(titleFrame);
            titleShift.y = CGRectGetMaxY(contentFrame) - margin.height - CGRectGetMaxY(titleFrame);
            imageShift.x = CGRectGetMidX(contentFrame) - CGRectGetMidX(imageFrame);
            imageShift.y = 0.5f*(CGRectGetMinY(contentFrame) + margin.height + (CGRectGetMinY(titleFrame) + titleShift.y)) - CGRectGetMidY(imageFrame);
        }
            break;
            
        case BIPButtonImageIgnored:
        {
            return;
        }
            break;
    }
    
    const CGSize titleSize = [self.titleLabel sizeThatFits:contentFrame.size];
    const CGFloat widthCorrection = MAX(0, titleSize.width - titleFrame.size.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(titleShift.y, titleShift.x - widthCorrection*0.5f, -titleShift.y, -titleShift.x - widthCorrection*0.5f);
    self.imageEdgeInsets = UIEdgeInsetsMake(imageShift.y, imageShift.x, -imageShift.y, -imageShift.x);
}

- (void)addBeatAnimation
{
    CABasicAnimation * animation = [CABasicAnimation animation];
    animation.keyPath =@"transform.scale";
    animation.fromValue = [NSNumber numberWithFloat:0.9];
    animation.toValue = [NSNumber numberWithFloat:1.2];
    animation.duration = 0.4f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 0.4f;
    animationGroup.autoreverses = YES;
    animationGroup.repeatCount = 1;
    animationGroup.removedOnCompletion = YES;
    [animationGroup setAnimations:[NSArray arrayWithObjects:animation, nil]];
    // 添加动画组
    [self.layer addAnimation:animationGroup forKey:@"animationGroup"];
}

-(void)setButtonImageTitleStyle:(ButtonImageTitleStyle)style padding:(CGFloat)padding itemGap:(CGFloat)gap {
    if (self.imageView.image != nil && self.titleLabel.text != nil)
    {
        //先还原
        self.titleEdgeInsets = UIEdgeInsetsZero;
        self.imageEdgeInsets = UIEdgeInsetsZero;
        
        CGRect imageRect = self.imageView.frame;
        CGRect titleRect = self.titleLabel.frame;
        
        CGFloat totalHeight = imageRect.size.height + padding + titleRect.size.height;
        CGFloat selfHeight = self.frame.size.height;
        CGFloat selfWidth = self.frame.size.width;
        
        switch (style) {
            case ButtonImageTitleStyleLeft:
                if (padding != 0)
                {
                    self.titleEdgeInsets = UIEdgeInsetsMake(0,
                                                            padding/2,
                                                            0,
                                                            -padding/2);
                    
                    self.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                            -padding/2,
                                                            0,
                                                            padding/2);
                }
                break;
            case ButtonImageTitleStyleRight:
            {
                //图片在右，文字在左
                self.titleEdgeInsets = UIEdgeInsetsMake(0,
                                                        -(imageRect.size.width + padding/2),
                                                        0,
                                                        (imageRect.size.width + padding/2));
                
                self.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                        (titleRect.size.width+ padding/2),
                                                        0,
                                                        -(titleRect.size.width+ padding/2));
            }
                break;
            case ButtonImageTitleStyleTop:
            {
                //图片在上，文字在下
                self.titleEdgeInsets = UIEdgeInsetsMake(((selfHeight - totalHeight)/2 + imageRect.size.height + padding - titleRect.origin.y),
                                                        (selfWidth/2 - titleRect.origin.x - titleRect.size.width /2) - (selfWidth - titleRect.size.width) / 2,
                                                        -((selfHeight - totalHeight)/2 + imageRect.size.height + padding - titleRect.origin.y),
                                                        -(selfWidth/2 - titleRect.origin.x - titleRect.size.width /2) - (selfWidth - titleRect.size.width) / 2);
                
                self.imageEdgeInsets = UIEdgeInsetsMake(((selfHeight - totalHeight)/2 - imageRect.origin.y),
                                                        (selfWidth /2 - imageRect.origin.x - imageRect.size.width / 2),
                                                        -((selfHeight - totalHeight)/2 - imageRect.origin.y),
                                                        -(selfWidth /2 - imageRect.origin.x - imageRect.size.width / 2));
                
            }
                break;
            case ButtonImageTitleStyleBottom:
            {
                //图片在下，文字在上。
                self.titleEdgeInsets = UIEdgeInsetsMake(((selfHeight - totalHeight)/2 - titleRect.origin.y),
                                                        (selfWidth/2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                                        -((selfHeight - totalHeight)/2 - titleRect.origin.y),
                                                        -(selfWidth/2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2);
                
                self.imageEdgeInsets = UIEdgeInsetsMake(((selfHeight - totalHeight)/2 + titleRect.size.height + padding - imageRect.origin.y),
                                                        (selfWidth /2 - imageRect.origin.x - imageRect.size.width / 2),
                                                        -((selfHeight - totalHeight)/2 + titleRect.size.height + padding - imageRect.origin.y),
                                                        -(selfWidth /2 - imageRect.origin.x - imageRect.size.width / 2));
            }
                break;
            case ButtonImageTitleStyleCenterTop:
            {
                self.titleEdgeInsets = UIEdgeInsetsMake(-(titleRect.origin.y - padding),
                                                        (selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                                        (titleRect.origin.y - padding),
                                                        -(selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2);
                
                self.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                        (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                                        0,
                                                        -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2));
            }
                break;
            case ButtonImageTitleStyleCenterBottom:
            {
                self.titleEdgeInsets = UIEdgeInsetsMake((selfHeight - padding - titleRect.origin.y - titleRect.size.height),
                                                        (selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                                        -(selfHeight - padding - titleRect.origin.y - titleRect.size.height),
                                                        -(selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2);
                
                self.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                        (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                                        0,
                                                        -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2));
            }
                break;
            case ButtonImageTitleStyleTitleBottom: {
                self.titleEdgeInsets = UIEdgeInsetsMake((selfHeight - padding - titleRect.origin.y - titleRect.size.height),
                                                        (selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                                        -(selfHeight - padding - titleRect.origin.y - titleRect.size.height),
                                                        -(selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2);
                
                self.imageEdgeInsets = UIEdgeInsetsMake(-gap,
                                                        (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                                        +gap,
                                                        -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2));
            }
                break;
            case ButtonImageTitleStyleCenterUp:
            {
                self.titleEdgeInsets = UIEdgeInsetsMake(-(titleRect.origin.y + titleRect.size.height - imageRect.origin.y + padding),
                                                        (selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                                        (titleRect.origin.y + titleRect.size.height - imageRect.origin.y + padding),
                                                        -(selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2);
                
                self.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                        (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                                        0,
                                                        -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2));
            }
                break;
            case ButtonImageTitleStyleCenterDown:
            {
                self.titleEdgeInsets = UIEdgeInsetsMake((imageRect.origin.y + imageRect.size.height - titleRect.origin.y + padding),
                                                        (selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                                        -(imageRect.origin.y + imageRect.size.height - titleRect.origin.y + padding),
                                                        -(selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2);
                
                self.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                        (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                                        0,
                                                        -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2));
            }
                break;
            case ButtonImageTitleStyleRightLeft:
            {
                //图片在右，文字在左，距离按钮两边边距
                
                self.titleEdgeInsets = UIEdgeInsetsMake(0,
                                                        -(titleRect.origin.x - padding),
                                                        0,
                                                        (titleRect.origin.x - padding));
                
                self.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                        (selfWidth - padding - imageRect.origin.x - imageRect.size.width),
                                                        0,
                                                        -(selfWidth - padding - imageRect.origin.x - imageRect.size.width));
            }
                
                break;
                
            case ButtonImageTitleStyleLeftRight:
            {
                //图片在左，文字在右，距离按钮两边边距
                
                
                self.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                        -(imageRect.origin.x - padding),
                                                        0,
                                                        (imageRect.origin.x - padding));
                
                self.titleEdgeInsets = UIEdgeInsetsMake(0,
                                                        (selfWidth - padding - titleRect.origin.x - titleRect.size.width),
                                                        0,
                                                        -(selfWidth - padding - titleRect.origin.x - titleRect.size.width));

                
            }
                break;
            case ButtonImageTitleStyleLeftRightOffsetLeft: {
                self.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                        -(imageRect.origin.x - padding),
                                                        0,
                                                        (imageRect.origin.x - padding));
                
                self.titleEdgeInsets = UIEdgeInsetsMake(0,
                                                        -(imageRect.origin.x - padding) + gap ,
                                                        0,
                                                        (imageRect.origin.x - padding) - gap);
            }
                break;
            case ButtonImageTilteStyleRightLeftOffsetRight: {
                
                self.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                        (selfWidth - padding - imageRect.origin.x - imageRect.size.width),
                                                        0,
                                                        -(selfWidth - padding - imageRect.origin.x - imageRect.size.width));
                
                self.titleEdgeInsets = UIEdgeInsetsMake(0,
                                                        (self.imageView.frame.origin.x - gap - titleRect.size.width - titleRect.origin.x),
                                                        0,
                                                        -(self.imageView.frame.origin.x - gap - titleRect.size.width - titleRect.origin.x));

            }
                break;
            case ButtonImageTilteStyleRightLeftOffsetLeft: {
                self.titleEdgeInsets = UIEdgeInsetsMake(0,
                                                        -(titleRect.origin.x - padding),
                                                        0,
                                                        (titleRect.origin.x - padding));
                self.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                        -(imageRect.origin.x - (padding + titleRect.size.width + gap)),
                                                        0,
                                                        (imageRect.origin.x - (padding + titleRect.size.width + gap))
                                                        );
                

            }
                break;
            default:
                break;
        }
    }
    else {
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
}

+ (UIButton*)getCommonButtonWithTitle:(NSString*)title
                           titleColor:(UIColor*)titleColor
                                 font:(UIFont*)font
                               target:(id)target
                                  sel:(SEL)sel
                                image:(UIImage*)image {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    } else {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
    }
    
    if (font) {
        button.titleLabel.font = font;
    } else {
        button.titleLabel.font = [UIFont getCommonFontWithFontType:MiddleFontType];
    }

    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)setGoodButtonStatusAnimated:(BOOL)animated isSelected:(BOOL)isSelected {
    NSArray *goodImages = @[@"good_blue_normal",@"good_blue_highlight"];
    NSInteger index = isSelected ? 1 : 0;
    [self setImage:WGImageNamed(goodImages[index]) forState:UIControlStateNormal];
    
    if (animated) {
        [self addBeatAnimation];
    }
}

- (void)setRoundImageWithButtonWidth:(CGFloat)width {
//    self.layer.cornerRadius = width / 2.0f;
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = [UIColor getCommonColorWithColorType:ColorLightGrayType].CGColor;
//    self.layer.masksToBounds = YES;
//    self.layer.shouldRasterize = YES;
//    self.layer.rasterizationScale =[UIScreen mainScreen].scale;

    UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width / 2.0, width / 2.0) radius:width / 2.0 startAngle:0 endAngle:2*M_PI clockwise:YES];
    CAShapeLayer* shape = [CAShapeLayer layer];
    shape.path = path.CGPath;
    self.layer.mask = shape;
    self.layer.masksToBounds = YES;
}

- (void)setUserIconWithIconURL:(NSString*)iconURL {
    [self sd_setImageWithURL:[NSURL URLWithString:iconURL] forState:UIControlStateNormal placeholderImage:WGDefaultUserIcon options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
}

@end
