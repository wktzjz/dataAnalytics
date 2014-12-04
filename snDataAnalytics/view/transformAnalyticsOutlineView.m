//
//  transformAnalyticsView.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-12-3.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "transformAnalyticsOutlineView.h"
#import "defines.h"
#import "PNColor.h"
#import "Colours.h"

@implementation transformAnalyticsOutlineView
{
    //付款金额 有效订单数 有效订单转化率
    NSInteger _paidMoneyNumber;
    NSInteger _validDealNumber;
    NSInteger _validDealConversionNumber;
    
    UILabel *_chartLabel;
    
    UILabel *_paidMoneyLabel;
    UILabel *_validDealLabel;
    UILabel *_validDealConversionLabel;
    
    UILabel *_paidMoneyNumberLabel;
    UILabel *_validDealNumberLabel;
    UILabel *_validDealConversionNumberLabel;
}

- (instancetype)initWithFrame:(CGRect)frame withData:(NSDictionary *)data
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _paidMoneyNumber = ((NSNumber *)data[@"paidMoney"]).integerValue;
        _validDealNumber = ((NSNumber *)data[@"validDeal"]).integerValue;
        _validDealConversionNumber = ((NSNumber *)data[@"validDealConversion"]).integerValue;
        
        [self addViews];
    }
    
    return self;
}

- (void)addViews
{
    _chartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 10, outlineViewWidth, 30)];
    _chartLabel.text = @"转化分析";
    _chartLabel.textColor = PNFreshGreen;
    _chartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:24.0];
    _chartLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_chartLabel];
    
    _paidMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10 + _chartLabel.frame.origin.y +_chartLabel.frame.size.height, outlineViewWidth/3, 20)];
    _paidMoneyLabel.text = @"付款金额:";
    _paidMoneyLabel.textColor = PNDeepGrey;
    _paidMoneyLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _paidMoneyLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_paidMoneyLabel];
    
    _paidMoneyNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(outlineViewWidth/2 ,_paidMoneyLabel.frame.origin.y, outlineViewWidth/2 - 20, 20)];
    _paidMoneyNumberLabel.text =[NSString stringWithFormat:@"%li",_paidMoneyNumber];
    _paidMoneyNumberLabel.textColor = PNDeepGrey;
    _paidMoneyNumberLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _paidMoneyNumberLabel.textAlignment = NSTextAlignmentRight;
    _paidMoneyNumberLabel.textColor = [UIColor fadedBlueColor];
    [self addSubview:_paidMoneyNumberLabel];
    
    _validDealLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10 + _paidMoneyLabel.frame.origin.y +_paidMoneyLabel.frame.size.height, outlineViewWidth/3, 20)];
    _validDealLabel.text = @"有效订单数:";
    _validDealLabel.textColor = PNDeepGrey;
    _validDealLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _validDealLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_validDealLabel];
    
    _validDealNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(outlineViewWidth/2 ,_validDealLabel.frame.origin.y, outlineViewWidth/2 - 20, 20)];
    _validDealNumberLabel.text =[NSString stringWithFormat:@"%li",_validDealNumber];
    _validDealNumberLabel.textColor = PNDeepGrey;
    _validDealNumberLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _validDealNumberLabel.textAlignment = NSTextAlignmentRight;
    _validDealNumberLabel.textColor = [UIColor fadedBlueColor];
    [self addSubview:_validDealNumberLabel];
    
    _validDealConversionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10 + _validDealLabel.frame.origin.y +_validDealLabel.frame.size.height, outlineViewWidth/2, 20)];
    _validDealConversionLabel.text = @"有效订单转化率:";
    _validDealConversionLabel.textColor = PNDeepGrey;
    _validDealConversionLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _validDealConversionLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_validDealConversionLabel];
    
    _validDealConversionNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(outlineViewWidth/2 ,_validDealConversionLabel.frame.origin.y, outlineViewWidth/2 - 20, 20)];
    _validDealConversionNumberLabel.text =[NSString stringWithFormat:@"%li",_validDealConversionNumber];
    _validDealConversionNumberLabel.textColor = PNDeepGrey;
    _validDealConversionNumberLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    _validDealConversionNumberLabel.textAlignment = NSTextAlignmentRight;
    _validDealConversionNumberLabel.textColor = [UIColor fadedBlueColor];
    [self addSubview:_validDealConversionNumberLabel];
}

@end
