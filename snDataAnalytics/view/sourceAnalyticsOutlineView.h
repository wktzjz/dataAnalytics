//
//  sourceAnalyticsOutlineView.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-11-17.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChart.h"

@interface sourceAnalyticsOutlineView : UIView

@property (nonatomic,strong) UILabel * chartLabel;

@property (nonatomic,strong) PNCircleChart *circleChart;
@property (nonatomic,strong) PNPieChart *pieChart;
@property (nonatomic,strong) PNBarChart *vaildSourceBarChart;

@property (nonatomic,strong) NSMutableArray *groupColorArray;
@property (nonatomic,strong) NSMutableArray *groupPercentArray;
@property (nonatomic,strong) NSMutableArray *groupValidPercentArray;

@property (nonatomic, strong) NSMutableArray *sourcesStringArray;

- (id)initWithFrame:(CGRect)frame withData:(NSDictionary *)data;
- (void)modifyPageViewWithData:(NSDictionary *)data;


@end
