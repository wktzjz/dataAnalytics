//
//  pageAnalyticsOutlineView.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-11.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChart.h"
#import "BEMSimpleLineGraphView.h"

@interface pageAnalyticsOutlineView : UIView <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@property (nonatomic) BEMSimpleLineGraphView *lineGraph;
@property (strong, nonatomic) NSMutableArray *ArrayOfValues;
@property (strong, nonatomic) NSMutableArray *ArrayOfDates;

@property (nonatomic) PNPieChart *pieChart;
@property (nonatomic) NSArray    *groupColorArray;
@property (nonatomic) NSArray    *groupPercentArray;

- (id)initWithFrame:(CGRect)frame;
- (void)modifyPageView;

@end
