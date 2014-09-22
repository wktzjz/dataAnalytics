//
//  dataOutlineViewContainer.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-4.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChart.h"
#import "PNChart.h"
#import "PNLineChartData.h"
#import "PNLineChartDataItem.h"
#import "BEMSimpleLineGraphView.h"

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


@property (nonatomic) UIImageView *snapView;
@property (nonatomic) dataVisualizedType dataType;
@property (nonatomic) UILabel * chartLabel;
@property (nonatomic) PNLineChart * lineChart;
@property (nonatomic) PNBarChart *barChart;
@property (nonatomic) PNCircleChart *circleChart;
@property (nonatomic) PNPieChart *pieChart;
@property (nonatomic) BEMSimpleLineGraphView *myGraph;

- (instancetype)initWithFrame:(CGRect)frame ifLoading:(BOOL)ifLoading;
- (instancetype)initWithFrame:(CGRect)frame dataType:(dataVisualizedType)type inControllerType:(inViewType)inViewType;
- (void)addDataViewType:(dataVisualizedType)dataType inControllerType:(inViewType)inViewType data:(id)data;

- (void)modifyLineChartWithDataArray1:(NSArray *)dataArray1 dataArray2:(NSArray *)dataArray2 xLabelArray:(NSArray *)labelArray;

@end
