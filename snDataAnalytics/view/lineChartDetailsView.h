//
//  lineChartDetailsView.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-27.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "labelLineChartView.h"
#import "detailsSwitchView.h"

typedef void(^dimensionButtonClicked)();
typedef void(^indexButtonClicked)();

@interface lineChartDetailsView : UIView

@property (nonatomic) labelLineChartView *lineView;
@property (nonatomic) detailsSwitchView *detailsView;

@property (nonatomic) NSString *dimensionName;
@property (nonatomic) NSString *indexName;
@property (nonatomic) NSString  *graphLabelName;

@property (nonatomic,copy) dimensionButtonClicked dimensionButtonClickedBlock;
@property (nonatomic,copy) indexButtonClicked indexButtonClickedBlock;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)addLineViewWithData:(NSDictionary *)data;

- (void)addDetailsViewButtonWithData:(NSDictionary *)data;
- (void)addDetailsViewWithData:(NSDictionary *)data;

- (void)reloadViewWithData:(NSDictionary *)info;

@end
