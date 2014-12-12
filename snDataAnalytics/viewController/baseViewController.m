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
#import "visitorGroupModel.h"
#import "notificationDefine.h"
#import "TLYShyNavBarManager.h"
#import "timeView.h"
#import "THDatePickerViewController.h"
#import "notificationDefine.h"

#import "realTimeModel.h"
#import "visitorGroupModel.h"
#import "sourcesAnalyticsModel.h"
#import "pageAnalyticsModel.h"
#import "hotCityModel.h"
#import "hotPageModel.h"
#import "transformAnalyticsModel.h"

#import "authenticationViewController.h"
#import "authenticationManager.h"
#import "flatButton.h"
#import "wkBlurPopover.h"


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

const static CGFloat titleViewHeight = 44.0f;

@interface baseViewController ()<THDatePickerDelegate,wkContextOverlayViewDataSource, wkContextOverlayViewDelegate/*,UINavigationControllerDelegate*/>

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
    changefulButton *_button;
    timeView        *_timeView;
    
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
    id _realTimeInitData;
    id _visitorGroupInitData;
    id _sourceAnalyticsInitData;
    id _pageAnalyticsInitData;
    id _transformAnalyticsInitData;

    BOOL _ifUseFlexibleBar;
    BOOL _statusBarShouldHide;
    
    BOOL _visitorGroupDetailsDataLoaded;
    BOOL _sourceAnalyticsDetailsDataLoaded;
    BOOL _pageAnalyticsDetailsDataLoaded;
    BOOL _transformAnalyticsDetailsDataLoaded;

    LoadingView *_loadingView;
    
    THDatePickerViewController *_datePicker;
    NSDateFormatter *_formatter;
    NSDate *_curDate;

}

#pragma mark viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
     _ifUseFlexibleBar   = YES;
    _statusBarShouldHide = NO;
    _visitorGroupDetailsDataLoaded    = NO;
    _sourceAnalyticsDetailsDataLoaded = NO;
    
    [self setNeedsStatusBarAppearanceUpdate];

//    self.view.BackgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:173/255.0 green:216.0/255.0 blue:230.0/255.0 alpha:1];
    
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];

    [self setTitle:@"概览"];
//    NSMutableDictionary *a = [[NSMutableDictionary alloc] initWithDictionary:@{@"1":@"1"}];
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:@{@"dict1":a}];
//    NSMutableDictionary *b = dict[@"dict1"];
//    NSLog(@"dict1[1]:%@",(NSString *)b[@"1"]);
////    [dict setObject:@{@"1":@"2"} forKey:@"dict1"];
//    [a setObject:@"2" forKey:@"1"];
//    NSLog(@"dict1[1]:%@",(NSString *)b[@"1"]);
//    

    
    [self addFrontAndBackgroundView];
    [self addTimeView];
    [self addDataView];
    [self addBarButton];
    [self addMenuController];
    [self addgestures];

    [self addLoadingBarItem];
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
                                                     name:realTimeDataOutlineDidInitialize object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:strongSelf
                                                 selector:@selector(handleRealTimeDataDidChange:)
                                                     name:realTimeDataDidChange object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:strongSelf
                                                 selector:@selector(handleVisitorGroupOutlineDataDidInitialize:)
                                                     name:visitorGroupOutlineDataDidInitialize object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:strongSelf
                                                 selector:@selector(handleSourceAnalyticsOutlineDataDidInitialize:)
                                                     name:sourceAnalyticsOutlineDataDidInitialize object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:strongSelf
                                                 selector:@selector(handlePageAnalyticsOutlineDataDidInitialize:)
                                                     name:pageAnalyticsOutlineDataDidInitialize object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:strongSelf
                                                 selector:@selector(handleHotCityOutlineDataDidInitialize:)
                                                     name:hotCityOutlineDataDidInitialize object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:strongSelf
                                                 selector:@selector(handleHotPageOutlineDataDidInitialize:)
                                                     name:hotPageOutlineDataDidInitialize object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:strongSelf
                                                 selector:@selector(handleTransformAnalyticsOutlineDataDidInitialize:)
                                                     name:transformAnalyticsOutlineDataDidInitialize object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:strongSelf
//                                                 selector:@selector(jumpToAuthenticationView)
//                                                     name:@"applicationNeedToAuthenticate" object:nil];
        
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

- (void)addObservers
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setDelegate:self];
}

- (void)addLoadingBarItem
{
    _loadingView = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    UIBarButtonItem *loadingItem = [[UIBarButtonItem alloc]initWithCustomView:_loadingView];
    _loadingView.lineColor = PNTwitterColor;
    self.navigationItem.rightBarButtonItem = loadingItem;
    [_loadingView startAnimation];
}

- (void)addModel
{
    _realTimeData =  [realTimeModel sharedInstance];
    [[visitorGroupModel sharedInstance] getOutlineData];
    [[sourcesAnalyticsModel sharedInstance] getOutlineData];
    [[pageAnalyticsModel sharedInstance] getOutlineData];
    [[hotCityModel sharedInstance] getOutlineData];
    [[hotPageModel sharedInstance] getOutlineData];
    [[transformAnalyticsModel sharedInstance] getOutlineData];

//    [[visitorGroupModel sharedInstance] initDetailsData];

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

#pragma mark add views

- (void)addFrontAndBackgroundView
{
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wkScreenWidth, wkScreenHeight)];
    _contentView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    //     _contentView.BackgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    [self.view addSubview:_contentView];
    
    CGRect frontViewRect = CGRectMake(0, 0, wkScreenWidth, wkScreenHeight);
    _frontView = [[UIView alloc] initWithFrame:frontViewRect];
    
//    _frontView.layer.shadowOpacity = 0.5;
//    _frontView.layer.shadowRadius  = 10;
//    _frontView.layer.shadowColor   = [UIColor blackColor].CGColor;
//    _frontView.layer.shadowOffset  = CGSizeMake(-3, 3);
//
//    if (!_ifUseFlexibleBar) {
//        _text = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 300, 50)];
//        [_text setText:@"Data Outline View"];
//        [_text setTextColor:[UIColor blackColor]];
//        _text.font = [UIFont boldSystemFontOfSize:33];
//        _text.textAlignment = NSTextAlignmentCenter;
//    }
//    FBShimmeringView *shimmeringLogo = [[FBShimmeringView alloc] initWithFrame:CGRectMake(20, 0, 300, 50)];
//    shimmeringLogo.contentView = _text;
//    shimmeringLogo.shimmeringSpeed = 140;
//    shimmeringLogo.shimmering = YES;
//    [_frontView addSubview:shimmeringLogo];
//    [_frontView addSubview:_text];
    
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
   // _settingView.frame = CGRectMake(0, 150, 500, 500);
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
    if (!_frontViewIsDraggedDown) {
        _frontViewIsDraggedDown = YES;
        [self mainViewPullDownFromTop];
    }else{
        [self mainViewPullUpFromBottom];
    }
}

#pragma mark addDataSubview
- (void)addTimeView
{
    _curDate = [NSDate date];
    _formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"dd/MM/yyyy --- HH:mm"];
    
    _timeView = [[timeView alloc] initWithFrame:CGRectMake(0, 0.0,self.view.frame.size.width, 50.0)];
    __weak typeof(self) weakSelf = self;
    _timeView.timeViewChoosedBlock = ^{
        typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf datePickerButtonClicked];
    };
    
//    [self.view addSubview:_timeView];
}

#pragma mark datePicker

- (void)datePickerButtonClicked
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        typeof(weakself) strongSelf = weakself;
        
        if (!_datePicker) {
            _datePicker = [THDatePickerViewController datePicker];
        }
        _datePicker.date = _curDate;
        _datePicker.delegate = strongSelf;
        [_datePicker setAllowClearDate:NO];
        [_datePicker setAutoCloseOnSelectDate:NO];
        [_datePicker setDisableFutureSelection:NO];
        [_datePicker setSelectedBackgroundColor:[UIColor colorWithRed:125/255.0 green:208/255.0 blue:0/255.0 alpha:1.0]];
        [_datePicker setCurrentDateColor:[UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [strongSelf presentSemiViewController:_datePicker withOptions:@{
                                                                            KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                                            KNSemiModalOptionKeys.animationDuration : @(0.6),
                                                                            KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
                                                                            }];
            
        });
    });
}


#pragma mark THDatePickerDelegate

-(void)datePickerDonePressed:(THDatePickerViewController *)datePicker selectedDays:(NSMutableDictionary *)selectedDays
{
    [self dismissSemiModalView];
    
    NSArray* arr = [selectedDays allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    
    if (arr.count > 0) {
        _timeView.fromTime = ((THDateDay *)selectedDays[(NSNumber *)arr[0]]).date;
        _timeView.toTime = ((THDateDay *)selectedDays[[arr lastObject]]).date;
        
    }
}

-(void)datePickerCancelPressed:(THDatePickerViewController *)datePicker
{
    [self dismissSemiModalView];
}

#pragma mark addDataSubview
- (void)addDataView
{
//    CGFloat originY = _ifUseFlexibleBar ? 10 : 50;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(mainDataScrollViewMargin, 0 , wkScreenWidth - mainDataScrollViewMargin * 2, self.view.frame.size.height)];
    [_scrollView setDelegate:self];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setContentSize:CGSizeMake(0, self.view.bounds.size.height * 3.8)];
    [_frontView addSubview:_scrollView];
//    [_scrollView setContentOffset:CGPointMake(0, -100) animated:YES];
    
    if (_ifUseFlexibleBar) {
        self.shyNavBarManager.scrollView = _scrollView;
        [self.shyNavBarManager setExtensionView:_timeView];
    }
    [_scrollView setContentOffset:CGPointMake(0, -80) animated:YES];


    CGFloat width = outleineContainerViewWidth;
    CGFloat height = wkScreenHeight/2 + 10;
//    NSLog(@"!!!!!width:%f",width);
    CGFloat originX = 0;
    
    _realTimeView = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(originX, 0, width, height + 490.0) ifLoading:YES];
    [_scrollView addSubview:_realTimeView];
    
    _visitorGruopView = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(originX, _realTimeView.frame.origin.y + _realTimeView.frame.size.height + 20, width, height - 85.0) ifLoading:YES];
    [_scrollView addSubview:_visitorGruopView];
    
    _sourceView = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(originX, _visitorGruopView.frame.origin.y + _visitorGruopView.frame.size.height + 20, width, height - 50.0) ifLoading:YES];
    [_scrollView addSubview:_sourceView];
    
    _pageView = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(originX, _sourceView.frame.origin.y + _sourceView.frame.size.height + 20, width, height/2) ifLoading:YES];
    [_scrollView addSubview:_pageView];
    
    _hotCityView = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(originX, _pageView.frame.origin.y + _pageView.frame.size.height + 20, width, 240) ifLoading:YES];
    [_scrollView addSubview:_hotCityView];
    
    _hotPageView = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(originX, _hotCityView.frame.origin.y + _hotCityView.frame.size.height + 20, width, 240) ifLoading:YES];
    [_scrollView addSubview:_hotPageView];

    _transformView = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(originX, _hotPageView.frame.origin.y + _hotPageView.frame.size.height + 20, width, height - 140.0) ifLoading:YES];
    [_scrollView addSubview:_transformView];
    
    _outLineViewArray = [[NSMutableArray alloc] initWithArray:@[_realTimeView,_visitorGruopView,_sourceView,_pageView,_hotCityView,_hotPageView,_transformView]];
}

#pragma mark - handle RealTimeData notification

- (void)handleRealTimeDataDidInitialize:(NSNotification *)notification
{
//    NSLog(@"handleRealTimeDataDidInitialize");
    if (notification.userInfo != nil && notification.object == _realTimeData) {
        _realTimeInitData = notification.userInfo;
        dispatch_main_async_safe(^{
            [_realTimeView addDataViewType:outlineRealTime inControllerType:outlineView data:notification.userInfo];
            [_realTimeView.loadingView stopAnimation];
        })
    }
}

- (void)handleRealTimeDataDidChange:(NSNotification *)notification
{
//    NSLog(@"handleRealTimeDataDidChange");
    if (notification.userInfo != nil && notification.object == _realTimeData) {
        dispatch_main_async_safe(^{
            [_realTimeView reloadRealTimeData:notification.userInfo];
        })
    }
}

#pragma mark - handle VisitorGroupOutline notification

- (void)handleVisitorGroupOutlineDataDidInitialize:(NSNotification *)notification
{
    if (notification.userInfo != nil && notification.object == [visitorGroupModel sharedInstance]) {
        _visitorGroupInitData = notification.userInfo;
        dispatch_main_async_safe(^{
            [_visitorGruopView addDataViewType:outlineVisitorGroup inControllerType:outlineView data:notification.userInfo];
            [_visitorGruopView.loadingView stopAnimation];
        })
    }
}

#pragma mark - handle analyticsViewOutline notification

- (void)handleSourceAnalyticsOutlineDataDidInitialize:(NSNotification *)notification
{
    if (notification.userInfo != nil && notification.object == [sourcesAnalyticsModel sharedInstance]) {
        _sourceAnalyticsInitData = notification.userInfo;
        dispatch_main_async_safe(^{
            [_sourceView addDataViewType:outlineSource inControllerType:outlineView data:notification.userInfo];
            [_sourceView.loadingView stopAnimation];
        })
    }
}


#pragma mark - handle analyticsViewOutline notification

- (void)handlePageAnalyticsOutlineDataDidInitialize:(NSNotification *)notification
{
    if (notification.userInfo != nil && notification.object == [pageAnalyticsModel sharedInstance]) {
        _pageAnalyticsInitData = notification.userInfo;
        dispatch_main_async_safe(^{
            [_pageView addDataViewType:outlinePageAnalytics inControllerType:outlineView data:notification.userInfo];
            [_pageView.loadingView stopAnimation];
        })
    }
}

- (void)handleHotCityOutlineDataDidInitialize:(NSNotification *)notification
{
    if (notification.userInfo != nil && notification.object == [hotCityModel sharedInstance]) {
        dispatch_main_async_safe(^{
            [_hotCityView addDataViewType:outlineHotCity inControllerType:outlineView data:notification.userInfo];
            [_hotCityView.loadingView stopAnimation];
        })
    }
}

- (void)handleHotPageOutlineDataDidInitialize:(NSNotification *)notification
{
    if (notification.userInfo != nil && notification.object == [hotPageModel sharedInstance]) {
        dispatch_main_async_safe(^{
            [_hotPageView addDataViewType:outlineHotPage inControllerType:outlineView data:notification.userInfo];
            [_hotPageView.loadingView stopAnimation];
        })
    }
}

- (void)handleTransformAnalyticsOutlineDataDidInitialize:(NSNotification *)notification
{
    if (notification.userInfo != nil && notification.object == [transformAnalyticsModel sharedInstance]) {
        _transformAnalyticsInitData = notification.userInfo;
        dispatch_main_async_safe(^{
            [_transformView addDataViewType:outlineTransform inControllerType:outlineView data:notification.userInfo];
            [_transformView.loadingView stopAnimation];
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
    
    if (![_userDefaults boolForKey:@"logInSucceeded"]) {
        loginViewController *viewController = [[loginViewController alloc] init];
        
        viewController.dismissBlock = ^{
            [self dismissViewControllerAnimated:YES completion:nil];
//            [self addModel];
//            [self getNetworkInfo];
        };
        
//        viewController.delegate = self;
//        viewController.title = @"Login";
//        [self.navigationController pushViewController:viewController animated:YES];
        
        [self presentViewController:viewController animated:YES completion:nil];
    }
#if !TARGET_IPHONE_SIMULATOR
    else if ([self isIOS8]){
        [self jumpToAuthenticationView];
    }
#endif
   
    [self getNetworkInfo];
}



#pragma mark - AuthenticationView

- (void)jumpToAuthenticationView
{
//    authenticationViewController *viewController = [[authenticationViewController alloc] init];
//    
//    viewController.dismissBlock = ^{
//        [self dismissViewControllerAnimated:YES completion:nil];
//    };
//    
//    [self presentViewController:viewController animated:YES completion:nil];
    
//    authenticationViewController *viewController = [[authenticationViewController alloc] initWithFrame:CGRectMake(0, 350, 280, 216)];
//    __weak typeof(self) weakSelf = self;
//    
//    viewController.dismissBlock = ^{
//        [self dismissViewControllerAnimated:YES completion:nil];
//    };
//
//    wkBlurPopover *popover = [[wkBlurPopover alloc] initWithContentViewController:viewController];
//    [self presentViewController:popover animated:YES completion:nil];

    UIView *blurView;
    UIVisualEffect *effect;
    effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
    blurView.frame = wkScreen;
    [self.view addSubview:blurView];
    blurView.alpha = 0.0;
    
    flatButton *button = [flatButton button];
    button.backgroundColor = [UIColor clearColor];
    button.alpha = 0.7;
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:@"点击指纹验证" forState:UIControlStateNormal];
    [button setTextColor:[UIColor blackColor]];
    [button addTarget:[authenticationManager sharedInstance] action:@selector(fingerAuthentication) forControlEvents:UIControlEventTouchUpInside];
    [blurView addSubview:button];
    
    [blurView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:blurView
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f
                                                           constant:0]];
    [blurView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:blurView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:-50]];

    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         blurView.alpha = 0.90;
                        }
                     completion: ^(BOOL finished){
                         [[authenticationManager sharedInstance] startAuthentication];
                         
                         [authenticationManager sharedInstance].dismissBlock = ^{
                             dispatch_main_async_safe(^{
                                 [authenticationManager sharedInstance].isAuthenticationg = NO;

                                 [UIView animateWithDuration:0.5
                                                       delay:0.0
                                                     options:UIViewAnimationOptionCurveEaseInOut
                                                  animations:^{
                                                      blurView.alpha = 0.0;
                                                  }completion:^(BOOL finished){
                                                      [blurView removeFromSuperview];
                                                  }];
                             })
                         };
                     }];
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
//    if (!info) {
//        NSArray *stringArray = @[@"实时",@"访客群体分析",@"来源分析",@"页面分析",@"热门城市",@"热门页面",@"转化分析"];
//        dispatch_main_async_safe(^{
//            [_outLineViewArray enumerateObjectsUsingBlock:^(dataOutlineViewContainer *view, NSUInteger idx, BOOL *stop) {
//                if (idx == 4 || idx == 5) {
//                    [view addDataViewType:(viewType)idx inControllerType:outlineView data:stringArray];
//                    if (idx != 1 ) {
////                        [view.loadingView stopAnimation];
//                    }
//
//                }
//            }];
//        });
//        
//    }
    
    //加载完概览页面后 预加载第二屏数据
    [self getDetailsData];

    return YES;
}


#pragma mark getDetailsData

- (void)getDetailsData
{
    [self getVisitorGroupDetailsData];
    [self getSourceAnalyticsDetailsData];
    [self getPageAnalyticsDetailsData];
    [self getTransformDetailData];
}


#pragma mark getVisitorGroupData

- (void)getVisitorGroupDetailsData
{
    [[visitorGroupModel sharedInstance] createDetailOutlineData];
    
    _visitorGroupDetailsDataLoaded = YES;
    [_visitorGruopView.loadingView stopAnimation];
}


#pragma mark getVisitorGroupData

- (void)getSourceAnalyticsDetailsData
{
    [[sourcesAnalyticsModel sharedInstance] createDetailOutlineData];
    
    _sourceAnalyticsDetailsDataLoaded = YES;
    [_sourceView.loadingView stopAnimation];
}


#pragma mark getVisitorGroupData

- (void)getPageAnalyticsDetailsData
{
    [[pageAnalyticsModel sharedInstance] createDetailOutlineData];
    
    _pageAnalyticsDetailsDataLoaded = YES;
    [_pageView.loadingView stopAnimation];
}

- (void)getTransformDetailData
{
    [[transformAnalyticsModel sharedInstance] createDetailOutlineData];
    
    _transformAnalyticsDetailsDataLoaded = YES;
    [_transformView.loadingView stopAnimation];
}


#pragma mark Gesture Control - handleTap

- (void)handleTap:(UITapGestureRecognizer *)recongnizer
{
    if (_frontViewIsDraggedDown) {
           [self mainViewPullUpFromBottom];
        
        }else{
        CGPoint locationInMainView = [recongnizer locationInView:_contentView];
            
            if (CGRectContainsPoint(_scrollView.frame, locationInMainView)) {
                CGPoint location = [recongnizer locationInView:_scrollView];
                
                if (CGRectContainsPoint(((dataOutlineViewContainer *)_outLineViewArray[0]).frame, location)) {
                      [self handleTappingOutlineView:outlineRealTime];
                    
                }else if (CGRectContainsPoint(((dataOutlineViewContainer *)_outLineViewArray[1]).frame, location)) {
                    if (_visitorGroupDetailsDataLoaded) {
                        [self handleTappingOutlineView:outlineVisitorGroup];
                    }
                
                }else if (CGRectContainsPoint(((dataOutlineViewContainer *)_outLineViewArray[2]).frame, location)) {
                    if (_sourceAnalyticsDetailsDataLoaded) {
                        [self handleTappingOutlineView:outlineSource];
                    }
                    
                }else if (CGRectContainsPoint(((dataOutlineViewContainer *)_outLineViewArray[3]).frame, location)) {
                    [self handleTappingOutlineView:outlinePageAnalytics];
                    
//                }else if (CGRectContainsPoint(((dataOutlineViewContainer *)_outLineViewArray[4]).frame, location)) {
//                    [self handleTappingOutlineView:4];
//                    
//                }else if (CGRectContainsPoint(((dataOutlineViewContainer *)_outLineViewArray[5]).frame, location)) {
//                    [self handleTappingOutlineView:5];
                }else if (CGRectContainsPoint(((dataOutlineViewContainer *)_outLineViewArray[outlineTransform]).frame, location)) {
                    [self handleTappingOutlineView:outlineTransform];
                }else{
                    
                }
        }
    }
}

- (void)handleTappingOutlineView:(int)index
{
    dataOutlineViewContainer *targetView;
    id data = nil;
    
    switch (index) {
        case 0:{
            targetView = _realTimeView;
            data = _realTimeInitData;
            }
            break;
        case 1:{
            targetView = _visitorGruopView;
            data = _visitorGroupInitData;
            }
            break;
        case 2:{
            targetView = _sourceView;
            data = _sourceAnalyticsInitData;
            }
            break;
        case 3:{
            targetView = _pageView;
            data = _pageAnalyticsInitData;
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
            data = _transformAnalyticsInitData;
        }
            break;
        default:
            break;
    }
    
    CGRect frame = targetView.frame;
    frame = [_scrollView convertRect:frame toView:self.view];
    
//    if (!_ifUseFlexibleBar) {
        [self.navigationController setClickedView:targetView];

        [self.navigationController setClickedViewFrame:@[@(frame.origin.x),@(frame.origin.y - navigationBarHeight),@(frame.size.width),@(frame.size.height)]];
//    }else{
//        [self setClickedView:targetView];
//        [self setClickedViewFrame:@[@(frame.origin.x),@(frame.origin.y - navigationBarHeight),@(frame.size.width),@(frame.size.height)]];
//    }
   
    
    [self transitOutlineView:targetView type:(viewType)(index) data:data];
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
- (void)transitOutlineView:(dataOutlineViewContainer *)view type:(viewType)type data:(id)data
{
    _detailsViewController = [[dataDetailsViewController alloc] initWithFrame:wkScreen type:type data:data title:@"Details"];
    _detailsViewController.delegate = self;
    _detailsViewController.modalPresentationStyle = UIModalPresentationCustom;
    
    if (type == outlineRealTime) {
        _detailsViewController.initializedDataReady = _realTimeData.initializeDataReady;
        _detailsViewController.initializedData      = _realTimeData.initializeData;
    }else if (type == outlineVisitorGroup) {
        [_detailsViewController addDetailOutlineViewWithData:[visitorGroupModel sharedInstance].detailInitializeData Type:type];
//        _detailsViewController.initializedDataReady = [visitorGroupModel sharedInstance].initializeDataReady;
//        _detailsViewController.initializedData      = [visitorGroupModel sharedInstance].detailInitializeData;
    }else if (type == outlineSource){
        [_detailsViewController addDetailOutlineViewWithData:[sourcesAnalyticsModel sharedInstance].detailInitializeData Type:type];
//        _detailsViewController.initializedDataReady = [sourcesAnalyticsModel sharedInstance].initializeDataReady;
//        _detailsViewController.initializedData      = [sourcesAnalyticsModel sharedInstance].detailInitializeData;
    }else if (type == outlinePageAnalytics){
         [_detailsViewController addDetailOutlineViewWithData:[pageAnalyticsModel sharedInstance].detailInitializeData Type:type];
//        _detailsViewController.initializedDataReady = [pageAnalyticsModel sharedInstance].initializeDataReady;
//        _detailsViewController.initializedData      = [pageAnalyticsModel sharedInstance].detailInitializeData;
    }else if (type == outlineTransform){
        [_detailsViewController addDetailOutlineViewWithData:[transformAnalyticsModel sharedInstance].detailInitializeData Type:type];
//        _detailsViewController.initializedDataReady = [transformAnalyticsModel sharedInstance].initializeDataReady;
//        _detailsViewController.initializedData      = [transformAnalyticsModel sharedInstance].detailInitializeData;
    }

    _animator = [[outlineViewTransitionAnimator alloc] initWithModalViewController:_detailsViewController];
    _animator.behindViewAlpha = 0.5f;
    _animator.behindViewScale = 0.5f;
    _animator.bounces  = YES;
    _animator.dragable = YES;
    _animator.delegate = self;
    
//    [_animator setContentScrollView:_detailsViewController.scrollView];
    _animator.direction = transitonDirectionRight;

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
        if (operation == UINavigationControllerOperationPush) {
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
    if([self isIOS8]){
    [self.shyNavBarManager setExtensionView:_timeView];
    }

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
                         
                         if(![self isIOS8]){
                             [self.shyNavBarManager setExtensionView:_timeView];
                         }

                     }];
}

- (void)mainViewPullDownFromBottom
{
    [_button animateToClose];
    [self.shyNavBarManager setExtensionView:nil];

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
                         [self setTitle:@"设置"];
//                         _frontViewIsDraggedDown = YES;
                     }];
    
}

- (void)mainViewPullUpFromTop
{
    [_button animateToMenu];
    [self.shyNavBarManager setExtensionView:_timeView];

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
                         [self setTitle:@"概览"];
                         _frontViewIsDraggedDown = NO;
                     }];
}

- (void)mainViewPullDownFromTop
{
    [_button animateToClose];
    [self.shyNavBarManager setExtensionView:nil];

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
    if (_progress<0) {
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
    if (_initalSelfCenterY == 0.0) {
        
        _initalSelfCenterY = recognizer.view.center.y;
        _initalBackgroundCenterY = _backgroundView.center.y;
        _initalFrontCenterY = _frontView.center.y;
    }
    
    CGPoint translation = [recognizer translationInView:self.view];
    
    if ((!_dragInProgress)) {
        if (!_frontViewIsDraggedDown && translation.y < 0) {
            return;
        }
        if ( _progress == 0 && translation.y > 0) {
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
            
            if (_frontViewIsDraggedDown && _dragDirection == dragUp) {
                [self handleDragUpWithTranslationY:translation.y];
            }else{
                if (!_frontViewIsDraggedDown && _dragDirection == dragdown) {
                    [self handleDragDownWithTranslationY:translation.y];
//                    NSLog(@"in dragdown handling");
                }
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{
            if (_dragDirection == dragUp) {
                if (_frontViewIsDraggedDown) {
                    if (_progress >mainViewPullSuccessedRatio) {
                        [self mainViewPullUpFromBottom];
                    }else{
                        [self mainViewPullDownFromBottom];
                    }
                }
            }else{
                if (!_frontViewIsDraggedDown) {
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
    if (_menuController) {
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
