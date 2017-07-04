//
//  UIView+Category.m
//  wengu
//
//  Created by Dana on 16/8/11.
//  Copyright © 2016年 wengutech. All rights reserved.
//

#import "UIView+Category.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>
#import <UIView+WZLBadge.h>

@implementation UIView (Category)

- (void)showNoticeViewWithTitle:(NSString*)title
                        message:(NSString*)message
                       duration:(NSTimeInterval)duration {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self viewType:NoticeViewType animated:YES];
    
    hud.color = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
    hud.labelColor = hud.detailsLabelColor = [UIColor getCommonColorWithColorType:ColorBlueType];
    hud.labelText = title;
    hud.detailsLabelText = message;
    hud.labelFont = [UIFont getCommonFontWithFontType:MiddleFontType];
    hud.detailsLabelFont = [UIFont getCommonFontWithFontType:SmallFontType];
    hud.mode = MBProgressHUDModeText;
    
    duration = (duration <= 0) ? 1.0 : duration;
    
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:duration];
}

- (void)showLoadingViewWithTitle:(NSString*)title {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self viewType:LoadingViewType animated:YES];
    hud.color          = [UIColor colorWithWhite:0 alpha:0];
    hud.activityIndicatorColor = [UIColor getCommonColorWithColorType:ColorMiddleGrayType];
    hud.labelColor = hud.detailsLabelColor = [UIColor getCommonColorWithColorType:ColorBlueType];
    hud.labelText = title;
}

- (void)showLoadingViewWithTitle:(NSString*)title interactionEnabled:(BOOL)enabled {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self viewType:LoadingViewType animated:YES];
    hud.color          = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
    hud.activityIndicatorColor = [UIColor getCommonColorWithColorType:ColorBlueType];
    hud.labelColor = hud.detailsLabelColor = [UIColor getCommonColorWithColorType:ColorBlueType];
    hud.labelText = title;
    
    hud.userInteractionEnabled = enabled;
}

- (void)hiddenLoadingView {
    [MBProgressHUD hideHUDForView:self animated:YES];
}

+ (CGFloat)viewHeight {
    return 0.0f;
}

- (void)hiddenKeyWindow:(UIWindow*)window {
    window.hidden = YES;
    window = nil;
}

- (UITableView*)createTableViewWithDelegate:(id)delegate datasourceDelegate:(id)datasource tableViewStyle:(UITableViewStyle)style layoutBlock:(void(^)(UITableView* tableView))layoutBlock {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:style];
    tableView.delegate = delegate;
    tableView.dataSource = datasource;
    [self addSubview:tableView];
    tableView.showsVerticalScrollIndicator = NO;
    
    [tableView setPageBackgroundColor];
    
    layoutBlock(tableView);
    
    tableView.tableFooterView = [[UIView alloc] init];
    
    return tableView;
}

- (void)showBadgeViewWithBadgeValue:(NSUInteger)badgeValue badgeCenterOffset:(CGPoint)point {
    if (!CGPointEqualToPoint(point, CGPointZero)) {
        self.badgeCenterOffset = point;
    }
    [self showBadgeWithStyle:WBadgeStyleNumber value:badgeValue animationType:WBadgeAnimTypeBreathe];
//    if (badgeValue <= 0) {
//        [self hiddenBadgeView];
//        return;
//    }
//    
//    UIView *redView = [self viewWithTag:1010110];
//    if (redView) {
//        return;
//    }
//    
//    CGSize redpointSize = CGSizeMake(10, 10);
//    redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, redpointSize.width, redpointSize.height)];
//    redView.backgroundColor = [UIColor redColor];
//    redView.tag = 1010110;
//    redView.layer.cornerRadius = CGRectGetWidth(redView.frame) / 2.0f;
//    [self addSubview:redView];
////    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.equalTo(self);
////        make.right.equalTo(self);
////        make.size.mas_equalTo(redpointSize);
////    }];
//    
//    if ([self isKindOfClass:[UIButton class]]) {
//        UIButton *button = (UIButton*)self;
//         if (button.titleLabel.text.length > 0) {
//            CGPoint originPoint = button.titleLabel.frame.origin;
//            redView.x = originPoint.x + CGRectGetWidth(button.titleLabel.frame) - 5;
//            redView.y = originPoint.y - 5;
//         } else if (button.imageView.image) {
//             CGPoint originPoint = button.imageView.frame.origin;
//             redView.x = originPoint.x + CGRectGetWidth(button.imageView.frame) - 5;
//             redView.y = originPoint.y - 5;
//         }
//    } else if ([self isKindOfClass:[UILabel class]]) {
//        UILabel *label = (UILabel*)self;
//        CGPoint originPoint = label.frame.origin;
//        CGFloat textWidth = [label.text stringSizeWithFont:label.font size:CGSizeMake(CGRectGetWidth(label.frame), CGRectGetHeight(label.frame)) lineSpace:0].width;
//        redView.x = textWidth + 5;
//        redView.y = originPoint.y + 10;
//    }
}

- (void)hiddenBadgeView {
    [self clearBadge];
    //    UIView *redView = [self viewWithTag:1010110];
//    if (redView) {
//        [redView removeFromSuperview];
//    }
}

- (void)showNoMoreDataNoticeView {
    UIView *noticeView = [self viewWithTag:10101010];
    if (noticeView) {
        [noticeView removeFromSuperview];
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.text = WGString(@"已经没有更多数据了");
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont getCommonFontWithFontType:EveninFontType];
    label.textColor = [UIColor getCommonColorWithColorType:ColorBlueType];
    
    noticeView = [[UIView alloc] initWithFrame:CGRectZero];
//    noticeView.backgroundColor = [UIColor whiteColor];
    [noticeView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(noticeView);
    }];
    noticeView.tag = 10101010;
    [self addSubview:noticeView];
    
    CGSize size = [label.text stringSizeWithFont:label.font size:CGSizeMake(kWidth - 30, 1000) lineSpace:2];
//    noticeView.layer.cornerRadius = size.height / 2.0f;
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView*)self;
        [noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(scrollView.contentSize.height);
            make.size.mas_offset(CGSizeMake(size.width + 15, size.height + 15));
        }];
    } else {
        [noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-5);
            make.size.mas_offset(CGSizeMake(size.width + 15, size.height + 15));
        }];
    }
    
    [self hiddenNoMoreDataViewWithDuration:1.2];
}

- (void)hiddenNoMoreDataViewWithDuration:(CGFloat)duration {
    UIView *noticeView = [self viewWithTag:10101010];
    if (noticeView) {
        [NSObject performBlock:^{
            [UIView animateWithDuration:0.4 animations:^{
                noticeView.alpha = 0;
            } completion:^(BOOL finished) {
                [noticeView removeFromSuperview];
            }];
        } afterDelay:duration];
    }
}

+ (UIButton*)getCommonButtonWithTitle:(NSString*)title
                                image:(UIImage*)image
                           titleColor:(UIColor*)titleColor
                            titleFont:(UIFont*)titleFont
                               target:(id)target
                                  sel:(SEL)sel
                         customConfig:(void (^)(UIButton *))configButton {
    CustomButton* button = [CustomButton buttonWithType:UIButtonTypeCustom];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
    }
    
    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    } else {
        [button setTitleColor:[UIColor getCommonColorWithColorType:ColorBlackType] forState:UIControlStateNormal];
    }
    
    if (titleFont) {
        button.titleLabel.font = titleFont;
    } else {
        button.titleLabel.font = [UIFont getCommonFontWithFontType:MiddleFontType];
    }
    
    if (target) {
        [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (configButton) {
        configButton(button);
    }
    
    return button;
}

//.
+ (UILabel*)getCommonLabelWithTitle:(NSString*)title
                         titleColor:(UIColor*)titleColor
                          titleFont:(UIFont*)titleFont
                        numberLines:(NSInteger)lines
                       customConfig:(void (^)(UILabel *))configLabel {
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.numberOfLines = lines;
    
    if (titleColor) {
        label.textColor = titleColor;
    } else {
        label.textColor = [UIColor getCommonColorWithColorType:ColorMiddleGrayType];
    }
    
    if (titleFont) {
        label.font = titleFont;
    } else {
        label.font = [UIFont getCommonFontWithFontType:MiddleFontType];
    }
    
    if (configLabel) {
        configLabel(label);
    }
    
    return label;
}

+ (LUNSegmentedControl*)getCommonSegmentViewWithDelegate:(id<LUNSegmentedControlDelegate>)delegate
                                              datasource:(id<LUNSegmentedControlDataSource>)datasource                                              containView:(UIView*)containView  {
    LUNSegmentedControl *control = [[LUNSegmentedControl alloc] initWithFrame:CGRectZero];
    [containView addSubview:control];
    [control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(1, 1, 1, 1));
    }];
    control.shadowsEnabled = NO;
    control.transitionStyle = LUNSegmentedControlTransitionStyleSlide;
    control.shapeStyle = LUNSegmentedControlShapeStyleRoundedRect;
    //    control.cornerRadius = 30 / 2.0f;
    control.textColor = [UIColor getCommonColorWithColorType:ColorMiddleGrayType];
    control.selectedStateTextColor = [UIColor whiteColor];
    control.selectorViewColor = [UIColor getCommonColorWithColorType:ColorBlueType];
    control.textFont = [UIFont getCommonFontWithFontType:SecondHeaderFontType];
    control.delegate = delegate;
    control.dataSource = datasource;
    
    return control;

}

- (void)setPageBackgroundColor {
    UIColor *backgroundColor = [UIColor getCommonBackgroundColor];
    if ([self isKindOfClass:[UITableView class]] || [self isKindOfClass:[UICollectionView class]]) {
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = backgroundColor;
        [self setValue:backgroundView forKey:@"backgroundView"];
    } else {
        self.backgroundColor = backgroundColor;
    }
}

+ (UIView*)getSeperatorView {
    UIView *sepeartorView = [[UIView alloc] init];
    sepeartorView.backgroundColor = [UIColor getCommonSeperaterViewColor];
    return sepeartorView;
}

- (void)setKeyboardDismissAccessoryView {
    UIButton *dismissKeyBoardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissKeyBoardButton setImage:WGImageNamed(@"dismiss_keyboard_icon") forState:UIControlStateNormal];
    [dismissKeyBoardButton addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *inputAccessView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 30)];
    inputAccessView.backgroundColor = [UIColor whiteColor];
    [inputAccessView addSubview:dismissKeyBoardButton];
    dismissKeyBoardButton.size = CGSizeMake(40, 30);
    dismissKeyBoardButton.x = kWidth - 40;
    dismissKeyBoardButton.y = 0;
    
    if ([self respondsToSelector:@selector(setInputAccessoryView:)]) {
        [self performSelector:@selector(setInputAccessoryView:) withObject:inputAccessView];
    }
}

- (void)dismissKeyBoard {
    [self endEditing:YES];
}

+ (UITextField*)getSearchTextFieldWithFrame:(CGRect)rect
                                placeHolder:(NSString*)placeholder
                                   delegate:(id)delegate {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 8, kWidth - 50 - 60, 44 - 8 * 2)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont getCommonFontWithFontType:MediFontType];
    textField.textColor = [UIColor getCommonColorWithColorType:ColorGrayType];
    textField.returnKeyType = UIReturnKeySearch;
    textField.autocorrectionType = UITextAutocorrectionTypeYes;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.delegate = delegate;
    [textField addTarget:delegate action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    UIImageView *leftView = [[UIImageView alloc] init];
    leftView.image = WGImageNamed(@"sarch_textFiled_leftview_icon");
    leftView.frame = CGRectMake(0, 0, 30, leftView.image.size.height);
    // 设置leftView的内容居中
    leftView.contentMode = UIViewContentModeCenter;
    textField.leftView = leftView;
    // 设置左边的view永远显示
    
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.placeholder = placeholder;

    return textField;
}

#pragma mark - base property
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}
- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size
{
    //    self.width = size.width;
    //    self.height = size.height;
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}



@end
