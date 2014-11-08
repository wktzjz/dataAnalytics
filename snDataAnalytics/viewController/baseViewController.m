//
//  baseViewController.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-1.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "baseViewController.h"
#import "defines.h"
#import "menuViewController.h"
#import "menuController.h"
#import "outlineViewTransitionAnimator.h"
#import "loginViewController.h"

#import "FBShimmeringView.h"
#import "UIViewController+clickedViewIndex.h"
#import "TSMessage.h"

#import "POP.h"
#import "Colours.h"
#import "changefulButton.h"

#import "wkContextMenuView.h"

#import "realTimeModel.h"
#import "visitorGroupModel.h"
#import "notificationDefine.h"
#import "TLYShyNavBarManager.h"

typedef enum {
    dragUnknown = 0,
    dragUp,
    dragdown
} dragDirection;

typedef enum {
    viewPresentedTypeMiddle = 0,
    viewPresentedTypeup,
    viewPresentedTypeDown
} viewPresentedType;

@interface baseViewController ()<wkContextOverlayViewDataSource, wkContextOverlayViewDelegate/*,UINavigationControllerDelegate*/>

@end

@implementation baseViewController
{
    menuViewController *_menuViewController;
    menuController     *_menuController;
    outlineViewTransitionAnimator *_animator;
    
//    UIView         *_contentView;
    UIScrollView    *_scrollView;
    UIView          *_backgroundView;
    UIView          *_frontView;
    UIView          *_blackView;
    UIScrollView    *_scrollView1;
    changefulButton *_button;
    
    UILabel *_title;
    UILabel *_text;
    UILabel *_text1;
    
    BOOL _frontViewIsDraggedDown;
    BOOL _dragInProgress;
    
    float _progress;
    float _initalSelfCenterY;
    float _initalBackgroundCenterY;
    float _initalFrontCenterY;
    float _addedDragDistanceY;
    float _backgroundViewScale;
    
    int _dragDirection;
    int _viewPresentedType;
    
    NSUserDefaults *_userDefaults;
    
    realTimeModel *_realTimeData;
    
    BOOL _ifUseFlexibleBar;
    BOOL _statusBarShouldHide;
}

#pragma mark viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
     _ifUseFlexibleBar   = YES;
    _statusBarShouldHide = NO;
    
    [self setNeedsStatusBarAppearanceUpdate];

//    self.view.BackgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:173/255.0 green:216.0/255.0 blue:230.0/255.0 alpha:1];
    
//72 209 204 [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1]
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    [self setTitle:@"概览"];
    
    [self addFrontAndBackgroundView];
    [self addDataView];
    [self addBarButton];
    [self addMenuController];
    [self addgestures];

    [self jumoToLoginView];
//    [self addModel];

    double delayInSeconds = 1.0;
    __weak id wself = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        baseViewController *strongSelf = wself;
        [strongSelf addModel];

//        [strongSelf addObservers];
        [[NSNotificationCenter defaultCenter] addObserver:strongSelf
                                                 selector:@selector(handleRealTimeDataDidInitialize:)
                                                     name:dataDidInitialize object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:strongSelf
                                                 selector:@selector(handleRealTimeDataDidChange:)
                                                     name:dataDidChange object:nil];
        
//        NSMutableArray *test1 = [[NSMutableArray alloc] initWithArray:@[@1,@2]];
//        NSMutableArray *test2 = [[NSMutableArray alloc] initWithArray:test1];
//        [test1 removeLastObject];
//        [test2 addObject:@3];
//        NSLog(@"!!!!!!!!!!!!!! test2.count:%i",test2.count);
        
        [strongSelf onApplicationFinishedLaunching];
//        NSLog(@"width:%f, height:%f",wkScreenWidth,wkScreenHeight);
//        NSLog(@"navigationbar height:%f",self.navigationController.navigationBar.frame.size.height);
    });
    
//    wkContextMenuView* overlay = [[wkContextMenuView alloc] init];
//    overlay.dataSource = self;
//    overlay.delegate = self;
//
//    UILongPressGestureRecognizer* _longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:overlay action:@selector(longPressDetected:)];
//    [self.view setUserInteractionEnabled:YES];
//    [self.view addGestureRecognizer:_longPressRecognizer];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setDelegate:self];
}

- (void)addObservers
{
    
}

- (void)addModel
{
    _realTimeData =  [realTimeModel sharedInstance];
    [[visitorGroupModel sharedInstance] initDefineDetails];
    [[visitorGroupModel sharedInstance] initDetailsData];

}


- (void)didSelectItemAtIndex:(NSInteger)selectedIndex forMenuAtPoint:(CGPoint)point
{
    NSString* msg = nil;
    switch (selectedIndex) {
        case 0:
            msg = @"1 Selected";
            break;
        case 1:
            msg = @"2 Selected";
            break;
        case 2:
            msg = @"3 Selected";
            break;
        case 3:
            msg = @"4 Selected";
            break;
        case 4:
            msg = @"5 Selected";
            break;
            
        default:
            break;
    }
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
}

- (void)addFrontAndBackgroundView
{
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wkScreenWidth, wkScreenHeight)];
    _contentView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    //     _contentView.BackgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    [self.view addSubview:_contentView];
    
    CGRect frontViewRect = CGRectMake(0, 0, wkScreenWidth, wkScreenHeight);
    _frontView = [[UIView alloc] initWithFrame:frontViewRect];
    _frontView.layer.shadowOpacity = 0.5;
    _frontView.layer.shadowRadius = 10;
    _frontView.layer.shadowColor = [UIColor blackColor].CGColor;
    _frontView.layer.shadowOffset = CGSizeMake(-3, 3);
    
    if(!_ifUseFlexibleBar){
        _text = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 300, 50)];
        [_text setText:@"Data Outline View"];
        [_text setTextColor:[UIColor blackColor]];
        _text.font = [UIFont boldSystemFontOfSize:33];
        _text.textAlignment = NSTextAlignmentCenter;
    }
    FBShimmeringView *shimmeringLogo = [[FBShimmeringView alloc] initWithFrame:CGRectMake(20, 0, 300, 50)];
    shimmeringLogo.contentView = _text;
    shimmeringLogo.shimmeringSpeed = 140;
    shimmeringLogo.shimmering = YES;
    [_frontView addSubview:shimmeringLogo];
    [_frontView addSubview:_text];
    _frontView.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1];
    //   _frontView.BackgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    CGRect backgroundViewRect = CGRectMake(0, 0, wkScreenWidth, wkScreenHeight);
    _backgroundView = [[UIView alloc] initWithFrame:backgroundViewRect];
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.transform = CGAffineTransformMakeScale(backgroundInitialScale,backgroundInitialScale);
    
    [_contentView addSubview:_backgroundView];
    _blackView = [[UIView alloc] initWithFrame:wkScreen];
    _blackView.backgroundColor = [UIColor blackColor];
    [_contentView addSubview:_blackView];
    [_contentView addSubview:_frontView];
    
//    NSDate *curDate = [NSDate date];
//    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
//    [formater setDateFormat:@"yyyy.MM.dd"];
//    NSString * curTime = [formater stringFromDate:curDate];
}

- (void)addMenuController
{
    _menuController = [[menuController alloc] init];
    //    _menuController.view.frame = wkScreen;
    _settingView = _menuController.view;
    [_backgroundView addSubview:_settingView];
    [self addChildViewController:_menuController];
}

- (void)addgestures
{
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handlePan:)];
    panGestureRecognizer.delegate = self;
    [_contentView addGestureRecognizer:panGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handleTap:)];
    [_frontView addGestureRecognizer:tapGestureRecognizer];
}

- (void)addBarButton
{
    _button = [changefulButton button];
    _button.tintColor = [UIColor blackColor];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:_button];
    [_button addTarget:self action:@selector(handleLeftBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = barButton;
}

- (void)handleLeftBarButtonClicked
{
    if(!_frontViewIsDraggedDown){
        _frontViewIsDraggedDown = YES;
        [self mainViewPullDownFromTop];
    }else{
        [self mainViewPullUpFromBottom];
    }
}

#pragma mark addDataSubview
- (void)addDataView
{
//    CGFloat originY = _ifUseFlexibleBar ? 10 : 50;
    _scrollView1 = [[UIScrollView alloc] initWithFrame:CGRectMake(mainDataScrollViewMargin, 0 , wkScreenWidth - mainDataScrollViewMargin * 2, self.view.frame.size.height)];
    [_scrollView1 setDelegate:self];
    [_scrollView1 setShowsVerticalScrollIndicator:NO];
    [_scrollView1 setContentSize:CGSizeMake(0, self.view.bounds.size.height * 5)];
    [_frontView addSubview:_scrollView1];
    [_scrollView1 setContentOffset:CGPointMake(0, -80)];
    
    if(_ifUseFlexibleBar){
        /* Library code */
        self.shyNavBarManager.scrollView = _scrollView1;
        /* Can then be remove by setting the ExtensionView to nil */
        [self.shyNavBarManager setExtensionView:nil];
    }

    CGFloat width = outleineContainerViewWidth;
    CGFloat height = wkScreenHeight/2 + 10;
//    NSLog(@"!!!!!width:%f",width);
    CGFloat originX = 0;
    
    _realTimeView = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(originX, 10, width, height + 410.0) ifLoading:YES];
    [_scrollView1 addSubview:_realTimeView];
    
    _visitorGruopView = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(originX, _realTimeView.frame.origin.y + _realTimeView.frame.size.height + 20, width, height) ifLoading:YES];
    [_scrollView1 addSubview:_visitorGruopView];
    
    _sourceView = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(originX, _visitorGruopView.frame.origin.y + _visitorGruopView.frame.size.height + 20, width, height - 50.0) ifLoading:YES];
    [_scrollView1 addSubview:_sourceView];
    
    _pageView = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(originX, _sourceView.frame.origin.y + _sourceView.frame.size.height + 20, width, height) ifLoading:YES];
    [_scrollView1 addSubview:_pageView];
    
    _hotCityView = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(originX, _pageView.frame.origin.y + _pageView.frame.size.height + 20, width, height) ifLoading:YES];
    [_scrollView1 addSubview:_hotCityView];
    
    _hotPageView = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(originX, _hotCityView.frame.origin.y + _hotCityView.frame.size.height + 20, width, height) ifLoading:YES];
    [_scrollView1 addSubview:_hotPageView];

    _transformView = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(originX, _hotPageView.frame.origin.y + _hotPageView.frame.size.height + 20, width, height) ifLoading:YES];
    [_scrollView1 addSubview:_transformView];
    
    
    _outLineViewArray = [[NSMutableArray alloc] initWithArray:@[_realTimeView,_visitorGruopView,_sourceView,_pageView,_hotCityView,_hotPageView,_transformView]];
}

#pragma mark - hdndle RealTimeData didChange

- (void)handleRealTimeDataDidInitialize:(NSNotification *)notification
{
//    NSLog(@"handleRealTimeDataDidInitialize");
    if(notification.userInfo != nil && notification.object == _realTimeData) {
        dispatch_main_async_safe(^{
            [_realTimeView addDataViewType:outlineRealTime inControllerType:outlineView data:nil];
        })
    }
}

- (void)handleRealTimeDataDidChange:(NSNotification *)notification
{
//    NSLog(@"handleRealTimeDataDidChange");
    if(notification.userInfo != nil && notification.object == _realTimeData) {
        dispatch_main_async_safe(^{
            [_realTimeView reloadRealTimeData:notification.userInfo];
        })
    }
} 

#pragma mark - viewWillAppear
- (void)viewWillAppear:(BOOL)animated
{
    
}

#pragma mark - Lazy Loading
- (void)jumoToLoginView
{
    _userDefaults = [NSUserDefaults standardUserDefaults];
    
    if(![_userDefaults objectForKey:@"logInSucceeded" ]){
        loginViewController *viewController = [[loginViewController alloc] init];
        
        viewController.dismissBlock = ^{
            [self dismissViewControllerAnimated:YES completion:nil];
//            [self addModel];
            [self getNetworkInfo];
        };
        
//        viewController.delegate = self;
//        viewController.title = @"Login";
//        [self.navigationController pushViewController:viewController animated:YES];
        
        [self presentViewController:viewController animated:YES completion:nil];
    }
}

- (void)onApplicationFinishedLaunching
{
    dispatch_main_async_safe(^{
//        [self jumoToLoginView];
        
        [TSMessage showNotificationWithTitle:@" Network Error" subtitle:@"There is a problem getting the data." type:TSMessageNotificationTypeError];
    });
}

#pragma mark - getNetworkInfo
- (void)getNetworkInfo
{
    [networkManager sharedInstance].delegate = self;
    
    [[networkManager sharedInstance] getNetworkInfo:nil];
     //@"http://news-at.zhihu.com/api/3/news/latest"];
    ////http://news-at.zhihu.com/api/3/news/hot;
}

#pragma mark - handleInfoFromNetwork
- (BOOL)handleInfoFromNetwork:(NSDictionary *)info
{
    if(!info){
        NSArray *visitorGroupData = @[@"实时",@"访客群体分析",@"来源分析",@"页面分析",@"热门城市",@"热门页面",@"转化分析"];
        dispatch_main_async_safe(^{
            [_outLineViewArray enumerateObjectsUsingBlock:^(dataOutlineViewContainer *view, NSUInteger idx, BOOL *stop) {
                if(idx != 0){
                    [view addDataViewType:(viewType)idx inControllerType:outlineView data:visitorGroupData];
                }
            }];
        });
    }
    
    return YES;
}


#pragma mark Gesture Control - handleTap
- (void)handleTap:(UITapGestureRecognizer *)recongnizer
{
    if(_frontViewIsDraggedDown){
           [self mainViewPullUpFromBottom];
        
        }else{
        CGPoint locationInMainView = [recongnizer locationInView:_contentView];
            
            if(CGRectContainsPoint(_scrollView1.frame, locationInMainView)){
                CGPoint location = [recongnizer locationInView:_scrollView1];
                
                if(CGRectContainsPoint(((dataOutlineViewContainer *)_outLineViewArray[0]).frame, location)){
                    [self handleTappingOutlineView:0];
                    
                }else if(CGRectContainsPoint(((dataOutlineViewContainer *)_outLineViewArray[1]).frame, location)){
                    [self handleTappingOutlineView:1];
                
                }else if(CGRectContainsPoint(((dataOutlineViewContainer *)_outLineViewArray[2]).frame, location)){
                    [self handleTappingOutlineView:2];
                    
                }else if(CGRectContainsPoint(((dataOutlineViewContainer *)_outLineViewArray[3]).frame, location)){
                    [self handleTappingOutlineView:3];
                    
                }else if(CGRectContainsPoint(((dataOutlineViewContainer *)_outLineViewArray[4]).frame, location)){
                    [self handleTappingOutlineView:4];
                    
                }else if(CGRectContainsPoint(((dataOutlineViewContainer *)_outLineViewArray[5]).frame, location)){
                    [self handleTappingOutlineView:5];
                }else if(CGRectContainsPoint(((dataOutlineViewContainer *)_outLineViewArray[6]).frame, location)){
                    [self handleTappingOutlineView:6];
                }else{
                    
                }
        }
    }
}

- (void)handleTappingOutlineView:(int)index
{
    dataOutlineViewContainer *targetView;
    
    switch (index) {
        case 0:{
            targetView = _realTimeView;
            }
            break;
        case 1:{
            targetView = _visitorGruopView;
            }
            break;
        case 2:{
            targetView = _sourceView;
            }
            break;
        case 3:{
            targetView = _pageView;
            }
            break;
        case 4:{
            targetView = _hotCityView;
            }
            break;
        case 5:{
            targetView = _hotPageView;
        }
        case 6:{
            targetView = _transformView;
        }
            break;
        default:
            break;
    }
    
    CGRect frame = targetView.frame;
    frame = [_scrollView1 convertRect:frame toView:self.view];
    
//    if(!_ifUseFlexibleBar){
        [self.navigationController setClickedView:targetView];
        [self.navigationController setClickedViewFrame:@[@(frame.origin.x),@(frame.origin.y - navigationBarHeight),@(frame.size.width),@(frame.size.height)]];
//    }else{
//        [self setClickedView:targetView];
//        [self setClickedViewFrame:@[@(frame.origin.x),@(frame.origin.y - navigationBarHeight),@(frame.size.width),@(frame.size.height)]];
//    }
   
    
    [self transitOutlineView:targetView type:(viewType)(index)];
}


#pragma mark dataDetailsControllerDelegate
- (void)dismissDetailsController
{
    [_detailsViewController removeObservers];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark loginControllerDelegate
- (void)dismissLoginController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    /*************************************
     Netwokr weather instance
     *************************************/
    [self getNetworkInfo];
//    [self handleInfoFromNetwork:nil];

}

#pragma mark outlineView transite to detailsView
- (void)transitOutlineView:(dataOutlineViewContainer *)view type:(viewType)type
{
    _detailsViewController = [[dataDetailsViewController alloc] initWithFrame:wkScreen type:type title:@"Details"];
    _detailsViewController.delegate = self;
    _detailsViewController.modalPresentationStyle = UIModalPresentationCustom;
    
    if(type == outlineRealTime){
        _detailsViewController.initializedDataReady = _realTimeData.initializeDataReady;
        _detailsViewController.initializedData = _realTimeData.initializeData;
    }else if(type == outlineVisitorGroup){
        _detailsViewController.initializedDataReady = [visitorGroupModel sharedInstance].initializeDataReady;
        _detailsViewController.initializedData = [visitorGroupModel sharedInstance].initializeData;
    }

    _animator = [[outlineViewTransitionAnimator alloc] initWithModalViewController:_detailsViewController];
    _animator.behindViewAlpha = 0.5f;
    _animator.behindViewScale = 0.5f;
    _animator.bounces  = YES;
    _animator.dragable = YES;
    _animator.delegate = self;
    
//    [_animator setContentScrollView:_detailsViewController.scrollView];
//    if(type == outlineRealTime){
//        _animator.direction = transitonDirectionBottom;
//        [_animator setContentScrollView:_detailsViewController.scrollView];
//    }else{
        _animator.direction = transitonDirectionRight/*(transitonDirection)fmodf(type, 3)*/;
//    }
    
    _detailsViewController.transitioningDelegate = _animator;
    _detailsViewController.modalPresentationCapturesStatusBarAppearance = YES;
    
    [self presentViewController:_detailsViewController animated:YES completion:nil];

}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC
{
    if (operation != UINavigationControllerOperationNone) {
        if(operation == UINavigationControllerOperationPush){
            _animator.isDismiss = NO;
        }else{
            _animator.isDismiss = YES;
        }
        _animator.navigationController = self.navigationController;
        return _animator;
    }
    return nil;
}

- (void)detailViewControllerWillDismiss
{
    [_detailsViewController removeObservers];
    
    /*
    _statusBarShouldHide = NO;
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    } completion:nil];
     */
    
}

#pragma mark - UIViewControllerTransitioningDelegate

//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
//                                                                  presentingController:(UIViewController *)presenting
//                                                                      sourceController:(UIViewController *)source
//{
//    return [PresentingAnimator new];
//}
//
//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
//{
//    return [DismissingAnimator new];
//}

#pragma mark outLineViewTransitionProtocol


#pragma mark viewAnimations
- (void)mainViewPullUpFromBottom
{
    [_button animateToMenu];
    [UIView animateWithDuration:0.35
                           delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _backgroundView.transform = CGAffineTransformMakeScale(backgroundInitialScale, backgroundInitialScale);
                         _frontView.center = CGPointMake(wkScreenWidth/2, wkScreenHeight/2);
                         _blackView.alpha  = blackViewMaximumAlpha;
                          [self setTitle:@"概览"];
                     } completion:^(BOOL finished) {
                         _frontViewIsDraggedDown = NO;
                         _initalFrontCenterY = _frontView.center.y;
                         _initalBackgroundCenterY = _backgroundView.center.y;
                     }];
}

- (void)mainViewPullDownFromBottom
{
    [_button animateToClose];
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.5
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _backgroundView.transform = CGAffineTransformIdentity;
                         _frontView.center = CGPointMake(_frontView.center.x, _initalFrontCenterY);
                         _blackView.alpha =0.0;
                         
                     } completion:^(BOOL finished) {
//                         _frontViewIsDraggedDown = YES;
                     }];
    
}

- (void)mainViewPullUpFromTop
{
    [_button animateToMenu];
    [UIView animateWithDuration:0.8
                          delay:0.0
         usingSpringWithDamping:0.5
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _backgroundView.center = CGPointMake(_backgroundView.center.x, _initalBackgroundCenterY);
                         _frontView.center = CGPointMake(_frontView.center.x, _initalFrontCenterY);
                         _blackView.alpha = blackViewMaximumAlpha;
                         
                     } completion:^(BOOL finished) {
                         _frontViewIsDraggedDown = NO;
                     }];
}

- (void)mainViewPullDownFromTop
{
    [_button animateToClose];
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _backgroundView.transform = CGAffineTransformIdentity;
                         _backgroundView.alpha = 1.0;
                         _frontView.center = CGPointMake(wkScreenWidth/2,(wkScreenHeight -frontViewRemainHeight) + wkScreenHeight/2);
                         _blackView.alpha = 0.0;
                          [self setTitle:@"设置"];
                     } completion:^(BOOL finished) {
                         _initalFrontCenterY = _frontView.center.y;
                         _initalBackgroundCenterY = _backgroundView.center.y;
                     }];
}



#pragma mark Gesture Control - handlePan
- (void)handleDragDownWithTranslationY:(CGFloat)translationY
{
    _progress += translationY / (wkScreenHeight - frontViewRemainHeight);
    
    //we can not drag view up than its original place after we first drag view down.
    if(_progress<0){
        return;
    }
    _progress = _progress >= 0 ? _progress : 0;
    
    _addedDragDistanceY += translationY;
    _frontView.center = CGPointMake(_frontView.center.x ,_initalFrontCenterY + _addedDragDistanceY);
    
    float scale = backgroundInitialScale + _progress * (1 - backgroundInitialScale);
    _backgroundView.transform = CGAffineTransformMakeScale(scale, scale);
    
    _blackView.alpha = blackViewMaximumAlpha - _progress;
}

- (void)handleDragUpWithTranslationY:(CGFloat)translationY
{
    _progress +=  -translationY / (wkScreenHeight - frontViewRemainHeight);
    _progress = _progress >= 0 ? _progress : 0;
    
    _addedDragDistanceY += translationY;
    _frontView.center = CGPointMake(_frontView.center.x ,_initalFrontCenterY + _addedDragDistanceY);
    
    // 1- (1-initacle)*progress
    float scale = backgroundInitialScale + (1 - backgroundInitialScale) * (1 - _progress);
    _backgroundView.transform = CGAffineTransformMakeScale(scale, scale);
    
    _blackView.alpha = (_progress - blackViewMaximumAlpha)> 0 ? blackViewMaximumAlpha : _progress;
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    if(_initalSelfCenterY == 0.0){
        
        _initalSelfCenterY = recognizer.view.center.y;
        _initalBackgroundCenterY = _backgroundView.center.y;
        _initalFrontCenterY = _frontView.center.y;
    }
    
    CGPoint translation = [recognizer translationInView:self.view];
    
    if((!_dragInProgress)){
        if(!_frontViewIsDraggedDown && translation.y < 0){
            return;
        }
        if( _progress == 0 && translation.y > 0) {
//            NSLog(@"drag down");
            _dragDirection = dragdown;
            _dragInProgress = YES;
            
        }else{
//            NSLog(@"drag up");
//            NSLog(@"_frontViewIsDraggedDown:%i",_frontViewIsDraggedDown);
            _dragDirection = dragUp;
            _dragInProgress = YES;
        }
    }
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            break;
        }
            
        case UIGestureRecognizerStateChanged:{
            
            if(_frontViewIsDraggedDown && _dragDirection == dragUp){
                [self handleDragUpWithTranslationY:translation.y];
            }else{
                if(!_frontViewIsDraggedDown && _dragDirection == dragdown){
                    [self handleDragDownWithTranslationY:translation.y];
//                    NSLog(@"in dragdown handling");
                }
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{
            if(_dragDirection == dragUp){
                if(_frontViewIsDraggedDown){
                    if (_progress >mainViewPullSuccessedRatio) {
                        [self mainViewPullUpFromBottom];
                    }else{
                        [self mainViewPullDownFromBottom];
                    }
                }
            }else{
                if(!_frontViewIsDraggedDown){
                    if (_progress >mainViewPullSuccessedRatio) {
                        _frontViewIsDraggedDown = YES;
                        [self mainViewPullDownFromTop];
                    }else{
                        [self mainViewPullUpFromTop];
                    }
                }
            }
            _progress           = 0.0;
            _dragInProgress     = NO;
            _addedDragDistanceY = 0.0;
            
            break;
        }

        case UIGestureRecognizerStateCancelled:{
            recognizer.view.center = CGPointMake(recognizer.view.center.x ,_initalSelfCenterY);
            break;
        }
        case UIGestureRecognizerStateFailed:{
            recognizer.view.center = CGPointMake(recognizer.view.center.x ,_initalSelfCenterY);
            break;
        }
        case UIGestureRecognizerStatePossible:{
            break;
        }
        default:{
            break;
        }
    }
    
    [recognizer setTranslation:CGPointZero inView:self.view];
}

#pragma mark visibleCells
- (NSArray*)visibleCells
{
    if(_menuController){
        return [_menuController visibleCells];
    }else{
        return nil;
    }
}

#pragma mark barSetting
- (BOOL)prefersStatusBarHidden
{
    return !_ifUseFlexibleBar;
}

#pragma mark isIOS8
- (BOOL)isIOS8
{
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"8.0" options: NSNumericSearch];
    if (order == NSOrderedSame || order == NSOrderedDescending) {
        // OS version >= 8.0
        return YES;
    }
    return NO;
}

- (NSInteger)numberOfMenuItems
{
    return 3;
}

- (UIImage *)imageForItemAtIndex:(NSInteger)index
{
    NSString* imageName = nil;
    switch (index) {
        case 0:
            imageName = @"facebook-white";
            break;
        case 1:
            imageName = @"twitter-white";
            break;
        case 2:
            imageName = @"google-plus-white";
            break;
        case 3:
            imageName = @"linkedin-white";
            break;
        case 4:
            imageName = @"pinterest-white";
            break;
            
        default:
            break;
    }
    return [UIImage imageNamed:imageName];
}

@end
