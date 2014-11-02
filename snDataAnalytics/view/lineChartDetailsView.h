//
//  lineChartDetailsView.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-27.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "labelLineChartView.h"
#import "detailsSwitchView.h"

@interface lineChartDetailsView : UIView

@property (nonatomic) labelLineChartView *lineView;
@property (nonatomic) detailsSwitchView *detailsView;

@property (nonatomic) NSString *dimensionName;
@property (nonatomic) NSString *indexName;

@property (nonatomic) NSString  *graphLabelName;

- (id)initWithFrame:(CGRect)frame;
- (void)reloadViewWithData:(NSDictionary *)info;

@end
