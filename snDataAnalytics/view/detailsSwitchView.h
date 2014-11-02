//
//  detailsSwitchView.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-31.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailsSwitchView : UIView

@property (nonatomic) NSString *dimensionName;
@property (nonatomic) NSString *indexName;

@property (nonatomic) NSArray *dimensionOptionsArray;
@property (nonatomic) NSArray *indexOptionsArray;

@property (nonatomic) NSArray *labelStringArray;
@property (nonatomic) NSArray *valueArray;

- (id)initWithFrame:(CGRect)frame;
- (void)addViewsWithData:(NSDictionary *)data;
- (void)reloadViewWithData:(NSDictionary *)data;

@end
