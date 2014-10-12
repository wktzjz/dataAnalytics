//
//  vistorGroupDetailOutlineView.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-9.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "vistorGroupDetailOutlineView.h"
#import "defines.h"
#import "PNColor.h"
#import "BEMSimpleLineGraphView.h"

@interface vistorGroupDetailOutlineView () <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@end
@implementation vistorGroupDetailOutlineView
{
    UILabel *_PVLabel;
    UILabel *_newUVLabel;
    UILabel *_averageStayTimeLabel;
    UILabel *_sumbitDealTransformLabel;
    UILabel *_validDealTransformLabel;

    NSMutableArray *_arrayOfValues;
    NSMutableArray *_arrayOfDates;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor whiteColor];
        
        [self addViews];
    }
    
    return self;
}


- (void)addViews
{
    //新UV、平均页面停留时间、提交订单转化率、有效订单转化率
    _PVLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, outlineViewWidth, 30)];
    _PVLabel.text = [NSString stringWithFormat:@"PV:          %i",(arc4random() % 20000)];
    _PVLabel.textColor = PNDeepGrey;
    _PVLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
    _PVLabel.textAlignment = NSTextAlignmentLeft;
    
    
    _arrayOfValues = [[NSMutableArray alloc] init];
    _arrayOfDates = [[NSMutableArray alloc] init];
    
    float totalNumber = 0;
    
    for (int i = 0; i < 15; i++) {
        [_arrayOfValues addObject:[NSNumber numberWithInteger:(arc4random() % 10000)]]; // Random values for the graph
        [_arrayOfDates addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:2000 + i]]]; // Dates for the X-Axis of the graph
        
        totalNumber = totalNumber + [[_arrayOfValues objectAtIndex:i] intValue]; // All of the values added together
    }
    
    //            self.ArrayOfValues = [[NSMutableArray alloc] initWithArray:@[@24444,@10000,@64213,@52341,@34445,@423,@81114,@22342,@33333]];
    
    /* This is commented out because the graph is created in the interface with this sample app. However, the code remains as an example for creating the graph using code. */
    
    BEMSimpleLineGraphView *lineGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 5.0+_PVLabel.frame.origin.y +_PVLabel.frame.size.height, outlineViewWidth, 30.0)];
    lineGraph.delegate = self;
    lineGraph.dataSource = self;
    
    lineGraph.backgroundColor = [UIColor clearColor];
    
    // Customization of the graph
    
    lineGraph.colorLine = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
    
    lineGraph.colorXaxisLabel = [UIColor clearColor];
    lineGraph.colorYaxisLabel = [UIColor clearColor];
    lineGraph.widthLine = 1.5;
    lineGraph.enableTouchReport = YES;
    lineGraph.enablePopUpReport = YES;
    lineGraph.enableBezierCurve = YES;
    
    lineGraph.enableYAxisLabel = NO;
    lineGraph.enableReferenceAxisLines = NO;
    
    lineGraph.autoScaleYAxis = YES;
    lineGraph.alwaysDisplayDots = NO;
    lineGraph.enableReferenceAxisLines = NO;
    lineGraph.enableReferenceAxisFrame = YES;
    lineGraph.animationGraphStyle = BEMLineAnimationDraw;
    
    lineGraph.colorTop = [UIColor whiteColor];
    lineGraph.colorBottom = [UIColor whiteColor];
    //            self.myGraph.backgroundColor = [UIColor whiteColor];
    self.tintColor = [UIColor whiteColor];
    
    [self addSubview:lineGraph];
    
    
    _newUVLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5 + lineGraph.frame.origin.y +lineGraph.frame.size.height, outlineViewWidth, 30)];
    _newUVLabel.text =[NSString stringWithFormat:@"新UV:      %i",(arc4random() % 1000)];
    _newUVLabel.textColor = PNDeepGrey;
    _newUVLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
    _newUVLabel.textAlignment = NSTextAlignmentLeft;
    
    _averageStayTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 3 + _newUVLabel.frame.origin.y +_newUVLabel.frame.size.height, outlineViewWidth, 30)];
    _averageStayTimeLabel.text =[NSString stringWithFormat:@"平均页面停留时间:  %i",(arc4random() % 100)];
    _averageStayTimeLabel.textColor = PNDeepGrey;
    _averageStayTimeLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
    _averageStayTimeLabel.textAlignment = NSTextAlignmentLeft;

    _sumbitDealTransformLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 3 + _averageStayTimeLabel.frame.origin.y +_averageStayTimeLabel.frame.size.height, outlineViewWidth, 30)];
    _sumbitDealTransformLabel.text =[NSString stringWithFormat:@"提交订单转化率:     %i%%",(arc4random() % 100)];
    _sumbitDealTransformLabel.textColor = PNDeepGrey;
    _sumbitDealTransformLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
    _sumbitDealTransformLabel.textAlignment = NSTextAlignmentLeft;

    _validDealTransformLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 3 + _sumbitDealTransformLabel.frame.origin.y +_sumbitDealTransformLabel.frame.size.height, outlineViewWidth, 30)];
    _validDealTransformLabel.text =[NSString stringWithFormat:@"有效订单转化率:     %i%%",(arc4random() % 100)];
    _validDealTransformLabel.textColor = PNDeepGrey;
    _validDealTransformLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
    _validDealTransformLabel.textAlignment = NSTextAlignmentLeft;
    
    [self addSubview:_PVLabel];
    [self addSubview:_newUVLabel];
    [self addSubview:_averageStayTimeLabel];
    [self addSubview:_sumbitDealTransformLabel];
    [self addSubview:_validDealTransformLabel];
    
}

#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return (int)[_arrayOfValues count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[_arrayOfValues objectAtIndex:index] floatValue];
}

@end
