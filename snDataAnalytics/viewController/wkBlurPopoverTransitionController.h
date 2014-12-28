//
//  wkBlurPopoverTransitionController.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-12.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSUInteger, popoverType) {
    center = 0,
    top,
};

@interface wkBlurPopoverTransitionController : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL isPresentation;
@property (nonatomic) popoverType popovertype;

@end

@interface wkBlurPopoverInteractiveTransitionController : NSObject <UIViewControllerInteractiveTransitioning>

- (void)startInteractiveTransitionWithTouchLocation:(CGPoint)location;
- (void)updateInteractiveTransitionWithTouchLocation:(CGPoint)location;
- (void)finishInteractiveTransitionWithTouchLocation:(CGPoint)location velocity:(CGPoint)velocity;
- (void)cancelInteractiveTransitionWithTouchLocation:(CGPoint)location;


@end