//
//  visitorGroupOutlineView.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-8.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "visitorGroupOutlineView.h"
#import "defines.h"
#import "PNChart.h"

@implementation visitorGroupOutlineView
{
    UILabel *_chartLabel;
    UILabel *_uvLabel;
    UILabel *_validUVLabel;
    UILabel *_visitorLabel;
    
    UILabel *_groupLabel1;
    UILabel *_groupLabel2;
    UILabel *_groupLabel3;
    
    UIView *_colorDotView1;
    UIView *_colorDotView2;
    UIView *_colorDotView3;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _groupPercentArray = @[@15,@30,@55];
        _groupColorArray   = @[PNLightGreen,PNFreshGreen,PNDeepGreen];
        [self addViews];
    }
    
    return self;
}


- (void)addViews
{
    //Add PieChart
    _chartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, outlineViewWidth, 30)];
    _chartLabel.text = @"访客群体分析";
    _chartLabel.textColor = PNFreshGreen;
    _chartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
    _chartLabel.textAlignment = NSTextAlignmentCenter;
    
    _uvLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 3 + _chartLabel.frame.origin.y +_chartLabel.frame.size.height, outlineViewWidth, 30)];
    _uvLabel.text = [NSString stringWithFormat:@"UV:        %i",(arc4random() % 20000)];
    _uvLabel.textColor = PNDeepGrey;
    _uvLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
    _uvLabel.textAlignment = NSTextAlignmentLeft;
    
    _validUVLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 3 + _uvLabel.frame.origin.y +_uvLabel.frame.size.height, outlineViewWidth, 30)];
    _validUVLabel.text =[NSString stringWithFormat:@"有效UV:  %i",(arc4random() % 10000)];
    _validUVLabel.textColor = PNDeepGrey;
    _validUVLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
    _validUVLabel.textAlignment = NSTextAlignmentLeft;
    
    _visitorLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 3 + _validUVLabel.frame.origin.y +_validUVLabel.frame.size.height, outlineViewWidth, 30)];
    _visitorLabel.text =[NSString stringWithFormat:@"VISIT:    %i",(arc4random() % 100000)];
    _visitorLabel.textColor = PNDeepGrey;
    _visitorLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
    _visitorLabel.textAlignment = NSTextAlignmentLeft;

    
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[0]).floatValue color:_groupColorArray[0]],
                       [PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[1]).floatValue color:_groupColorArray[1]],
                       [PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[2]).floatValue color:_groupColorArray[2]],
                       ];
    
    float pieWidth = outlineViewHeight - ( _visitorLabel.frame.origin.y +_visitorLabel.frame.size.height) + 35;
    _pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(15.0,5 + _visitorLabel.frame.origin.y +_visitorLabel.frame.size.height,pieWidth, pieWidth) items:items];
    _pieChart.descriptionTextColor = [UIColor whiteColor];
    _pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
    _pieChart.descriptionTextShadowColor = [UIColor clearColor];
    [_pieChart strokeChart];

    [self addSubview:_chartLabel];
    [self addSubview:_uvLabel];
    [self addSubview:_validUVLabel];
    [self addSubview:_visitorLabel];
    [self addSubview:_pieChart];
    
    float originDotViewX = 10 + _pieChart.frame.origin.x + pieWidth;
    
    _colorDotView1 = [[UIView alloc] initWithFrame:CGRectMake(originDotViewX,15 + _pieChart.frame.origin.y, 10, 10)];
    _colorDotView2 = [[UIView alloc] initWithFrame:CGRectMake(originDotViewX,3 + _colorDotView1.frame.origin.y + _colorDotView1.frame.size.height,10, 10)];
    _colorDotView3 = [[UIView alloc] initWithFrame:CGRectMake(originDotViewX,3 + _colorDotView2.frame.origin.y + _colorDotView2.frame.size.height, 10, 10)];
    
    _colorDotView1.layer.cornerRadius = _colorDotView2.layer.cornerRadius = _colorDotView3.layer.cornerRadius = 5.0;
    _colorDotView1.backgroundColor = (UIColor *)_groupColorArray[0];
    _colorDotView2.backgroundColor = (UIColor *)_groupColorArray[1];
    _colorDotView3.backgroundColor = (UIColor *)_groupColorArray[2];
    
    [self addSubview: _colorDotView1];
    [self addSubview: _colorDotView2];
    [self addSubview: _colorDotView3];
    
    float originX = originDotViewX + _colorDotView1.frame.size.width + 5;
    _groupLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(originX, 15 + _pieChart.frame.origin.y, outlineViewWidth/2, 30)];
    _groupLabel1.text =[NSString stringWithFormat:@"群体A:  %i%%",((NSNumber *)_groupPercentArray[0]).intValue];
    _groupLabel1.textColor = (UIColor *)_groupColorArray[0];
    _groupLabel1.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _groupLabel1.textAlignment = NSTextAlignmentLeft;
    
    _groupLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(originX, 3 + _groupLabel1.frame.origin.y + _groupLabel1.frame.size.height, outlineViewWidth/2, 30)];
    _groupLabel2.text =[NSString stringWithFormat:@"群体B:  %i%%",((NSNumber *)_groupPercentArray[1]).intValue];
    _groupLabel2.textColor = (UIColor *)_groupColorArray[1];
    _groupLabel2.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _groupLabel2.textAlignment = NSTextAlignmentLeft;
    
    _groupLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(originX, 3 + _groupLabel2.frame.origin.y + _groupLabel2.frame.size.height, outlineViewWidth/2, 30)];
    _groupLabel3.text =[NSString stringWithFormat:@"群体C:  %i%%",((NSNumber *)_groupPercentArray[2]).intValue];
    _groupLabel3.textColor =(UIColor *)_groupColorArray[2];
    _groupLabel3.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _groupLabel3.textAlignment = NSTextAlignmentLeft;
    
    [self addSubview: _groupLabel1];
    [self addSubview: _groupLabel2];
    [self addSubview: _groupLabel3];
    
    _colorDotView1.center = CGPointMake(_colorDotView1.center.x,_groupLabel1.center.y);
    _colorDotView2.center = CGPointMake(_colorDotView2.center.x,_groupLabel2.center.y);
    _colorDotView3.center = CGPointMake(_colorDotView3.center.x,_groupLabel3.center.y);
}

- (void)modifyGroupView
{
    _colorDotView1.backgroundColor = _groupLabel1.textColor = (UIColor *)_groupColorArray[0];
    _colorDotView2.backgroundColor = _groupLabel2.textColor = (UIColor *)_groupColorArray[1];
    _colorDotView3.backgroundColor = _groupLabel3.textColor = (UIColor *)_groupColorArray[2];
    _groupLabel1.text =[NSString stringWithFormat:@"群体A:  %i%%",((NSNumber *)_groupPercentArray[0]).intValue];
    _groupLabel2.text =[NSString stringWithFormat:@"群体B:  %i%%",((NSNumber *)_groupPercentArray[1]).intValue];
    _groupLabel3.text =[NSString stringWithFormat:@"群体C:  %i%%",((NSNumber *)_groupPercentArray[2]).intValue];
}


@end
