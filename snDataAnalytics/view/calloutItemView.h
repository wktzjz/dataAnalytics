//
//  calloutItemView.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-26.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface calloutItemView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) NSInteger itemIndex;
@property (nonatomic, strong) UIColor *originalBackgroundColor;

@end