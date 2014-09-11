//
//  UIViewController+clickedViewIndex.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-9.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (clickedView)

- (void)setClickedViewIndex:(NSNumber *)index;
- (NSNumber *)clickedViewIndex;

- (void)setClickedView:(UIView *)view;
- (UIView *)clickedView;

- (void)setClickedViewFrame:(NSArray *)arrayOfFrame;
- (NSArray *)clickedViewFrame;

@end
