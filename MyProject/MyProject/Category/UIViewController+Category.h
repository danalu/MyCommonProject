//
//  UIViewController+wengu.h
//  EYEE
//
//  Created by Dana on 15/10/14.
//  Copyright © 2015年 wengutech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WGBaseServiceRequest;

typedef enum : NSUInteger {
    EndRefreshStatus, //数据加载完毕
    NomoreDataStatus, //已经没有更多数据了
    ResetNomoreDataStatus, //重置已经没有更多数据的状态
} FooterRefreshStatus;


@interface UIViewController (wengu)

@property (nonatomic, strong) NSMutableDictionary *serivceRequestDic;

/* 
 *  添加child viewcontroller
 */
- (void)showChildController:(UIViewController*)childController
                     inView:(UIView*)view
                   animated:(BOOL)animated
            finalStateBlock:(void(^)(void))finalStateBlock
            completionBlock:(void(^)(void))completionBlock;

/*
 *  移除child viewcontroller
 */
- (void)dismissChildViewController:(UIViewController*)childController
                          animated:(BOOL)animated
                   finalStateBlock:(void(^)(void))finalStateBlock
                   completionBlock:(void(^)(void))completionBlock;


/*
 * 显示系统对话框，需要用户同意或取消之后才能进行下一步行为
 *8.0使用UIAlertController，titles可以传多个，用|分割
 */
- (void)showAlertControllerWithAlertStyle:(UIAlertControllerStyle)style
                                    Title:(NSString*)title
                             message:(NSString*)message
                         cancelTitle:(NSString*)cancelTitle
                    destructiveTitle:(NSString*)destructiveTitle
                         otherTitles:(NSArray*)otherTitles
                             handler:(void (^ __nullable)(UIAlertAction *action))handler;


/*
 *  设置navigationbar背景色
 */
- (void)setNavigationBarBackgroundColor:(UINavigationBar*)navigationBar color:(UIColor*)color  needBorder:(BOOL)needBorder;


/*
 *  返回上一页(navigationController作为容器，且返回没有任何额外数据处理）
 */
- (void)popViewControllerAnimated;


/*
 *  添加下拉刷新 （需要实现 - (void)pulldownToRefresh;）
 
 */
- (void)addRefreshHeaderWithScrollView:(UIScrollView*)scrollView;

/*
 *  添加上拉加载更多 (需要实现 - (void)pullupToLoadMore;）
 */
- (void)addRefreshFooterWithScrollView:(UIScrollView*)scrollView;

/*
 *  进入刷新状态.
 */
- (void)beginRefreshingWithScrollView:(UIScrollView*)scrollView;

/*
 结束下拉刷新状态
 */
- (void)endHeaderRefreshingWithScrollView:(UIScrollView*)scrollView;

/*
 *  结束上拉加载更多状态
 */
- (void)endFooterRefreshingWithScrollView:(UIScrollView*)scrollView refreshStatus:(FooterRefreshStatus)status;

/*
 *  下拉刷新时会被调用，需要重载此函数
 */
- (void)pulldownToRefresh;

/*
 *  上拉加载更多时会被调用，需要重载函数
 */
- (void)pullupToLoadMore;

//返回首页
- (void)backToHomePage;

//请求数据
- (void)didTapNoDataImageTorefreshData;

//开启一个请求，指定一个唯一key，用于后续的取消或删除
- (void)addServiceRequest:(WGBaseServiceRequest*)request key:(NSString*)key;

//取消当前页面指定的的请求
- (void)cancelPageServiceRequestWithKey:(NSString*)key;

//取消当前页面所有的请求
- (void)cancelPageAllServiceRequest;

- (void)setNavigationBarItemWithTitle:(NSString*)title
                                 font:(UIFont*)font
                                color:(UIColor*)textColor
                                image:(NSString*)image
                       highlightImage:(NSString*)highlightImage
                               target:(id)target
                                  sel:(SEL)SEL
                                isLeft:(BOOL)isLeft;

//导航栏设置双图标.
- (void)setNavigationBarItemsWithFirstItem:(void(^__nullable)( UIButton* _Nullable  button))firstItemConfig
                                secondItem:(void(^__nullable)(UIButton* _Nullable button))secondItemConfig
                                    isLeft:(BOOL)isLeft;

/**
 *  返回上页，用到默认返回功能的viewcontroller无需重载，对返回有特殊处理的需要重载
 */
- (void)back;

@end
