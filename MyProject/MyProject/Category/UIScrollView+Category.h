//
//  UIScrollView+Category.h
//  EYEE
//
//  Created by Dana on 15/10/22.
//  Copyright © 2015年 wengutech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Category)

/*
 *  增加下拉刷新
 */
- (void)addRefreshHeaderWithTarget:(id)target action:(SEL)sel;

/*
 *  增加上拉加载更多
 */
- (void)addRefreshFooterWithTarget:(id)target action:(SEL)sel;



@end
