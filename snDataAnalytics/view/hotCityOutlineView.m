//
//  hotCityOutlineView.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-12-4.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "hotCityOutlineView.h"
#import "defines.h"
#import "PNColor.h"
#import "Colours.h"
#import "UIColor+BFPaperColors.h"
#import "PNChart.h"
#import "BEMSimpleLineGraphView.h"

@interface hotCityOutlineView () <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@end

@implementation hotCityOutlineView
{
    UILabel *_chartLabel;
    PNBarChart *_barChart;
    BEMSimpleLineGraphView *_lineGraph;
    NSMutableArray *_hotCityNameArray;
    NSMutableArray *_hotCityUVArray;
    NSMutableArray *_validDealConversionArrayOfValue;
    NSMutableArray *_validDealConversionArrayOfDates;
}

- (instancetype)initWithFrame:(CGRect)frame withData:(NSDictionary *)data
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _hotCityNameArray = [[NSMutableArray alloc] initWithArray:(NSArray *)data[@"hotCityNameArray"]];
        _hotCityUVArray   = [[NSMutableArray alloc] initWithArray:(NSArray *)data[@"hotCityUVArray"]];
        _validDealConversionArrayOfValue = [[NSMutableArray alloc] initWithArray:(NSArray *)data[@"validDealConversionArrayOfValue"]];
        _validDealConversionArrayOfDates = [[NSMutableArray alloc] initWithArray:(NSArray *)data[@"validDealConversionArrayOfDates"]];

        [self addViews];
    }
    
    return self;
}

- (void)addViews
{
    _chartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, outlineViewWidth, 30)];
    _chartLabel.text = @"热门城市";
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
    [_barChart setXLabels:_hotCityNameArray];
    [_barChart setYValues:_hotCityUVArray];
    [_barChart setStrokeColor: PNDeepGreen];
    // Adding gradient
    _barChart.barColorGradientStart = [UIColor paperColorLightBlue];
    _barChart.ifUseGradientColor = YES;
    _barChart.showReferenceLines = NO;
    [_barChart strokeChart];
    
    [self addSubview:_chartLabel];
    [self addSubview:_barChart];
    
    
    _lineGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(60, 15.0, outlineViewWidth - 100, 215.0)];
    _lineGraph.delegate = self;
    _lineGraph.dataSource = self;
    
    _lineGraph.backgroundColor = [UIColor clearColor];
    
    // Customization of the graph
    
    _lineGraph.colorLine = [UIColor blueberryColor];
    
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
    tipLabel.text = @"柱状图:UV   折线图:有效订单转化率";
    tipLabel.textColor = PNDeepGrey;
    tipLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:12.0];
    tipLabel.textAlignment = NSTextAlignmentCenter;

    [self addSubview:tipLabel];

}

#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return (int)[_validDealConversionArrayOfValue count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[_validDealConversionArrayOfValue objectAtIndex:index] floatValue];
}

#pragma mark - SimpleLineGraph Delegate

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph
{
    return 1;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index
{
    NSString *label = [_validDealConversionArrayOfDates objectAtIndex:index];
    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}

//- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index
//{
//    //    self.labelValues.text = [NSString stringWithFormat:@"%@", [self.ArrayOfValues objectAtIndex:index]];
//    //    self.labelDates.text = [NSString stringWithFormat:@"in %@", [self.ArrayOfDates objectAtIndex:index]];
//}
//
//- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index
//{
//    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        //        self.labelValues.alpha = 0.0;
//        //        self.labelDates.alpha = 0.0;
//    } completion:^(BOOL finished) {
//        //        self.labelValues.text = [NSString stringWithFormat:@"%i", [[_lineGraph calculatePointValueSum] intValue]];
//        //        self.labelDates.text = [NSString stringWithFormat:@"between 2000 and %@", [self.ArrayOfDates lastObject]];
//        
//        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            //            self.labelValues.alpha = 1.0;
//            //            self.labelDates.alpha = 1.0;
//        } completion:nil];
//    }];
//}
//
//- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph
//{
//}

@end
