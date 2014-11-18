//
//  sourceAnalyticsView.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-11-17.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "sourceAnalyticsView.h"
#import "defines.h"
#import "UIColor+BFPaperColors.h"
#import "Colours.h"

@implementation sourceAnalyticsView
{
    UILabel *_visitorLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _groupPercentArray = [[NSMutableArray alloc] initWithArray:@[@30,@20,@20,@15,@10,@5]];
        _groupValidPercentArray = [[NSMutableArray alloc] initWithArray:@[@10,@7,@13,@6,@6,@9]];

        _groupColorArray   = [[NSMutableArray alloc] initWithArray:@[[UIColor paperColorIndigo],[UIColor paperColorBlue],[UIColor paperColorLightBlue],[UIColor paperColorCyan],[UIColor paperColorTeal],[UIColor paperColorGreen]]];
        
        _sourcesStringArray = [[NSMutableArray alloc] initWithArray: @[@"硬广",@"导航",@"搜索",@"广告联盟",@"直接流量",@"EDM"]];

        [self addViews];
    }
    
    return self;
}


- (void)addViews
{
    _chartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, outlineViewWidth, 30)];
    //        _chartLabel.text = (NSString *)data[dataType]?(NSString *)data[dataType]: @"Circle Chart";
    _chartLabel.text = @"来源分析";
    _chartLabel.textColor = PNFreshGreen;
    _chartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
    _chartLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addVisitorPieChart];
    
    [self addValidUVBarChart];
    
    [self addTipsView];

}

- (void)addVisitorPieChart
{
    _visitorLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10 + _chartLabel.frame.origin.y + _chartLabel.frame.size.height, outlineViewWidth/2, 30)];
    _visitorLabel.text = @"VISIT:";
    _visitorLabel.textColor = PNDeepGrey;
    _visitorLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
    _visitorLabel.textAlignment = NSTextAlignmentLeft;
    
    CGSize size = [_visitorLabel.text sizeWithFont:_visitorLabel.font];
    CGRect r = _visitorLabel.frame;
    r.size.width = size.width;
    _visitorLabel.frame = r;
    
//    _circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(5.0,_visitorLabel.frame.origin.y + _visitorLabel.frame.size.height - 30.0, 70, 70) andTotal:@100 andCurrent:@60 andClockwise:YES andShadow:YES];
//    _circleChart.backgroundColor = [UIColor clearColor];
//    
//    [_circleChart setStrokeColor:[UIColor colorWithRed:77.0 / 255.0 green:106.0 / 255.0 blue:122.0 / 255.0 alpha:1.0f]];
//    [_circleChart setStrokeColorGradientStart:[UIColor colorWithRed:77.0 / 255.0 green:236.0 / 255.0 blue:122.0 / 255.0 alpha:1.0f]];
//    _circleChart.isRestroke = NO;
//    [_circleChart strokeChart];
    
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[0]).floatValue color:_groupColorArray[0]],
                       [PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[1]).floatValue color:_groupColorArray[1]],
                       [PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[2]).floatValue color:_groupColorArray[2]],
                       [PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[3]).floatValue color:_groupColorArray[3]],
                       [PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[4]).floatValue color:_groupColorArray[4]],
                       [PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[5]).floatValue color:_groupColorArray[5]],
                       ];
    
    float pieWidth = outlineViewHeight - ( _visitorLabel.frame.origin.y +_visitorLabel.frame.size.height) + 35;
    _pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(5.0,5 + _visitorLabel.frame.origin.y +_visitorLabel.frame.size.height + 15.0,80, 80) items:items];
    _pieChart.descriptionTextColor = [UIColor whiteColor];
    _pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:10.0];
    _pieChart.descriptionTextShadowColor = [UIColor clearColor];
    [_pieChart strokeChart];
    
    [self addSubview:_visitorLabel];
    [self addSubview:_chartLabel];
    [self addSubview:_pieChart];

}


- (void)addValidUVBarChart
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50 + _visitorLabel.frame.size.width + 10, 10 + _chartLabel.frame.origin.y + _chartLabel.frame.size.height, outlineViewWidth, 30)];
    label.text = @"有效UV:";
    label.textColor = PNDeepGrey;
    label.font = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
    label.textAlignment = NSTextAlignmentLeft;
    
    CGSize size = [label.text sizeWithFont:label.font];
    CGRect r = label.frame;
    r.size.width = size.width;
    label.frame = r;
    
    _vaildSourceBarChart = [[PNBarChart alloc] initWithFrame:CGRectMake(80,label.frame.origin.y + label.frame.size.height, 210, 150)];
    _vaildSourceBarChart.backgroundColor = [UIColor clearColor];
    _vaildSourceBarChart.yLabelFormatter = ^(CGFloat yValue) {
        CGFloat yValueParsed = yValue;
        NSString * labelText = [NSString stringWithFormat:@"%1.f",yValueParsed];
        return labelText;
    };
    _vaildSourceBarChart.labelMarginTop = 5.0;
    _vaildSourceBarChart.yLabelSum = 5;
    [_vaildSourceBarChart setXLabels:_sourcesStringArray];
    [_vaildSourceBarChart setYValues:_groupPercentArray];
    [_vaildSourceBarChart setYValues1:_groupValidPercentArray];
    _vaildSourceBarChart.labelFont = [UIFont fontWithName:@"OpenSans-Light" size:8.0];
    [_vaildSourceBarChart setStrokeColors:_groupColorArray];
    [_vaildSourceBarChart setStrokeColor1:[UIColor paperColorBlueGray]];
    
    _vaildSourceBarChart.ifUseGradientColor = NO;
    _vaildSourceBarChart.showChartBorder = NO;
    _vaildSourceBarChart.showReferenceLines = YES;
    
    // Adding gradient
    _vaildSourceBarChart.barColorGradientStart = PNDeepGreen;
    _vaildSourceBarChart.barWidth = 20.0;
    
    [_vaildSourceBarChart strokeChart];
    
    [self addSubview:label];
    [self addSubview:_vaildSourceBarChart];

}


- (void)addTipsView
{
    float originY = _vaildSourceBarChart.frame.origin.y + _vaildSourceBarChart.frame.size.height - 20;
    __block float lastOriginX = 5;
    
    [_sourcesStringArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(lastOriginX + 8, originY, 40, 30)];
        label.text = _sourcesStringArray[idx];
        label.textColor = PNDeepGrey;
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:9.0];
        label.textAlignment = NSTextAlignmentLeft;
        CGSize size = [label.text sizeWithFont:label.font];
        CGRect r = label.frame;
        r.size.width = size.width;
        label.frame = r;
        [self addSubview:label];
        
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width + 1,originY, 10, 10)];
        dotView.layer.cornerRadius = 5.0;
        dotView.backgroundColor = (UIColor *)_groupColorArray[idx];
        [self addSubview: dotView];
        CGPoint p = dotView.center;
        p.y = label.center.y;
        dotView.center = p;
        
        lastOriginX = dotView.frame.origin.x + dotView.frame.size.width;
        
    }];
}

- (void)modifyPageViewWithData:(NSDictionary *)data
{
    _groupPercentArray      = data[@"groupPercentArray"];
    _groupValidPercentArray = data[@"groupValidPercentArray"];
    
    [_vaildSourceBarChart setYValues:_groupPercentArray];
    [_vaildSourceBarChart setYValues1:_groupValidPercentArray];
    [_vaildSourceBarChart strokeChart];
    
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[0]).floatValue color:_groupColorArray[0]],
                       [PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[1]).floatValue color:_groupColorArray[1]],
                       [PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[2]).floatValue color:_groupColorArray[2]],
                       [PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[3]).floatValue color:_groupColorArray[3]],
                       [PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[4]).floatValue color:_groupColorArray[4]],
                       [PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[5]).floatValue color:_groupColorArray[5]],
                       ];
    
    _pieChart.items = items;
    [_pieChart strokeChart];
}


@end
