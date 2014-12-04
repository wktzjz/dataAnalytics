//
//  hotPageOutlineView.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-12-4.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "hotPageOutlineView.h"
#import "defines.h"
#import "PNColor.h"
#import "Colours.h"
#import "UIColor+BFPaperColors.h"
#import "PNChart.h"
#import "BEMSimpleLineGraphView.h"

@interface hotPageOutlineView () <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@end

@implementation hotPageOutlineView
{
    UILabel *_chartLabel;
    PNBarChart *_barChart;
    BEMSimpleLineGraphView *_lineGraph;
    NSMutableArray *_hotPageNameArray;
    NSMutableArray *_hotPagePVArray;
    NSMutableArray *_clickRatioArrayOfValue;
    NSMutableArray *_clickRatioArrayOfDates;
}

- (instancetype)initWithFrame:(CGRect)frame withData:(NSDictionary *)data
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _hotPageNameArray = [[NSMutableArray alloc] initWithArray:(NSArray *)data[@"hotPageNameArray"]];
        _hotPagePVArray   = [[NSMutableArray alloc] initWithArray:(NSArray *)data[@"hotPagePVArray"]];
        _clickRatioArrayOfValue = [[NSMutableArray alloc] initWithArray:(NSArray *)data[@"clickRatioArrayOfValue"]];
        _clickRatioArrayOfDates = [[NSMutableArray alloc] initWithArray:(NSArray *)data[@"clickRatioArrayOfDates"]];
        
        [self addViews];
    }
    
    return self;
}

- (void)addViews
{
    _chartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, outlineViewWidth, 30)];
    _chartLabel.text = @"热门页面";
    _chartLabel.textColor = PNFreshGreen;
    _chartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
    _chartLabel.textAlignment = NSTextAlignmentCenter;
    
    _barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(20, 35.0, outlineViewWidth - 20, 180)];
    _barChart.backgroundColor = [UIColor clearColor];
    _barChart.yLabelFormatter = ^(CGFloat yValue) {
        CGFloat yValueParsed = yValue;
        NSString * labelText = [NSString stringWithFormat:@"%1.f",yValueParsed];
        return labelText;
    };
    _barChart.labelMarginTop = 5.0;
    [_barChart setXLabels:_hotPageNameArray];
    [_barChart setYValues:_hotPagePVArray];
    [_barChart setStrokeColor:[UIColor violetColor]];
    // Adding gradient
    _barChart.ifUseGradientColor = YES;
    _barChart.barColorGradientStart = [UIColor paperColorLightBlue];
    
    _barChart.showReferenceLines = NO;
    [_barChart strokeChart];
    
    [self addSubview:_chartLabel];
    [self addSubview:_barChart];
    
    
    _lineGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(60, 15.0, outlineViewWidth - 100, 215.0)];
    _lineGraph.delegate = self;
    _lineGraph.dataSource = self;
    
    _lineGraph.backgroundColor = [UIColor clearColor];
    
    // Customization of the graph
    
    _lineGraph.colorLine = [UIColor robinEggColor];
    
    _lineGraph.colorXaxisLabel = [UIColor clearColor];
    _lineGraph.colorYaxisLabel = [UIColor clearColor];
    _lineGraph.widthLine = 1.5;
    _lineGraph.enableTouchReport = YES;
    _lineGraph.enablePopUpReport = YES;
    _lineGraph.enableBezierCurve = NO;
    
    _lineGraph.enableYAxisLabel = NO;
    _lineGraph.enableReferenceAxisLines = NO;
    
    _lineGraph.autoScaleYAxis = YES;
    _lineGraph.alwaysDisplayDots = NO;
    _lineGraph.enableReferenceAxisLines = NO;
    _lineGraph.enableReferenceAxisFrame = YES;
    _lineGraph.animationGraphStyle = BEMLineAnimationDraw;
    
    _lineGraph.colorTop = [UIColor clearColor];
    _lineGraph.colorBottom = [UIColor clearColor];
    //            _lineGraph.backgroundColor = [UIColor whiteColor];
    self.tintColor = [UIColor whiteColor];
    
    [self addSubview:_lineGraph];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, _barChart.frame.origin.y + _barChart.frame.size.height - 10.0, outlineViewWidth - 40, 20)];
    tipLabel.text = @"柱状图:PV   折线图:点击率";
    tipLabel.textColor = PNDeepGrey;
    tipLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:12.0];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:tipLabel];
}

#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return (int)[_clickRatioArrayOfValue count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[_clickRatioArrayOfValue objectAtIndex:index] floatValue];
}

#pragma mark - SimpleLineGraph Delegate

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph
{
    return 1;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index
{
    NSString *label = [_clickRatioArrayOfDates objectAtIndex:index];
    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}
@end
