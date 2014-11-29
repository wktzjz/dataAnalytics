//
//  detailOutlineView.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-11-28.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "labelLineChartView.h"
#import "dataOutlineViewContainer.h"


typedef void(^viewClicked)(NSInteger markers);


@interface detailOutlineView : UIView

@property (nonatomic, copy) viewClicked viewClickedBlock;

- (instancetype)initWithFrame:(CGRect)frame viewType:(viewType)type;

- (void)initViewsWithData:(NSDictionary *)data;
- (void)reloadData:(NSDictionary *)info;
- (void)shouldShowReferencedLines:(BOOL)show;

@end
