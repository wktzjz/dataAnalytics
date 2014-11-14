//
//  detailsSwitchView.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-31.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^dimensionButtonClicked)();
typedef void(^indexButtonClicked)();

@interface detailsSwitchView : UIView

@property (nonatomic) NSString *dimensionName;
@property (nonatomic) NSString *indexName;

@property (nonatomic) NSArray *dimensionOptionsArray;
@property (nonatomic) NSArray *indexOptionsArray;

@property (nonatomic) NSArray *labelStringArray;
@property (nonatomic) NSArray *valueArray;

@property (nonatomic,copy) dimensionButtonClicked dimensionButtonClickedBlock;
@property (nonatomic,copy) indexButtonClicked indexButtonClickedBlock;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)addLabelsWithData:(NSDictionary *)data;
- (void)addViewsWithData:(NSDictionary *)data;

- (void)reloadLabelsWithData:(NSDictionary *)data;
- (void)reloadValuesWithData:(NSDictionary *)data;

@end
