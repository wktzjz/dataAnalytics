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


@property (nonatomic,strong) BEMSimpleLineGraphView *lineGraph;
@property (nonatomic,strong) PNPieChart *visitorPieChart;
//@property (nonatomic,strong) PNPieChart *vaildSourcePieChart;
@property (nonatomic,strong) PNBarChart *vaildSourceBarChart;
@property (nonatomic,strong) PNBarChart *vaildSourceRatioBarChart;
@property (nonatomic,strong) JBBarChartView *barChartView;
@property (nonatomic,strong) JBBarChartView *barChartView1;
@property (nonatomic,strong) JBBarChartView *barChartView2;

@property (nonatomic,strong) PNBarChart *citiesBarChart;
@property (nonatomic,strong) PNBarChart *pagesBarChart;

@property (nonatomic) NSInteger dealMoney;
@property (nonatomic) NSInteger validDealNumber;
@property (nonatomic) float validDealTransformRatio;
@property (nonatomic) int   groupUV;
@property (nonatomic) int   validGroupUV;
@property (nonatomic) float validUVRatio;
@property (nonatomic) int   VISITNumber;

//@property (nonatomic,strong) NSArray *groupColorArray;
//@property (nonatomic,strong) NSArray *groupPercentArray;
@property (nonatomic,strong) NSArray *validSourceUVColorArray;
@property (nonatomic,strong) NSArray *validSourceUVPercentArray;

@property (nonatomic,strong) NSMutableArray *arrayOfValues;
@property (nonatomic,strong) NSMutableArray *arrayOfDates;

@property (nonatomic,strong) NSMutableArray *groupColorArray;
@property (nonatomic,strong) NSMutableArray *groupPercentArray;
@property (nonatomic,strong) NSMutableArray *groupValidPercentArray;
@property (nonatomic,strong) NSMutableArray *cityNameArray;
@property (nonatomic,strong) NSMutableArray *cityValueArray;
@property (nonatomic,strong) NSMutableArray *pagesNameArray;
@property (nonatomic,strong) NSMutableArray *pagesValueArray;


//jb chart
@property (nonatomic, strong) NSArray *chartData;
@property (nonatomic, strong) NSArray *chartData1;
@property (nonatomic, strong) NSArray *monthlySymbols;
@property (nonatomic, strong) NSArray *sourcesStringArray;

- (instancetype)initWithFrame:(CGRect)frame withData:(NSDictionary *)data;
- (void)relodData:(NSDictionary *)info;

@end
