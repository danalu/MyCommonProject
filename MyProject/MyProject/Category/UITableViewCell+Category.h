//
//  UITableViewCell+Category.h
//  wengu
//
//  Created by Dana on 16/8/23.
//  Copyright © 2016年 wengutech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SingleLineCellWithRightButtonType = 1 << 0,
    SingleLineCellWithOutRightButtonType = 1 << 1,
    MultiLineInputCellType = 1 << 2,
    MultiLineDisplayCellType = 1 << 3
} TemplateRowRegisterType;

@interface TableViewCellRowInfo : NSObject {
}

@property (nonatomic) EditRowType rowType;
@property (nonatomic, assign) NSInteger rowTag;
@property (nonatomic) BOOL showDisclosureIndicator; //是否显示箭头
@property (nonatomic, strong) NSString *rowTitle;
@property (nonatomic, strong) NSString *placeholder; //针对输入框
@property (nonatomic, strong) NSString *propertyName;
@property (nonatomic) NSArray *datasources; //针对pickerView
@property (nonatomic, strong) NSDate *date; //针对time pickerview
@property (nonatomic, strong) NSString *dateFormatString; //默认为yyyy.MM.dd
@property (nonatomic, assign) NSInteger selectedIndex;  //针对pickerView
@property (nonatomic, assign) UIKeyboardType keyboardType;  //针对输入框. 默认为全键盘
@property (nonatomic, assign) CGFloat imageScale;   //图片选择的宽高比例.
@property (nonatomic, strong) NSString *imageLocalPath;
@property (nonatomic, assign) NSUInteger inputFontmaxCount; //字数限制，默认500
@property (nonatomic, assign) BOOL isAllowEmpty; //默认允许.

+ (TableViewCellRowInfo*)tableViewCellRowInfo;

@end


@interface UITableViewCell (Category)

- (void)hideSeperatorLineAtBottom:(BOOL)isBottom;

- (void)showSeperatorLineAtCelBottom:(BOOL)isBottom leftOffsetX:(CGFloat)leftOffsetX rightOffsetX:(CGFloat)rightOffsetX;

+ (NSString*)reuseIdentifier;

//注册需要的cell
+ (void)registerTableViewCellWithRegisterType:(TemplateRowRegisterType)registerType tableView:(UITableView*)tableView;

//设置图片cell.
+ (UITableViewCell*)getImageSettingCellWithTableView:(UITableView*)tableView
                                tableViewCellRowInfo:(TableViewCellRowInfo*)rowInfo
                                        isAllowEmpty:(BOOL)couldEmpty
                                        isLocalImage:(BOOL)isLocalImage
                                              initConfig:(void(^)(UITableViewCell* cell, UIImageView *imageView))cellConfigBlock;

//单行输入cell.
+ (UITableViewCell*)getSingleLineInputCellWithTableView:(UITableView*)tableView
                               tableViewCellRowInfo:(TableViewCellRowInfo*)rowInfo
                                           rowValue:(NSString*)rowValue
                                           delegate:(id)delegate
                                         initConfig:(void(^)(UITableViewCell* cell))cellConfigBlock;

//多行输入cell.
+ (UITableViewCell*)getMultiLineInputCellWithTableView:(UITableView*)tableView
                               tableViewCellRowInfo:(TableViewCellRowInfo*)rowInfo
                                           rowValue:(NSString*)rowValue
                                              delegate:(id)delegate;
//选择值或者时间.
+ (UITableViewCell*)getPickerViewWithTableView:(UITableView*)tableView
                          tableViewCellRowInfo:(TableViewCellRowInfo*)rowInfo                                               delegate:(id)delegate
                                    initConfig:(void(^)(UITableViewCell* cell))cellConfigBlock;


@end
