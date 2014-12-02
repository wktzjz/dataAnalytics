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
#import "UIColor+BFPaperColors.h"

@implementation visitorGroupOutlineView
{
    UILabel *_chartLabel;
    UILabel *_uvLabel;
    UILabel *_validUVLabel;
    UILabel *_visitLabel;
    UIView  *_newVISITLine;
    UIView  *_backVISITLine;
    UIView  *_newUVLine;
    UIView  *_backUVLine;
    UIView  *_newValidUVLine;
    UIView  *_backValidUVLine;
    
    UILabel *_visitRatioLabel;
    UILabel *_UVRatioLabel;
    UILabel *_validUVRatioLabel;
    
    UILabel *_groupLabel1;
    UILabel *_groupLabel2;
    UILabel *_groupLabel3;
    
    UIView *_colorDotView1;
    UIView *_colorDotView2;
    UIView *_colorDotView3;
    
    UIColor *_newColor;
    UIColor *_backColor;
    
    float _lineWidth;
}

- (instancetype)initWithFrame:(CGRect)frame withData:(NSDictionary *)data
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _groupPercentArray = @[@15,@30,@55];
        _groupColorArray   = @[PNLightGreen,PNFreshGreen,PNDeepGreen];
        
//        _visitNumber       = arc4random() % 100000;
//        _UVNumber          = arc4random() % 20000;
//        _validUVNumber     = arc4random() % 10000;
//        _newVISITRatio     = (arc4random() % 1000) / 1000.0;
//        _newUVRatio        = (arc4random() % 1000) / 1000.0;
//        _newVaildUVRatio   = (arc4random() % 1000) / 1000.0;
        NSAssert(data != nil, @"ERROR visitorGroup outline data error");
        
        _visitNumber   = ((NSNumber *)data[@"visitNumber"]).integerValue;
        _UVNumber      = ((NSNumber *)data[@"UVNumber"]).integerValue;
        _validUVNumber = ((NSNumber *)data[@"validUVNumber"]).integerValue;
        _newVISITRatio = ((NSNumber *)data[@"newVISITRatio"]).floatValue;
        _newUVRatio    = ((NSNumber *)data[@"newUVRatio"]).floatValue;
        _newVaildUVRatio = ((NSNumber *)data[@"newVaildUVRatio"]).floatValue;
        
        _lineWidth = outlineViewWidth/2 + 30.0;
        _newColor  = [UIColor colorWithRed:0x45/255.0 green:0xa7/255.0 blue:0xff/255.0 alpha:1];
        _backColor = PNLightGrey;
        
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
    
    _visitLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10 + _chartLabel.frame.origin.y +_chartLabel.frame.size.height, outlineViewWidth/2 - 20, 30)];
    _visitLabel.text = [NSString stringWithFormat:@"VISIT: %li",_visitNumber];
    _visitLabel.textColor = PNDeepGrey;
    _visitLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _visitLabel.textAlignment = NSTextAlignmentLeft;
    
    _newVISITLine = [[UIView alloc] initWithFrame:CGRectMake(_lineWidth - 70.0,10 + _chartLabel.frame.origin.y +_chartLabel.frame.size.height,(_lineWidth - 1)*_newVISITRatio,30)];
    _newVISITLine.backgroundColor = _newColor;
    _backVISITLine = [[UIView alloc] initWithFrame:CGRectMake(1 + _newVISITLine.frame.origin.x+_newVISITLine.frame.size.width,_newVISITLine.frame.origin.y,(_lineWidth - 1)*(1 - _newVISITRatio),30)];
    _backVISITLine.backgroundColor = _backColor;
    
    _uvLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,10 + _visitLabel.frame.origin.y +_visitLabel.frame.size.height, outlineViewWidth/2 - 20, 30)];
    _uvLabel.text =[NSString stringWithFormat:@"UV: %li",_UVNumber];
    _uvLabel.textColor = PNDeepGrey;
    _uvLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _uvLabel.textAlignment = NSTextAlignmentLeft;
    
    _newUVLine = [[UIView alloc] initWithFrame:CGRectMake(_lineWidth - 70.0,10 + _visitLabel.frame.origin.y +_visitLabel.frame.size.height,(_lineWidth - 1) * _newUVRatio,30)];
    _newUVLine.backgroundColor = _newColor;
    _backUVLine = [[UIView alloc] initWithFrame:CGRectMake(1 + _newUVLine.frame.origin.x+_newUVLine.frame.size.width,_newUVLine.frame.origin.y,(_lineWidth - 1)*(1 - _newUVRatio),30)];
    _backUVLine.backgroundColor = _backColor;
    
    _validUVLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10.0 + _uvLabel.frame.origin.y +_uvLabel.frame.size.height, outlineViewWidth/2 - 20, 30)];
    _validUVLabel.text =[NSString stringWithFormat:@"有效UV: %li",_validUVNumber];
    _validUVLabel.textColor = PNDeepGrey;
    _validUVLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _validUVLabel.textAlignment = NSTextAlignmentLeft;
    
    _newValidUVLine = [[UIView alloc] initWithFrame:CGRectMake(_lineWidth - 70.0,10 + _uvLabel.frame.origin.y +_uvLabel.frame.size.height,(_lineWidth - 1) * _newVaildUVRatio,30)];
    _newValidUVLine.backgroundColor = _newColor;
    _backValidUVLine = [[UIView alloc] initWithFrame:CGRectMake(1 + _newValidUVLine.frame.origin.x + _newValidUVLine.frame.size.width,_newValidUVLine.frame.origin.y,(_lineWidth - 1)*(1 - _newVaildUVRatio),30)];
    _backValidUVLine.backgroundColor = _backColor;
    
    UILabel *tipNewLabel  = [[UILabel alloc] initWithFrame:CGRectMake(outlineViewWidth/7,10 + _validUVLabel.frame.origin.y +_validUVLabel.frame.size.height, outlineViewWidth/5, 30)];
    tipNewLabel.text = @"新访客";
    tipNewLabel.textColor = PNDeepGrey;
    tipNewLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    tipNewLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *tipNewView = [[UIView alloc] initWithFrame:CGRectMake(3.0 + tipNewLabel.frame.origin.x +tipNewLabel.frame.size.width,17.5 + _validUVLabel.frame.origin.y +_validUVLabel.frame.size.height, 15, 15)];
    tipNewView.backgroundColor = _newColor;
    tipNewView.layer.cornerRadius = 7.5;
    
    UILabel *tipBackLabel  = [[UILabel alloc] initWithFrame:CGRectMake(outlineViewWidth/2 + 5.0,10 + _validUVLabel.frame.origin.y +_validUVLabel.frame.size.height, outlineViewWidth/5, 30)];
    tipBackLabel.text = @"回访客";
    tipBackLabel.textColor = PNDeepGrey;
    tipBackLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    tipBackLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *tipBackView = [[UIView alloc] initWithFrame:CGRectMake(3.0 + tipBackLabel.frame.origin.x +tipBackLabel.frame.size.width,17.5 + _validUVLabel.frame.origin.y +_validUVLabel.frame.size.height,15, 15)];
    tipBackView.backgroundColor = _backColor;
    tipBackView.layer.cornerRadius = 7.5;

    _visitRatioLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,_visitLabel.frame.origin.y, outlineViewWidth/4, 30)];
    _visitRatioLabel.text =[NSString stringWithFormat:@"%.1f%%",_newVISITRatio * 100.0];
    _visitRatioLabel.textColor = PNDeepGrey;
    _visitRatioLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:20.0];
    _visitRatioLabel.textAlignment = NSTextAlignmentRight;
    CGRect r = _visitRatioLabel.frame;
    CGSize size = [_visitRatioLabel.text sizeWithFont:_visitRatioLabel.font];
    r.size.width = size.width;
    _visitRatioLabel.frame = r;
    r.origin.x = _backVISITLine.frame.origin.x - 1 - r.size.width - 5;
    _visitRatioLabel.frame = r;
    
    if (_visitRatioLabel.frame.origin.x < _newVISITLine.frame.origin.x) {
        r.origin.x =  _backVISITLine.frame.origin.x + 5 ;
        _visitRatioLabel.frame = r;
    }
    
    _UVRatioLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,_uvLabel.frame.origin.y, outlineViewWidth/4, 30)];
    _UVRatioLabel.text =[NSString stringWithFormat:@"%.1f%%",_newUVRatio * 100.0];
    _UVRatioLabel.textColor = PNDeepGrey;
    _UVRatioLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:20.0];
    _UVRatioLabel.textAlignment = NSTextAlignmentRight;
    r = _UVRatioLabel.frame;
    size = [_UVRatioLabel.text sizeWithFont:_UVRatioLabel.font];
    r.size.width = size.width;
    _UVRatioLabel.frame = r;
    r.origin.x = _backUVLine.frame.origin.x - 1 - r.size.width - 5;
    _UVRatioLabel.frame = r;
    if (_UVRatioLabel.frame.origin.x < _newUVLine.frame.origin.x) {
        r.origin.x =  _backUVLine.frame.origin.x + 5 ;
        _UVRatioLabel.frame = r;
    }
    
    _validUVRatioLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,_validUVLabel.frame.origin.y, outlineViewWidth/4, 30)];
    _validUVRatioLabel.text =[NSString stringWithFormat:@"%.1f%%",_newVaildUVRatio * 100.0];
    _validUVRatioLabel.textColor = PNDeepGrey;
    _validUVRatioLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:20.0];
    _validUVRatioLabel.textAlignment = NSTextAlignmentRight;
    r = _validUVRatioLabel.frame;
    size = [_validUVRatioLabel.text sizeWithFont:_validUVRatioLabel.font];
    r.size.width = size.width;
    _validUVRatioLabel.frame = r;
    r.origin.x = _backValidUVLine.frame.origin.x - 1 - r.size.width - 5;
    _validUVRatioLabel.frame = r;
    if (_validUVRatioLabel.frame.origin.x < _newValidUVLine.frame.origin.x) {
        r.origin.x =  _backValidUVLine.frame.origin.x + 5 ;
        _validUVRatioLabel.frame = r;
    }
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
    
    [self addSubview:_visitLabel];
    [self addSubview:_newVISITLine];
    [self addSubview:_backVISITLine];
    [self addSubview:_visitRatioLabel];
    
    [self addSubview:_uvLabel];
    [self addSubview:_newUVLine];
    [self addSubview:_backUVLine];
    [self addSubview:_UVRatioLabel];
    
    [self addSubview:_validUVLabel];
    [self addSubview:_newValidUVLine];
    [self addSubview:_backValidUVLine];
    [self addSubview:_validUVRatioLabel];

    [self addSubview:tipNewLabel];
    [self addSubview:tipNewView];
    [self addSubview:tipBackLabel];
    [self addSubview:tipBackView];

    
//    [self addPieChart];
    
}

- (void)addPieChart
{
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[0]).floatValue color:_groupColorArray[0]],
                       [PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[1]).floatValue color:_groupColorArray[1]],
                       [PNPieChartDataItem dataItemWithValue:((NSNumber *)_groupPercentArray[2]).floatValue color:_groupColorArray[2]],
                       ];
    
    float pieWidth = outlineViewHeight - ( _visitLabel.frame.origin.y +_visitLabel.frame.size.height) - 10.0;
    _pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(30.0,5 + _validUVLabel.frame.origin.y +_validUVLabel.frame.size.height,pieWidth, pieWidth) items:items];
    _pieChart.descriptionTextColor = [UIColor whiteColor];
    _pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
    _pieChart.descriptionTextShadowColor = [UIColor clearColor];
    [_pieChart strokeChart];
    
    [self addSubview:_chartLabel];
    [self addSubview:_uvLabel];
    [self addSubview:_validUVLabel];
    [self addSubview:_visitLabel];
    [self addSubview:_pieChart];
    
    float originDotViewX = 20 + _pieChart.frame.origin.x + pieWidth;
    
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

- (void)reloadViewWithData:(NSDictionary *)data
{
    if (nil == data){
        return;
    }
    _visitNumber   = ((NSNumber *)data[@"visitNumber"]).integerValue;
    _UVNumber      = ((NSNumber *)data[@"UVNumber"]).integerValue;
    _validUVNumber = ((NSNumber *)data[@"validUVNumber"]).integerValue;
    _newVISITRatio = ((NSNumber *)data[@"newVISITRatio"]).floatValue;
    _newUVRatio    = ((NSNumber *)data[@"newUVRatio"]).floatValue;
    _newVaildUVRatio = ((NSNumber *)data[@"newVaildUVRatio"]).floatValue;

    _visitLabel.text = [NSString stringWithFormat:@"VISIT: %li",_visitNumber];
    _uvLabel.text =[NSString stringWithFormat:@"UV: %li",_UVNumber];
    _validUVLabel.text =[NSString stringWithFormat:@"有效UV: %li",_validUVNumber];
    
    CGRect newVISITLine = CGRectMake(_lineWidth - 70.0,10 + _chartLabel.frame.origin.y +_chartLabel.frame.size.height,(_lineWidth - 1)*_newVISITRatio,30);
    CGRect backVISITLine = CGRectMake(1 + newVISITLine.origin.x + newVISITLine.size.width,newVISITLine.origin.y,(_lineWidth - 1)*(1 - _newVISITRatio),30);
    
    CGRect newUVLine = CGRectMake(_lineWidth - 70.0,10 + _visitLabel.frame.origin.y +_visitLabel.frame.size.height,(_lineWidth - 1) * _newUVRatio,30);
    CGRect backUVLine = CGRectMake(1 + newUVLine.origin.x +newUVLine.size.width,newUVLine.origin.y,(_lineWidth - 1)*(1 - _newUVRatio),30);

    CGRect newValidUVLine = CGRectMake(_lineWidth - 70.0,10 + _uvLabel.frame.origin.y +_uvLabel.frame.size.height,(_lineWidth - 1) * _newVaildUVRatio,30);
    CGRect backValidUVLine = CGRectMake(1 + newValidUVLine.origin.x + newValidUVLine.size.width,newValidUVLine.origin.y,(_lineWidth - 1)*(1 - _newVaildUVRatio),30);
    
    [UIView animateWithDuration:0.8
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _newVISITLine.frame    = newVISITLine;
                         _backVISITLine.frame   = backVISITLine;
                         _newUVLine.frame       = newUVLine;
                         _backUVLine.frame      = backUVLine;
                         _newValidUVLine.frame  = newValidUVLine;
                         _backValidUVLine.frame = backValidUVLine;
                     }
                     completion:nil];
    
//    _colorDotView1.backgroundColor = _groupLabel1.textColor = (UIColor *)_groupColorArray[0];
//    _colorDotView2.backgroundColor = _groupLabel2.textColor = (UIColor *)_groupColorArray[1];
//    _colorDotView3.backgroundColor = _groupLabel3.textColor = (UIColor *)_groupColorArray[2];
//    _groupLabel1.text =[NSString stringWithFormat:@"群体A:  %i%%",((NSNumber *)_groupPercentArray[0]).intValue];
//    _groupLabel2.text =[NSString stringWithFormat:@"群体B:  %i%%",((NSNumber *)_groupPercentArray[1]).intValue];
//    _groupLabel3.text =[NSString stringWithFormat:@"群体C:  %i%%",((NSNumber *)_groupPercentArray[2]).intValue];
}


@end
