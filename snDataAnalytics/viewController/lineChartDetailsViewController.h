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

// Block
typedef void(^dismiss)();
typedef void(^dimensionChoosed)(NSInteger i);
typedef void(^indexChoosed)(NSInteger i);

@interface lineChartDetailsViewController : UIViewController

@property lineChartDetailsView *chartDetailsView;
@property (nonatomic) NSString *titleString;

@property (nonatomic) NSDictionary *data;
@property (nonatomic) NSMutableDictionary *selectedDays;
@property (nonatomic) NSMutableArray *dimensionArray;
@property (nonatomic) NSMutableArray *indexArray;

@property (nonatomic,copy) dismiss dismissBlock;
@property (nonatomic,copy) dimensionChoosed dimensionChoosedBlock;
@property (nonatomic,copy) indexChoosed indexChoosedBlock;

- (instancetype)initWithFrame:(CGRect)frame data:(NSDictionary *)data;
- (void)reloadViewWithData:(NSDictionary *)data;

- (void)addDetailsViewButtonWithData:(NSDictionary *)data;
- (void)addDetailsViewWithData:(NSDictionary *)data;

- (void)addLineViewWithData:(NSDictionary *)data;

@end
