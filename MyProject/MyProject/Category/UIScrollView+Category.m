//
//  UIScrollView+Category.m
//  EYEE
//
//  Created by Dana on 15/10/22.
//  Copyright © 2015年 wengutech. All rights reserved.
//

#import "UIScrollView+Category.h"
//#import "MJRefresh.h"

static CGFloat const KRefreshheight = 65;

@implementation UIScrollView (Category)

//- (void)addRefreshHeaderWithTarget:(id)target action:(SEL)sel {
//    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
////    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:target refreshingAction:sel];
//    // 设置普通状态的动画图片
//    
////    NSMutableArray *imageArray = [NSMutableArray new];
////    for (NSInteger i = 1 ; i <= 18; i++) {
////        NSString *imageName = [NSString stringWithFormat:@"%ld",(long)i];
////        UIImage *image = WGImageNamed(imageName);
////        
////        if (image) {
////            [imageArray addObject:image];
////        }
////    }
////    
////    [header setImages:imageArray duration:imageArray.count * 0.03 forState:MJRefreshStateIdle];
////    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
////    [header setImages:imageArray duration:imageArray.count * 0.03 forState:MJRefreshStatePulling];
////    // 设置正在刷新状态的动画图片
////    
////    [header setImages:imageArray duration:imageArray.count * 0.03 forState:MJRefreshStateRefreshing];
//    
//    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:target refreshingAction:sel];
//
//     //设置文字
//    [header setTitle:WGString(@"headerRefresh_draguprefresh") forState:MJRefreshStateIdle];
//    [header setTitle:WGString(@"headerRefresh_loading_title") forState:MJRefreshStatePulling];
//    
//     //设置字体
//    header.stateLabel.font = [UIFont getCommonFontWithFontType:SmallFontType];
////    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
//    
//    // 设置颜色
//    header.stateLabel.textColor = [UIColor getCommonColorWithColorType:ColorGrayType];
////    header.lastUpdatedTimeLabel.textColor = [UIColor blueColor];
//    
//    // 隐藏时间
//    header.lastUpdatedTimeLabel.hidden = YES;
//    // 隐藏状态
////    header.stateLabel.hidden = YES;
//    
//    header.automaticallyChangeAlpha = YES;
//    
//    [header setDefaultHeaderHeight:KRefreshheight];
//    
//    // 设置header
//    self.header = header;
//}
//
//- (void)addRefreshFooterWithTarget:(id)target action:(SEL)sel {
//    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
////    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:target refreshingAction:sel];
////    
//////    NSArray *images = @[WGImageNamed(@"home_onlineshop_icon")];
////
////    NSMutableArray *imageArray = [NSMutableArray new];
////    for (NSInteger i = 1 ; i <= 18; i++) {
////        NSString *imageName = [NSString stringWithFormat:@"%ld",(long)i];
////        UIImage *image = WGImageNamed(imageName);
////        
////        if (image) {
////            [imageArray addObject:image];
////        }
////    }
////    
////    // 设置刷新图片
////    [footer setImages:imageArray duration:imageArray.count * 0.03 forState:MJRefreshStateRefreshing];
////    
////    
////    // 设置文字
////    [footer setTitle:WGString(@"refresh_loading_title") forState:MJRefreshStateIdle];
////    [footer setTitle:WGString(@"refresh_draguprefresh") forState:MJRefreshStateRefreshing];
////    [footer setTitle:WGString(@"refresh_nomore") forState:MJRefreshStateNoMoreData];
////    
////    // 设置字体
////    footer.stateLabel.font = [UIFont getCommonFontWithFontType:SmallFontType];
////    
////    // 设置颜色
////    footer.stateLabel.textColor = [UIColor getCommonColorWithColorType:ColorGrayType];
////    // 隐藏刷新状态的文字
//////    footer.refreshingTitleHidden = YES;
////    footer.automaticallyChangeAlpha = NO;
////
////    // 设置尾部
////    self.footer = footer;
////    
////    footer.mj_h = KRefreshheight;
//
//    
//    
//    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
//    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:target refreshingAction:sel];
//    // 设置文字
//    [footer setTitle:WGString(@"refresh_draguprefresh") forState:MJRefreshStateIdle];
//    [footer setTitle:WGString(@"refresh_loading_title") forState:MJRefreshStateRefreshing];
//    [footer setTitle:WGString(@"refresh_nomore") forState:MJRefreshStateNoMoreData];
//
//    // 设置字体
//    footer.stateLabel.font = [UIFont getCommonFontWithFontType:SmallFontType];
//    
//    // 设置颜色
//    footer.stateLabel.textColor = [UIColor getCommonColorWithColorType:ColorGrayType];
//    // 隐藏刷新状态的文字
//    footer.automaticallyChangeAlpha = NO;
//
//    self.footer = footer;
//}

@end
