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
#import "clickedViewData.h"
#import "TSMessage.h"

#import "PresentingAnimator.h"
#import "DismissingAnimator.h"
#import "POP.h"

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

@interface baseViewController ()

@end

@implementation baseViewController
{
    menuViewController *_menuViewController;
    menuController     *_menuController;
    outlineViewTransitionAnimator *_animator;
    
//    UIView         *_contentView;
    UIScrollView   *_scrollView;
    UIView         *_backgroundView;
    UIView         *_frontView;
    UIView         *_blackView;
    UIScrollView   *_scrollView1;
    
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
}

#pragma mark viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
//    self.view.BackgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    [self setNeedsStatusBarAppearanceUpdate];

//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:173/255.0 green:216.0/255.0 blue:230.0/255.0 alpha:1];
    //72 209 204 [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1]
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;

    [self setTitle:@"Data Analytics Main View"];

    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wkScreenWidth, wkScreenHeight)];
    _contentView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
//     _contentView.BackgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    [self.view addSubview:_contentView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [_scrollView setPagingEnabled:NO];
    [_scrollView setDelegate:self];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setContentSize:CGSizeMake( _scrollView.frame.size.width, self.view.bounds.size.height * 2)];
//    [_contentView addSubview:_scrollView];
    
    CGRect frontViewRect = CGRectMake(0, 0, wkScreenWidth, wkScreenHeight);
    _frontView = [[UIView alloc] initWithFrame:frontViewRect];
//    _frontView.layer.cornerRadius = 8;
    //    _frontView.alpha = 0.2;
    //    _frontView.layer.shadowOpacity = 0.5;
    //    _frontView.layer.shadowRadius = 10;
    //    _frontView.layer.shadowColor = [UIColor blackColor].CGColor;
    //    _frontView.layer.shadowOffset = CGSizeMake(-3, 3);
    
    _text = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 300, 50)];
    [_text setText:@"Data Outline View"];
    [_text setTextColor:[UIColor blackColor]];
    _text.font = [UIFont boldSystemFontOfSize:33];
    _text.textAlignment = NSTextAlignmentCenter;
    FBShimmeringView *shimmeringLogo = [[FBShimmeringView alloc] initWithFrame:CGRectMake(20, 0, 300, 50)];
    shimmeringLogo.contentView = _text;
    shimmeringLogo.shimmeringSpeed = 140;
    shimmeringLogo.shimmering = YES;
    [_frontView addSubview:shimmeringLogo];
    [_frontView addSubview:_text];
    _frontView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
//   _frontView.BackgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    CGRect backgroundViewRect = CGRectMake(0, 0, wkScreenWidth, wkScreenHeight);
    _backgroundView = [[UIView alloc] initWithFrame:backgroundViewRect];
    
    _text1 = [[UILabel alloc] init];
    [_text1 setTextColor:[UIColor blackColor]];
    _text1.font = [UIFont boldSystemFontOfSize:13];
    _text1.frame = CGRectMake(115, 215, 180, 100);
    [_text1 setText:@"frontView"];
    //    [labelCity setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:25]];
    [_backgroundView addSubview:_text1];
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.transform = CGAffineTransformMakeScale(backgroundInitialScale,backgroundInitialScale);
    
    [_contentView addSubview:_backgroundView];
    _blackView = [[UIView alloc] initWithFrame:wkScreen];
    _blackView.backgroundColor = [UIColor blackColor];
    [_contentView addSubview:_blackView];
    [_contentView addSubview:_frontView];
    
    [self addDataView];
    
    _menuController = [[menuController alloc] init];
    _menuController.view.frame = wkScreen;
    _settingView = _menuController.view;
    [_backgroundView addSubview:_settingView];
    [self addChildViewController:_menuController];
    

    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handlePan:)];
    panGestureRecognizer.delegate = self;
    [_contentView addGestureRecognizer:panGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handleTap:)];
    [_frontView addGestureRecognizer:tapGestureRecognizer];
    
    
    
    double delayInSeconds = 1.0;
    __weak id wself = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        baseViewController *strongSelf = wself;
        [strongSelf onApplicationFinishedLaunching];
        NSLog(@"width:%f, height:%f",wkScreenWidth,wkScreenHeight);
        NSLog(@"navigationbar height:%f",self.navigationController.navigationBar.frame.size.height);

    });
    
}

#pragma mark addDataSubview
- (void)addDataView
{
    _scrollView1 = [[UIScrollView alloc] initWithFrame:CGRectMake(mainDataScrollViewMargin, 50, wkScreenWidth - mainDataScrollViewMargin * 2, self.view.frame.size.height)];
    [_scrollView1 setDelegate:self];
    [_scrollView1 setShowsVerticalScrollIndicator:NO];
    [_scrollView1 setContentSize:CGSizeMake(0, self.view.bounds.size.height * 3)];
    [_frontView addSubview:_scrollView1];

    CGFloat width = outleineContainerViewWidth;
    CGFloat height = wkScreenHeight/2 + 10;
    NSLog(@"!!!!!width:%f",width);
    CGFloat originX = 0;
    
    _outlineView1 = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(originX, 0, width, height) dataType:outlineTypeLine inControllerType:outlineView];
    [_scrollView1 addSubview:_outlineView1];
    
    _outlineView2 = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(originX, _outlineView1.frame.origin.y + _outlineView1.frame.size.height + 30, width, height) dataType:outlineTypeBar inControllerType:outlineView];
    [_scrollView1 addSubview:_outlineView2];
    
    _outlineView3 = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(originX, _outlineView2.frame.origin.y + _outlineView2.frame.size.height + 30, width, height) dataType:outlineTypeLine1 inControllerType:outlineView];
    [_scrollView1 addSubview:_outlineView3];
    
    _outlineView4 = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(originX, _outlineView3.frame.origin.y + _outlineView3.frame.size.height + 30, width, height) dataType:outlineTypeCircle inControllerType:outlineView];
    [_scrollView1 addSubview:_outlineView4];
    
    _outLineViewArray = [[NSMutableArray alloc] initWithArray:@[_outlineView1,_outlineView2,_outlineView3,_outlineView4]];
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}

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
        viewController.delegate = self;
//        viewController.title = @"Login";
//        [self.navigationController pushViewController:viewController animated:YES];
        [self presentViewController:viewController animated:YES completion:nil];
    }
}

- (void)onApplicationFinishedLaunching
{
    [self jumoToLoginView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [TSMessage showNotificationWithTitle:@" Network Error" subtitle:@"There is a problem getting the data." type:TSMessageNotificationTypeError];
    });
    
//    NSLog(@"onApplicationFinishedLaunching");
    /*************************************
     Netwokr weather instance
     *************************************/
    [self getNetworkInfo];
    
    
}

#pragma mark - getNetworkInfo
- (void)getNetworkInfo
{
    [networkManager sharedInstance].delegate = self;
    
    [[networkManager sharedInstance] getNetworkInfo:@"http://news-at.zhihu.com/api/3/news/latest"];
    ////http://news-at.zhihu.com/api/3/news/hot;
}

- (BOOL)handleInfoFromNetwork:(NSDictionary *)info
{
    dispatch_main_sync_safe(^{
    });
    
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
                
                if(CGRectContainsPoint(_outlineView1.frame, location)){
                    [self handleTappingOutlineView:1];
                
                }else if(CGRectContainsPoint(_outlineView2.frame, location)){
                    [self handleTappingOutlineView:2];
                    
                }else if(CGRectContainsPoint(_outlineView3.frame, location)){
                    [self handleTappingOutlineView:3];
                    
                }else if(CGRectContainsPoint(_outlineView4.frame, location)){
                    [self handleTappingOutlineView:4];
                }
        }
    }
}

- (void)handleTappingOutlineView:(int)index
{
    dataOutlineViewContainer *targetView;
    
    switch (index) {
        case 1:{
            targetView = _outlineView1;
            }
            break;
        case 2:{
            targetView = _outlineView2;
            }
            break;
        case 3:{
            targetView = _outlineView3;
            }
            break;
        case 4:{
            targetView = _outlineView4;
            }
            break;
        default:
            break;
    }
    
    [self.navigationController setClickedView:targetView];

    CGRect frame = targetView.frame;
    frame = [_scrollView1 convertRect:frame toView:self.view];
    [self.navigationController setClickedViewFrame:@[@(frame.origin.x),@(frame.origin.y - 44.0),@(frame.size.width),@(frame.size.height)]];
    
    [self transitOutlineView:targetView type:(dataVisualizedType)(index - 1)];
}


#pragma mark dataDetailsControllerDelegate
- (void)dismissDetailsController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark loginControllerDelegate
- (void)dismissLoginController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark outlineView transite to detailsView
- (void)transitOutlineView:(dataOutlineViewContainer *)view type:(dataVisualizedType)type
{
    _detailsViewController = [[dataDetailsViewController alloc] initWithFrame:wkScreen type:type];
    _detailsViewController.delegate = self;
    _detailsViewController.modalPresentationStyle = UIModalPresentationCustom;

    _animator = [[outlineViewTransitionAnimator alloc] initWithModalViewController:_detailsViewController];
    _animator.behindViewAlpha = 0.5f;
    _animator.behindViewScale = 0.5f;
    _animator.bounces = YES;
    _animator.dragable = YES;
    
    [_animator setContentScrollView:_detailsViewController.scrollView];
    _animator.direction = (transitonDirection)fmodf(type, 3);
    
    _detailsViewController.transitioningDelegate = _animator;
    
    [self presentViewController:_detailsViewController animated:YES completion:nil];
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
- (NSMutableArray *)outLineViewArray
{
    return _outLineViewArray;
}

- (NSNumber *)clickedOutlineIndex
{
    return _clickedOutLineViewIndex;
}

#pragma mark viewAnimations
- (void)mainViewPullUpFromBottom
{
    [UIView animateWithDuration:0.35
                           delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _backgroundView.transform = CGAffineTransformMakeScale(backgroundInitialScale, backgroundInitialScale);
                         _frontView.center = CGPointMake(wkScreenWidth/2, wkScreenHeight/2);
                         _blackView.alpha  = blackViewMaximumAlpha;
                         
                     } completion:^(BOOL finished) {
                         _frontViewIsDraggedDown = NO;
                         _initalFrontCenterY = _frontView.center.y;
                         _initalBackgroundCenterY = _backgroundView.center.y;
                     }];
}

- (void)mainViewPullDownFromBottom
{
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
                         _frontViewIsDraggedDown = YES;
                     }];
    
}

- (void)mainViewPullUpFromTop
{
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
                         
                     } completion:^(BOOL finished) {
                         _initalFrontCenterY = _frontView.center.y;
                         _initalBackgroundCenterY = _backgroundView.center.y;
                     }];
}



#pragma mark Gesture Control - handlePan
- (void)handleDragDownWithTranslationY:(CGFloat)translationY
{
    _progress += translationY / (wkScreenHeight - frontViewRemainHeight);
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
        if( _progress == 0 && translation.y >= 0) {
//            NSLog(@"drag down");
            _dragDirection = dragdown;
            _dragInProgress = YES;
            
        }else{
//            NSLog(@"drag up");
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
                }
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{
            if(_dragDirection == dragUp){
                
                if (_progress >mainViewPullSuccessedRatio) {
                    [self mainViewPullUpFromBottom];
                    
                }else{
                    [self mainViewPullDownFromBottom];
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
    return YES;
}


@end
