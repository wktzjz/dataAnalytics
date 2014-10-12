//
//  vistorGroupOutlineView.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-8.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChart.h"

@interface vistorGroupOutlineView : UIView

@property (nonatomic) PNPieChart *pieChart;
@property (nonatomic) NSInteger  UVNumber;
@property (nonatomic) NSInteger  validUVNumber;
@property (nonatomic) NSInteger  vistorNumber;
@property (nonatomic) NSArray    *groupColorArray;
@property (nonatomic) NSArray    *groupPercentArray;

- (id)initWithFrame:(CGRect)frame;
- (void)modifyGroupView;

@end