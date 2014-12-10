//
//  menuViewController.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-1.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "Colours.h"
#import "defines.h"
#import "menuViewController.h"
#import "AMWaveTransition.h"
#import "outlineViewTransitionAnimator.h"
#import "dataDetailsViewController.h"
#import "visitorGroupModel.h"
#import "sourcesAnalyticsModel.h"
#import "pageAnalyticsModel.h"
#import "transformAnalyticsModel.h"
#import "PresentingAnimator.h"
#import "DismissingAnimator.h"
#import "lineChartDetailsViewFactory.h"

@interface menuViewController ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate,UIViewControllerTransitioningDelegate>

@property (strong, nonatomic)  UITableView *tableView;
@property (strong, nonatomic)  AMWaveTransition *interactive;

@end

@implementation menuViewController
{
    outlineViewTransitionAnimator *_animator;
    dataDetailsViewController *_detailsViewController;

    NSArray *_dataArray;
    NSArray *_titleArray;
    
    cellType _type;
    viewType _viewControllerType;
    DismissingAnimator *_dismissTransitionController;

}

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (instancetype)initWithType:(cellType)type
{
    if (self = [super init]) {
        _type = type;
        switch (type) {
            case visitorGroup:
            {
                _viewControllerType = outlineVisitorGroup;
                _dataArray = @[@"概览",@"UV",@"PV",@"VISIT",@"新UV",@"有效UV",@"平均页面停留时间",@"提交订单转化率",@"有效订单转化率"];
                break;
            }
            case source:
            {
                _viewControllerType = outlineSource;
                _dataArray = @[@"概览",@"UV",@"PV",@"VISIT",@"新UV",@"有效UV",@"平均页面停留时间",@"提交订单转化率",@"有效订单转化率",@"间接订单数",@"间接订单转化率"];
                break;
            }
            case pageAnalytics:
            {
                _viewControllerType = outlinePageAnalytics;
                _dataArray = @[@"概览",@"PV",@"UV",@"平均页面停留时间",@"一跳",@"四级页面PV",@"购物车PV"];
                break;
            }
            case transform:
            {
                _viewControllerType = outlineTransform;
                _dataArray = @[@"概览",@"UV",@"PV",@"VISIT",@"新UV",@"有效UV",@"平均页面停留时间",@"注册数",@"注册转化率",@"提交订单数",@"提交订单转化率",@"有效订单数",@"有效订单转化率",@"付款金额"];
                break;
            }
            
            default:
                break;
        }
        _titleArray = @[@"账户",@"选择数据来源",@"实时",@"访客群体分析",@"来源分析",@"页面分析",@"转化分析"];
//        _dataArray = @[@"概览",@"访客类型",@"终端类型",@"会员分析-整体",@"会员分析-新会员",@"会员分析-老会员",@"会员等级",@"城市分布"];
        _dismissTransitionController = [DismissingAnimator new];

    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *contentView = [[UIView alloc] initWithFrame:wkScreen];
    [self.view addSubview:contentView];
    [self setTitle:_titleArray[_type]];
//    NSLog(@"menuViewController self.navigationController:%@",self.navigationController);

//    contnetView.BackgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    contentView.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [contentView addSubview:_tableView];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    _interactive = [[AMWaveTransition alloc] init];
    
//    _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    _tableView.backgroundColor = [UIColor colorWithRed:135/255.0 green:206.0/255.0 blue:238.0/255.0 alpha:1];
//    _tableView.backgroundColor = [UIColor denimColor];

//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;

//    if([self isIOS8]){
//        [self.navigationItem setHidesBackButton:YES];
//    }
    
    [self setNeedsStatusBarAppearanceUpdate];
    
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setDelegate:self];
    [self.interactive attachInteractiveGestureToNavigationController:self.navigationController];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.interactive detachInteractiveGesture];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int returnValue;
    switch (_type) {
        case visitorGroup:
            returnValue = 9;
            break;
        case source:
            returnValue = 11;
            break;
        case pageAnalytics:
            returnValue = 7;
            break;
        case transform:
            returnValue = 14;
            break;
            
        default:
            returnValue = 6;
            break;
    }
    return returnValue;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if ( nil == cell ) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
//    cell.detailTextLabel.text = [_dataArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cellView = [tableView cellForRowAtIndexPath:indexPath];
    
    float scale = 0.95 ;
    
    [UIView animateWithDuration:0.9
                          delay:0.0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         cellView.transform = CGAffineTransformMakeScale(scale, scale);
                         cellView.alpha = 0.8;
                     }
                     completion:^(BOOL finished) {
                     }];

}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cellView = [tableView cellForRowAtIndexPath:indexPath];
    
    [UIView animateWithDuration:0.9
                          delay:0.0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         cellView.transform = CGAffineTransformIdentity;
                         cellView.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                     }];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
           if (indexPath.row == 0) {
            
            id data = nil;
            
            switch (_type) {
                case visitorGroup:{
                    data = [[visitorGroupModel sharedInstance] outlineData];
                }
                    break;
                case source:{
                    data = [[sourcesAnalyticsModel sharedInstance] outlineData];
                }
                    break;
                case pageAnalytics:{
                    data = [[pageAnalyticsModel sharedInstance] outlineData];
                }
                    break;

                case transform:{
                    data = [[transformAnalyticsModel sharedInstance] outlineData];
                }
                    break;
                default:
                    break;
            }
            
            [self transitOutlineView:nil type:_viewControllerType data:data];
            
            
        }else{
//            _detailsViewController = [[dataDetailsViewController alloc] initWithFrame:wkScreen type:(viewType)indexPath.row title:@"Details"];
//            _detailsViewController.delegate  = self;
//            _detailsViewController.modalPresentationStyle = UIModalPresentationCustom;
//            
//            _animator = [[outlineViewTransitionAnimator alloc] initWithModalViewController:_detailsViewController];
//            _animator.behindViewAlpha = 0.5f;
//            _animator.behindViewScale = 0.5f;
//            _animator.bounces  = YES;
//            _animator.dragable = YES;
//            _animator.showSnapView = NO;
//            
//            _detailsViewController.transitioningDelegate = _animator;
//            
//            [self presentViewController:_detailsViewController animated:YES completion:nil];
            
            lineChartDetailsViewController *vc = [[lineChartDetailsViewFactory sharedInstance]
                    getControllerFromView:_viewControllerType detailsType:(indexPath.row - 1)];
            
            __weak typeof(self) weakSelf = self;
            vc.dismissBlock = ^{
                typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf dismissViewControllerAnimated:YES completion:nil];
            };
            
            vc.transitioningDelegate = self;
            vc.modalPresentationStyle = UIModalPresentationCustom;
            
            [_dismissTransitionController wireToViewController:vc];
            _dismissTransitionController.dismissModalViewControllerBlock = ^{
                typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf dismissViewControllerAnimated:YES completion:nil];
            };
            
            vc.modalPresentationCapturesStatusBarAppearance = YES;

            [self presentViewController:vc animated:YES completion:nil];
        }
}

- (void)presentVistorGroupOverview
{
    _detailsViewController = [[dataDetailsViewController alloc] initWithFrame:wkScreen type:outlineVisitorGroup data:[visitorGroupModel sharedInstance].outlineData title:@"访客群体分析"];
    _detailsViewController.delegate = self;
    _detailsViewController.modalPresentationStyle = UIModalPresentationCustom;
    
    _detailsViewController.initializedDataReady = [visitorGroupModel sharedInstance].initializeDataReady;
    _detailsViewController.initializedData = [visitorGroupModel sharedInstance].detailInitializeData;
    
    _animator = [[outlineViewTransitionAnimator alloc] initWithModalViewController:_detailsViewController];
    _animator.behindViewAlpha = 0.5f;
    _animator.behindViewScale = 0.5f;
    _animator.bounces  = YES;
    _animator.dragable = YES;
    _animator.showSnapView = NO;

    _detailsViewController.transitioningDelegate = _animator;
    _detailsViewController.modalPresentationCapturesStatusBarAppearance = YES;
    
    [self presentViewController:_detailsViewController animated:YES completion:nil];
}

#pragma mark outlineView transite to detailsView
- (void)transitOutlineView:(dataOutlineViewContainer *)view type:(viewType)viewControllerType data:(id)data
{
    _detailsViewController = [[dataDetailsViewController alloc] initWithFrame:wkScreen type:viewControllerType data:data title:@"Details"];
    _detailsViewController.delegate = self;
    _detailsViewController.modalPresentationStyle = UIModalPresentationCustom;
    
  if (viewControllerType == outlineVisitorGroup) {
        [_detailsViewController addDetailOutlineViewWithData:[visitorGroupModel sharedInstance].detailInitializeData Type:viewControllerType];
    }else if (viewControllerType == outlineSource){
        [_detailsViewController addDetailOutlineViewWithData:[sourcesAnalyticsModel sharedInstance].detailInitializeData Type:viewControllerType];
    }else if (viewControllerType == outlinePageAnalytics){
        [_detailsViewController addDetailOutlineViewWithData:[pageAnalyticsModel sharedInstance].detailInitializeData Type:viewControllerType];
    }else if (viewControllerType == outlineTransform){
        [_detailsViewController addDetailOutlineViewWithData:[transformAnalyticsModel sharedInstance].detailInitializeData Type:viewControllerType];
    }
    
    _animator = [[outlineViewTransitionAnimator alloc] initWithModalViewController:_detailsViewController];
    _animator.behindViewAlpha = 0.5f;
    _animator.behindViewScale = 0.5f;
    _animator.bounces  = YES;
    _animator.dragable = YES;
    _animator.showSnapView = NO;
    
    _animator.direction = transitonDirectionRight;
    
    _detailsViewController.transitioningDelegate = _animator;
    _detailsViewController.modalPresentationCapturesStatusBarAppearance = YES;
    
    [self presentViewController:_detailsViewController animated:YES completion:nil];
    
}

- (void)detailViewControllerWillDismiss
{
    [_detailsViewController removeObservers];
    
}

#pragma mark dataDetailsControllerDelegate
- (void)dismissDetailsController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return [PresentingAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return _dismissTransitionController;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return _dismissTransitionController.interacting ? _dismissTransitionController : nil;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController          animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC
{
    if (operation != UINavigationControllerOperationNone) {
        return [AMWaveTransition transitionWithOperation:operation];
    }
    return nil;
}

- (NSArray*)visibleCells
{
    return [self.tableView visibleCells];
}

- (void)dealloc
{
    [self.navigationController setDelegate:nil];
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

@end
