//
//  realTimeDetailsView.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-29.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "labelLineChartView.h"

typedef void(^viewClicked)(NSInteger markers);

@interface realTimeDetailsView : UIView

@property (nonatomic) labelLineChartView *UVView;
@property (nonatomic) labelLineChartView *PVView;
@property (nonatomic) labelLineChartView *visitorView;
@property (nonatomic) labelLineChartView *newlyUVView;
@property (nonatomic) labelLineChartView *validUVView;
@property (nonatomic) labelLineChartView *payMoneyView;
@property (nonatomic) labelLineChartView *vaildDealAmountView;
@property (nonatomic) labelLineChartView *validDealConversionView;

//@property (nonatomic) UIViewController *hostController;

@property (nonatomic,copy) viewClicked viewClickedBlock;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)initViewsWithData:(NSDictionary *)data;
- (void)reloadData:(NSDictionary *)data;
- (void)shouldShowReferencedLines:(BOOL)show;

@end
