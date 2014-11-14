//
//  loadingView.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-11-13.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

//default is 1.0f
@property (nonatomic, assign) CGFloat lineWidth;

//default is [UIColor lightGrayColor]
@property (nonatomic, strong) UIColor *lineColor;

@property (nonatomic, readonly) BOOL isAnimating;

//use this to init
- (instancetype)initWithFrame:(CGRect)frame;

- (void)startAnimation;
- (void)stopAnimation;


@end
