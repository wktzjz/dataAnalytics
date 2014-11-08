//
//  flatButton.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-12.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface flatButton : UIButton

@property (nonatomic) int fontSize;
@property (nonatomic) UIColor *textColor;
+ (instancetype)button;
//+ (instancetype)buttonWithTextColor:(UIColor *)color;

@end
