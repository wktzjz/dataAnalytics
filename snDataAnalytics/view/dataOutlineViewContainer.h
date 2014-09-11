//
//  dataOutlineViewContainer.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-4.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChart.h"

typedef NS_ENUM(NSUInteger, dataVisualizedType) {
    outlineTypeLine = 0,
    outlineTypeBar,
    outlineTypeLine1,
    outlineTypeCircle,
    outlineTypePie,
};

typedef NS_ENUM(NSUInteger, inViewType) {
    outlineView,
    detailView,
};

@interface dataOutlineViewContainer : UIView

@property (nonatomic) PNBarChart *barChart;
@property (nonatomic) UIImageView *snapView;
- (instancetype)initWithFrame:(CGRect)frame dataType:(dataVisualizedType)type inControllerType:(inViewType)inViewType;

@end
