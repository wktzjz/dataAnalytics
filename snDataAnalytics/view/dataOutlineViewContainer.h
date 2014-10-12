//
//  dataOutlineViewContainer.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-4.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChart.h"
#import "PNLineChartData.h"
#import "PNLineChartDataItem.h"
#import "BEMSimpleLineGraphView.h"

#import "vistorGroupOutlineView.h"
#import "pageAnalyticsOutlineView.h"

typedef NS_ENUM(NSUInteger, dataVisualizedType) {
    outlineTypeRealTime = 0,
    outlineTypePie,
    outlineTypeCircle,
    outlineTypeLine,
    outlineTypeBar,
//    outlineTypeCircle,
//    outlineTypePie,
    outlineTypeLine1,
};

typedef NS_ENUM(NSUInteger, viewType) {
    outlineRealTime = 0,
    outlineVistorGroup,
    outlineSource,
    outlinePageAnalytics,
    outlineHotCity,
    //    outlineTypeCircle,
    //    outlineTypePie,
    outlineHotPage,
    outlineTransform,
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
@property (nonatomic) vistorGroupOutlineView *vistorGroupView;
@property (nonatomic) pageAnalyticsOutlineView *pageView;


- (instancetype)initWithFrame:(CGRect)frame ifLoading:(BOOL)ifLoading;
- (instancetype)initWithFrame:(CGRect)frame dataType:(dataVisualizedType)type inControllerType:(inViewType)inViewType;

- (void)addView:(UIView *)view inControllerType:(inViewType)inViewType;


- (void)addDataViewType:(dataVisualizedType)dataType inControllerType:(inViewType)inViewType data:(id)data;
- (void)modifyLineChartWithDataArray1:(NSArray *)dataArray1 dataArray2:(NSArray *)dataArray2 xLabelArray:(NSArray *)labelArray;
- (void)modifyBarChartWithDataArray:(NSArray *)dataArray xLabelArray:(NSArray *)labelArray;
- (void)modifyCircleChartWithData:(NSNumber *)data;
- (void)modifyPieChartInView:(UIView *)view type:(viewType)type WithDataArray:(NSArray *)dataArray groupColorArray:(NSArray *)colorArray groupPercentArray:(NSArray *)percentArray;
- (void)modifyLineChartInView:(UIView *)view type:(viewType)type WithValueArray:(NSMutableArray *)valueArray dateArray:(NSMutableArray *)dateArray;


@end
