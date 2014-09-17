//
//  menuViewController.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-1.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "menuViewController.h"
#import "AMWaveTransition.h"
#import "defines.h"
#import "outlineViewTransitionAnimator.h"
#import "dataDetailsViewController.h"
#import "Colours.h"


@interface menuViewController ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>

@property (strong, nonatomic)  UITableView *tableView;
@property (strong, nonatomic)  AMWaveTransition *interactive;

@end

@implementation menuViewController
{
    outlineViewTransitionAnimator *_animator;
    dataDetailsViewController *_detailsViewController;

    NSArray *_dataArray;
}

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *contentView = [[UIView alloc] initWithFrame:wkScreen];
    [self.view addSubview:contentView];
    [self setTitle:@"Setting View"];
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

    self.navigationController.interactivePopGestureRecognizer.delegate = self;
     self.navigationController.interactivePopGestureRecognizer.enabled = YES;

    [self setNeedsStatusBarAppearanceUpdate];
    
    _dataArray = @[@"Line",@"Bar",@"Line1",@"Circle"];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
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
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if( nil == cell ) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = @"Detail View";
    cell.detailTextLabel.text = [_dataArray objectAtIndex:fmodf(indexPath.row, 4)];
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
    _detailsViewController = [[dataDetailsViewController alloc] initWithFrame:wkScreen type:fmodf(indexPath.row,3)];
    _detailsViewController.delegate = self;
    _detailsViewController.modalPresentationStyle = UIModalPresentationCustom;
    
    _animator = [[outlineViewTransitionAnimator alloc] initWithModalViewController:_detailsViewController];
    _animator.behindViewAlpha = 0.5f;
    _animator.behindViewScale = 0.5f;
    _animator.bounces = YES;
    _animator.dragable = YES;
    
    _detailsViewController.transitioningDelegate = _animator;
    
    [self presentViewController:_detailsViewController animated:YES completion:nil];
}

#pragma mark dataDetailsControllerDelegate
- (void)disMissDetailsController
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end
