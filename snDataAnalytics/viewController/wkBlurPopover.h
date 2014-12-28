//
//  wkBlurPopover.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-12.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

@import UIKit;
#import "wkBlurPopoverTransitionController.h"

@interface wkBlurPopover : UIViewController

/// create a popover with a content view controller
/// size of the popover is determined by [contentViewController preferredContentSize]
- (instancetype)initWithContentViewController:(UIViewController *)contentViewController;
- (instancetype)initWithContentViewController:(UIViewController *)contentViewController type:(popoverType)type;

/// set to YES if you want content view controller to be dismissed by "throwing away"
@property (nonatomic, assign, getter = isThrowingGestureEnabled) BOOL throwingGestureEnabled;

@property (nonatomic, weak, readonly) UIViewController *contentViewController;

@end
