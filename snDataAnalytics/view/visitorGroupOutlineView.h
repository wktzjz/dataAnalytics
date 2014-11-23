//
//  visitorGroupOutlineView.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-8.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChart.h"

@interface visitorGroupOutlineView : UIView

@property (nonatomic) PNPieChart *pieChart;
@property (nonatomic) NSInteger  UVNumber;
@property (nonatomic) NSInteger  validUVNumber;
@property (nonatomic) NSInteger  visitNumber;
@property (nonatomic) float newVISITRatio;
@property (nonatomic) float newUVRatio;
@property (nonatomic) float newVaildUVRatio;
@property (nonatomic) NSArray    *groupColorArray;
@property (nonatomic) NSArray    *groupPercentArray;

- (instancetype)initWithFrame:(CGRect)frame withData:(NSDictionary *)data;
- (void)modifyGroupViewWithData:(NSDictionary *)data;

@end
