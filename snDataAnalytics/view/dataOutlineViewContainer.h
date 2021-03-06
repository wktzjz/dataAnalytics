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

#import "loadingView.h"
#import "realTimeOutlineView.h"
#import "visitorGroupOutlineView.h"
#import "sourceAnalyticsOutlineView.h"
#import "pageAnalyticsOutlineView.h"
#import "hotCityOutlineView.h"
#import "hotPageOutlineView.h"
#import "transformAnalyticsOutlineView.h"


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
    outlineVisitorGroup,
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


@property (nonatomic,strong) UIImageView *snapView;
@property (nonatomic) viewType dataType;
@property (nonatomic,strong) UILabel *chartLabel;
@property (nonatomic,strong) PNLineChart *lineChart;
@property (nonatomic,strong) PNBarChart *barChart;
@property (nonatomic,strong) PNCircleChart *circleChart;
@property (nonatomic,strong) PNPieChart *pieChart;
@property (nonatomic,strong) BEMSimpleLineGraphView *myGraph;
@property (nonatomic,strong) realTimeOutlineView *realTimeView;
@property (nonatomic,strong) visitorGroupOutlineView *visitorGroupView;
@property (nonatomic,strong) sourceAnalyticsOutlineView *sourceView;
@property (nonatomic,strong) pageAnalyticsOutlineView *pageView;
@property (nonatomic,strong) hotCityOutlineView *hotCityView;
@property (nonatomic,strong) hotPageOutlineView *hotPageView;
@property (nonatomic,strong) transformAnalyticsOutlineView *transformView;

@property (nonatomic,strong) LoadingView *loadingView;

- (instancetype)initWithFrame:(CGRect)frame ifLoading:(BOOL)ifLoading;
- (instancetype)initWithFrame:(CGRect)frame dataType:(viewType)type data:(id)data inControllerType:(inViewType)inViewType;

- (void)addView:(UIView *)view inControllerType:(inViewType)inViewType;

- (void)addDataViewType:(viewType)dataType inControllerType:(inViewType)inViewType data:(id)data;

- (void)modifyLineChartWithDataArray1:(NSArray *)dataArray1 dataArray2:(NSArray *)dataArray2 xLabelArray:(NSArray *)labelArray;
- (void)modifyBarChartWithDataArray:(NSArray *)dataArray xLabelArray:(NSArray *)labelArray;
- (void)modifyCircleChartWithData:(NSNumber *)data;
- (void)modifyPieChartInView:(UIView *)view type:(viewType)type WithDataArray:(NSArray *)dataArray groupColorArray:(NSArray *)colorArray groupPercentArray:(NSArray *)percentArray;
- (void)modifyLineChartInView:(UIView *)view type:(viewType)type WithValueArray:(NSMutableArray *)valueArray dateArray:(NSMutableArray *)dateArray;

- (void)reloadRealTimeData:(NSDictionary *)info;
@end
