//
//  PresentingAnimator.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-21.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "PresentingAnimator.h"
#import "UIColor+CustomColors.h"
#import "POP.h"

@interface UIViewController (wkPresentingAnimator)

- (void)_wkDismiss;

@end

@implementation UIViewController (wkPresentingAnimator)

- (void)_wkDismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

@implementation PresentingAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.6f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *fromView = fromVC.view;
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    fromView.userInteractionEnabled = NO;

    UIView *dimmingView = [[UIView alloc] initWithFrame:fromView.bounds];
    dimmingView.backgroundColor = [UIColor customGrayColor];
    dimmingView.layer.opacity = 0.0;
    
    [toView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:fromVC action:@selector(_wkDismiss)]];

    toView.frame = CGRectMake(0,
                              0,
                              CGRectGetWidth(transitionContext.containerView.bounds),
                              CGRectGetHeight(transitionContext.containerView.bounds));
    toView.center = CGPointMake(transitionContext.containerView.center.x, transitionContext.containerView.center.y);
    toView.alpha = 0.0;
    [transitionContext.containerView addSubview:dimmingView];
    [transitionContext.containerView addSubview:toView];

//    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
//    positionAnimation.toValue = @(transitionContext.containerView.center.y);
//    positionAnimation.springBounciness = 10;
//    [positionAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
//        [transitionContext completeTransition:YES];
//    }];

    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.springBounciness = 5;
    scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(2.5, 2.5)];
//    scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.4, 1.4)];
    [scaleAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                [transitionContext completeTransition:YES];
            }];

    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(0.2);
    POPBasicAnimation *opacityAnimation1 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation1.toValue = @(1.0);

//    [toView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    [toView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    [toView.layer pop_addAnimation:opacityAnimation1 forKey:@"opacityAnimation1"];
    [dimmingView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

@end
