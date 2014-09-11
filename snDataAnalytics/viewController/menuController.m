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

@interface menuController () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate,UIViewControllerTransitioningDelegate>

@property (strong, nonatomic)  UITableView *tableView;
@property (strong, nonatomic) NSArray *data;
@property (strong) menuViewController *menuViewController;

@end

@implementation menuController

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
      @{@"text": @"Setting1", @"icon": @"pencil"},
      @{@"text": @"Setting2", @"icon": @"pencil"},
      @{@"text": @"Setting3", @"icon": @"pencil"},
      @{@"text": @"Setting4", @"icon": @"puzzle"},
      @{@"text": @"Setting5", @"icon": @"puzzle"},
      @{@"text": @"Setting6", @"icon": @"puzzle"}
      ];
    //heart camera pencil beaker puzzle glass
    self.view.BackgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
     [self setTitle:@"Setting View"];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
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
    return 70;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if( nil == cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary* dict = self.data[indexPath.row];
    
    cell.textLabel.text = dict[@"text"];
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.imageView setImage:[UIImage imageNamed:dict[@"icon"]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _menuViewController = [[menuViewController alloc] init];
    _menuViewController.view.frame = CGRectMake(0, 0, wkScreenWidth, wkScreenHeight-frontViewRemainHeight);
    NSLog(@"self.navigationController:%@",self.navigationController);
    [self.navigationController pushViewController:_menuViewController animated:YES ];
//    [self.navigationController pushViewController:_menuViewController animated:YES];
//    [self addChildViewController:_menuViewController];

//    [self presentViewController:_menuViewController animated:YES completion:^{
    
//    }];
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
