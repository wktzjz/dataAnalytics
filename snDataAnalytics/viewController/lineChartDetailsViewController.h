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
typedef void(^dateChoosed)(NSString *fromDate, NSString *toString);
typedef void(^conditionChoosed)(NSDictionary *data);


@interface lineChartDetailsViewController : UIViewController

@property (nonatomic) NSInteger type;
@property (nonatomic, strong) lineChartDetailsView *chartDetailsView;
@property (nonatomic, strong) NSString *titleString;

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSMutableDictionary *selectedDays;
@property (nonatomic, strong) NSMutableArray *dimensionArray;
@property (nonatomic, strong) NSMutableArray *indexArray;

@property (nonatomic, copy) dismiss dismissBlock;
@property (nonatomic, copy) dimensionChoosed dimensionChoosedBlock;
@property (nonatomic, copy) indexChoosed indexChoosedBlock;
@property (nonatomic, copy) dateChoosed dateChoosedBlock;
@property (nonatomic, copy) conditionChoosed conditionChoosedBlock;

- (instancetype)initWithFrame:(CGRect)frame data:(NSDictionary *)data;
- (void)reloadViewWithData:(NSDictionary *)data;

- (void)addDetailsViewButtonWithData:(NSDictionary *)data;
- (void)addDetailsViewWithData:(NSDictionary *)data;

- (void)addLineViewWithData:(NSDictionary *)data;

@end
