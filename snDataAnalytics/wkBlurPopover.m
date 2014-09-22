//
//  wkBlurPopover.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-12.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "wkBlurPopover.h"
#import "wkBlurPopoverTransitionController.h"

@interface wkBlurPopover () <UIViewControllerTransitioningDelegate>

@property (nonatomic, weak) UIViewController *contentViewController;
@property (nonatomic, strong) wkBlurPopoverTransitionController *transitionController;
@property (nonatomic, strong) wkBlurPopoverInteractiveTransitionController *interactiveTransitionController;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, assign) BOOL isInteractiveDismissal;

@end

@implementation wkBlurPopover

- (instancetype)initWithContentViewController:(UIViewController *)contentViewController
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        self.contentViewController = contentViewController;
        self.transitioningDelegate = self;
        
        // UIModalPresentationCustom won't work after device rotated
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        
        self.throwingGestureEnabled = YES;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor clearColor];
    self.view.clipsToBounds = NO;
    self.contentViewController.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:self.contentViewController.view];
    
    if ([self isThrowingGestureEnabled])
    {
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self.contentViewController.view addGestureRecognizer:self.panGestureRecognizer];
    }
    
    // make content view controller center aligned
    CGRect frame = CGRectZero;
    frame.origin.x = (CGRectGetWidth(self.view.bounds) - self.contentViewController.preferredContentSize.width) / 2;
    frame.origin.y = (CGRectGetHeight(self.view.bounds) - self.contentViewController.preferredContentSize.height) / 2;
    frame.size = [self contentViewController].preferredContentSize;
    self.contentViewController.view.frame = frame;
    NSLog(@"popover frame, origin,x:%f, y:%f ,width:%f, height:%f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addChildViewController:self.contentViewController];
    [self.contentViewController didMoveToParentViewController:self];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gr
{
    CGPoint location = [gr locationInView:self.view];
    
    switch (gr.state) {
        case UIGestureRecognizerStateBegan: {
            self.isInteractiveDismissal = YES;
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.interactiveTransitionController startInteractiveTransitionWithTouchLocation:location];
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            [self.interactiveTransitionController updateInteractiveTransitionWithTouchLocation:location];
            break;
        }
            
        case UIGestureRecognizerStateEnded: case UIGestureRecognizerStateCancelled: {
            CGPoint velocity = [gr velocityInView:self.view];
            self.isInteractiveDismissal = NO;
            if (fabs(velocity.x) + fabs(velocity.y) <= 1000 || gr.state == UIGestureRecognizerStateCancelled)
            {
                [self.interactiveTransitionController cancelInteractiveTransitionWithTouchLocation:location];
            }
            else
            {
                [self.interactiveTransitionController finishInteractiveTransitionWithTouchLocation:location velocity:velocity];
            }
            break;
        }
            
        default:
            break;
    }
}

- (wkBlurPopoverTransitionController *)transitionController
{
    @synchronized(self)
    {
        if (!_transitionController)
        {
            _transitionController = [wkBlurPopoverTransitionController new];
        }
        return _transitionController;
    }
}

- (wkBlurPopoverInteractiveTransitionController *)interactiveTransitionController
{
    @synchronized(self)
    {
        if (!_interactiveTransitionController)
        {
            _interactiveTransitionController = [wkBlurPopoverInteractiveTransitionController new];
        }
        return _interactiveTransitionController;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.transitionController.isPresentation = YES;
    return self.transitionController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.transitionController.isPresentation = NO;
    return self.transitionController;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    if ([self isInteractiveDismissal] && [animator isKindOfClass:[wkBlurPopoverTransitionController class]])
    {
        return self.interactiveTransitionController;
    }
    return nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [self.presentingViewController preferredStatusBarStyle];
}

@end
