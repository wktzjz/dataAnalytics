//
//  visitorGroupDetailOutlineView.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-9.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "labelLineChartView.h"
@interface visitorGroupDetailOutlineView : UIView

@property (nonatomic) labelLineChartView *UVView;
@property (nonatomic) labelLineChartView *PVView;
@property (nonatomic) labelLineChartView *visitorView;
@property (nonatomic) labelLineChartView *newlyUVView;
@property (nonatomic) labelLineChartView *validUVView;
@property (nonatomic) labelLineChartView *averageRemainTimeView;
@property (nonatomic) labelLineChartView *submittedDealconversionView;
@property (nonatomic) labelLineChartView *validDealConversionView;

- (id)initWithFrame:(CGRect)frame;
- (void)reloadData:(NSDictionary *)info;
- (void)shouldShowReferencedLines:(BOOL)show;

@end
