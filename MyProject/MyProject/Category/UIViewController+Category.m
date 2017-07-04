//
//  UIViewController+wengu.m
//  EYEE
//
//  Created by Dana on 15/10/14.
//  Copyright © 2015年 wengutech. All rights reserved.
//

#import "UIViewController+Category.h"
#import "UIScrollView+Category.h"
//#import "MJRefresh.h"
#import <AudioToolbox/AudioToolbox.h>
//#import "WGServiceRequest.h"
#import <objc/runtime.h>

static void * MyObjectServiceRequestDicKey = (void *)@"MyObjectServiceRequestDicKey";

@interface UIViewController ()<UIAlertViewDelegate>

@end


@implementation UIViewController (wengu)

// mark - method swizzling
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(swizz_viewWillAppear:);
        
        [self swizzMethodWithOriginalSEL:originalSelector swizzledSEL:swizzledSelector class:class];
        
        originalSelector = @selector(viewDidDisappear:);
        swizzledSelector = @selector(swizz_viewDidDisappear:);
        
        [self swizzMethodWithOriginalSEL:originalSelector swizzledSEL:swizzledSelector class:class];
    }); 
}

+ (void)swizzMethodWithOriginalSEL:(SEL)originalSelector swizzledSEL:(SEL)swizzledSelector class:(Class)class {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)swizz_viewWillAppear:(BOOL)animated {
    [self swizz_viewWillAppear:animated];

    //埋点.
}

- (void)swizz_viewDidDisappear:(BOOL)animated {
    [self swizz_viewDidDisappear:animated];
    
    //埋点.
}

//自定义方法
- (void)showChildController:(UIViewController*)childController
                     inView:(UIView*)hostView
                   animated:(BOOL)animated
            finalStateBlock:(void(^)(void))finalStateBlock
            completionBlock:(void(^)(void))completionBlock
{
    if(!childController)
    {
        return;
    }
    
    [self addChildViewController:childController];
    childController.view.frame = hostView.bounds;
    
    [childController beginAppearanceTransition:YES animated:YES];
    [hostView addSubview:childController.view];
    [childController endAppearanceTransition];
    
    if (![hostView isKindOfClass:[UIScrollView class]]) {
        [childController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(hostView);
        }];
    }
    
    if(!animated)
    {
        if(finalStateBlock)
        {
            finalStateBlock();
        }
        [childController didMoveToParentViewController:self];
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil);
        if(completionBlock)
        {
            completionBlock();
        }
    }
    else
    {
        childController.view.alpha = 0.0f;
        [UIView animateWithDuration:0.4 animations:^{
            childController.view.alpha = 1.0f;
            if(finalStateBlock)
            {
                finalStateBlock();
            }
        } completion:^(BOOL finished) {
            [childController didMoveToParentViewController:self];
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil);
            if(completionBlock)
            {
                completionBlock();
            }
        }];
    }
}

- (void)dismissChildViewController:(UIViewController*)childController
                          animated:(BOOL)animated
                   finalStateBlock:(void(^)(void))finalStateBlock
                   completionBlock:(void(^)(void))completionBlock
{
    if(childController.parentViewController != self)
    {
        return;
    }
    
    [childController willMoveToParentViewController:nil];
    if(!animated)
    {
        if(finalStateBlock)
        {
            finalStateBlock();
        }
        
        [childController beginAppearanceTransition:NO animated:YES];
        [childController.view removeFromSuperview];
        [childController endAppearanceTransition];
//        childController.view = nil;
        [childController removeFromParentViewController];
        childController = nil;
        if(completionBlock)
        {
            completionBlock();
        }
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil);
    }
    else
    {
        childController.view.alpha = 1.0f;
        [UIView animateWithDuration:0.4 animations:^{
            childController.view.alpha = 0.0f;
            if(finalStateBlock)
            {
                finalStateBlock();
            }
        } completion:^(BOOL finished) {
            [childController.view removeFromSuperview];
            [childController removeFromParentViewController];
            if(completionBlock)
            {
                completionBlock();
            }
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil);
        }];
    }
}

- (void)showAlertControllerWithAlertStyle:(UIAlertControllerStyle)style
                                    Title:(NSString*)title
                                  message:(NSString*)message
                              cancelTitle:(NSString*)cancelTitle
                         destructiveTitle:(NSString*)destructiveTitle
                              otherTitles:(NSArray*)otherTitles
                                  handler:(void (^ __nullable)(UIAlertAction *action))handler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    
    UIAlertAction *cancelAction;
    if (cancelTitle) {
        cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:nil];
    } else {
        cancelAction = [UIAlertAction actionWithTitle:WGString(@"cancel_title") style:UIAlertActionStyleCancel handler:nil];
    }
    [alertController addAction:cancelAction];
    
    if (destructiveTitle) {
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (handler) {
                handler(action);
            }
        }];
        [alertController addAction:destructiveAction];
    }
    
    if (otherTitles.count > 0) {
        [otherTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *title = obj;
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (handler) {
                    handler(action);
                }
            }];
            [alertController addAction:defaultAction];
        }];
    }
    
    if (!self.presentedViewController) {
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)setNavigationBarBackgroundColor:(UINavigationBar*)navigationBar color:(UIColor*)color  needBorder:(BOOL)needBorder {
    UIImage *image = [UIImage imageWithColor:color size:CGSizeMake(kWidth, 64 * 2)];
    [navigationBar.layer setBorderWidth:0.0];
    [navigationBar.layer setBorderColor:color.CGColor];
    [navigationBar setBackgroundImage:image forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    if (!needBorder) {
        [navigationBar setShadowImage:[[UIImage alloc] init]];
    } else {
        [navigationBar setShadowImage:nil];
    }
}

- (void)popViewControllerAnimated {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addRefreshHeaderWithScrollView:(UIScrollView*)scrollView {
    [scrollView addRefreshHeaderWithTarget:self action:@selector(pulldownToRefresh)];
}

- (void)addRefreshFooterWithScrollView:(UIScrollView*)scrollView {
    [scrollView addRefreshFooterWithTarget:self action:@selector(pullupToLoadMore)];
}

- (void)beginRefreshingWithScrollView:(UIScrollView*)scrollView {
    if (![scrollView.header isRefreshing]) {
        [scrollView.header beginRefreshing];
    }
}

- (void)endHeaderRefreshingWithScrollView:(UIScrollView*)scrollView {
    if ([scrollView.header isRefreshing]) {
        [scrollView.header endRefreshing];
    }
}

- (void)endFooterRefreshingWithScrollView:(UIScrollView*)scrollView refreshStatus:(FooterRefreshStatus)status {
    
    if ([scrollView.footer isRefreshing]) {
//        scrollView.footer.hidden = NO;
        if (status == EndRefreshStatus) {
            [scrollView.footer endRefreshing];
        }
    }
    
    if (status == NomoreDataStatus) {
        [scrollView.footer endRefreshingWithNoMoreData];
    }
    
    if (status == ResetNomoreDataStatus) {
        [scrollView.footer resetNoMoreData];
    }
}

- (void)pulldownToRefresh {
    
}

- (void)pullupToLoadMore {
    
}

- (void)setDefaultNoDataImageWithView:(UIView*)parentView withImage:(NSString *)imageName hidden:(BOOL)hidden {
    NSInteger contentTag = 11111111;

    if (hidden) {
        UIButton *button = (UIButton*)[parentView viewWithTag:contentTag];
        if (button) {
            [button removeFromSuperview];
            button = nil;
        } else {
            if ([parentView isKindOfClass:[UITableView class]]) {
                UITableView *tableView = (UITableView*)parentView;
                tableView.backgroundView = nil;
            } else if ([parentView isKindOfClass:[UICollectionView class]]) {
                UICollectionView *collectionView = (UICollectionView*)parentView;
                collectionView.backgroundView = nil;
            }
        }
    } else {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        button.imageView.clipsToBounds = YES;
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
        button.frame = CGRectMake(0, 0, kWidth, kWidth);
        [button addTarget:self action:@selector(didTapNoDataImageTorefreshData) forControlEvents:UIControlEventTouchUpInside];
        
        if ([parentView isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView*)parentView;
            tableView.backgroundView = button;
        } else if ([parentView isKindOfClass:[UICollectionView class]]) {
            UICollectionView *collectionView = (UICollectionView*)parentView;
            collectionView.backgroundView = button;
        } else {
            button.tag = contentTag;

            [parentView  addSubview:button];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(parentView);
            }];
        }
    }
}

//#pragma mark
//- (void)didTapedRefreshControlWithView:(PageNoDataView*)view {
//    [self didTapNoDataImageTorefreshData];
//}
//
- (void)didTapNoDataImageTorefreshData {
    //刷新数据
}

#pragma mark - - custom property
#pragma mark - - getter and setter methods
- (NSMutableDictionary*)serivceRequestDic {
    return objc_getAssociatedObject(self, MyObjectServiceRequestDicKey);
}

- (void)setSerivceRequestDic:(NSMutableDictionary *)serivceRequestDic {
    objc_setAssociatedObject(self, MyObjectServiceRequestDicKey, serivceRequestDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)backToHomePage {
}

- (void)addServiceRequest:(WGBaseServiceRequest*)request key:(NSString*)key {
    NSMutableDictionary *dic = self.serivceRequestDic;
    if (!dic) {
        dic = [NSMutableDictionary dictionaryWithCapacity:1];
        self.serivceRequestDic = dic;
    } else {
        WGBaseServiceRequest *lastRequest = [dic hs_getSafeValueWithKey:key];
        [lastRequest cancelRequest];
    }
    
    [dic hs_setSafeValue:request forKey:key];
}

//取消当前页面指定的的请求
- (void)cancelPageServiceRequestWithKey:(NSString*)key {
    WGServiceRequest *request = [self.serivceRequestDic hs_getSafeValueWithKey:key];
    if ([request isKindOfClass:[WGServiceRequest class]]) {
        [request cancelRequest];
        
        [self.serivceRequestDic removeObjectForKey:key];
    }
}

//取消当前页面所有的请求
- (void)cancelPageAllServiceRequest {
    for (WGBaseServiceRequest *request in self.serivceRequestDic.allValues) {
        if ([request isKindOfClass:[WGBaseServiceRequest class]]) {
            [request cancelRequest];
        }
    }
    
    [self.serivceRequestDic removeAllObjects];
}

- (void)setNavigationBarItemWithTitle:(NSString*)title
                                 font:(UIFont*)font
                                color:(UIColor*)textColor
                                image:(NSString*)imageName
                       highlightImage:(NSString*)highlightImageName
                               target:(id)target
                                  sel:(SEL)SEL
                                isLeft:(BOOL)isLeft {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:SEL forControlEvents:UIControlEventTouchUpInside];

    if (imageName) {
        [button setImage:WGImageNamed(imageName) forState:UIControlStateNormal];
        if (highlightImageName) {
            [button setImage:WGImageNamed(highlightImageName) forState:UIControlStateHighlighted];
        }
    }

    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    
        font = font ? font : [UIFont getCommonFontWithFontType:MiddleFontType];
        button.titleLabel.font = font;

        textColor = textColor ? textColor : [UIColor getCommonColorWithColorType:ColorBlueType];
        if (textColor) {
            [button setTitleColor:textColor forState:UIControlStateNormal];
        }
    }
                                
                                    
    [button sizeToFit];
    CGFloat widith = MAX(CGRectGetWidth(button.frame), 60);
    CGSize size = CGSizeMake(widith, 44.0f);
    if (button.bounds.size.width > size.width) {
        size = CGSizeMake(size.width, 44.0f);
    }
    button.bounds = CGRectMake(0, 0, size.width, size.height);
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    button.contentHorizontalAlignment = isLeft ? UIControlContentHorizontalAlignmentLeft : UIControlContentHorizontalAlignmentRight;

    
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = item;
    } else {
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setNavigationBarItemsWithFirstItem:(void(^__nullable)( UIButton* _Nullable  button))firstItemConfig
                                secondItem:(void(^__nullable)(UIButton* _Nullable button))secondItemConfig
                                    isLeft:(BOOL)isLeft {
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setFrame:CGRectMake(0, 0, 35, 40)];
    firstItemConfig(btn1);
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setFrame:CGRectMake(0, 0, 35, 40)];
    secondItemConfig(btn2);
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:btn2];
    
    if (isLeft) {
        item1.width = -5;
        btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.navigationItem.leftBarButtonItems = @[item1,item2];
    } else {
        item2.width = -5;
        btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        btn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.navigationItem.rightBarButtonItems = @[item2,item1];
    }
}

@end
