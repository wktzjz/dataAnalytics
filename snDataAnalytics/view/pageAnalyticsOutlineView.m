//
//  pageAnalyticsOutlineView.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-11.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "pageAnalyticsOutlineView.h"
#import "defines.h"
#import "PNColor.h"
#import "Colours.h"

@implementation pageAnalyticsOutlineView
{
    //PV、四级页面PV、购物车PV
    UILabel *_chartLabel;
    UILabel *_PVLabel;
    UILabel *_fourthPagePVLabel;
    UILabel *_shoppingCartPVLabel;
    
//    NSMutableArray *_arrayOfValues;
//    NSMutableArray *_arrayOfDates;
    
    UILabel *_groupLabel1;
    UILabel *_groupLabel2;
    UILabel *_groupLabel3;
    UILabel *_groupLabel4;
    
    UIView *_colorDotView1;
    UIView *_colorDotView2;
    UIView *_colorDotView3;
    UIView *_colorDotView4;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _groupPercentArray = @[@15,@20,@30,@35];
        _groupColorArray   = @[PNLightBlue,PNBlue,PNTwitterColor,[UIColor indigoColor]];
        [self addViews];
    }
    
    return self;
}


- (void)addViews
{
    _chartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 10, outlineViewWidth, 30)];
    _chartLabel.text = @"页面分析";
    _chartLabel.textColor = PNFreshGreen;
    _chartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:24.0];
    _chartLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_chartLabel];

    _PVLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 3 + _chartLabel.frame.origin.y +_chartLabel.frame.size.height, outlineViewWidth, 30)];
    _PVLabel.text =[NSString stringWithFormat:@"PV:   %i",(arc4random() % 20000)];
    _PVLabel.textColor = PNDeepGrey;
    _PVLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
    _PVLabel.textAlignment = NSTextAlignmentLeft;
    
    _ArrayOfValues = [[NSMutableArray alloc] init];
    _ArrayOfDates = [[NSMutableArray alloc] init];
    
    float totalNumber = 0;
    
    for (int i = 0; i < 20; i++) {
        [_ArrayOfValues addObject:[NSNumber numberWithInteger:(arc4random() % 10000)]]; // Random values for the graph
        [_ArrayOfDates addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:2000 + i]]]; // Dates for the X-Axis of the graph
        
        totalNumber = totalNumber + [[_ArrayOfValues objectAtIndex:i] intValue]; // All of the values added together
    }
    
    //            self.ArrayOfValues = [[NSMutableArray alloc] initWithArray:@[@24444,@10000,@64213,@52341,@34445,@423,@81114,@22342,@33333]];
    
    /* This is commented out because the graph is created in the interface with this sample app. However, the code remains as an example for creating the graph using code. */
    
    _lineGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 20.0+_PVLabel.frame.origin.y +_PVLabel.frame.size.height, outlineViewWidth, 30.0)];
    _lineGraph.delegate = self;
    _lineGraph.dataSource = self;
    
    _lineGraph.backgroundColor = [UIColor clearColor];
    
    // Customization of the graph
    
    _lineGraph.colorLine = PNTitleColor;
    
    _lineGraph.colorXaxisLabel = [UIColor clearColor];
    _lineGraph.colorYaxisLabel = [UIColor clearColor];
    _lineGraph.widthLine = 1.5;
    _lineGraph.enableTouchReport = YES;
    _lineGraph.enablePopUpReport = YES;
    _lineGraph.enableBezierCurve = YES;
    
    _lineGraph.enableYAxisLabel = NO;
    _lineGraph.enableReferenceAxisLines = NO;
    
    _lineGraph.autoScaleYAxis = YES;
    _lineGraph.alwaysDisplayDots = NO;
    _lineGraph.enableReferenceAxisLines = NO;
    _lineGraph.enableReferenceAxisFrame = YES;
    _lineGraph.animationGraphStyle = BEMLineAnimationDraw;
    
    _lineGraph.colorTop = [UIColor whiteColor];
    _lineGraph.colorBottom = [UIColor whiteColor];
    self.tintColor = [UIColor whiteColor];
    
    _fourthPagePVLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 3 + _lineGraph.frame.origin.y +_lineGraph.frame.size.height, outlineViewWidth, 30)];
    _fourthPagePVLabel.text =[NSString stringWithFormat:@"四级页面PV:   %i",(arc4random() % 2000)];
    _fourthPagePVLabel.textColor = PNDeepGrey;
    _fourthPagePVLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
    _fourthPagePVLabel.textAlignment = NSTextAlignmentLeft;

    
    _shoppingCartPVLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 3 + _fourthPagePVLabel.frame.origin.y +_fourthPagePVLabel.frame.size.height, outlineViewWidth, 30)];
    _shoppingCartPVLabel.text =[NSString stringWithFormat:@"购物车PV:       %i",(arc4random() % 2000)];
    _shoppingCartPVLabel.textColor = PNDeepGrey;
    _shoppingCartPVLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
    _shoppingCartPVLabel.textAlignment = NSTextAlignmentLeft;
    
    [self addSubview:_PVLabel];
    [self addSubview:_lineGraph];
    [self addSubview:_fourthPagePVLabel];
    [self addSubview:_shoppingCartPVLabel];
    
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[0]).floatValue color:_groupColorArray[0]],
                       [PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[1]).floatValue color:_groupColorArray[1]],
                       [PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[2]).floatValue color:_groupColorArray[2]],
                       [PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[3]).floatValue color:_groupColorArray[3]],
                       ];
    
    float pieWidth = outlineViewHeight - ( _shoppingCartPVLabel.frame.origin.y +_shoppingCartPVLabel.frame.size.height) + 45;
    _pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(25.0, _shoppingCartPVLabel.frame.origin.y +_shoppingCartPVLabel.frame.size.height,pieWidth, pieWidth) items:items];
    _pieChart.descriptionTextColor = [UIColor whiteColor];
    _pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
    _pieChart.descriptionTextShadowColor = [UIColor clearColor];
    [_pieChart strokeChart];
    
    [self addSubview:_pieChart];
    
    float originDotViewX = 20 + _pieChart.frame.origin.x + pieWidth;
    
    _colorDotView1 = [[UIView alloc] initWithFrame:CGRectMake(originDotViewX,25 + _pieChart.frame.origin.y, 10, 10)];
    _colorDotView2 = [[UIView alloc] initWithFrame:CGRectMake(originDotViewX,3 + _colorDotView1.frame.origin.y + _colorDotView1.frame.size.height,10, 10)];
    _colorDotView3 = [[UIView alloc] initWithFrame:CGRectMake(originDotViewX,3 + _colorDotView2.frame.origin.y + _colorDotView2.frame.size.height, 10, 10)];
    _colorDotView4 = [[UIView alloc] initWithFrame:CGRectMake(originDotViewX,3 + _colorDotView3.frame.origin.y + _colorDotView3.frame.size.height, 10, 10)];
    
    _colorDotView1.layer.cornerRadius = _colorDotView2.layer.cornerRadius = _colorDotView3.layer.cornerRadius =_colorDotView4.layer.cornerRadius= 5.0;
    _colorDotView1.backgroundColor = (UIColor *)_groupColorArray[0];
    _colorDotView2.backgroundColor = (UIColor *)_groupColorArray[1];
    _colorDotView3.backgroundColor = (UIColor *)_groupColorArray[2];
    _colorDotView4.backgroundColor = (UIColor *)_groupColorArray[3];
    
    [self addSubview: _colorDotView1];
    [self addSubview: _colorDotView2];
    [self addSubview: _colorDotView3];
    [self addSubview: _colorDotView4];
    
    float originX = originDotViewX + _colorDotView1.frame.size.width + 15;
    _groupLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(originX,  _pieChart.frame.origin.y + 8, outlineViewWidth/2, 20)];
    _groupLabel1.text =[NSString stringWithFormat:@"页面A:  %i%%",((NSNumber *)_groupPercentArray[0]).intValue];
    _groupLabel1.textColor = (UIColor *)_groupColorArray[0];
    _groupLabel1.font = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
    _groupLabel1.textAlignment = NSTextAlignmentLeft;
    
    _groupLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(originX, _groupLabel1.frame.origin.y + _groupLabel1.frame.size.height, outlineViewWidth/2, 20)];
    _groupLabel2.text =[NSString stringWithFormat:@"页面B:  %i%%",((NSNumber *)_groupPercentArray[1]).intValue];
    _groupLabel2.textColor = (UIColor *)_groupColorArray[1];
    _groupLabel2.font = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
    _groupLabel2.textAlignment = NSTextAlignmentLeft;
    
    _groupLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(originX, _groupLabel2.frame.origin.y + _groupLabel2.frame.size.height, outlineViewWidth/2, 20)];
    _groupLabel3.text =[NSString stringWithFormat:@"页面C:  %i%%",((NSNumber *)_groupPercentArray[2]).intValue];
    _groupLabel3.textColor =(UIColor *)_groupColorArray[2];
    _groupLabel3.font = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
    _groupLabel3.textAlignment = NSTextAlignmentLeft;
    
    _groupLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(originX, _groupLabel3.frame.origin.y + _groupLabel3.frame.size.height, outlineViewWidth/2, 20)];
    _groupLabel4.text =[NSString stringWithFormat:@"页面D:  %i%%",((NSNumber *)_groupPercentArray[3]).intValue];
    _groupLabel4.textColor =(UIColor *)_groupColorArray[3];
    _groupLabel4.font = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
    _groupLabel4.textAlignment = NSTextAlignmentLeft;
    
    [self addSubview: _groupLabel1];
    [self addSubview: _groupLabel2];
    [self addSubview: _groupLabel3];
    [self addSubview: _groupLabel4];
    
    _colorDotView1.center = CGPointMake(_colorDotView1.center.x,_groupLabel1.center.y);
    _colorDotView2.center = CGPointMake(_colorDotView2.center.x,_groupLabel2.center.y);
    _colorDotView3.center = CGPointMake(_colorDotView3.center.x,_groupLabel3.center.y);
    _colorDotView4.center = CGPointMake(_colorDotView4.center.x,_groupLabel4.center.y);
    
}

- (void)modifyPageView
{
    _colorDotView1.backgroundColor = _groupLabel1.textColor = (UIColor *)_groupColorArray[0];
    _colorDotView2.backgroundColor = _groupLabel2.textColor = (UIColor *)_groupColorArray[1];
    _colorDotView3.backgroundColor = _groupLabel3.textColor = (UIColor *)_groupColorArray[2];
    _colorDotView4.backgroundColor = _groupLabel4.textColor = (UIColor *)_groupColorArray[3];
    _groupLabel1.text =[NSString stringWithFormat:@"页面A:  %i%%",((NSNumber *)_groupPercentArray[0]).intValue];
    _groupLabel2.text =[NSString stringWithFormat:@"页面B:  %i%%",((NSNumber *)_groupPercentArray[1]).intValue];
    _groupLabel3.text =[NSString stringWithFormat:@"页面C:  %i%%",((NSNumber *)_groupPercentArray[2]).intValue];
    _groupLabel4.text =[NSString stringWithFormat:@"页面D:  %i%%",((NSNumber *)_groupPercentArray[3]).intValue];

}

#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return (int)[_ArrayOfValues count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[_ArrayOfValues objectAtIndex:index] floatValue];
}

#pragma mark - SimpleLineGraph Delegate

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 1;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    NSString *label = [_ArrayOfDates objectAtIndex:index];
    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
    //    self.labelValues.text = [NSString stringWithFormat:@"%@", [self.ArrayOfValues objectAtIndex:index]];
    //    self.labelDates.text = [NSString stringWithFormat:@"in %@", [self.ArrayOfDates objectAtIndex:index]];
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        //        self.labelValues.alpha = 0.0;
        //        self.labelDates.alpha = 0.0;
    } completion:^(BOOL finished) {
        //        self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSum] intValue]];
        //        self.labelDates.text = [NSString stringWithFormat:@"between 2000 and %@", [self.ArrayOfDates lastObject]];
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            //            self.labelValues.alpha = 1.0;
            //            self.labelDates.alpha = 1.0;
        } completion:nil];
    }];
}

- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph {
    //    self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSum] intValue]];
    //    self.labelDates.text = [NSString stringWithFormat:@"between 2000 and %@", [self.ArrayOfDates lastObject]];
}
@end
