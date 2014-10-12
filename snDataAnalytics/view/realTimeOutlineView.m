//
//  realTimeOutlineView.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-8.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "realTimeOutlineView.h"
#import "defines.h"
#import "PNColor.h"

@interface realTimeOutlineView () <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@end

@implementation realTimeOutlineView
{
    UILabel *_chartLabel;
    UILabel *_realtimeVistorGroupLabel;
    UILabel *_realtimeDealLabel;
    UILabel *_realtimeSourceLabel;
    UILabel *_realtimeCityLabel;
    UILabel *_realtimeTop5Label;
    
    NSMutableArray *_arrayOfValues;
    NSMutableArray *_arrayOfDates;

}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addViews];
    }
    
    return self;
}


- (void)addViews
{
    _chartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 10, outlineViewWidth, 30)];
    _chartLabel.text = @"实时";
    _chartLabel.textColor = PNFreshGreen;
    _chartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:24.0];
    _chartLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_chartLabel];
    //    访客群体分析
    //    成交
    //    来源渠道
    //    城市分布
    //    TOP5页面
    _realtimeVistorGroupLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 3 + _chartLabel.frame.origin.y +_chartLabel.frame.size.height, outlineViewWidth, 30)];
    _realtimeVistorGroupLabel.text =@"访客群体分析";
    _realtimeVistorGroupLabel.textColor = PNDeepGrey;
    _realtimeVistorGroupLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
    _realtimeVistorGroupLabel.textAlignment = NSTextAlignmentLeft;
    
    _realtimeDealLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 3 + _realtimeVistorGroupLabel.frame.origin.y +_realtimeVistorGroupLabel.frame.size.height, outlineViewWidth, 30)];
    _realtimeDealLabel.text =[NSString stringWithFormat:@"成交:   %i",(arc4random() % 2000)];
    _realtimeDealLabel.textColor = PNDeepGrey;
    _realtimeDealLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
    _realtimeDealLabel.textAlignment = NSTextAlignmentLeft;
    
    _arrayOfValues = [[NSMutableArray alloc] init];
    _arrayOfDates = [[NSMutableArray alloc] init];
    
    float totalNumber = 0;
    
    for (int i = 0; i < 20; i++) {
        [_arrayOfValues addObject:[NSNumber numberWithInteger:(arc4random() % 10000)]]; // Random values for the graph
        [_arrayOfDates addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:2000 + i]]]; // Dates for the X-Axis of the graph
        
        totalNumber = totalNumber + [[_arrayOfValues objectAtIndex:i] intValue]; // All of the values added together
    }
    
    //            self.ArrayOfValues = [[NSMutableArray alloc] initWithArray:@[@24444,@10000,@64213,@52341,@34445,@423,@81114,@22342,@33333]];
    
    /* This is commented out because the graph is created in the interface with this sample app. However, the code remains as an example for creating the graph using code. */
    
    _lineGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 20.0+_realtimeDealLabel.frame.origin.y +_realtimeDealLabel.frame.size.height, outlineViewWidth, 30.0)];
    _lineGraph.delegate = self;
    _lineGraph.dataSource = self;
    
    _lineGraph.backgroundColor = [UIColor clearColor];
    
    // Customization of the graph
    
    _lineGraph.colorLine = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
    
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
    //            self.myGraph.backgroundColor = [UIColor whiteColor];
    self.tintColor = [UIColor whiteColor];
    
    _realtimeSourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 3 + _lineGraph.frame.origin.y +_lineGraph.frame.size.height, outlineViewWidth, 30)];
    _realtimeSourceLabel.text =@"来源渠道";
    _realtimeSourceLabel.textColor = PNDeepGrey;
    _realtimeSourceLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
    _realtimeSourceLabel.textAlignment = NSTextAlignmentLeft;
    
    _realtimeCityLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 3 + _realtimeSourceLabel.frame.origin.y +_realtimeSourceLabel.frame.size.height, outlineViewWidth, 30)];
    _realtimeCityLabel.text =@"城市分布";
    _realtimeCityLabel.textColor = PNDeepGrey;
    _realtimeCityLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
    _realtimeCityLabel.textAlignment = NSTextAlignmentLeft;
    
    _realtimeTop5Label = [[UILabel alloc] initWithFrame:CGRectMake(20, 3 + _realtimeCityLabel.frame.origin.y +_realtimeCityLabel.frame.size.height, outlineViewWidth, 30)];
    _realtimeTop5Label.text =@"TOP5页面";
    _realtimeTop5Label.textColor = PNDeepGrey;
    _realtimeTop5Label.font = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
    _realtimeTop5Label.textAlignment = NSTextAlignmentLeft;
    
    [self addSubview:_realtimeVistorGroupLabel];
    [self addSubview:_realtimeDealLabel];
    [self addSubview:_lineGraph];
    [self addSubview:_realtimeSourceLabel];
    [self addSubview:_realtimeCityLabel];
    [self addSubview:_realtimeTop5Label];
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:10.0f target:self selector:@selector(change) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}

- (void)change
{
    _realtimeDealLabel.text =[NSString stringWithFormat:@"成交:   %i",(arc4random() % 2000)];
    [_arrayOfValues removeAllObjects];
    [_arrayOfDates removeAllObjects];
    
    for (int i = 0; i < 20; i++) {
        [_arrayOfValues addObject:[NSNumber numberWithInteger:(arc4random() % 10000)]]; // Random values for the graph
        [_arrayOfDates addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:2000 + i]]]; // Dates for the X-Axis of the graph
        
    }
    
    [_lineGraph reloadGraph];

}

#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return (int)[_arrayOfValues count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[_arrayOfValues objectAtIndex:index] floatValue];
}

#pragma mark - SimpleLineGraph Delegate

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 1;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    NSString *label = [_arrayOfDates objectAtIndex:index];
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
