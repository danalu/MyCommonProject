//
//  UITableViewCell+Category.m
//  wengu
//
//  Created by Dana on 16/8/23.
//  Copyright © 2016年 wengutech. All rights reserved.
//

#import "UITableViewCell+Category.h"
#import "FullScreenImageView.h"
#import "SingleLineInputCell.h"
#import "TitleContentDisplayCell.h"
#import "MultiLineInputCell.h"
#import "CommonPickerCell.h"

@implementation TableViewCellRowInfo

- (id)init {
    self = [super init];
    if (self) {
        _inputFontmaxCount = 500;
        _isAllowEmpty = YES;
    }
    return self;
}

+ (TableViewCellRowInfo*)tableViewCellRowInfo {
    return [[TableViewCellRowInfo alloc] init];
}

@end

static NSInteger SSeperatorLineViewTag = 1111110;

@implementation UITableViewCell (Category)

- (void)showSeperatorLineAtCelBottom:(BOOL)isBottom leftOffsetX:(CGFloat)leftOffsetX rightOffsetX:(CGFloat)rightOffsetX {
    UIView *seperatorView = [self viewWithTag:SSeperatorLineViewTag + (isBottom ? 0 : 1)];
    
    if (!seperatorView) {
        seperatorView = [[UIView alloc] initWithFrame:CGRectZero];
        
        seperatorView.tag = SSeperatorLineViewTag + (isBottom ? 0 : 1);
        [self addSubview:seperatorView];
        
        seperatorView.backgroundColor = [UIColor colorWithHexString:@"#dfdfdf"];
        
        [seperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftOffsetX);
            make.right.mas_equalTo(-rightOffsetX);
            make.height.mas_equalTo(0.5);
            
            if (isBottom) {
                make.bottom.equalTo(self);
            } else {
                make.top.equalTo(self);
            }
        }];
    }
}

- (void)hideSeperatorLineAtBottom:(BOOL)isBottom {
    UIView *seperatorView = [self viewWithTag:SSeperatorLineViewTag + (isBottom ? 0 : 1)];
    
    if (seperatorView) {
        [seperatorView removeFromSuperview];
    }
}

+ (NSString*)reuseIdentifier {
    return @"TableViewCellReuseID";
}

+ (void)registerTableViewCellWithRegisterType:(TemplateRowRegisterType)registerTypes tableView:(UITableView *)tableView {
//    SingleLineCellWithRightButtonType = 1 << 0,
//    SingleLineCellWithOutRightButtonType = 1 << 1,
//    MultiLineInputCellType = 1 << 2,
//    MultiLineDisplayCellType = 1 << 3

    if (registerTypes & SingleLineCellWithRightButtonType) {
        [tableView registerClass:[SingleLineInputCell class] forCellReuseIdentifier:[SingleLineInputCell getReuseIdentifierWithDisplayRightButton:YES]];
    }
    
    if (registerTypes & SingleLineCellWithOutRightButtonType) {
        [tableView registerClass:[SingleLineInputCell class] forCellReuseIdentifier:[SingleLineInputCell getReuseIdentifierWithDisplayRightButton:NO]];
    }
    
    if (registerTypes & MultiLineInputCellType) {
        [tableView registerClass:[MultiLineInputCell class] forCellReuseIdentifier:[MultiLineInputCell reuseIdentifier]];
    }
    
    if (registerTypes & MultiLineDisplayCellType) {
        [tableView registerClass:[TitleContentDisplayCell class] forCellReuseIdentifier:[TitleContentDisplayCell reuseIdentifierWithCellLayoutType:TopAndBottomMultiLineCellType]];
    }
}

+ (UITableViewCell*)getImageSettingCellWithTableView:(UITableView*)tableView
                                tableViewCellRowInfo:(TableViewCellRowInfo*)rowInfo
                                        isAllowEmpty:(BOOL)couldEmpty
                                        isLocalImage:(BOOL)isLocalImage
                                          initConfig:(void(^)(UITableViewCell* cell, UIImageView *imageView))cellConfigBlock {
    static NSString *const KSelectImageCellID = @"SelectImageCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KSelectImageCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KSelectImageCellID];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.tag = 100;
        [cell.contentView addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView).offset(-15);
            make.top.equalTo(cell.contentView).offset(2);
            make.bottom.mas_equalTo(cell.contentView).offset(-2);
            make.width.equalTo(imageView.mas_height).multipliedBy(rowInfo.imageScale);
        }];
        cell.textLabel.font = [UIFont getCommonFontWithFontType:MiddleFontType];
        cell.textLabel.textColor = [UIColor getCommonColorWithColorType:ColorBlackType];
        cell.textLabel.text = rowInfo.rowTitle;
        
        if (rowInfo.showDisclosureIndicator) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        if (!couldEmpty) {
            [UIView getCommonLabelWithTitle:WGString(@"（必选）") titleColor:[UIColor lightGrayColor] titleFont:cell.textLabel.font numberLines:1 customConfig:^(UILabel *label) {
                [cell.contentView addSubview:label];
                label.tag = 1001010;
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(imageView.mas_left).offset(0);
                    make.centerY.equalTo(cell.contentView);
                }];
            }];
        }
        
        if (cellConfigBlock) {
            cellConfigBlock(cell, imageView);
        }
    }
    
    FullScreenImageView *imageView = [(FullScreenImageView*)cell.contentView viewWithTag:100];
    
    BOOL hasImage = NO;
    
    if (rowInfo.imageLocalPath.length > 0) {
        hasImage = NO;
        
        NSURL *imageURL = nil;
        if (isLocalImage) {
            imageURL = [NSURL fileURLWithPath:rowInfo.imageLocalPath];
        } else {
            imageURL = [NSURL URLWithString:rowInfo.imageLocalPath];
        }
        
        [imageView sd_setImageWithURL:imageURL];
    } else {
        hasImage = YES;
        
        imageView.image = WGImageNamed(@"add_dashborder_back");
    }
    
    if (couldEmpty) {
        UILabel *label = (UILabel*)[cell.contentView viewWithTag:1001010];
        
        label.hidden = hasImage;
    }
    
    return cell;
}

+ (UITableViewCell*)getSingleLineInputCellWithTableView:(UITableView*)tableView
                               tableViewCellRowInfo:(TableViewCellRowInfo*)rowInfo
                                           rowValue:(NSString*)rowValue
                                           delegate:(id)delegate
                                         initConfig:(void(^)(UITableViewCell* cell))cellConfigBlock {
    if (!rowInfo.showDisclosureIndicator) {
        SingleLineInputCell *singleLineInputCell = [tableView dequeueReusableCellWithIdentifier:[SingleLineInputCell getReuseIdentifierWithDisplayRightButton:rowInfo.rowType == SingleLineInputWithRightFunctionRowType]];
        
        singleLineInputCell.inputTextField.keyboardType = rowInfo.keyboardType;
        
        singleLineInputCell.titleLabel.text = rowInfo.rowTitle;
        
        singleLineInputCell.inputString = rowValue;
        singleLineInputCell.inputTextField.placeholder = rowInfo.placeholder;
        singleLineInputCell.inputTextField.delegate = delegate;
        [singleLineInputCell.inputTextField addTarget:delegate action:@selector(textFiledDidChanged:) forControlEvents:UIControlEventEditingChanged];
        
        return singleLineInputCell;
    } else {
        static NSString *KSingleLineInputCellID = @"singleLineInputCellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KSingleLineInputCellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:KSingleLineInputCellID];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont getCommonFontWithFontType:MiddleFontType];
            cell.textLabel.textColor = [UIColor getCommonColorWithColorType:ColorBlackType];
            cell.detailTextLabel.font = [UIFont getCommonFontWithFontType:MediFontType];
            cell.detailTextLabel.textColor = [UIColor getCommonColorWithColorType:ColorMiddleGrayType];
            
            if (cellConfigBlock) {
                cellConfigBlock(cell);
            }
        }
        
        cell.textLabel.text = rowInfo.rowTitle;
        
        cell.detailTextLabel.text = rowValue;
        
        return cell;
    }
}

+ (UITableViewCell*)getMultiLineInputCellWithTableView:(UITableView*)tableView
                                  tableViewCellRowInfo:(TableViewCellRowInfo*)rowInfo
                                              rowValue:(NSString*)rowValue
                                              delegate:(id)delegate {
    if (rowInfo.showDisclosureIndicator) {
        TitleContentDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:[TitleContentDisplayCell reuseIdentifierWithCellLayoutType:TopAndBottomMultiLineCellType]];
        cell.titleLabel.textColor = [UIColor getCommonColorWithColorType:ColorBlackType];
        cell.contentLabel.textColor = [UIColor getCommonColorWithColorType:ColorMiddleGrayType];
        
        cell.titleLabel.text = rowInfo.rowTitle;
        
        cell.contentLabel.text = rowValue;
            
        return cell;
    } else {
        MultiLineInputCell *cell = [tableView dequeueReusableCellWithIdentifier:[MultiLineInputCell reuseIdentifier]];
        
        cell.titleLabel.text = rowInfo.rowTitle;
        cell.textView.delegate = delegate;
        [cell.textView setKeyboardDismissAccessoryView];
        cell.textView.text = rowValue;
        
        return cell;
    }
}

+ (UITableViewCell*)getPickerViewWithTableView:(UITableView*)tableView
                          tableViewCellRowInfo:(TableViewCellRowInfo*)rowInfo                                               delegate:(id)delegate
                                    initConfig:(void(^)(UITableViewCell* cell))cellConfigBlock {
    CommonPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:[CommonPickerCell reuseIdentifier]];
    if (!cell) {
        cell = [[CommonPickerCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[CommonPickerCell reuseIdentifier]];
        cell.detailTextLabel.font = [UIFont getCommonFontWithFontType:MiddleFontType];
        cell.detailTextLabel.textColor = [UIColor getCommonColorWithColorType:ColorBlackType];
        
        if (cellConfigBlock) {
            cellConfigBlock(cell);
        }
    }
    cell.pickerType = rowInfo.rowType == ValuePickerSelectType ? SelectPickerType : DatePickerType;
    cell.datasource = rowInfo.datasources;
    cell.date = rowInfo.date;
    cell.selectedIndex = rowInfo.selectedIndex;
    cell.delegate = delegate;
    cell.propertyName = rowInfo.propertyName;
    
    cell.textLabel.text = rowInfo.rowTitle;
    
    if (cell.pickerType == SelectPickerType) {
        NSInteger index = rowInfo.selectedIndex > -1 ? rowInfo.selectedIndex : 0;
        cell.detailTextLabel.text = rowInfo.datasources[index];
    } else {
        cell.detailTextLabel.text = [NSString getTimeDescWithDate:rowInfo.date formatString:@"yyyy.MM.dd"];
    }
    
    return cell;
}

@end
