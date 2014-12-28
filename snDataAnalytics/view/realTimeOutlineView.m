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
#import "UIColor+BFPaperColors.h"

@interface realTimeOutlineView () <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@end

@implementation realTimeOutlineView
{
    UILabel *_chartLabel;
    UILabel *_realtimeVisitorGroupLabel;
    UILabel *_realtimeDealLabel;
    UILabel *_realtimeSourceLabel;
    UILabel *_realtimeCityLabel;
    UILabel *_realtimeTop5PagiesLabel;
    
//    LTMorphingLabel *_uvGroupLabel;
    UILabel *_uvGroupLabel;
    UILabel *_validGroupUVLabel;
    UILabel *_visitorGroupLabel;
    UIView  *_UVLine;
    UIView  *_validUVLine;
    UILabel *_validUVRatioLabel;
    
    UIView  *_newVISITLine;
    UIView  *_backVISITLine;
    UIView  *_newUVLine;
    UIView  *_backUVLine;
    UIView  *_newValidUVLine;
    UIView  *_backValidUVLine;
    
    UILabel *_visitRatioLabel;
    UILabel *_UVRatioLabel;
    float _lineWidth;
    UIColor *_newColor;
    UIColor *_backColor;


    UILabel *_dealMoneyLabel;
    UILabel *_validDealNumberLabel;
    UILabel *_validDealTransformRatioLabel;

    
    UILabel *_visitorRatioLabel;
    UILabel *_visitorLabel1;
    UILabel *_visitorLabel2;
    UILabel *_visitorLabel3;
    UILabel *_visitorLabel4;
    UILabel *_visitorLabel5;
    UILabel *_visitorLabel6;
    UIView  *_visitorColorDotView1;
    UIView  *_visitorColorDotView2;
    UIView  *_visitorColorDotView3;
    UIView  *_visitorColorDotView4;
    UIView  *_visitorColorDotView5;
    UIView  *_visitorColorDotView6;
    
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

- (instancetype)initWithFrame:(CGRect)frame withData:(NSDictionary *)data
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _lineWidth = outlineViewWidth/2 + 10.0;
        _newColor  = [UIColor colorWithRed:0x45/255.0 green:0xa7/255.0 blue:0xff/255.0 alpha:1];
        _backColor = PNLightGrey;
        
        _groupUV      = ((NSNumber *)data[@"groupUV"]).integerValue;
//        _validUVRatio = ((NSNumber *)data[@"validUVRatio"]).floatValue;
        _validGroupUV = ((NSNumber *)data[@"validGroupUV"]).integerValue;
        _VISITNumber  = ((NSNumber *)data[@"VISIT"]).integerValue;
        
        _newVISITRatio = ((NSNumber *)data[@"newVISITRatio"]).floatValue;
        _newUVRatio    = ((NSNumber *)data[@"newUVRatio"]).floatValue;
        _newVaildUVRatio = ((NSNumber *)data[@"newVaildUVRatio"]).floatValue;

        _dealMoney    = ((NSNumber *)data[@"dealMoney"]).integerValue;
        _arrayOfValues = (NSMutableArray *)data[@"arrayOfValues"];
        _arrayOfDates  = (NSMutableArray *)data[@"arrayOfDates"];
        _validDealNumber         = ((NSNumber *)data[@"validDealNumber"]).integerValue;
        _validDealTransformRatio = ((NSNumber *)data[@"validDealTransformRatio"]).floatValue;
        
        _sourceVisitArray      = (NSMutableArray *)data[@"sourceVisitArray"];
        _sourceValidUVArray = (NSMutableArray *)data[@"sourceValidUVArray"];
        _cityNameArray          = (NSMutableArray *)data[@"cityNameArray"];
        _cityValueArray         = (NSMutableArray *)data[@"cityValueArray"];
        _pagesNameArray         = (NSMutableArray *)data[@"pagesNameArray"];
        _pagesValueArray        = (NSMutableArray *)data[@"pagesValueArray"];
        
//        _sourceVisitArray = [[NSMutableArray alloc] initWithArray:@[@15,@30,@55,@23,@33,@40,@20]];
//        _sourceValidUVArray = [[NSMutableArray alloc] initWithArray:@[@7,@14,@25,@11,@15,@19,@9]];
        _groupColorArray = [[NSMutableArray alloc] initWithArray:@[
                                                                   PNLightGreen,
                                                                   PNFreshGreen,
                                                                   PNDeepGreen,
                                                                   [UIColor paperColorTeal],
                                                                   [UIColor paperColorCyan],
                                                                   [UIColor paperColorLightBlue]
                                                                   ]
                            ];
        
//        _validSourceUVColorArray = @[[UIColor robinEggColor],[UIColor pastelBlueColor],[UIColor turquoiseColor],[UIColor steelBlueColor],[UIColor denimColor],[UIColor emeraldColor],[UIColor cardTableColor]];

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
    if (_lineGraph) {
        _lineGraph.enableReferenceAxisLines = _lineGraph.enableReferenceAxisLines == NO ? YES : NO;
        _lineGraph.enableYAxisLabel = _lineGraph.enableYAxisLabel == NO ? YES : NO;
        _lineGraph.colorXaxisLabel = (_lineGraph.colorXaxisLabel == [UIColor grayColor]) ? [UIColor clearColor] : [UIColor grayColor];

        [_lineGraph reloadGraph];
    }
    if (_vaildSourceBarChart) {
       _vaildSourceBarChart.showChartBorder = _vaildSourceBarChart.showReferenceLines = _vaildSourceBarChart.showReferenceLines == NO ? YES : NO;
        [_vaildSourceBarChart strokeChart];
    }
    if (_citiesBarChart) {
        _citiesBarChart.showChartBorder =_citiesBarChart.showReferenceLines = _citiesBarChart.showReferenceLines == NO ? YES : NO;
        [_citiesBarChart strokeChart];
    }
    if (_pagesBarChart) {
        _pagesBarChart.showChartBorder = _pagesBarChart.showReferenceLines = _pagesBarChart.showReferenceLines == NO ? YES : NO;
        [_pagesBarChart strokeChart];
    }
}

- (void)addvisitorGroupAnalyticsView
{
    _realtimeVisitorGroupLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 2.5 + _chartLabel.frame.origin.y +_chartLabel.frame.size.height, outlineViewWidth/2, 20)];
    _realtimeVisitorGroupLabel.text =@"访客群体分析:";
    _realtimeVisitorGroupLabel.textColor = PNDeepGrey;
    _realtimeVisitorGroupLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _realtimeVisitorGroupLabel.textAlignment = NSTextAlignmentLeft;
    CGSize size = [_realtimeVisitorGroupLabel.text sizeWithFont:_realtimeVisitorGroupLabel.font];
    CGRect r = _realtimeVisitorGroupLabel.frame;
    r.size.width = size.width;
    _realtimeVisitorGroupLabel.frame = r;

    UIView *backgroudLineView = [[UIView alloc] initWithFrame:CGRectMake(0,_chartLabel.frame.origin.y +_chartLabel.frame.size.height, outlineViewWidth, 25)];
    backgroudLineView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    
    [self addSubview:backgroudLineView];
    [self addSubview:_realtimeVisitorGroupLabel];
    
    
    
    
    _visitorGroupLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 10 + _realtimeVisitorGroupLabel.frame.origin.y +_realtimeVisitorGroupLabel.frame.size.height, outlineViewWidth/2 - 20, 30)];
    _visitorGroupLabel.text = [NSString stringWithFormat:@"VISIT: %li",_VISITNumber];
    _visitorGroupLabel.textColor = PNDeepGrey;
    _visitorGroupLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _visitorGroupLabel.textAlignment = NSTextAlignmentLeft;
    
    _newVISITLine = [[UIView alloc] initWithFrame:CGRectMake(_lineWidth - 30.0,12.5 + _realtimeVisitorGroupLabel.frame.origin.y +_realtimeVisitorGroupLabel.frame.size.height,(_lineWidth - 1) * _newVISITRatio,25)];
    _newVISITLine.backgroundColor = _newColor;
    _backVISITLine = [[UIView alloc] initWithFrame:CGRectMake(1 + _newVISITLine.frame.origin.x+_newVISITLine.frame.size.width,_newVISITLine.frame.origin.y,(_lineWidth - 1) * (1 - _newVISITRatio),25)];
    _backVISITLine.backgroundColor = _backColor;
    
    _uvGroupLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,7.5 + _visitorGroupLabel.frame.origin.y +_visitorGroupLabel.frame.size.height, outlineViewWidth/2 - 20, 30)];
    _uvGroupLabel.text =[NSString stringWithFormat:@"UV: %li",_groupUV];
    _uvGroupLabel.textColor = PNDeepGrey;
    _uvGroupLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _uvGroupLabel.textAlignment = NSTextAlignmentLeft;
    
    _newUVLine = [[UIView alloc] initWithFrame:CGRectMake(_lineWidth - 30.0,10 + _visitorGroupLabel.frame.origin.y +_visitorGroupLabel.frame.size.height,(_lineWidth - 1) * _newUVRatio,25)];
    _newUVLine.backgroundColor = _newColor;
    _backUVLine = [[UIView alloc] initWithFrame:CGRectMake(1 + _newUVLine.frame.origin.x+_newUVLine.frame.size.width,_newUVLine.frame.origin.y,(_lineWidth - 1) * (1 - _newUVRatio),25)];
    _backUVLine.backgroundColor = _backColor;
    
    _validGroupUVLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 7.5 + _uvGroupLabel.frame.origin.y +_uvGroupLabel.frame.size.height, outlineViewWidth/2 - 20, 30)];
    _validGroupUVLabel.text =[NSString stringWithFormat:@"有效UV: %li",_validGroupUV];
    _validGroupUVLabel.textColor = PNDeepGrey;
    _validGroupUVLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _validGroupUVLabel.textAlignment = NSTextAlignmentLeft;
    
    _newValidUVLine = [[UIView alloc] initWithFrame:CGRectMake(_lineWidth - 30.0,10.0 + _uvGroupLabel.frame.origin.y +_uvGroupLabel.frame.size.height,(_lineWidth - 1) * _newVaildUVRatio,25)];
    _newValidUVLine.backgroundColor = _newColor;
    _backValidUVLine = [[UIView alloc] initWithFrame:CGRectMake(1 + _newValidUVLine.frame.origin.x + _newValidUVLine.frame.size.width,_newValidUVLine.frame.origin.y,(_lineWidth - 1) * (1 - _newVaildUVRatio),25)];
    _backValidUVLine.backgroundColor = _backColor;
    
    UILabel *tipNewLabel  = [[UILabel alloc] initWithFrame:CGRectMake(outlineViewWidth/7,5 + _validGroupUVLabel.frame.origin.y +_validGroupUVLabel.frame.size.height, outlineViewWidth/5, 30)];
    tipNewLabel.text = @"新访客";
    tipNewLabel.textColor = PNDeepGrey;
    tipNewLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    tipNewLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *tipNewView = [[UIView alloc] initWithFrame:CGRectMake(3.0 + tipNewLabel.frame.origin.x +tipNewLabel.frame.size.width,12.5 + _validGroupUVLabel.frame.origin.y +_validGroupUVLabel.frame.size.height, 15, 15)];
    tipNewView.backgroundColor = _newColor;
    tipNewView.layer.cornerRadius = 7.5;
    
    UILabel *tipBackLabel  = [[UILabel alloc] initWithFrame:CGRectMake(outlineViewWidth/2 + 5.0,5 + _validGroupUVLabel.frame.origin.y +_validGroupUVLabel.frame.size.height, outlineViewWidth/5, 30)];
    tipBackLabel.text = @"回访客";
    tipBackLabel.textColor = PNDeepGrey;
    tipBackLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    tipBackLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *tipBackView = [[UIView alloc] initWithFrame:CGRectMake(3.0 + tipBackLabel.frame.origin.x +tipBackLabel.frame.size.width,12.5 + _validGroupUVLabel.frame.origin.y +_validGroupUVLabel.frame.size.height,15, 15)];
    tipBackView.backgroundColor = _backColor;
    tipBackView.layer.cornerRadius = 7.5;
    
    _visitRatioLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,_newVISITLine.frame.origin.y, outlineViewWidth/4, 25)];
    _visitRatioLabel.text =[NSString stringWithFormat:@"%.1f%%",_newVISITRatio * 100.0];
    _visitRatioLabel.textColor = PNDeepGrey;
    _visitRatioLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:20.0];
    _visitRatioLabel.textAlignment = NSTextAlignmentRight;
    r = _visitRatioLabel.frame;
    size = [_visitRatioLabel.text sizeWithFont:_visitRatioLabel.font];
    r.size.width = size.width;
    r.origin.x = _backVISITLine.frame.origin.x - 1 - r.size.width - 5;
    if (r.origin.x < _newVISITLine.frame.origin.x) {
        r.origin.x =  _backVISITLine.frame.origin.x + 5 ;
    }
    _visitRatioLabel.frame = r;
    
    _UVRatioLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,_newUVLine.frame.origin.y, outlineViewWidth/4, 25)];
    _UVRatioLabel.text =[NSString stringWithFormat:@"%.1f%%",_newUVRatio * 100.0];
    _UVRatioLabel.textColor = PNDeepGrey;
    _UVRatioLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:20.0];
    _UVRatioLabel.textAlignment = NSTextAlignmentRight;
    r = _UVRatioLabel.frame;
    size = [_UVRatioLabel.text sizeWithFont:_UVRatioLabel.font];
    r.size.width = size.width;
    r.origin.x = _backUVLine.frame.origin.x - 1 - r.size.width - 5;
    if (r.origin.x < _newUVLine.frame.origin.x) {
        r.origin.x =  _backUVLine.frame.origin.x + 5 ;
    }
    _UVRatioLabel.frame = r;

    
    _validUVRatioLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,_newValidUVLine.frame.origin.y, outlineViewWidth/4, 25)];
    _validUVRatioLabel.text =[NSString stringWithFormat:@"%.1f%%",_newVaildUVRatio * 100.0];
    _validUVRatioLabel.textColor = PNDeepGrey;
    _validUVRatioLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:20.0];
    _validUVRatioLabel.textAlignment = NSTextAlignmentRight;
    r = _validUVRatioLabel.frame;
    size = [_validUVRatioLabel.text sizeWithFont:_validUVRatioLabel.font];
    r.size.width = size.width;
    r.origin.x = _backValidUVLine.frame.origin.x - 1 - r.size.width - 5;
    if (r.origin.x < _newValidUVLine.frame.origin.x) {
        r.origin.x =  _backValidUVLine.frame.origin.x + 5 ;
    }
    _validUVRatioLabel.frame = r;

    //    center = _visitRatioLabel.center;
    //    center.y = _UVLine.center.y;
    //    _visitRatioLabel.center = center;
    
    //    CGPoint center = tipNewLabel.center;
    //    center.x = outlineViewWidth/4;
    //    tipNewLabel.center = center;
    //
    //    center = tipNewView.center;
    //    center.x = outlineViewWidth/4 + 50;
    //    tipNewView.center = center;
    //
    //    center = tipBackLabel.c                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           enter;
    //    center.x = 3 * outlineViewWidth/4;
    //    tipNewLabel.center = center;
    //
    //    center = tipNewView.center;
    //    center.x = outlineViewWidth/4 + 50;
    //    tipNewView.center = center;
    
    [self addSubview:_chartLabel];
    
    [self addSubview:_visitorGroupLabel];
    [self addSubview:_newVISITLine];
    [self addSubview:_backVISITLine];
    [self addSubview:_visitRatioLabel];
    
    [self addSubview:_uvGroupLabel];
    [self addSubview:_newUVLine];
    [self addSubview:_backUVLine];
    [self addSubview:_UVRatioLabel];
    
    [self addSubview:_validGroupUVLabel];
    [self addSubview:_newValidUVLine];
    [self addSubview:_backValidUVLine];
    [self addSubview:_validUVRatioLabel];
    
    [self addSubview:tipNewLabel];
    [self addSubview:tipNewView];
    [self addSubview:tipBackLabel];
    [self addSubview:tipBackView];

    
    
    
    
/*
    _uvGroupLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10 + _realtimeVisitorGroupLabel.frame.origin.y +_realtimeVisitorGroupLabel.frame.size.height, outlineViewWidth/2, 20)];
    _uvGroupLabel.text = [NSString stringWithFormat:@"UV:%i",_groupUV];
    _uvGroupLabel.textColor = PNDeepGrey;
    _uvGroupLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _uvGroupLabel.textAlignment = NSTextAlignmentLeft;
    size = [_uvGroupLabel.text sizeWithFont:_uvGroupLabel.font];
    r = _uvGroupLabel.frame;
    r.size.width = size.width;
    _uvGroupLabel.frame = r;
//    _uvGroupLabel.morphingDuration = 0.07f;
    
    _visitorGroupLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _uvGroupLabel.frame.origin.y, outlineViewWidth/2, 20)];
    _visitorGroupLabel.text =[NSString stringWithFormat:@"VISIT: %i",_VISITNumber];
    _visitorGroupLabel.textColor = PNDeepGrey;
    _visitorGroupLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _visitorGroupLabel.textAlignment = NSTextAlignmentRight;
    size = [_visitorGroupLabel.text sizeWithFont:_visitorGroupLabel.font];
    r = _visitorGroupLabel.frame;
    r.size.width = size.width + 20;
    r.origin.x = outlineViewWidth - size.width - 45;
    _visitorGroupLabel.frame = r;
    
    _validUVLine = [[UIView alloc] initWithFrame:CGRectMake(2,5 + _uvGroupLabel.frame.origin.y+_uvGroupLabel.frame.size.height,(outlineViewWidth - 5)*_validUVRatio,30)];
    _validUVLine.backgroundColor = PNDeepGreen;
    _UVLine = [[UIView alloc] initWithFrame:CGRectMake(1+_validUVLine.frame.origin.x+_validUVLine.frame.size.width,_validUVLine.frame.origin.y,(outlineViewWidth - 5)*(1 - _validUVRatio),30)];
    _UVLine.backgroundColor = PNLightGreen;
    
    _validGroupUVLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,3 + _uvGroupLabel.frame.origin.y + _uvGroupLabel.frame.size.height, outlineViewWidth/2 , 30)];
    float ratio = _validUVRatio * 100.0;
    _validGroupUVLabel.text =[NSString stringWithFormat:@"有效UV: %i",_validGroupUV];
    _validGroupUVLabel.textColor = PNDeepGrey;
    _validGroupUVLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _validGroupUVLabel.textAlignment = NSTextAlignmentLeft;
    size = [_validGroupUVLabel.text sizeWithFont:_validGroupUVLabel.font];
    r = _validGroupUVLabel.frame;
    r.size.width = size.width + 15;
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
    if (CGRectIntersectsRect(_validGroupUVLabel.frame,_validUVRatioLabel.frame)) {
        r.origin.x =  _UVLine.frame.origin.x + 5 ;
        _validUVRatioLabel.frame = r;
    }
    
    [self addSubview:backgroudLineView];
    [self addSubview:_realtimeVisitorGroupLabel];
//    [self addSubview:_UVLine];
//    [self addSubview:_validUVLine];
//    [self addSubview:_validUVRatioLabel];
//    [self addSubview:_validGroupUVLabel];
//    [self addSubview:_uvGroupLabel];
//    [self addSubview:_visitorGroupLabel];
    */
}

- (void)addDealView
{
    //    成交
//    _realtimeDealLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 2.5 + _UVLine.frame.origin.y +_UVLine.frame.size.height, outlineViewWidth/2, 20)];
    _realtimeDealLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 2.5 + 10 + _validGroupUVLabel.frame.origin.y +_validGroupUVLabel.frame.size.height + 30, outlineViewWidth/2, 20)];

    _realtimeDealLabel.text =@"成交:";
    _realtimeDealLabel.textColor = PNDeepGrey;
    _realtimeDealLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _realtimeDealLabel.textAlignment = NSTextAlignmentLeft;
    CGSize size = [_realtimeDealLabel.text sizeWithFont:_realtimeDealLabel.font];
    CGRect r = _realtimeDealLabel.frame;
    r.size.width = size.width;
    _realtimeDealLabel.frame = r;
    
//    UIView *backgroudLineView = [[UIView alloc] initWithFrame:CGRectMake(0, _UVLine.frame.origin.y +_UVLine.frame.size.height, outlineViewWidth, 25)];
    UIView *backgroudLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 10 + _validGroupUVLabel.frame.origin.y +_validGroupUVLabel.frame.size.height + 30, outlineViewWidth, 25)];

    backgroudLineView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    
    _dealMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10 + _realtimeDealLabel.frame.origin.y +_realtimeDealLabel.frame.size.height, outlineViewWidth, 20)];
    _dealMoneyLabel.text =[NSString stringWithFormat:@"付款金额: %li",_dealMoney];
    _dealMoneyLabel.textColor = PNDeepGrey;
    _dealMoneyLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _dealMoneyLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel *dealMoneyTip = [[UILabel alloc] initWithFrame:CGRectMake( outlineViewWidth / 2 + 40.0, _dealMoneyLabel.frame.origin.y , outlineViewWidth/3, 20)];
    dealMoneyTip.text = @"付款变化趋势图如下";
    dealMoneyTip.textColor = [UIColor fadedBlueColor];
    dealMoneyTip.font = [UIFont fontWithName:@"Avenir-Medium" size:10.0];
    dealMoneyTip.textAlignment = NSTextAlignmentRight;

//    _dealMoneyLabel.morphingDuration = 0.07f;
    
//    _arrayOfValues = [[NSMutableArray alloc] init];
//    _arrayOfDates = [[NSMutableArray alloc] init];
//    
//    for (int i = 0; i < 20; i++) {
//        [_arrayOfValues addObject:[NSNumber numberWithInteger:(arc4random() % 100)]]; // Random values for the graph
//        [_arrayOfDates addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:i]]]; // Dates for the X-Axis of the graph
//        
//    }
    
    _lineGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 5.0+_dealMoneyLabel.frame.origin.y +_dealMoneyLabel.frame.size.height, outlineViewWidth, 60.0)];
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
    _lineGraph.enableYAxisLabel  = NO;
    _lineGraph.autoScaleYAxis    = YES;
    _lineGraph.alwaysDisplayDots = NO;
    _lineGraph.enableReferenceAxisLines = NO;
    _lineGraph.enableReferenceAxisFrame = NO;
    _lineGraph.animationGraphStyle = BEMLineAnimationDraw;
    
    _lineGraph.colorTop = [UIColor whiteColor];
    _lineGraph.colorBottom = [UIColor whiteColor];
    //            self.myGraph.backgroundColor = [UIColor whiteColor];
    self.tintColor = [UIColor whiteColor];
    
    _validDealNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, -15 + _lineGraph.frame.origin.y +_lineGraph.frame.size.height, outlineViewWidth/2, 20)];
    _validDealNumberLabel.text =[NSString stringWithFormat:@"有效订单数: %li",_validDealNumber];
    _validDealNumberLabel.textColor = PNDeepGrey;
    _validDealNumberLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _validDealNumberLabel.textAlignment = NSTextAlignmentLeft;
    r = _validDealNumberLabel.frame;
    size = [_validDealNumberLabel.text sizeWithFont:_validDealNumberLabel.font];
    r.size.width = size.width + 20;
    _validDealNumberLabel.frame = r;
    
    _validDealTransformRatioLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 + _validDealNumberLabel.frame.origin.x +_validDealNumberLabel.frame.size.width, _validDealNumberLabel.frame.origin.y, outlineViewWidth/2, 20)];
    _validDealTransformRatioLabel.text =[NSString stringWithFormat:@"转化率: %.1f%%",_validDealTransformRatio];
    _validDealTransformRatioLabel.textColor = PNDeepGrey;
    _validDealTransformRatioLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _validDealTransformRatioLabel.textAlignment = NSTextAlignmentLeft;
    r = _validDealTransformRatioLabel.frame;
    size = [_validDealTransformRatioLabel.text sizeWithFont:_validDealTransformRatioLabel.font];
    r.size.width = size.width;
    r.origin.x = outlineViewWidth - size.width - 20;
    _validDealTransformRatioLabel.frame = r;
    
    [self addSubview:backgroudLineView];
    [self addSubview:_realtimeDealLabel];
    [self addSubview:_dealMoneyLabel];
    [self addSubview:dealMoneyTip];
    [self addSubview:_lineGraph];
    [self addSubview:_validDealNumberLabel];
    [self addSubview:_validDealTransformRatioLabel];
}

- (void)addSourceView
{
    //    来源渠道
    
    _realtimeSourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5.0 + _validDealTransformRatioLabel.frame.origin.y +_validDealTransformRatioLabel.frame.size.height, outlineViewWidth/2, 20)];
    _realtimeSourceLabel.text =@"来源分析:";
    _realtimeSourceLabel.textColor = PNDeepGrey;
    _realtimeSourceLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _realtimeSourceLabel.textAlignment = NSTextAlignmentLeft;
    CGSize size = [_realtimeSourceLabel.text sizeWithFont:_realtimeSourceLabel.font];
    CGRect r = _realtimeSourceLabel.frame;
    r.size.width = size.width;
    _realtimeSourceLabel.frame = r;
    
    UIView *backgroudLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 2.5 +_validDealTransformRatioLabel.frame.origin.y +_validDealTransformRatioLabel.frame.size.height, outlineViewWidth, 25)];
    backgroudLineView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];

    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:((NSNumber *)_sourceVisitArray[0]).floatValue color:_groupColorArray[0]],
                       [PNPieChartDataItem dataItemWithValue:((NSNumber *)_sourceVisitArray[1]).floatValue color:_groupColorArray[1]],
                       [PNPieChartDataItem dataItemWithValue:((NSNumber *)_sourceVisitArray[2]).floatValue color:_groupColorArray[2]],
                       [PNPieChartDataItem dataItemWithValue:((NSNumber *)_sourceVisitArray[3]).floatValue color:_groupColorArray[3]],
                       [PNPieChartDataItem dataItemWithValue:((NSNumber *)_sourceVisitArray[4]).floatValue color:_groupColorArray[4]],
                       [PNPieChartDataItem dataItemWithValue:((NSNumber *)_sourceVisitArray[5]).floatValue color:_groupColorArray[5]],
                       ];
    
    
    _visitorRatioLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10 + _realtimeSourceLabel.frame.origin.y +_realtimeSourceLabel.frame.size.height, outlineViewWidth, 20)];
    _visitorRatioLabel.text =@"VISIT占比:";
    _visitorRatioLabel.textColor = PNDeepGrey;
    _visitorRatioLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _visitorRatioLabel.textAlignment = NSTextAlignmentLeft;
    r = _visitorRatioLabel.frame;
    size = [_visitorRatioLabel.text sizeWithFont:_visitorRatioLabel.font];
    r.size.width = size.width;
    _visitorRatioLabel.frame = r;
    
    float pieWidth = 110.0;
    _visitorPieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(85.0 + _visitorRatioLabel.frame.origin.x + _visitorRatioLabel.frame.size.width, _visitorRatioLabel.frame.origin.y - 5.0 ,pieWidth, pieWidth) items:items];
    _visitorPieChart.descriptionTextColor = [UIColor whiteColor];
    _visitorPieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:12.0];
    _visitorPieChart.descriptionTextShadowColor = [UIColor clearColor];
    [_visitorPieChart strokeChart];
    
    //iPhone6P
    if(outlineViewWidth > 400){
        CGPoint center = _visitorPieChart.center;
        center.x += 50;
        _visitorPieChart.center = center;
    }
    
    float originDotViewX = 35.0/*5 + _visitorPieChart.frame.origin.x + pieWidth*/;
    
    _visitorColorDotView1 = [[UIView alloc] init];
    _visitorColorDotView2 = [[UIView alloc] init];
    _visitorColorDotView3 = [[UIView alloc] init];
    _visitorColorDotView4 = [[UIView alloc] init];
    _visitorColorDotView5 = [[UIView alloc] init];
    _visitorColorDotView6 = [[UIView alloc] init];
    _visitorColorDotViewArray = @[_visitorColorDotView1,_visitorColorDotView2,_visitorColorDotView3,_visitorColorDotView4,_visitorColorDotView5,_visitorColorDotView6];
    
    [_visitorColorDotViewArray enumerateObjectsUsingBlock:^(UIView *dotView, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
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
    _visitorLabel4 = [[UILabel alloc] init];
    _visitorLabel5 = [[UILabel alloc] init];
    _visitorLabel6 = [[UILabel alloc] init];
    
    _visitorLabelArray = @[_visitorLabel1,_visitorLabel2,_visitorLabel3,_visitorLabel4,_visitorLabel5,_visitorLabel6];
    
    [_visitorLabelArray enumerateObjectsUsingBlock:^(UILabel *labelView, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            labelView.frame = CGRectMake(originX,  5 + _visitorRatioLabel.frame.origin.y + _visitorRatioLabel.frame.size.height, outlineViewWidth/7, 15);
        }else if(idx == 1 || idx == 2){
            labelView.frame = CGRectMake(originX, 3 + ((UILabel *)(_visitorLabelArray[idx - 1])).frame.origin.y + _visitorLabel1.frame.size.height, outlineViewWidth/7, 15);
        }else if(idx == 3){
            labelView.frame = CGRectMake(((UILabel *)(_visitorLabelArray[0])).frame.origin.x + _visitorLabel1.frame.size.width + 10.0, 5 + _visitorRatioLabel.frame.origin.y + _visitorRatioLabel.frame.size.height, outlineViewWidth/5, 15);
        }else{
            labelView.frame = CGRectMake(((UILabel *)(_visitorLabelArray[idx - 1])).frame.origin.x, 3 + ((UILabel *)(_visitorLabelArray[idx - 1])).frame.origin.y + _visitorLabel1.frame.size.height, outlineViewWidth/5, 15);
        }
        labelView.text = _sourcesStringArray[idx];
        labelView.textColor = (UIColor *)_groupColorArray[idx];
        labelView.font = [UIFont fontWithName:@"Avenir-Medium" size:13.0];
        labelView.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview: labelView];
        
        ((UIView *)_visitorColorDotViewArray[idx]).center = CGPointMake(labelView.frame.origin.x - 8.0, labelView.center.y);
        
    }];
    
    _validUVSourceRatioLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, -20.0 + _visitorPieChart.frame.origin.y +_visitorPieChart.frame.size.height, outlineViewWidth, 20)];
    _validUVSourceRatioLabel.text =@"有效UV占比:";
    _validUVSourceRatioLabel.textColor = PNDeepGrey;
    _validUVSourceRatioLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _validUVSourceRatioLabel.textAlignment = NSTextAlignmentLeft;
    
    
    _vaildSourceBarChart = [[PNBarChart alloc] initWithFrame:CGRectMake(10,3+ _validUVSourceRatioLabel.frame.origin.y + _validUVSourceRatioLabel.frame.size.height, outlineViewWidth, outlineViewHeight/2)];
    _vaildSourceBarChart.backgroundColor = [UIColor clearColor];
    _vaildSourceBarChart.yLabelFormatter = ^(CGFloat yValue) {
        CGFloat yValueParsed = yValue;
        NSString * labelText = [NSString stringWithFormat:@"%1.f",yValueParsed];
        return labelText;
    };
    _vaildSourceBarChart.labelMarginTop = 5.0;
    _vaildSourceBarChart.yLabelSum = 5;
    [_vaildSourceBarChart setXLabels:_sourcesStringArray];
    [_vaildSourceBarChart setYValues:_sourceVisitArray];
    [_vaildSourceBarChart setYValues1:_sourceValidUVArray];
    _vaildSourceBarChart.labelFont = [UIFont fontWithName:@"OpenSans-Light" size:10.0];
//    [_vaildSourceBarChart setStrokeColor:[UIColor colorWithRed:0x6a/255.0 green:0xb9/255.0 blue:0xff/255.0 alpha:1.0]/*[UIColor colorWithRed:0x45/255.0 green:0xa7/255.0 blue:0xff/255.0 alpha:1]*/];
    [_vaildSourceBarChart setStrokeColor: [UIColor paperColorLightBlue]];
    // Adding gradient
    _vaildSourceBarChart.barColorGradientStart = PNDeepGreen;

    [_vaildSourceBarChart setStrokeColor1:[UIColor indigoColor]];

    _vaildSourceBarChart.ifUseGradientColor = YES;
    _vaildSourceBarChart.showChartBorder    = NO;
    _vaildSourceBarChart.showReferenceLines = NO;
    
    // Adding gradient
    _vaildSourceBarChart.barWidth = 20.0;
    
    [_vaildSourceBarChart strokeChart];
    
    [self addSubview:backgroudLineView];
    [self addSubview:_realtimeSourceLabel];
    [self addSubview:_visitorRatioLabel];
    [self addSubview:_visitorPieChart];
    [self addSubview:_validUVSourceRatioLabel];
    [self addSubview:_vaildSourceBarChart];

}

- (void)addCitiesAnalyticsView
{
//    _realtimeCityLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, -5 + _barChartView2.frame.origin.y + _barChartView2.frame.size.height, outlineViewWidth, 20)];
    _realtimeCityLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, -7.5 + _vaildSourceBarChart.frame.origin.y + _vaildSourceBarChart.frame.size.height, outlineViewWidth, 20)];

    _realtimeCityLabel.text =@"城市分布:";
    _realtimeCityLabel.textColor = PNDeepGrey;
    _realtimeCityLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _realtimeCityLabel.textAlignment = NSTextAlignmentLeft;
    
    UIView *backgroudLineView = [[UIView alloc] initWithFrame:CGRectMake(0,-10 + _vaildSourceBarChart.frame.origin.y + _vaildSourceBarChart.frame.size.height, outlineViewWidth, 25)];
    backgroudLineView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    
    _citiesBarChart = [[PNBarChart alloc] initWithFrame:CGRectMake(30, 5.0 + _realtimeCityLabel.frame.origin.y + _realtimeCityLabel.frame.size.height, outlineViewWidth - 40, outlineViewHeight/2)];
    _citiesBarChart.backgroundColor = [UIColor clearColor];
    _citiesBarChart.yLabelFormatter = ^(CGFloat yValue) {
        CGFloat yValueParsed = yValue;
        NSString * labelText = [NSString stringWithFormat:@"%i",(int)yValueParsed];
        return labelText;
    };
    _citiesBarChart.labelMarginTop = 5.0;
    _citiesBarChart.yChartLabelWidth = 20;
    [_citiesBarChart setXLabels:_cityNameArray];
    [_citiesBarChart setYValues:_cityValueArray];
    [_citiesBarChart setStrokeColor:PNDeepGreen];
    _citiesBarChart.ifUseGradientColor = NO;
    // Adding gradient
    _citiesBarChart.barColorGradientStart = PNFreshGreen;
    
    [_citiesBarChart strokeChart];
    
    [self addSubview:backgroudLineView];
    [self addSubview:_realtimeCityLabel];
    [self addSubview:_citiesBarChart];
}

- (void)addPagesAnalyticsView
{
    _realtimeTop5PagiesLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, -7.5 + _citiesBarChart.frame.origin.y +_citiesBarChart.frame.size.height, outlineViewWidth, 20)];
    _realtimeTop5PagiesLabel.text =@"TOP5页面:";
    _realtimeTop5PagiesLabel.textColor = PNDeepGrey;
    _realtimeTop5PagiesLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _realtimeTop5PagiesLabel.textAlignment = NSTextAlignmentLeft;

    UIView *backgroudLineView = [[UIView alloc] initWithFrame:CGRectMake(0,-10 +_citiesBarChart.frame.origin.y +_citiesBarChart.frame.size.height, outlineViewWidth, 25)];
    backgroudLineView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    
    _pagesBarChart = [[PNBarChart alloc] initWithFrame:CGRectMake(30, 5.0 + _realtimeTop5PagiesLabel.frame.origin.y + _realtimeTop5PagiesLabel.frame.size.height, outlineViewWidth - 40, outlineViewHeight/2)];
    _pagesBarChart.backgroundColor = [UIColor clearColor];
    _pagesBarChart.yLabelFormatter = ^(CGFloat yValue) {
        CGFloat yValueParsed = yValue;
        NSString * labelText = [NSString stringWithFormat:@"%i",(int)yValueParsed];
        return labelText;
    };

    _pagesBarChart.yChartLabelWidth = 20;
    _pagesBarChart.labelMarginTop = 5.0;
    _pagesBarChart.labelLineNumber = 2;
    [_pagesBarChart setXLabels:_pagesNameArray];
    [_pagesBarChart setYValues:_pagesValueArray];
    [_pagesBarChart setStrokeColor:[UIColor violetColor]];
    // Adding gradient
    _pagesBarChart.ifUseGradientColor = NO;

    _pagesBarChart.barColorGradientStart = [UIColor periwinkleColor];
    
    [_pagesBarChart strokeChart];
    
    [self addSubview:backgroudLineView];
    [self addSubview:_realtimeTop5PagiesLabel];
    [self addSubview:_pagesBarChart];
}


#pragma mark - relodData
- (void)relodData:(NSDictionary *)data
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
    @autoreleasepool {
            _arrayOfValues = (NSMutableArray *)data[@"arrayOfValues"];
            _groupUV       = ((NSNumber *)data[@"groupUV"]).integerValue;
//            _validUVRatio  = ((NSNumber *)data[@"validUVRatio"]).floatValue;
            _validGroupUV  = ((NSNumber *)data[@"validGroupUV"]).integerValue;
            _VISITNumber   = ((NSNumber *)data[@"VISIT"]).integerValue;
            _newVISITRatio = ((NSNumber *)data[@"newVISITRatio"]).floatValue;
            _newUVRatio    = ((NSNumber *)data[@"newUVRatio"]).floatValue;
            _newVaildUVRatio = ((NSNumber *)data[@"newVaildUVRatio"]).floatValue;
            
            _dealMoney     = ((NSNumber *)data[@"dealMoney"]).integerValue;
            _validDealNumber         = ((NSNumber *)data[@"validDealNumber"]).integerValue;
            _validDealTransformRatio = ((NSNumber *)data[@"validDealTransformRatio"]).floatValue;
            _cityNameArray          = (NSMutableArray *)data[@"cityNameArray"];
            _cityValueArray         = (NSMutableArray *)data[@"cityValueArray"];
            _pagesNameArray         = (NSMutableArray *)data[@"pagesNameArray"];
            _pagesValueArray        = (NSMutableArray *)data[@"pagesValueArray"];
            
    //        _validGroupUVLabel.text =[NSString stringWithFormat:@"有效UV: %i",_validGroupUV];
            
            CGSize size = [_validGroupUVLabel.text sizeWithFont:_validGroupUVLabel.font];
            CGRect r = _validGroupUVLabel.frame;
            r.size.width = size.width + 15.0;
            _validGroupUVLabel.frame = r;
            size = [_validGroupUVLabel.text sizeWithFont:_validGroupUVLabel.font];
            r = _uvGroupLabel.frame;
            r.size.width = size.width;
            _uvGroupLabel.frame = r;
            
//            CGRect validUVLineRect = CGRectMake(2,5 + _uvGroupLabel.frame.origin.y+_uvGroupLabel.frame.size.height,(outlineViewWidth - 5)*_validUVRatio,30);
//            CGRect UVLineRect = CGRectMake(1 + validUVLineRect.origin.x + validUVLineRect.size.width,validUVLineRect.origin.y,(outlineViewWidth - 5)*(1 - _validUVRatio),30);
//            
//            CGRect validUVRatioLabelRect = _validUVRatioLabel.frame;
//            _validUVRatioLabel.frame = validUVRatioLabelRect;
//            validUVRatioLabelRect.origin.x = UVLineRect.origin.x - 1 - validUVRatioLabelRect.size.width - 5;
//            
//            if (CGRectIntersectsRect(_validGroupUVLabel.frame,validUVRatioLabelRect)) {
//                validUVRatioLabelRect.origin.x =  UVLineRect.origin.x + 5 ;
//            }
        
        
            CGRect newVISITLine = CGRectMake(_lineWidth - 30.0,12.5 + _realtimeVisitorGroupLabel.frame.origin.y +_realtimeVisitorGroupLabel.frame.size.height,(_lineWidth - 1)*_newVISITRatio,25);
            CGRect backVISITLine = CGRectMake(1 + newVISITLine.origin.x + newVISITLine.size.width,newVISITLine.origin.y,(_lineWidth - 1)*(1 - _newVISITRatio),25);
            
            CGRect newUVLine = CGRectMake(_lineWidth - 30.0,10 + _visitorGroupLabel.frame.origin.y +_visitorGroupLabel.frame.size.height,(_lineWidth - 1) * _newUVRatio,25);
            CGRect backUVLine = CGRectMake(1 + newUVLine.origin.x +newUVLine.size.width,newUVLine.origin.y,(_lineWidth - 1)*(1 - _newUVRatio),25);
            
            CGRect newValidUVLine = CGRectMake(_lineWidth - 30.0,10 + _uvGroupLabel.frame.origin.y +_uvGroupLabel.frame.size.height,(_lineWidth - 1) * _newVaildUVRatio,25);
            CGRect backValidUVLine = CGRectMake(1 + newValidUVLine.origin.x + newValidUVLine.size.width,newValidUVLine.origin.y,(_lineWidth - 1)*(1 - _newVaildUVRatio),25);

            CGRect visitRatioLabelRect = _visitRatioLabel.frame;
            CGSize visitRatioLabelsize = [_visitRatioLabel.text sizeWithFont:_visitRatioLabel.font];
            visitRatioLabelRect.size.width = visitRatioLabelsize.width;
            visitRatioLabelRect.origin.x = backVISITLine.origin.x - 1 - visitRatioLabelRect.size.width - 5;
            if (visitRatioLabelRect.origin.x < newVISITLine.origin.x) {
                visitRatioLabelRect.origin.x =  backVISITLine.origin.x + 5 ;
            }
            CGRect UVRatioLabelRect = _UVRatioLabel.frame;
            CGSize UVRatioLabelsize = [_UVRatioLabel.text sizeWithFont:_UVRatioLabel.font];
            UVRatioLabelRect.size.width = UVRatioLabelsize.width;
            UVRatioLabelRect.origin.x = backUVLine.origin.x - 1 - UVRatioLabelRect.size.width - 5;
            if (UVRatioLabelRect.origin.x < newUVLine.origin.x) {
                UVRatioLabelRect.origin.x =  backUVLine.origin.x + 5 ;
            }
            CGRect validUVRatioLabelRect = _validUVRatioLabel.frame;
            CGSize validUVRatioLabelsize = [_validUVRatioLabel.text sizeWithFont:_validUVRatioLabel.font];
            validUVRatioLabelRect.size.width = validUVRatioLabelsize.width;
            validUVRatioLabelRect.origin.x = backValidUVLine.origin.x - 1 - validUVRatioLabelRect.size.width - 5;
            if (validUVRatioLabelRect.origin.x < newValidUVLine.origin.x) {
                validUVRatioLabelRect.origin.x =  backValidUVLine.origin.x + 5 ;
            }
        
            _sourceVisitArray = (NSMutableArray *)data[@"sourceVisitArray"];
            
            NSArray *items = @[[PNPieChartDataItem dataItemWithValue:((NSNumber *)_sourceVisitArray[0]).floatValue color:_groupColorArray[0]],
                               [PNPieChartDataItem dataItemWithValue:((NSNumber *)_sourceVisitArray[1]).floatValue color:_groupColorArray[1]],
                               [PNPieChartDataItem dataItemWithValue:((NSNumber *)_sourceVisitArray[2]).floatValue color:_groupColorArray[2]],
                               [PNPieChartDataItem dataItemWithValue:((NSNumber *)_sourceVisitArray[3]).floatValue color:_groupColorArray[3]],
                               [PNPieChartDataItem dataItemWithValue:((NSNumber *)_sourceVisitArray[4]).floatValue color:_groupColorArray[4]],
                               [PNPieChartDataItem dataItemWithValue:((NSNumber *)_sourceVisitArray[5]).floatValue color:_groupColorArray[5]],
                               ];
            
            _visitorPieChart.items = items;
            
            [_vaildSourceBarChart setYValues:_sourceVisitArray];
            _sourceValidUVArray = (NSMutableArray *)data[@"sourceValidUVArray"];
            [_vaildSourceBarChart setYValues1:_sourceValidUVArray];
            
            [_citiesBarChart setYValues:_cityValueArray];
            [_pagesBarChart setYValues:_pagesValueArray];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_lineGraph reloadGraph];
                
                _uvGroupLabel.text = [NSString stringWithFormat:@"UV: %li",_groupUV];
                _validGroupUVLabel.text =[NSString stringWithFormat:@"有效UV: %li",(long)_validGroupUV];
                _visitorGroupLabel.text =[NSString stringWithFormat:@"VISIT: %li",(long)_VISITNumber];
                
                _visitRatioLabel.text =[NSString stringWithFormat:@"%.1f%%",_newVISITRatio * 100.0];
                _UVRatioLabel.text =[NSString stringWithFormat:@"%.1f%%",_newUVRatio * 100.0];
                _validUVRatioLabel.text =[NSString stringWithFormat:@"%.1f%%",_newVaildUVRatio * 100.0];
                
                _dealMoneyLabel.text = [NSString stringWithFormat:@"付款金额: %li",(long)_dealMoney];
                _validDealNumberLabel.text =[NSString stringWithFormat:@"有效订单数: %li",_validDealNumber];
                _validDealTransformRatioLabel.text =[NSString stringWithFormat:@"转化率: %.1f%%",_validDealTransformRatio];

                [UIView animateWithDuration:0.8
                                      delay:0.0
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
    //                                 _validUVLine.frame = validUVLineRect;
    //                                 _UVLine.frame = UVLineRect;
                                     _visitRatioLabel.frame = visitRatioLabelRect;
                                     _UVRatioLabel.frame = UVRatioLabelRect;
                                     _validUVRatioLabel.frame = validUVRatioLabelRect;

                                     _newVISITLine.frame    = newVISITLine;
                                     _backVISITLine.frame   = backVISITLine;
                                     _newUVLine.frame       = newUVLine;
                                     _backUVLine.frame      = backUVLine;
                                     _newValidUVLine.frame  = newValidUVLine;
                                     _backValidUVLine.frame = backValidUVLine;
                                 } completion:nil];
                
                [_visitorPieChart strokeChart];
                
                [_vaildSourceBarChart strokeChart];
                [_citiesBarChart strokeChart];
                [_pagesBarChart strokeChart];
            });
   }
});


   
    
    
//    [UIView animateWithDuration:0.8
//                          delay:0.0
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         _validUVLine.frame = validUVLineRect;
//                         _UVLine.frame = UVLineRect;
//                          _validUVRatioLabel.frame = validUVRatioLabelRect;
//                   } completion:nil];
    
//    _sourceVisitArray = (NSMutableArray *)data[@"groupPercentArray"];
//    
//    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:((NSNumber *)_sourceVisitArray[0]).floatValue color:_groupColorArray[0]],
//                       [PNPieChartDataItem dataItemWithValue:((NSNumber *)_sourceVisitArray[1]).floatValue color:_groupColorArray[1]],
//                       [PNPieChartDataItem dataItemWithValue:((NSNumber *)_sourceVisitArray[2]).floatValue color:_groupColorArray[2]],
//                       [PNPieChartDataItem dataItemWithValue:((NSNumber *)_sourceVisitArray[3]).floatValue color:_groupColorArray[3]],
//                       [PNPieChartDataItem dataItemWithValue:((NSNumber *)_sourceVisitArray[4]).floatValue color:_groupColorArray[4]],
//                       [PNPieChartDataItem dataItemWithValue:((NSNumber *)_sourceVisitArray[5]).floatValue color:_groupColorArray[5]],
//                       ];
//    
//    _visitorPieChart.items = items;
//    [_visitorPieChart strokeChart];
    
//    [_vaildSourceBarChart setYValues:_sourceVisitArray];
//    _sourceValidUVArray = (NSMutableArray *)data[@"groupValidPercentArray"];
//    [_vaildSourceBarChart strokeChart];

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
//    NSString *label = [_arrayOfDates objectAtIndex:index];
//    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
    return @"";
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




@end
