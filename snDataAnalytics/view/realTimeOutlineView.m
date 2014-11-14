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
#import "Colours.h"
#import <snDataAnalytics-swift.h>

CGFloat const kJBBarChartViewControllerChartHeight = 250.0f;
CGFloat const kJBBarChartViewControllerChartPadding = 10.0f;
CGFloat const kJBBarChartViewControllerChartHeaderHeight = 80.0f;
CGFloat const kJBBarChartViewControllerChartHeaderPadding = 20.0f;
CGFloat const kJBBarChartViewControllerChartFooterHeight = 25.0f;
CGFloat const kJBBarChartViewControllerChartFooterPadding = 5.0f;
CGFloat const kJBBarChartViewControllerBarPadding = 20.0f;
NSInteger const kJBBarChartViewControllerNumBars = 6;
NSInteger const kJBBarChartViewControllerMaxBarHeight = 10;
NSInteger const kJBBarChartViewControllerMinBarHeight = 5;

@interface realTimeOutlineView () <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@end

@implementation realTimeOutlineView
{
    UILabel *_chartLabel;
    UILabel *_realtimevisitorGroupLabel;
    UILabel *_realtimeDealLabel;
    UILabel *_realtimeCityLabel;
    UILabel *_realtimeTop5PagiesLabel;
    
    UILabel *_uvGroupLabel;
    UILabel *_validGroupUVLabel;
    UILabel *_visitorGroupLabel;
    UIView  *_UVLine;
    UIView  *_validUVLine;
    UILabel *_validUVRatioLabel;

    UILabel *_dealMoneyLabel;
    UILabel *_validDealNumberLabel;
    UILabel *_validDealTransformRatioLabel;

    
    UILabel *_visitorRatioLabel;
    UILabel *_visitorLabel1;
    UILabel *_visitorLabel2;
    UILabel *_visitorLabel3;
    UIView  *_visitorColorDotView1;
    UIView  *_visitorColorDotView2;
    UIView  *_visitorColorDotView3;
    NSArray *_visitorLabelArray;
    NSArray *_visitorColorDotViewArray;

    
    UILabel *_validUVSourceRatioLabel;
    UILabel *_validSourceLabel1;
    UILabel *_validSourceLabel2;
    UILabel *_validSourceLabel3;
    UILabel *_validSourceLabel4;
    UILabel *_validSourceLabel5;
    UILabel *_validSourceLabel6;
    UILabel *_validSourceLabel7;
    UIView *_validSourceColorDotView1;
    UIView *_validSourceColorDotView2;
    UIView *_validSourceColorDotView3;
    UIView *_validSourceColorDotView4;
    UIView *_validSourceColorDotView5;
    UIView *_validSourceColorDotView6;
    UIView *_validSourceColorDotView7;
//    NSArray *_validSourceLabelArray;
    NSArray *_validSourceColorDotViewArray;
    
    NSArray *_validSourceLabelArray;
    

    UIButton *_referenceLineButton;
}

- (instancetype)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _groupPercentArray = @[@15,@30,@55,@23,@33,@40,@20];
        _validSourceUVPercentArray = @[@7,@14,@25,@11,@15,@19,@9];
//        _groupColorArray   = @[PNTwitterColor,[UIColor colorWithRed:30.0/255.0 green:144.0/255.0 blue:255.0/255.0 alpha:1],PNBlue];
        _groupColorArray = @[PNLightGreen,PNFreshGreen,PNDeepGreen,PNRed,PNTitleColor,PNYellow,PNBrown];
        _validSourceUVColorArray = @[[UIColor robinEggColor],[UIColor pastelBlueColor],[UIColor turquoiseColor],[UIColor steelBlueColor],[UIColor denimColor],[UIColor emeraldColor],[UIColor cardTableColor]];

        _sourcesStringArray = @[@"硬广",@"导航",@"搜索",@"广告联盟",@"直接流量",@"EDM"];
        [self addViews];
    }
    
    return self;
}

- (void)addViews
{
    [self addTitleLabel];
    [self addReferenceButton];
    [self addvisitorGroupAnalyticsView];
    [self addDealView];
    [self addSourceView];
    [self addCitiesAnalyticsView];
    [self addPagesAnalyticsView];
    
    [self addSubview:_realtimevisitorGroupLabel];
    [self addSubview:_UVLine];
    [self addSubview:_validUVLine];
    [self addSubview:_validUVRatioLabel];
    [self addSubview:_validGroupUVLabel];
    [self addSubview:_uvGroupLabel];
    [self addSubview:_visitorGroupLabel];

    [self addSubview:_dealMoneyLabel];
    [self addSubview:_lineGraph];
    [self addSubview:_validDealNumberLabel];
    [self addSubview:_validDealTransformRatioLabel];
    [self addSubview:_visitorRatioLabel];
    [self addSubview:_visitorPieChart];
    [self addSubview:_validUVSourceRatioLabel];

//    [self addSubview:_vaildSourcePieChart];
    [self addSubview:_realtimeCityLabel];
    [self addSubview:_realtimeTop5PagiesLabel];
}

- (void)addTitleLabel
{
    _chartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 5, outlineViewWidth/4, 30)];
    _chartLabel.text = @"实时";
    _chartLabel.textColor = PNFreshGreen;
    _chartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:24.0];
    _chartLabel.textAlignment = NSTextAlignmentCenter;
    _chartLabel.center = CGPointMake(outlineViewWidth/2,  _chartLabel.center.y);
    [self addSubview:_chartLabel];
}

- (void)addReferenceButton
{
    _referenceLineButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _referenceLineButton.frame = CGRectMake(200.0, 8, 25, 25);
    [_referenceLineButton setBackgroundImage:[UIImage imageNamed:@"icon_dataBar"] forState:UIControlStateNormal];
    [_referenceLineButton addTarget:self action:@selector(referenceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    CGRect r = _referenceLineButton.frame;
    r.origin.x = outlineViewWidth - 10.0 - 32;
    _referenceLineButton.frame = r;
    [self addSubview:_referenceLineButton];
}

- (void)referenceButtonClicked:(UIButton *)button
{
    if(_lineGraph){
        _lineGraph.enableReferenceAxisLines = _lineGraph.enableReferenceAxisLines == NO ? YES : NO;
        _lineGraph.enableYAxisLabel = _lineGraph.enableYAxisLabel == NO ? YES : NO;
        _lineGraph.colorXaxisLabel = (_lineGraph.colorXaxisLabel == [UIColor grayColor]) ? [UIColor clearColor] : [UIColor grayColor];

        [_lineGraph reloadGraph];
    }
    if(_vaildSourceBarChart){
       _vaildSourceBarChart.showChartBorder = _vaildSourceBarChart.showReferenceLines = _vaildSourceBarChart.showReferenceLines == NO ? YES : NO;
        [_vaildSourceBarChart strokeChart];
    }
    if(_citiesBarChart){
        _citiesBarChart.showChartBorder =_citiesBarChart.showReferenceLines = _citiesBarChart.showReferenceLines == NO ? YES : NO;
        [_citiesBarChart strokeChart];
    }
    if(_pagesBarChart){
        _pagesBarChart.showChartBorder = _pagesBarChart.showReferenceLines = _pagesBarChart.showReferenceLines == NO ? YES : NO;
        [_pagesBarChart strokeChart];
    }
}

- (void)addvisitorGroupAnalyticsView
{
    _groupUV = arc4random() % 20000;
    _validUVRatio = ((arc4random() % 500) + 500) / 1000.0;
    _validGroupUV = _groupUV * _validUVRatio;
    
    _uvGroupLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5 + _chartLabel.frame.origin.y +_chartLabel.frame.size.height, outlineViewWidth/2, 20)];
    _uvGroupLabel.text = [NSString stringWithFormat:@"UV:%i",_groupUV];
    _uvGroupLabel.textColor = PNDeepGrey;
    _uvGroupLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _uvGroupLabel.textAlignment = NSTextAlignmentLeft;
    CGSize size = [_uvGroupLabel.text sizeWithFont:_uvGroupLabel.font];
    CGRect r = _uvGroupLabel.frame;
    r.size.width = size.width;
    _uvGroupLabel.frame = r;
//    _uvGroupLabel.morphingDuration = 0.07f;
    
    _visitorGroupLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _uvGroupLabel.frame.origin.y, outlineViewWidth/2, 20)];
    _visitorGroupLabel.text =[NSString stringWithFormat:@"visitor: %i",(arc4random() % 100000)];
    _visitorGroupLabel.textColor = PNDeepGrey;
    _visitorGroupLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _visitorGroupLabel.textAlignment = NSTextAlignmentRight;
    size = [_visitorGroupLabel.text sizeWithFont:_visitorGroupLabel.font];
    r = _visitorGroupLabel.frame;
    r.size.width = size.width;
    r.origin.x = outlineViewWidth - size.width - 20;
    _visitorGroupLabel.frame = r;
    
    _validUVLine = [[UIView alloc] initWithFrame:CGRectMake(0,5 + _uvGroupLabel.frame.origin.y+_uvGroupLabel.frame.size.height,(outlineViewWidth - 1)*_validUVRatio,30)];
    _validUVLine.backgroundColor = PNDeepGreen;
    _UVLine = [[UIView alloc] initWithFrame:CGRectMake(1+_validUVLine.frame.origin.x+_validUVLine.frame.size.width,_validUVLine.frame.origin.y,(outlineViewWidth - 1)*(1 - _validUVRatio),30)];
    _UVLine.backgroundColor = PNLightGreen;
    
    _validGroupUVLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,3 + _uvGroupLabel.frame.origin.y + _uvGroupLabel.frame.size.height, outlineViewWidth/2 , 30)];
    float ratio = _validUVRatio * 100.0;
    _validGroupUVLabel.text =[NSString stringWithFormat:@"有效UV: %i",_validGroupUV];
    _validGroupUVLabel.textColor = PNDeepGrey;
    _validGroupUVLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _validGroupUVLabel.textAlignment = NSTextAlignmentLeft;
    size = [_validGroupUVLabel.text sizeWithFont:_validGroupUVLabel.font];
    r = _validGroupUVLabel.frame;
    r.size.width = size.width;
    _validGroupUVLabel.frame = r;
    CGPoint center = _validGroupUVLabel.center;
    center.y = _UVLine.center.y;
    _validGroupUVLabel.center = center;
    //    _uvGroupLabel = [[UILabel alloc] initWithFrame:CGRectMake(-40 +_validGroupUVLabel.frame.origin.x + _validGroupUVLabel.frame.size.width,_validGroupUVLabel.frame.origin.y, outlineViewWidth/2 -30, 30)];
    //    _uvGroupLabel.text = [NSString stringWithFormat:@"UV: %i",_groupUV];
    //    _uvGroupLabel.textColor = PNDeepGrey;
    //    _uvGroupLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:15.0];
    //    _uvGroupLabel.textAlignment = NSTextAlignmentRight;
    
    _validUVRatioLabel =[[UILabel alloc] initWithFrame:CGRectMake(0,_UVLine.frame.origin.y, outlineViewWidth/2, 30)];
    _validUVRatioLabel.text =[NSString stringWithFormat:@"%.1f%%",ratio];
    _validUVRatioLabel.textColor = PNDeepGrey;
    _validUVRatioLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:20.0];
    _validUVRatioLabel.textAlignment = NSTextAlignmentRight;
    r = _validUVRatioLabel.frame;
    size = [_validUVRatioLabel.text sizeWithFont:_validUVRatioLabel.font];
    r.size.width = size.width;
    _validUVRatioLabel.frame = r;
    r.origin.x = _UVLine.frame.origin.x - 1 - r.size.width - 5;
    _validUVRatioLabel.frame = r;
    center = _validUVRatioLabel.center;
    center.y = _UVLine.center.y;
    _validUVRatioLabel.center = center;
    if(CGRectIntersectsRect(_validGroupUVLabel.frame,_validUVRatioLabel.frame)){
        r.origin.x =  _UVLine.frame.origin.x + 5 ;
        _validUVRatioLabel.frame = r;
    }
}

- (void)addDealView
{
    //    成交
    _dealMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5 + _UVLine.frame.origin.y +_UVLine.frame.size.height, outlineViewWidth, 20)];
    _dealMoneyLabel.text =[NSString stringWithFormat:@"付款金额: %i",(arc4random() % 2000)];
    _dealMoneyLabel.textColor = PNDeepGrey;
    _dealMoneyLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _dealMoneyLabel.textAlignment = NSTextAlignmentLeft;
//    _dealMoneyLabel.morphingDuration = 0.07f;
    
    _arrayOfValues = [[NSMutableArray alloc] init];
    _arrayOfDates = [[NSMutableArray alloc] init];
    
    float totalNumber = 0;
    
    for (int i = 0; i < 20; i++) {
        [_arrayOfValues addObject:[NSNumber numberWithInteger:(arc4random() % 100)]]; // Random values for the graph
        [_arrayOfDates addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:i]]]; // Dates for the X-Axis of the graph
        
        totalNumber = totalNumber + [[_arrayOfValues objectAtIndex:i] intValue]; // All of the values added together
    }
    
    _lineGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 15.0+_dealMoneyLabel.frame.origin.y +_dealMoneyLabel.frame.size.height, outlineViewWidth, 30.0)];
    _lineGraph.delegate = self;
    _lineGraph.dataSource = self;
    
    _lineGraph.backgroundColor = [UIColor clearColor];
    
    // Customization of the graph
    
    _lineGraph.colorLine = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
    
    _lineGraph.colorXaxisLabel = [UIColor clearColor];
    _lineGraph.colorYaxisLabel = [UIColor grayColor];
    _lineGraph.widthLine = 1.5;
//    _lineGraph.labelFont = [UIFont fontWithName:@"Avenir-Medium" size:13.0];
    _lineGraph.enableTouchReport = YES;
    _lineGraph.enablePopUpReport = NO;
    _lineGraph.enableBezierCurve = YES;
    _lineGraph.enableYAxisLabel = NO;
    _lineGraph.autoScaleYAxis = YES;
    _lineGraph.alwaysDisplayDots = NO;
    _lineGraph.enableReferenceAxisLines = NO;
    _lineGraph.enableReferenceAxisFrame = NO;
    _lineGraph.animationGraphStyle = BEMLineAnimationDraw;
    
    _lineGraph.colorTop = [UIColor whiteColor];
    _lineGraph.colorBottom = [UIColor whiteColor];
    //            self.myGraph.backgroundColor = [UIColor whiteColor];
    self.tintColor = [UIColor whiteColor];
    
    _validDealNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 3 + _lineGraph.frame.origin.y +_lineGraph.frame.size.height, outlineViewWidth/2, 20)];
    _validDealNumberLabel.text =[NSString stringWithFormat:@"有效订单数: %i",(arc4random() % 1000)];
    _validDealNumberLabel.textColor = PNDeepGrey;
    _validDealNumberLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _validDealNumberLabel.textAlignment = NSTextAlignmentLeft;
    CGRect r = _validDealNumberLabel.frame;
    CGSize size = [_validDealNumberLabel.text sizeWithFont:_validDealNumberLabel.font];
    r.size.width = size.width;
    _validDealNumberLabel.frame = r;
    
    _validDealTransformRatioLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 + _validDealNumberLabel.frame.origin.x +_validDealNumberLabel.frame.size.width, _validDealNumberLabel.frame.origin.y, outlineViewWidth/2, 20)];
    _validDealTransformRatioLabel.text =[NSString stringWithFormat:@"转化率: %.1f%%",((arc4random() % 1000)/1000.0)*100];
    _validDealTransformRatioLabel.textColor = PNDeepGrey;
    _validDealTransformRatioLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _validDealTransformRatioLabel.textAlignment = NSTextAlignmentLeft;
    r = _validDealTransformRatioLabel.frame;
    size = [_validDealTransformRatioLabel.text sizeWithFont:_validDealTransformRatioLabel.font];
    r.size.width = size.width;
    _validDealTransformRatioLabel.frame = r;
}

- (void)addSourceView
{
    //    来源渠道
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[0]).floatValue color:_groupColorArray[0]],
                       [PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[1]).floatValue color:_groupColorArray[1]],
                       [PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[2]).floatValue color:_groupColorArray[2]],
                       ];
    
    
    _visitorRatioLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5 + _validDealTransformRatioLabel.frame.origin.y +_validDealTransformRatioLabel.frame.size.height, outlineViewWidth, 20)];
    _visitorRatioLabel.text =@"visitor占比:";
    _visitorRatioLabel.textColor = PNDeepGrey;
    _visitorRatioLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _visitorRatioLabel.textAlignment = NSTextAlignmentLeft;
    CGRect r = _visitorRatioLabel.frame;
    CGSize size = [_visitorRatioLabel.text sizeWithFont:_visitorRatioLabel.font];
    r.size.width = size.width;
    _visitorRatioLabel.frame = r;
    
    float pieWidth = 100.0;
    _visitorPieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(45.0 + _visitorRatioLabel.frame.origin.x + _visitorRatioLabel.frame.size.width, _visitorRatioLabel.frame.origin.y ,pieWidth, pieWidth) items:items];
    _visitorPieChart.descriptionTextColor = [UIColor whiteColor];
    _visitorPieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:12.0];
    _visitorPieChart.descriptionTextShadowColor = [UIColor clearColor];
    [_visitorPieChart strokeChart];
    
    float originDotViewX = 35.0/*5 + _visitorPieChart.frame.origin.x + pieWidth*/;
    
    _visitorColorDotView1 = [[UIView alloc] init];
    _visitorColorDotView2 = [[UIView alloc] init];
    _visitorColorDotView3 = [[UIView alloc] init];
    _visitorColorDotViewArray = @[_visitorColorDotView1,_visitorColorDotView2,_visitorColorDotView3];
    
    [_visitorColorDotViewArray enumerateObjectsUsingBlock:^(UIView *dotView, NSUInteger idx, BOOL *stop) {
        if(idx == 0){
            dotView.frame = CGRectMake(originDotViewX,20 + _visitorPieChart.frame.origin.y, 10, 10);
        }else{
            dotView.frame = CGRectMake(originDotViewX,3 + ((UIView *)_visitorColorDotViewArray[idx - 1]).frame.origin.y + _visitorColorDotView1.frame.size.height,10, 10);
        }
        dotView.layer.cornerRadius = 5.0;
        dotView.backgroundColor = (UIColor *)_groupColorArray[idx];
        [self addSubview: dotView];
        
    }];
    
//    float originX = originDotViewX + _visitorColorDotView1.frame.size.width + 5;
    float originX = originDotViewX + _visitorColorDotView1.frame.size.width + 5;
    _visitorLabel1 = [[UILabel alloc] init];
    _visitorLabel2 = [[UILabel alloc] init];
    _visitorLabel3 = [[UILabel alloc] init];
    
    _visitorLabelArray = @[_visitorLabel1,_visitorLabel2,_visitorLabel3];
    
    [_visitorLabelArray enumerateObjectsUsingBlock:^(UILabel *labelView, NSUInteger idx, BOOL *stop) {
        if(idx == 0){
            labelView.frame = CGRectMake(originX,  5 + _visitorRatioLabel.frame.origin.y + _visitorRatioLabel.frame.size.height, outlineViewWidth/2, 15);
        }else{
            labelView.frame = CGRectMake(originX, 3 +( (UILabel *)(_visitorLabelArray[idx - 1])).frame.origin.y + + _visitorLabel1.frame.size.height, outlineViewWidth/2, 15);
        }
        labelView.text =[NSString stringWithFormat:@"群体%i: %i%%",idx,((NSNumber *)_groupPercentArray[idx]).intValue];
        labelView.textColor = (UIColor *)_groupColorArray[idx];
        labelView.font = [UIFont fontWithName:@"Avenir-Medium" size:13.0];
        labelView.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview: labelView];
        
        ((UIView *)_visitorColorDotViewArray[idx]).center = CGPointMake(((UIView *)_visitorColorDotViewArray[idx]).center.x,labelView.center.y);
        
    }];
    
    
    _validUVSourceRatioLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0 + _visitorPieChart.frame.origin.y +_visitorPieChart.frame.size.height, outlineViewWidth, 20)];
    _validUVSourceRatioLabel.text =@"来源有效UV占比:";
    _validUVSourceRatioLabel.textColor = PNDeepGrey;
    _validUVSourceRatioLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _validUVSourceRatioLabel.textAlignment = NSTextAlignmentLeft;
    
    
    _vaildSourceBarChart = [[PNBarChart alloc] initWithFrame:CGRectMake(10,3+ _validUVSourceRatioLabel.frame.origin.y + _validUVSourceRatioLabel.frame.size.height, outlineViewWidth, outlineViewHeight/2)];
    _vaildSourceBarChart.backgroundColor = [UIColor clearColor];
    _vaildSourceBarChart.yLabelFormatter = ^(CGFloat yValue){
        CGFloat yValueParsed = yValue;
        NSString * labelText = [NSString stringWithFormat:@"%1.f",yValueParsed];
        return labelText;
    };
    _vaildSourceBarChart.labelMarginTop = 5.0;
    _vaildSourceBarChart.yLabelSum = 5;
    [_vaildSourceBarChart setXLabels:_sourcesStringArray];
    [_vaildSourceBarChart setYValues:@[@24,@12,@18,@10,@21,@15]];
    [_vaildSourceBarChart setYValues1:@[@10,@7,@13,@6,@6,@9]];
    _vaildSourceBarChart.labelFont = [UIFont fontWithName:@"OpenSans-Light" size:10.0];
    [_vaildSourceBarChart setStrokeColor:PNDeepGreen];
    [_vaildSourceBarChart setStrokeColor1:[UIColor indigoColor]];

    _vaildSourceBarChart.ifUseGradientColor = NO;
    _vaildSourceBarChart.showChartBorder = NO;
    _vaildSourceBarChart.showReferenceLines = NO;
    
    // Adding gradient
    _vaildSourceBarChart.barColorGradientStart = PNDeepGreen;
    _vaildSourceBarChart.barWidth = 20.0;
    
    [_vaildSourceBarChart strokeChart];
    
    [self addSubview:_vaildSourceBarChart];
    
    
//    _vaildSourceRatioBarChart = [[PNBarChart alloc] initWithFrame:CGRectMake(10,35+ _validUVSourceRatioLabel.frame.origin.y + _validUVSourceRatioLabel.frame.size.height, outlineViewWidth, outlineViewHeight/3)];
//    _vaildSourceRatioBarChart.backgroundColor = [UIColor clearColor];
//    _vaildSourceRatioBarChart.barBackgroundColor = [UIColor clearColor];
//    _vaildSourceRatioBarChart.yLabelFormatter = ^(CGFloat yValue){
//        CGFloat yValueParsed = yValue;
//        NSString * labelText = [NSString stringWithFormat:@"%1.f",yValueParsed];
//        return labelText;
//    };
//    _vaildSourceRatioBarChart.labelMarginTop = 5.0;
////    [_vaildSourceRatioBarChart setXLabels:@[@"1",@"2",@"搜索",@"广告联盟",@"直接流量",@"EDM"]];
//    [_vaildSourceRatioBarChart setYValues:@[@10,@7,@13,@6,@6,@9]];
//    _vaildSourceRatioBarChart.showLabel = NO;
//    _vaildSourceRatioBarChart.barWidth = 20.0;
//
//    [_vaildSourceRatioBarChart setStrokeColor:[UIColor indigoColor]];
//    // Adding gradient
////    _vaildSourceRatioBarChart.barColorGradientStart = [UIColor indigoColor];
//    
//    [_vaildSourceRatioBarChart strokeChart];
//    
////    [self addSubview:_vaildSourceRatioBarChart];
//    
//    CGRect f = _vaildSourceRatioBarChart.frame;
//    f.origin.y = _vaildSourceBarChart.frame.origin.y + _vaildSourceBarChart.frame.size.height - _vaildSourceRatioBarChart.frame.size.height;
//    _vaildSourceRatioBarChart.frame = f;
    
    {
//    [self initFakeData];
//    
//    
//    self.barChartView = [[JBBarChartView alloc] init];
//    self.barChartView.frame = CGRectMake(20, f.origin.y + f.size.height -20, outlineViewWidth - 40, outlineViewHeight/2);
//    self.barChartView.delegate = self;
//    self.barChartView.dataSource = self;
//    self.barChartView.headerPadding = kJBBarChartViewControllerChartHeaderPadding;
//    self.barChartView.minimumValue = 0.0f;
//    self.barChartView.inverted = NO;
//    self.barChartView.backgroundColor = [UIColor clearColor];
//    
//    [self addSubview:self.barChartView];
//    [self.barChartView reloadData];
//
//    self.barChartView1 = [[JBBarChartView alloc] init];
//    self.barChartView1.frame = CGRectMake(20, _barChartView.frame.origin.y + _barChartView.frame.size.height + 5,outlineViewWidth - 40, outlineViewHeight/4);
//    self.barChartView1.delegate = self;
//    self.barChartView1.dataSource = self;
//    self.barChartView1.headerPadding = kJBBarChartViewControllerChartHeaderPadding;
//    self.barChartView1.minimumValue = 0.0f;
//    self.barChartView1.inverted = NO;
//    self.barChartView1.backgroundColor = [UIColor clearColor];
//    
//    [self addSubview:self.barChartView1];
//    [self.barChartView1 reloadData];
//    
//    f = _barChartView1.frame;
//    f.origin.y = _barChartView.frame.origin.y + _barChartView.frame.size.height - f.size.height;
//    _barChartView1.frame = f;
//
//    originX = 15;
//    _validSourceLabel1 = [[UILabel alloc] init];
//    _validSourceLabel2 = [[UILabel alloc] init];
//    _validSourceLabel3 = [[UILabel alloc] init];
//    _validSourceLabel4 = [[UILabel alloc] init];
//    _validSourceLabel5 = [[UILabel alloc] init];
//    _validSourceLabel6 = [[UILabel alloc] init];
//
//    _validSourceLabelArray = @[_validSourceLabel1,_validSourceLabel2,_validSourceLabel3,_validSourceLabel4,_validSourceLabel5,_validSourceLabel6];
//
//    [_validSourceLabelArray enumerateObjectsUsingBlock:^(UILabel *labelView, NSUInteger idx, BOOL *stop) {
//        if(idx == 0){
//            labelView.frame = CGRectMake(originX, 2 + _barChartView1.frame.origin.y + _barChartView1.frame.size.height, 35, 15);
//        }else{
//            labelView.frame = CGRectMake(15 +((UILabel *)(_validSourceLabelArray[idx - 1])).frame.origin.x + ((UILabel *)(_validSourceLabelArray[idx - 1])).frame.size.width, 2 + _barChartView1.frame.origin.y + _barChartView1.frame.size.height, 30, 15);
//        }
//        labelView.text =_sourcesStringArray[idx];
//        labelView.textColor = PNDeepGrey;
//        labelView.font = [UIFont fontWithName:@"Avenir-Medium" size:10.0];
//        labelView.textAlignment = NSTextAlignmentCenter;
////        CGSize size = [labelView.text sizeWithFont:labelView.font];
////        CGRect r = labelView.frame;
////        r.size.width = size.width;
////        labelView.frame = r;
//        [self addSubview: labelView];
//        
//    }];
//
//    
//    
//    self.barChartView2 = [[JBBarChartView alloc] init];
//    self.barChartView2.frame = CGRectMake(20,_barChartView1.frame.origin.y + _barChartView1.frame.size.height + 5, self.bounds.size.width - (kJBBarChartViewControllerChartPadding * 2), outlineViewHeight/3);
//    self.barChartView2.delegate = self;
//    self.barChartView2.dataSource = self;
//    self.barChartView2.headerPadding = kJBBarChartViewControllerChartHeaderPadding;
//    self.barChartView2.minimumValue = 0.0f;
//    self.barChartView2.inverted = NO;
//    self.barChartView2.backgroundColor = [UIColor clearColor];
//    
//    [self addSubview:self.barChartView2];
//    [self.barChartView2 reloadData];
//    
//    [self.barChartView setState:JBChartViewStateExpanded animated:YES callback:^{
//    }];
    
//    pieWidth = 100.0;
//    NSArray *items1 = @[[PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[0]).floatValue color:_validSourceUVColorArray[0]],
//                        [PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[1]).floatValue color:_validSourceUVColorArray[1]],
//                        [PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[2]).floatValue color:_validSourceUVColorArray[2]],
//                        [PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[3]).floatValue color:_validSourceUVColorArray[3]],
//                        [PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[4]).floatValue color:_validSourceUVColorArray[4]],
//                        [PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[5]).floatValue color:_validSourceUVColorArray[5]],
//                        [PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[6]).floatValue color:_validSourceUVColorArray[6]],
//                        ];
//    _vaildSourcePieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(35.0 /*+ _validUVSourceRatioLabel.frame.origin.x + _validUVSourceRatioLabel.frame.size.width*/,3+ _validUVSourceRatioLabel.frame.origin.y + _validUVSourceRatioLabel.frame.size.height ,pieWidth, pieWidth) items:items1];
//    _vaildSourcePieChart.descriptionTextColor = [UIColor whiteColor];
//    _vaildSourcePieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:10.0];
//    _vaildSourcePieChart.descriptionTextShadowColor = [UIColor clearColor];
//    [_vaildSourcePieChart strokeChart];
//    
//    originDotViewX = 30 + _vaildSourcePieChart.frame.origin.x + pieWidth;
//    _validSourceColorDotView1 = [[UIView alloc] init];
//    _validSourceColorDotView2 = [[UIView alloc] init];
//    _validSourceColorDotView3 = [[UIView alloc] init];
//    _validSourceColorDotView4 = [[UIView alloc] init];
//    _validSourceColorDotView5 = [[UIView alloc] init];
//    _validSourceColorDotView6 = [[UIView alloc] init];
//    _validSourceColorDotView7 = [[UIView alloc] init];
//    
//    _validSourceColorDotViewArray = @[_validSourceColorDotView1,_validSourceColorDotView2,_validSourceColorDotView3,_validSourceColorDotView4,_validSourceColorDotView5,_validSourceColorDotView6,_validSourceColorDotView7];
//    
//    [_validSourceColorDotViewArray enumerateObjectsUsingBlock:^(UIView *dotView, NSUInteger idx, BOOL *stop) {
//        if(idx == 0){
//            dotView.frame = CGRectMake(originDotViewX,15 + _vaildSourcePieChart.frame.origin.y, 10, 10);
//        }else{
//            dotView.frame = CGRectMake(originDotViewX,3 + ((UIView *)_validSourceColorDotViewArray[idx - 1]).frame.origin.y + _validSourceColorDotView1.frame.size.height,10, 10);
//        }
//        dotView.layer.cornerRadius = 5.0;
//        dotView.backgroundColor = (UIColor *)_validSourceUVColorArray[idx];
//        [self addSubview: dotView];
//        
//    }];
//    
//    
//    originX = originDotViewX + _validSourceColorDotView1.frame.size.width + 7;
//    _validSourceLabel1 = [[UILabel alloc] init];
//    _validSourceLabel2 = [[UILabel alloc] init];
//    _validSourceLabel3 = [[UILabel alloc] init];
//    _validSourceLabel4 = [[UILabel alloc] init];
//    _validSourceLabel5 = [[UILabel alloc] init];
//    _validSourceLabel6 = [[UILabel alloc] init];
//    _validSourceLabel7 = [[UILabel alloc] init];
//    
//    _validSourceLabelArray = @[_validSourceLabel1,_validSourceLabel2,_validSourceLabel3,_validSourceLabel4,_validSourceLabel5,_validSourceLabel6,_validSourceLabel7];
//    
//    [_validSourceLabelArray enumerateObjectsUsingBlock:^(UILabel *labelView, NSUInteger idx, BOOL *stop) {
//        if(idx == 0){
//            labelView.frame = CGRectMake(originX, 2 + _vaildSourcePieChart.frame.origin.y, outlineViewWidth/2, 15);
//        }else{
//            labelView.frame = CGRectMake(originX, 14 +( (UILabel *)(_validSourceLabelArray[idx - 1])).frame.origin.y, outlineViewWidth/2, 15);
//        }
//        labelView.text =[NSString stringWithFormat:@"群体%i: %i%%",idx,((NSNumber *)_validSourceUVPercentArray[idx]).intValue];
//        labelView.textColor = (UIColor *)_validSourceUVColorArray[idx];
//        labelView.font = [UIFont fontWithName:@"Avenir-Medium" size:13.0];
//        labelView.textAlignment = NSTextAlignmentLeft;
//        
//        [self addSubview: labelView];
//        
//        ((UIView *)_validSourceColorDotViewArray[idx]).center = CGPointMake(((UIView *)_validSourceColorDotViewArray[idx]).center.x,labelView.center.y);
//        
//    }];
    }

}

- (void)addCitiesAnalyticsView
{
//    _realtimeCityLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, -5 + _barChartView2.frame.origin.y + _barChartView2.frame.size.height, outlineViewWidth, 20)];
    _realtimeCityLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, -5 + _vaildSourceBarChart.frame.origin.y + _vaildSourceBarChart.frame.size.height, outlineViewWidth, 20)];

    _realtimeCityLabel.text =@"城市分布:";
    _realtimeCityLabel.textColor = PNDeepGrey;
    _realtimeCityLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _realtimeCityLabel.textAlignment = NSTextAlignmentLeft;
    
    _citiesBarChart = [[PNBarChart alloc] initWithFrame:CGRectMake(30, 0.0 + _realtimeCityLabel.frame.origin.y + _realtimeCityLabel.frame.size.height, outlineViewWidth - 40, outlineViewHeight/2)];
    _citiesBarChart.backgroundColor = [UIColor clearColor];
    _citiesBarChart.yLabelFormatter = ^(CGFloat yValue){
        CGFloat yValueParsed = yValue;
        NSString * labelText = [NSString stringWithFormat:@"%1.f",yValueParsed];
        return labelText;
    };
    _citiesBarChart.labelMarginTop = 5.0;
    [_citiesBarChart setXLabels:@[@"北京",@"上海",@"广州",@"深圳",@"南京"]];
    [_citiesBarChart setYValues:@[@24,@12,@18,@10,@21]];
    [_citiesBarChart setStrokeColor:PNDeepGreen];
    _citiesBarChart.ifUseGradientColor = NO;
    // Adding gradient
    _citiesBarChart.barColorGradientStart = PNFreshGreen;
    
    [_citiesBarChart strokeChart];
    
    [self addSubview:_citiesBarChart];
}

- (void)addPagesAnalyticsView
{
    _realtimeTop5PagiesLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, -5 + _citiesBarChart.frame.origin.y +_citiesBarChart.frame.size.height, outlineViewWidth, 20)];
    _realtimeTop5PagiesLabel.text =@"TOP5页面:";
    _realtimeTop5PagiesLabel.textColor = PNDeepGrey;
    _realtimeTop5PagiesLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _realtimeTop5PagiesLabel.textAlignment = NSTextAlignmentLeft;

    _pagesBarChart = [[PNBarChart alloc] initWithFrame:CGRectMake(30, 0.0 + _realtimeTop5PagiesLabel.frame.origin.y + _realtimeTop5PagiesLabel.frame.size.height, outlineViewWidth - 40, outlineViewHeight/2)];
    _pagesBarChart.backgroundColor = [UIColor clearColor];
    _pagesBarChart.yLabelFormatter = ^(CGFloat yValue){
        CGFloat yValueParsed = yValue;
        NSString * labelText = [NSString stringWithFormat:@"%1.f",yValueParsed];
        return labelText;
    };
    _pagesBarChart.labelMarginTop = 5.0;
    [_pagesBarChart setXLabels:@[@"页面1",@"页面2",@"页面3",@"页面4",@"页面5"]];
    [_pagesBarChart setYValues:@[@15,@10,@20,@30,@11]];
    [_pagesBarChart setStrokeColor:[UIColor violetColor]];
    // Adding gradient
    _pagesBarChart.ifUseGradientColor = NO;

    _pagesBarChart.barColorGradientStart = [UIColor periwinkleColor];
    
    [_pagesBarChart strokeChart];
    
    [self addSubview:_pagesBarChart];
}


#pragma mark - relodData
- (void)relodData:(NSDictionary *)info
{
    _dealMoneyLabel.text =[NSString stringWithFormat:@"付款金额: %i",((NSNumber *)info[@"dealMoney"]).intValue];

    _arrayOfValues = (NSMutableArray *)info[@"arrayOfValues"];
    [_lineGraph reloadGraph];
    
    _groupUV = ((NSNumber *)info[@"groupUV"]).intValue;
    _validUVRatio = ((NSNumber *)info[@"validUVRatio"]).floatValue;
    _validGroupUV = ((NSNumber *)info[@"validGroupUV"]).intValue;
    
    _uvGroupLabel.text = [NSString stringWithFormat:@"UV: %i",_groupUV];
    _validGroupUVLabel.text =[NSString stringWithFormat:@"有效UV: %i",_validGroupUV];
    CGSize size = [_validGroupUVLabel.text sizeWithFont:_validGroupUVLabel.font];
    CGRect r = _validGroupUVLabel.frame;
    r.size.width = size.width;
    _validGroupUVLabel.frame = r;
    size = [_validGroupUVLabel.text sizeWithFont:_validGroupUVLabel.font];
    r = _uvGroupLabel.frame;
    r.size.width = size.width;
    _uvGroupLabel.frame = r;

    CGRect validUVLineRect = CGRectMake(0,5 + _uvGroupLabel.frame.origin.y+_uvGroupLabel.frame.size.height,(outlineViewWidth - 1)*_validUVRatio,30);
    CGRect UVLineRect = CGRectMake(1 + validUVLineRect.origin.x + validUVLineRect.size.width,validUVLineRect.origin.y,(outlineViewWidth - 1)*(1 - _validUVRatio),30);
    _validUVRatioLabel.text =[NSString stringWithFormat:@"%.1f%%",_validUVRatio * 100.0];

    CGRect validUVRatioLabelRect = _validUVRatioLabel.frame;
    _validUVRatioLabel.frame = validUVRatioLabelRect;
    validUVRatioLabelRect.origin.x = UVLineRect.origin.x - 1 - validUVRatioLabelRect.size.width - 5;
    
    if(CGRectIntersectsRect(_validGroupUVLabel.frame,validUVRatioLabelRect)){
        validUVRatioLabelRect.origin.x =  UVLineRect.origin.x + 5 ;
    }
    
    [UIView animateWithDuration:0.8
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _validUVLine.frame = validUVLineRect;
                         _UVLine.frame = UVLineRect;
                          _validUVRatioLabel.frame = validUVRatioLabelRect;
                   } completion:nil];
    
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

//- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
//    //    self.labelValues.text = [NSString stringWithFormat:@"%@", [self.ArrayOfValues objectAtIndex:index]];
//    //    self.labelDates.text = [NSString stringWithFormat:@"in %@", [self.ArrayOfDates objectAtIndex:index]];
//}
//
//- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
//    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        //        self.labelValues.alpha = 0.0;
//        //        self.labelDates.alpha = 0.0;
//    } completion:^(BOOL finished) {
//        //        self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSum] intValue]];
//        //        self.labelDates.text = [NSString stringWithFormat:@"between 2000 and %@", [self.ArrayOfDates lastObject]];
//        
//        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            //            self.labelValues.alpha = 1.0;
//            //            self.labelDates.alpha = 1.0;
//        } completion:nil];
//    }];
//}

//- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph {
//    //    self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSum] intValue]];
//    //    self.labelDates.text = [NSString stringWithFormat:@"between 2000 and %@", [self.ArrayOfDates lastObject]];
//}

#pragma mark - JBBarChartViewDataSource

- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView
{
    return kJBBarChartViewControllerNumBars;
}

- (void)barChartView:(JBBarChartView *)barChartView didSelectBarAtIndex:(NSUInteger)index touchPoint:(CGPoint)touchPoint
{
}

- (void)didDeselectBarChartView:(JBBarChartView *)barChartView
{
  
}

#pragma mark - JBBarChartViewDelegate

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtIndex:(NSUInteger)index
{
    if(barChartView == _barChartView1){
        return [[self.chartData1 objectAtIndex:index] floatValue];
    }else{
        return [[self.chartData objectAtIndex:index] floatValue];
    }
}

- (UIColor *)barChartView:(JBBarChartView *)barChartView colorForBarViewAtIndex:(NSUInteger)index
{
    if(barChartView == _barChartView1){
        return [UIColor indigoColor];
    }else{
        return PNDeepGreen;
    }
}

- (UIColor *)barSelectionColorForBarChartView:(JBBarChartView *)barChartView
{
    return [UIColor whiteColor];
}

- (CGFloat)barPaddingForBarChartView:(JBBarChartView *)barChartView
{
    return kJBBarChartViewControllerBarPadding;
}

- (void)initFakeData
{
    NSMutableArray *mutableChartData = [NSMutableArray array];
    for (int i=0; i<kJBBarChartViewControllerNumBars; i++)
    {
        NSInteger delta = (kJBBarChartViewControllerNumBars - abs((kJBBarChartViewControllerNumBars - i) - i)) + 2;
        [mutableChartData addObject:[NSNumber numberWithFloat:MAX((delta * kJBBarChartViewControllerMinBarHeight), arc4random() % (delta * kJBBarChartViewControllerMaxBarHeight))]];
        
    }
    _chartData = [NSArray arrayWithArray:mutableChartData];
    
    for (int i=0; i<kJBBarChartViewControllerNumBars; i++)
    {
        NSInteger delta = (kJBBarChartViewControllerNumBars - abs((kJBBarChartViewControllerNumBars - i) - i)) + 2;
        [mutableChartData addObject:[NSNumber numberWithFloat:MAX((delta * kJBBarChartViewControllerMinBarHeight/2), arc4random() % (delta * kJBBarChartViewControllerMaxBarHeight/2))]];
        
    }
    _chartData1 = [NSArray arrayWithArray:mutableChartData];
    _monthlySymbols = [[[NSDateFormatter alloc] init] shortMonthSymbols];
}



@end
