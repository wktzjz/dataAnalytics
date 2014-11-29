//
//  labelLineChartView.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-29.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "BEMSimpleLineGraphView.h"

// Block
typedef void(^viewClicked)(NSInteger markers);

@interface labelLineChartView : UIView <BEMSimpleLineGraphDataSource,BEMSimpleLineGraphDelegate>

@property (nonatomic, strong) BEMSimpleLineGraphView *lineGraph;
@property (nonatomic) CGFloat                        lineGraphHeight;
@property (nonatomic, strong) NSMutableArray         *arrayOfValues;
@property (nonatomic, strong) NSMutableArray         *arrayOfDates;
@property (nonatomic, strong) NSString               *labelString;
@property (nonatomic, strong) NSNumber               *labelNumber;
@property (nonatomic, strong) UILabel                *label;
@property (nonatomic, strong) UILabel                *numberLabel;
@property (nonatomic) BOOL                           shouldReferencedLinesShow;
@property (nonatomic) NSInteger                      viewMarker;

@property (nonatomic, copy) viewClicked viewClickedBlock;

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame referencedLinesShow:(BOOL)show;

- (void)addViewsWithData:(NSDictionary *)data;
- (void)relodData:(NSDictionary *)data;

@end
