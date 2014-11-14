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

@property (nonatomic) BEMSimpleLineGraphView *lineGraph;
@property (nonatomic) CGFloat                lineGraphHeight;
@property (nonatomic) NSMutableArray         *arrayOfValues;
@property (nonatomic) NSMutableArray         *arrayOfDates;
@property (nonatomic) NSString               *labelString;
@property (nonatomic) NSNumber               *labelNumber;
@property (nonatomic) UILabel                *label;
@property (nonatomic) UILabel                *numberLabel;
@property (nonatomic) BOOL                   shouldReferencedLinesShow;
@property (nonatomic) NSInteger              viewMarker;

@property (nonatomic, copy) viewClicked viewClickedBlock;

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame referencedLinesShow:(BOOL)show;

- (void)addViewsWithData:(NSDictionary *)data;
- (void)relodData:(NSDictionary *)data;

@end
