//
//  outlineViewTransitionAnimator.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-4.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

#import "outLineViewTransitionProtocol.h"


typedef NS_ENUM(NSUInteger, transitonDirection) {
    transitonDirectionBottom,
    transitonDirectionLeft,
    transitonDirectionRight,
};

@interface detectScrollViewEndGestureRecognizer : UIPanGestureRecognizer

@property (nonatomic, weak) UIScrollView *scrollview;

@end



@interface outlineViewTransitionAnimator : UIPercentDrivenInteractiveTransition<UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate,outLineViewTransitionProtocol>

@property transitonDirection direction;
@property BOOL bounces;
@property CGFloat behindViewScale;
@property CGFloat behindViewAlpha;
@property (nonatomic, assign, getter=isDragable) BOOL dragable;
@property (nonatomic) BOOL showSnapView;

//wk
@property BOOL isDismiss;
@property (nonatomic, weak) UINavigationController *navigationController;

@property (nonatomic, weak) id <outLineViewTransitionProtocol> delegate;

- (instancetype)initWithModalViewController:(UIViewController *)modalViewController;
- (void)setContentScrollView:(UIScrollView *)scrollView;

@end
