//
//  lineChartDetailsViewController.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-31.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "lineChartDetailsView.h"

//typedef NS_ENUM(NSUInteger, detailsViewType) {
//    realtimePV,
//};

@interface lineChartDetailsViewController : UIViewController

@property (nonatomic) NSDictionary *data;
@property lineChartDetailsView *chartDetailsView;

- (instancetype)initWithFrame:(CGRect)frame data:(NSDictionary *)data;
- (void)reloadViewWithData:(NSDictionary *)data;

@end
