//
//  lineChartDetailsViewFactory.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-11-5.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "lineChartDetailsViewController.h"
#import "dataOutlineViewContainer.h"

typedef NS_ENUM(NSUInteger, visitorGroupControllerType) {
    UV      = 0,
    PV      = 1,
    Visitor = 2,
    NewUV   = 3,
    ValidUV = 4,
    AverageTime      = 5,
    SubmitVonversion = 6,
    ValidConversion  = 7,
};



@interface lineChartDetailsViewFactory : NSObject

+ (instancetype)sharedInstance;

- (lineChartDetailsViewController *)getControllerFromView:(viewType)viewType detailsType:(NSInteger)detailsType;

- (lineChartDetailsViewController *)getVisitorGroupControllerByType:(NSInteger)type;

@end
