//
//  DismissingAnimator.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-21.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "DismissingAnimator.h"
#import "POP.h"

@implementation DismissingAnimator
{
    BOOL _shouldComplete;
    UIViewController *_presentingVC;
    id<UIViewControllerContextTransitioning> _transitionContext;
    CATransform3D _tempTransform;

    float _percentComplete;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.6f;
}

//- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
//{
//    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    toVC.view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
//    toVC.view.userInteractionEnabled = YES;
//
//    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//
////    __block UIView *dimmingView;
////    [transitionContext.containerView.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
////        if (view.layer.opacity < 1.f) {
////            dimmingView = view;
////            *stop = YES;
////        }
////    }];
//    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
//    opacityAnimation.toValue = @(0.0);
//    
////    POPBasicAnimation *offscreenAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
////    offscreenAnimation.toValue = @(-fromVC.view.layer.position.y);
////    [offscreenAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
////        [transitionContext completeTransition:YES];
////    }];
//    
//    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//    scaleAnimation.springBounciness = 10;
//    scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.5, 1.5)];
//    //    scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.4, 1.4)];
//    [scaleAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
//        [transitionContext completeTransition:YES];
//    }];
//
//    
//    [fromVC.view.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
//    [fromVC.view.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation1"];
//
////    [dimmingView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
//}



- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    if(_interacting) return;
    
    // 1. Get controllers from transition context
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    toVC.view.userInteractionEnabled = YES;
    
    // 2. Set init frame for fromVC
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect initFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect finalFrame = CGRectOffset(initFrame, screenBounds.size.width, 0);
    
    CGRect originalToViewFrame = toVC.view.frame;
    CGRect r = toVC.view.frame;
    toVC.view.frame = CGRectMake(-200, 0, originalToViewFrame.size.width, originalToViewFrame.size.height);
    
    // 3. Add target view to the container, and move it to back.
    UIView *containerView = [transitionContext containerView];
//    [containerView addSubview:toVC.view];
//    [containerView sendSubviewToBack:toVC.view];
    
    // 4. Do animate now
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
//        fromVC.view.alpha = 0.0;
        fromVC.view.frame = finalFrame;
        toVC.view.frame = originalToViewFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}

-(void)wireToViewController:(UIViewController *)viewController
{
    _presentingVC = viewController;
    [self prepareGestureRecognizerInView:viewController.view];
}

- (void)prepareGestureRecognizerInView:(UIView*)view
{
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [view addGestureRecognizer:gesture];
}

-(CGFloat)completionSpeed
{
    return 1 - self.percentComplete;
}

- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            // 1. Mark the interacting flag. Used when supplying it in delegate.
            _interacting = YES;
            if(_dismissModalViewControllerBlock){
                _dismissModalViewControllerBlock();
            }
//            [_presentingVC dismissViewControllerAnimated:YES completion:nil];
            break;
        case UIGestureRecognizerStateChanged: {
            // 2. Calculate the percentage of guesture
            CGFloat fraction = translation.x / 300.0;
            //Limit it between 0 and 1
            fraction = fminf(fraction, 1.0);
            _percentComplete += fraction;
            _shouldComplete = (_percentComplete > 0.4);

//            NSLog(@"fraction:%f ,_percentComplete:%f",fraction,_percentComplete);
            [self updateInteractiveTransition:fraction];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            // 3. Gesture over. Check if the transition should happen or not
            if (!_shouldComplete || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            } else {
                [self finishInteractiveTransition];
            }
            
             _interacting = NO;
            break;
        }
        default:
            break;
    }
    
    [gestureRecognizer setTranslation:CGPointZero inView:gestureRecognizer.view];
}

-(void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    _transitionContext = transitionContext;
    _percentComplete = 0.0;
//   UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
   UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.userInteractionEnabled = YES;

    CGRect originalToViewFrame = toVC.view.frame;
    toVC.view.frame = CGRectMake(-200, 0, originalToViewFrame.size.width, originalToViewFrame.size.height);
//
//    //    if (![self isIOS8]) {
//    //    _toViewController.view.layer.transform = CATransform3DMakeScale(self.behindViewScale,self.behindViewScale,1);
//    _toViewController.view.layer.transform = CATransform3DScale(_toViewController.view.layer.transform, self.behindViewScale, self.behindViewScale, 1);
//    //    }
//    
//    _tempTransform = _toViewController.view.layer.transform;
//    
//    _toViewController.view.alpha = self.behindViewAlpha;
//    
//    _blackView = [[UIView alloc] initWithFrame:_fromViewController.view.frame];
//    _blackView.backgroundColor = [UIColor blackColor];
    
//    [[transitionContext containerView] bringSubviewToFront:fromViewController.view];
    
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    if(_percentComplete < 0) return;
    
    id<UIViewControllerContextTransitioning> transitionContext = _transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGPoint center = fromViewController.view.center;
    
    center = CGPointMake(center.x + percentComplete * screenBounds.size.width, center.y);
    fromViewController.view.center = center;
    
    center = toViewController.view.center;
    center = CGPointMake(center.x + percentComplete * 200, center.y);
    toViewController.view.center = center;
    
}

- (void)finishInteractiveTransition
{
    id<UIViewControllerContextTransitioning> transitionContext = _transitionContext;

    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // 2. Set init frame for fromVC
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect initFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect finalFrame = CGRectOffset(initFrame, screenBounds.size.width, 0);
    
//    CGRect originalToViewFrame = toVC.view.frame;
//    CGRect r = toVC.view.frame;
//    toVC.view.frame = CGRectMake(-200, 0, originalToViewFrame.size.width, originalToViewFrame.size.height);
    
    // 3. Add target view to the container, and move it to back.
//    UIView *containerView = [transitionContext containerView];
    //    [containerView addSubview:toVC.view];
    //    [containerView sendSubviewToBack:toVC.view];
    
    // 4. Do animate now
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        //        fromVC.view.alpha = 0.0;
        fromVC.view.frame = finalFrame;
        toVC.view.frame = screenBounds;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
//        NSLog(@"![transitionContext transitionWasCancelled] :%i",![transitionContext transitionWasCancelled]);
    }];

}

- (void)cancelInteractiveTransition
{
    id<UIViewControllerContextTransitioning> transitionContext = _transitionContext;
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect initFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect finalFrame = CGRectOffset(initFrame, screenBounds.size.width, 0);

    CGRect originalToViewFrame = toVC.view.frame;

    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        //        fromVC.view.alpha = 0.0;
        fromVC.view.frame = initFrame;
        toVC.view.frame = CGRectMake(-200, 0, originalToViewFrame.size.width, originalToViewFrame.size.height);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:NO];
//        NSLog(@"cancelInteractiveTransition ![transitionContext transitionWasCancelled] :%i",![transitionContext transitionWasCancelled]);
    }];

    
}


@end
