//
//  outlineViewTransitionAnimator.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-4.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "outlineViewTransitionAnimator.h"
#import "UIViewController+clickedViewIndex.h"
#import "outLineViewTransitionProtocol.h"
#import "clickedViewData.h"
#import "defines.h"
#import "UIView+snapShot.h"

@implementation outlineViewTransitionAnimator
{
    UIViewController *_modalController;
    id<UIViewControllerContextTransitioning> _transitionContext;
    detectScrollViewEndGestureRecognizer *_gesture;
    CGFloat _panLocationStart;
    BOOL _isDismiss;
    BOOL _isInteractive;
    CATransform3D _tempTransform;
    
    UIView *_blackView;
    UIViewController *_fromViewController;
    UIViewController *_toViewController;
    
    UIView *_clickedOutlineView;
    UIImageView *_snapView;
    CGRect _snapInitialFrame;
}

- (instancetype)initWithModalViewController:(UIViewController *)modalViewController
{
    self = [super init];
    if (self) {
        _modalController = modalViewController;
        _dragable = NO;
        _direction = transitonDirectionLeft;
        _behindViewScale = 0.9f;
        _behindViewAlpha = 1.0f;
        }
    
    return self;
}

- (void)setDragable:(BOOL)dragable
{
    _dragable = dragable;
    if (self.isDragable) {
        _gesture = [[detectScrollViewEndGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        _gesture.delegate = self;
        
        [_modalController.view addGestureRecognizer:_gesture];
    }
}

- (void)setContentScrollView:(UIScrollView *)scrollView
{
    _gesture.scrollview = scrollView;
}


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.8;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (_isInteractive) {
        return;
    }
//    // Grab the from and to view controllers from the context
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (!_isDismiss) {

//        CGRect startRect;
//        
//        [[transitionContext containerView] addSubview:toViewController.view];
//        
//        toViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        
//        if (self.direction == transitonDirectionBottom) {
//            startRect = CGRectMake(0,
//                                   CGRectGetHeight(toViewController.view.frame),
//                                   CGRectGetWidth(toViewController.view.bounds),
//                                   CGRectGetHeight(toViewController.view.bounds));
//        } else if (self.direction == transitonDirectionLeft) {
//            startRect = CGRectMake(-CGRectGetWidth(toViewController.view.frame),
//                                   0,
//                                   CGRectGetWidth(toViewController.view.bounds),
//                                   CGRectGetHeight(toViewController.view.bounds));
//        } else if (self.direction == transitonDirectionRight) {
//            startRect = CGRectMake(CGRectGetWidth(toViewController.view.frame),
//                                   0,
//                                   CGRectGetWidth(toViewController.view.bounds),
//                                   CGRectGetHeight(toViewController.view.bounds));
//        }
//
//        CGPoint transformedPoint = CGPointApplyAffineTransform(startRect.origin, toViewController.view.transform);
//        toViewController.view.frame = CGRectMake(transformedPoint.x, transformedPoint.y, startRect.size.width, startRect.size.height);
//        
//        [UIView animateWithDuration:[self transitionDuration:transitionContext]
//                              delay:0
//             usingSpringWithDamping:5
//              initialSpringVelocity:15
//                            options:UIViewAnimationOptionCurveEaseOut
//                         animations:^{
//                             
//                             fromViewController.view.transform = CGAffineTransformScale(fromViewController.view.transform, self.behindViewScale, self.behindViewScale);
//                             fromViewController.view.alpha = self.behindViewAlpha;
//                             
//                             toViewController.view.frame = CGRectMake(0,0,
//                                                                      CGRectGetWidth(toViewController.view.frame),
//                                                                      CGRectGetHeight(toViewController.view.frame));
//                             
//                             
//                         } completion:^(BOOL finished) {
//                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//                             
//                         }];

        
//        UIViewController <outLineViewTransitionProtocol> *fromViewController = (UIViewController <outLineViewTransitionProtocol> * )([transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey]);
        
        UIView *containerView = [transitionContext containerView];
        UIView *fromView = fromViewController.view;
        UIView *toView = toViewController.view;
        
        //in iOS8 we cannot
//        [containerView addSubview:fromView];
        [containerView addSubview:toView];

        
/* get the clicked outlineView we have stored in fromViewController */
        _clickedOutlineView = (UIView *)[fromViewController clickedView];

/* get the imageSnapshot View of the clicked View */
        _snapView = [[UIImageView alloc] initWithImage:[_clickedOutlineView snapshot] ];
        
/* set the snapshot view frame as the clicked outlineView is in mainView */
        NSArray *arrayOfFrame = (NSArray *)[fromViewController clickedViewFrame];
        _snapInitialFrame = CGRectMake( ((NSNumber *)arrayOfFrame[0]).floatValue, ((NSNumber *)arrayOfFrame[1]).floatValue + navigationBarHeight,((NSNumber *)arrayOfFrame[2]).floatValue, ((NSNumber *)arrayOfFrame[3]).floatValue );
        [_snapView setFrame:_snapInitialFrame];
        
        
//        NSLog(@"clickedOutlineView1 :%@",_clickedOutlineView);
        NSLog(@"imageView origin.x: %f, y:%f, width:%f, height:%f",_snapView.frame.origin.x,_snapView.frame.origin.y,_snapView.frame.size.width,_snapView.frame.size.height);
        
        toView.alpha = 0.0;
        [containerView addSubview:_snapView];
        
        CGFloat animationScale = wkScreenWidth/220;
        
        [UIView animateWithDuration:0.6
                              delay:0.0
             usingSpringWithDamping:0.6
              initialSpringVelocity:0.5
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            CGRect frameRect = _snapView.frame;
            frameRect.origin = CGPointMake(20,10);
            _snapView.frame = frameRect;
            fromView.alpha = 0.00;
//            fromView.transform = CGAffineTransformMakeScale(animationScale,animationScale);
//            fromView.frame = CGRectMake(-(leftUpperPoint.x)*animationScale,
//                                        -(leftUpperPoint.y-offsetStatuBar)*animationScale+offsetStatuBar-1,
//                                        fromView.frame.size.width,
//                                        fromView.frame.size.height);
        } completion:^(BOOL finished) {
            if (finished) {
                fromView.transform = CGAffineTransformIdentity;
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }
        }];
        
        [UIView animateWithDuration:1.2 animations:^{
            toView.alpha = 1.0;
        } completion:^(BOOL finished) {            
            // set the _snapView hidden so we could use it later
//            _snapView.alpha = 0.0 ;
            _snapView.hidden = YES;
        }];
        
    }else{
    // Grab the from and to view controllers from the context
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

        if(_snapView){
            _snapView.hidden = NO;
           [_snapView setFrame:_snapInitialFrame];
        }
        [[transitionContext containerView] bringSubviewToFront:fromViewController.view];
  
        NSLog(@"_snapInitialFrame.origin.x:%f, y:%f",_snapInitialFrame.origin.x,_snapInitialFrame.origin.y);
    
//        if (![self isIOS8]) {
            toViewController.view.layer.transform = CATransform3DScale(toViewController.view.layer.transform, self.behindViewScale, self.behindViewScale, 1);
//        }
        
        toViewController.view.alpha = self.behindViewAlpha;
        
        CGRect endRect;
        
        if (self.direction == transitonDirectionBottom) {
            endRect = CGRectMake(0,
                                 CGRectGetHeight(fromViewController.view.bounds),
                                 CGRectGetWidth(fromViewController.view.frame),
                                 CGRectGetHeight(fromViewController.view.frame));
        } else if (self.direction == transitonDirectionLeft) {
            endRect = CGRectMake(-CGRectGetWidth(fromViewController.view.bounds),
                                 0,
                                 CGRectGetWidth(fromViewController.view.frame),
                                 CGRectGetHeight(fromViewController.view.frame));
        } else if (self.direction == transitonDirectionRight) {
            endRect = CGRectMake(CGRectGetWidth(fromViewController.view.bounds),
                                 0,
                                 CGRectGetWidth(fromViewController.view.frame),
                                 CGRectGetHeight(fromViewController.view.frame));
        }
        
        CGPoint transformedPoint = CGPointApplyAffineTransform(endRect.origin, fromViewController.view.transform);
        endRect = CGRectMake(transformedPoint.x, transformedPoint.y, endRect.size.width, endRect.size.height);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
             usingSpringWithDamping:0.6
              initialSpringVelocity:0.5
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             CGFloat scaleBack = (1 / self.behindViewScale);
                             toViewController.view.layer.transform = CATransform3DScale(toViewController.view.layer.transform, scaleBack, scaleBack, 1);
                             toViewController.view.alpha = 1.0f;
                             fromViewController.view.frame = endRect;
                         } completion:^(BOOL finished) {
                             if(_snapView){
                                [_snapView removeFromSuperview];
                             }
//                             toViewController.view.layer.transform = CATransform3DIdentity;
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                             
                         }];
    }
}

- (void)animationEnded:(BOOL)transitionCompleted
{
    // Reset to our default state
    _isInteractive = NO;
    _transitionContext = nil;
}

# pragma mark - Gesture

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    // Location reference
    CGPoint location = [recognizer locationInView:_modalController.view.window];
    location = CGPointApplyAffineTransform(location, CGAffineTransformInvert(recognizer.view.transform));
    // Velocity reference
    CGPoint velocity = [recognizer velocityInView:[_modalController.view window]];
    velocity = CGPointApplyAffineTransform(velocity, CGAffineTransformInvert(recognizer.view.transform));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _isInteractive = YES;
        
/* add _snapView when the dismiss animation begins*/
        if(_snapView && _direction!=transitonDirectionBottom){
            _snapView.hidden = NO;
            _snapView.alpha = 0.0;
            [_snapView setFrame:_snapInitialFrame];
        }
/****************/
        
        if (self.direction == transitonDirectionBottom) {
            _panLocationStart = location.y;
        } else {
            _panLocationStart = location.x;
        }
        [_modalController dismissViewControllerAnimated:YES completion:nil];
    }
    
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat animationRatio = 0;
        
        if (self.direction == transitonDirectionBottom) {
            animationRatio = (location.y - _panLocationStart) / (CGRectGetHeight([_modalController view].bounds));
        } else if (self.direction == transitonDirectionLeft) {
            animationRatio = (_panLocationStart - location.x) / (CGRectGetWidth([_modalController view].bounds));
        } else if (self.direction == transitonDirectionRight){
                animationRatio = (location.x - _panLocationStart) / (CGRectGetWidth([_modalController view].bounds));
        }
        
        [self updateInteractiveTransition:animationRatio];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGFloat velocityForSelectedDirection;
        
        if (self.direction == transitonDirectionBottom) {
            velocityForSelectedDirection = velocity.y;
        } else {
            velocityForSelectedDirection = velocity.x;
        }
        
        if (velocityForSelectedDirection > 100
            && (self.direction == transitonDirectionRight
                || self.direction == transitonDirectionBottom)) {
                [self finishInteractiveTransition];
            } else if (velocityForSelectedDirection < -100 && self.direction == transitonDirectionLeft) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
        _isInteractive = NO;
    }
}

#pragma mark -

-(void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    _transitionContext = transitionContext;
    
    _fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    _toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
//    if (![self isIOS8]) {
//    _toViewController.view.layer.transform = CATransform3DMakeScale(self.behindViewScale,self.behindViewScale,1);
        _toViewController.view.layer.transform = CATransform3DScale(_toViewController.view.layer.transform, self.behindViewScale, self.behindViewScale, 1);
//    }
    
    _tempTransform = _toViewController.view.layer.transform;
    
    _toViewController.view.alpha = self.behindViewAlpha;
    
    _blackView = [[UIView alloc] initWithFrame:_fromViewController.view.frame];
    _blackView.backgroundColor = [UIColor blackColor];

    [[transitionContext containerView] bringSubviewToFront:_fromViewController.view];

}

- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    if (!_bounces && percentComplete < 0) {
        percentComplete = 0;
    }
    
    id<UIViewControllerContextTransitioning> transitionContext = _transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    float scaleRatio = 1 + (((1 / self.behindViewScale) - 1) * percentComplete);
    CATransform3D transform = CATransform3DMakeScale(scaleRatio,scaleRatio, 1);
    toViewController.view.layer.transform = CATransform3DConcat(_tempTransform, transform);
    
    toViewController.view.alpha = self.behindViewAlpha + ((1 - self.behindViewAlpha) * percentComplete);
    
    if(_snapView && _direction!=transitonDirectionBottom){
        _snapView.alpha = toViewController.view.alpha + 0.4;
    }
    
    CGRect updateRect;
    if (self.direction == transitonDirectionBottom) {
        updateRect = CGRectMake(0,
                                (CGRectGetHeight(fromViewController.view.bounds) * percentComplete),
                                CGRectGetWidth(fromViewController.view.frame),
                                CGRectGetHeight(fromViewController.view.frame));
    } else if (self.direction == transitonDirectionLeft) {
        updateRect = CGRectMake(-(CGRectGetWidth(fromViewController.view.bounds) * percentComplete),
                                0,
                                CGRectGetWidth(fromViewController.view.frame),
                                CGRectGetHeight(fromViewController.view.frame));
    } else if (self.direction == transitonDirectionRight) {
        updateRect = CGRectMake(CGRectGetWidth(fromViewController.view.bounds) * percentComplete,
                                0,
                                CGRectGetWidth(fromViewController.view.frame),
                                CGRectGetHeight(fromViewController.view.frame));
    }
    
    CGPoint transformedPoint = CGPointApplyAffineTransform(updateRect.origin, fromViewController.view.transform);
    updateRect = CGRectMake(transformedPoint.x, transformedPoint.y, updateRect.size.width, updateRect.size.height);
    
    fromViewController.view.frame = updateRect;
}

- (void)finishInteractiveTransition
{
    id<UIViewControllerContextTransitioning> transitionContext = _transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect endRect;
    
    if (self.direction == transitonDirectionBottom) {
        endRect = CGRectMake(0,
                             CGRectGetHeight(fromViewController.view.bounds),
                             CGRectGetWidth(fromViewController.view.frame),
                             CGRectGetHeight(fromViewController.view.frame));
    } else if (self.direction == transitonDirectionLeft) {
        endRect = CGRectMake(-CGRectGetWidth(fromViewController.view.bounds),
                             0,
                             CGRectGetWidth(fromViewController.view.frame),
                             CGRectGetHeight(fromViewController.view.frame));
    } else if (self.direction == transitonDirectionRight) {
        endRect = CGRectMake(CGRectGetWidth(fromViewController.view.bounds),
                             0,
                             CGRectGetWidth(fromViewController.view.frame),
                             CGRectGetHeight(fromViewController.view.frame));
    }
    
    CGPoint transformedPoint = CGPointApplyAffineTransform(endRect.origin, fromViewController.view.transform);
    endRect = CGRectMake(transformedPoint.x, transformedPoint.y, endRect.size.width, endRect.size.height);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGFloat scaleBack = (1 / self.behindViewScale);
                         toViewController.view.layer.transform = CATransform3DScale(_tempTransform, scaleBack, scaleBack, 1);
                         toViewController.view.alpha = 1.0f;
                         fromViewController.view.frame = endRect;
                     } completion:^(BOOL finished) {
                         NSLog(@"finish");
                         
                         if(_snapView && _direction!=transitonDirectionBottom){
                             [_snapView removeFromSuperview];
                         }
                         
                         [transitionContext completeTransition:YES];
                         _modalController = nil;
                     }];
    
}

- (void)cancelInteractiveTransition
{
    id<UIViewControllerContextTransitioning> transitionContext = _transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         toViewController.view.layer.transform = _tempTransform;
                         toViewController.view.alpha = self.behindViewAlpha;
                         
                         fromViewController.view.frame = CGRectMake(0,0,
                                                                    CGRectGetWidth(fromViewController.view.frame),
                                                                    CGRectGetHeight(fromViewController.view.frame));
                         
                         
                     } completion:^(BOOL finished) {
                         _toViewController.view.layer.transform = CATransform3DIdentity;
                         [transitionContext completeTransition:NO];
                     }];
}


#pragma mark - UIViewControllerTransitioningDelegate Methods

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    _isDismiss = NO;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    _isDismiss = YES;
    return self;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    // Return nil if we are not interactive
    if (_isInteractive && _dragable) {
        _isDismiss = YES;
        return self;
    }
    
    return nil;
}

#pragma mark - Gesture Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (_direction == transitonDirectionBottom) {
        return YES;
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (_direction == transitonDirectionBottom) {
        return YES;
    }
    return NO;
}

#pragma mark - Utils

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

// Gesture Class Implement
@interface detectScrollViewEndGestureRecognizer ()
@property (nonatomic, strong) NSNumber *isFail;
@end

@implementation detectScrollViewEndGestureRecognizer

- (void)reset
{
    [super reset];
    self.isFail = nil;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    if (!self.scrollview) {
        return;
    }
    
    if (self.state == UIGestureRecognizerStateFailed) return;
    CGPoint nowPoint = [touches.anyObject locationInView:self.view];
    CGPoint prevPoint = [touches.anyObject previousLocationInView:self.view];
    
    if (self.isFail) {
        if (self.isFail.boolValue) {
            self.state = UIGestureRecognizerStateFailed;
        }
        return;
    }
    
    if (nowPoint.y > prevPoint.y && self.scrollview.contentOffset.y <= 0) {
        self.isFail = @NO;
    } else if (self.scrollview.contentOffset.y >= 0) {
        self.state = UIGestureRecognizerStateFailed;
        self.isFail = @YES;
    } else {
        self.isFail = @NO;
    }
    
}

@end
