//
//  UIView+Category.h
//  wengu
//
//  Created by Dana on 16/8/11.
//  Copyright © 2016年 wengutech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LUNSegmentedControl.h"

@interface UIView (Category)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

/*
 * 显示渐隐提示框（一般的提示都采用此提示方式）
 */
- (void)showNoticeViewWithTitle:(NSString*)title
                        message:(NSString*)message
                       duration:(NSTimeInterval)duration;
/*
 * 显示数据加载菊花
 */
- (void)showLoadingViewWithTitle:(NSString*)title;

- (void)showLoadingViewWithTitle:(NSString*)title interactionEnabled:(BOOL)enabled;

/*
 * 隐藏数据加载菊花
 */
- (void)hiddenLoadingView;

+ (CGFloat)viewHeight;

- (UITableView*)createTableViewWithDelegate:(id)delegate datasourceDelegate:(id)datasource tableViewStyle:(UITableViewStyle)style layoutBlock:(void(^)(UITableView* tableView))layoutBlock;

- (void)showBadgeViewWithBadgeValue:(NSUInteger)badgeValue badgeCenterOffset:(CGPoint)point;
- (void)hiddenBadgeView;


- (void)showNoMoreDataNoticeView;


//UIButton
+ (UIButton*)getCommonButtonWithTitle:(NSString*)title
                                image:(UIImage*)image
                           titleColor:(UIColor*)titleColor
                            titleFont:(UIFont*)titleFont
                               target:(id)target
                                  sel:(SEL)sel
                         customConfig:(void(^)(UIButton* button))configButton;

//UILabel
+ (UILabel*)getCommonLabelWithTitle:(NSString*)title
                         titleColor:(UIColor*)titleColor
                          titleFont:(UIFont*)titleFont
                        numberLines:(NSInteger)lines
                       customConfig:(void(^)(UILabel* label))configLabel;

+ (LUNSegmentedControl*)getCommonSegmentViewWithDelegate:(id<LUNSegmentedControlDelegate>)delegate
                                              datasource:(id<LUNSegmentedControlDataSource>)datasource
                                             containView:(UIView*)containView;

//得到分割线
+ (UIView*)getSeperatorView;

//设置背景色.
- (void)setPageBackgroundColor;

//给键盘加上消失的按钮.
- (void)setKeyboardDismissAccessoryView;

//获取搜索栏的UITextField
+ (UITextField*)getSearchTextFieldWithFrame:(CGRect)rect
                                placeHolder:(NSString*)placeholder
                                   delegate:(id)delegate;

@end
