//
//  menuController.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-2.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "menuController.h"

#import "AMWaveTransition.h"
#import "menuViewController.h"
#import "defines.h"
#import "Colours.h"
#import "dataDetailsViewController.h"
#import "outlineViewTransitionAnimator.h"
#import "realTimeModel.h"


@interface menuController () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate,UIViewControllerTransitioningDelegate,dataDetailsControllerDelegate>

@property (strong, nonatomic)  UITableView *tableView;
@property (strong, nonatomic) NSArray *data;
@property (strong) menuViewController *menuViewController;

@end

@implementation menuController
{
    outlineViewTransitionAnimator *_animator;
    dataDetailsViewController *_detailsViewController;
}

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self setTitle:@"Demo"];
    self.data =
    @[
      @{@"text": @"Setting1", @"icon": @"heart"},
      @{@"text": @"Setting2", @"icon": @"heart"},
      @{@"text": @"实时", @"icon": @"puzzle"},
      @{@"text": @"访客群体分析", @"icon": @"puzzle"},
      @{@"text": @"来源分析", @"icon": @"puzzle"},
      @{@"text": @"页面分析", @"icon": @"puzzle"},
      @{@"text": @"热门城市", @"icon": @"puzzle"},
      @{@"text": @"热门页面", @"icon": @"puzzle"},
      @{@"text": @"转化分析", @"icon": @"puzzle"}
      ];
/*    访客群体分析
    来源分析
    页面分析
    热门城市
    热门页面
    转化分析 */
    
    //heart camera pencil beaker puzzle glass
//    self.view.BackgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    self.view.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];

    CGRect frame = self.view.frame;
    _tableView = [[UITableView alloc] initWithFrame:frame];
//    _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
//    _tableView.backgroundColor = [UIColor colorWithRed:135/255.0 green:206.0/255.0 blue:238.0/255.0 alpha:1];
    _tableView.backgroundColor = [UIColor colorWithRed:135/255.0 green:206.0/255.0 blue:238.0/255.0 alpha:1];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
     [self setTitle:@"Setting View"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setDelegate:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0) {
//        
//        static NSString *cellIdentifier = @"AccountCell";
//        
//        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AccountCell"];
//        if ( nil == cell ) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
//        }
//        
//        NSDictionary* dict = self.data[indexPath.row];
//        
//        cell.textLabel.text = @"AccountName 王康";
//        cell.textLabel.textColor = [UIColor whiteColor];
//        [cell setBackgroundColor:[UIColor clearColor]];
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        [cell.imageView setImage:[UIImage imageNamed:dict[@"icon"]]];
//        
//        return cell;
//    }else if (indexPath.row == 1) {
//        
//        static NSString *cellIdentifier = @"choose Data Sources";
//        
//        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AccountCell"];
//        if ( nil == cell ) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
//        }
//        
//        NSDictionary* dict = self.data[indexPath.row];
//        
//        cell.textLabel.text = @"Choose data origin";
//        cell.textLabel.textColor = [UIColor whiteColor];
//        cell.detailTextLabel.text = @"选择数据来源";
//        cell.detailTextLabel.textColor = [UIColor whiteColor];
//        [cell setBackgroundColor:[UIColor clearColor]];
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        [cell.imageView setImage:[UIImage imageNamed:dict[@"icon"]]];
//        
//        return cell;
//    }else{
//        static NSString *cellIdentifier = @"Cell";
//        
//        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
//        if ( nil == cell ) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
//        }
//        
//        NSDictionary* dict = self.data[indexPath.row];
//        
//        cell.textLabel.text = dict[@"text"];
//        cell.textLabel.textColor = [UIColor whiteColor];
//        [cell setBackgroundColor:[UIColor clearColor]];
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        [cell.imageView setImage:[UIImage imageNamed:dict[@"icon"]]];
//        
//        return cell;
//    }
  
        static NSString *cellIdentifier = @"Cell";

       NSDictionary* dict = self.data[indexPath.row];
    
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if ( nil == cell ) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            
            cell.textLabel.textColor = [UIColor whiteColor];
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.imageView setImage:[UIImage imageNamed:dict[@"icon"]]];
        }
    
    if (indexPath.row == 0) {
         cell.textLabel.text = @"AccountName 王康";
    }else if (indexPath.row == 1) {
        cell.textLabel.text = @"Choose data origin";
        cell.detailTextLabel.text = @"选择数据来源";
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    }else{
        cell.textLabel.text = dict[@"text"];
    }
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case account:
            
            break;
        case chooseSource:
            
            break;
        case realTime:{
            
            [self presentRealTimeViewController];
        }
            break;
        case visitorGroup:{
            _menuViewController = [[menuViewController alloc] initWithType:visitorGroup];
            _menuViewController.view.frame = CGRectMake(0, 0, wkScreenWidth, wkScreenHeight-frontViewRemainHeight);
            [self.navigationController pushViewController:_menuViewController animated:YES ];
        }
            
            break;
        default:
            break;
    }
}


- (void)presentRealTimeViewController
{
    _detailsViewController = [[dataDetailsViewController alloc] initWithFrame:wkScreen type:outlineRealTime title:@"实时"];
    _detailsViewController.delegate  = self;
    _detailsViewController.modalPresentationStyle = UIModalPresentationCustom;
    
    _detailsViewController.initializedDataReady = [realTimeModel sharedInstance].initializeDataReady;
    _detailsViewController.initializedData = [realTimeModel sharedInstance].initializeData;
    
    _animator = [[outlineViewTransitionAnimator alloc] initWithModalViewController:_detailsViewController];
    _animator.behindViewAlpha = 0.5f;
    _animator.behindViewScale = 0.5f;
    _animator.bounces  = YES;
    _animator.dragable = YES;
    _animator.showSnapView = NO;
    
    _detailsViewController.modalPresentationCapturesStatusBarAppearance = YES;
    
    _detailsViewController.transitioningDelegate = _animator;
    _detailsViewController.modalPresentationCapturesStatusBarAppearance = YES;
    
    [self presentViewController:_detailsViewController animated:YES completion:nil];
}

#pragma mark dataDetailsControllerDelegate
- (void)dismissDetailsController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC
{
    if (operation != UINavigationControllerOperationNone) {
        return [AMWaveTransition transitionWithOperation:operation andTransitionType:AMWaveTransitionTypeBounce];
    }
    return nil;
}

//- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
//{
//    return self.presentAnimation;
//}
//
//-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
//{
//    return self.dismissAnimation;
//}
//
//-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
////    return self.transitionController.interacting ? self.transitionController : nil;
//}

- (NSArray*)visibleCells
{
    return [self.tableView visibleCells];
}

- (void)dealloc
{
    [self.navigationController setDelegate:nil];
}

@end
