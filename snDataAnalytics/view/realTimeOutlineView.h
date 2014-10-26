//
//  realTimeOutlineView.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-8.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "BEMSimpleLineGraphView.h"
#import "PNChart.h"
#import "JBBarChartView.h"
#import "JBChartHeaderView.h"

@interface realTimeOutlineView : UIView <JBBarChartViewDelegate, JBBarChartViewDataSource>


@property (nonatomic) BEMSimpleLineGraphView *lineGraph;
@property (nonatomic) PNPieChart *visitorPieChart;
@property (nonatomic) PNPieChart *vaildSourcePieChart;
@property (nonatomic) PNBarChart *vaildSourceBarChart;
@property (nonatomic) PNBarChart *vaildSourceRatioBarChart;
@property (nonatomic) JBBarChartView *barChartView;
@property (nonatomic) JBBarChartView *barChartView1;
@property (nonatomic) JBBarChartView *barChartView2;

@property (nonatomic) PNBarChart *citiesBarChart;
@property (nonatomic) PNBarChart *pagesBarChart;

@property (nonatomic) NSInteger dealMoney;
@property (nonatomic) NSInteger validDealNumber;
@property (nonatomic) NSInteger validDealTransformRatio;
@property (nonatomic) int   groupUV;
@property (nonatomic) int   validGroupUV;
@property (nonatomic) float validUVRatio;

@property (nonatomic) NSArray *groupColorArray;
@property (nonatomic) NSArray *groupPercentArray;
@property (nonatomic) NSArray *validSourceUVColorArray;
@property (nonatomic) NSArray *validSourceUVPercentArray;

@property (nonatomic) NSMutableArray *arrayOfValues;
@property (nonatomic) NSMutableArray *arrayOfDates;

//jb chart
@property (nonatomic, strong) NSArray *chartData;
@property (nonatomic, strong) NSArray *chartData1;
@property (nonatomic, strong) NSArray *monthlySymbols;
@property (nonatomic, strong) NSArray *sourcesStringArray;

- (id)initWithFrame:(CGRect)frame;
- (void)relodData:(NSDictionary *)info;

@end
