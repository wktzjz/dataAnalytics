//
//  lineChartDetailsView.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-27.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "labelLineChartView.h"

@interface lineChartDetailsView : UIView 

@property (nonatomic) labelLineChartView *lineView;
@property (nonatomic) UIView *detailsView;

@property (nonatomic) NSString  *graphLabelName;

- (id)initWithFrame:(CGRect)frame;
- (void)relodData:(NSDictionary *)info;

@end
