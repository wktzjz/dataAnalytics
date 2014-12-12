//
//  UIViewController+clickedViewIndex.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-9.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "UIViewController+clickedViewIndex.h"
#import <objc/runtime.h>

static NSString * const indexKey            = @"wkIndexKey";
static NSString * const clickedViewKey      = @"wkClickedView";
static NSString * const clickedViewFrameKey = @"wkClickedViewFrame";

@implementation UIViewController (clickedView)

- (void)setClickedViewIndex:(NSNumber *)index
{
    objc_setAssociatedObject(self, &indexKey, index, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)clickedViewIndex
{
    NSNumber *index = (NSNumber *)objc_getAssociatedObject(self, &indexKey);
    return index;
}

- (void)setClickedView:(UIView *)view
{
    objc_setAssociatedObject(self, &clickedViewKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)clickedView
{
    UIView *view = (UIView *)objc_getAssociatedObject(self, &clickedViewKey);
    return view;
}

- (void)setClickedViewFrame:(NSArray *)arrayOfFrame
{
    objc_setAssociatedObject(self, &clickedViewFrameKey, arrayOfFrame, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)clickedViewFrame
{
    NSArray *frame = (NSArray *)objc_getAssociatedObject(self, &clickedViewFrameKey);
    return frame;
}
@end
