//
//  lineChartDetailsView.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-27.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "lineChartDetailsView.h"
#import "defines.h"

@implementation lineChartDetailsView
{
    BOOL _showReferencedLines;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _showReferencedLines = NO;
        _graphLabelName = @"UV";
//        _lableNameArray = @[@"UV",@"PV",@"Visitor", @"新UV",@"有效UV",@"付款金额",@"有效订单数",@"有效订单转化率"];
        
        self.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];

        [self addViews];
        
    }
    
    return self;
}

- (void)addViews
{
    float marginX = 10.0;
    float marginY = 10.0;
    float width   = wkScreenWidth - 10 * 2;
    float height  = wkScreenHeight/2 - 15;
    
    _lineView = [[labelLineChartView alloc] initWithFrame:CGRectMake(marginX, 10, width, height)];
    _lineView.labelString = _graphLabelName;
    _lineView.shouldReferencedLinesShow = YES;

    [self addSubview:_lineView];

    _detailsView = [[detailsSwitchView alloc] initWithFrame:CGRectMake(marginX, _lineView.frame.origin.y + _lineView.frame.size.height + marginY, width, height)];
    [self addSubview:_detailsView];
    
}

- (void)setGraphLabelName:(NSString *)labelString
{
    _graphLabelName       = labelString;
    _lineView.labelString = labelString;
}

- (void)reloadViewWithData:(NSDictionary *)data
{
    [_detailsView addViewsWithData:data];
}

- (void)setDimensionName:(NSString *)dimensionName
{
    _dimensionName = dimensionName;
   _detailsView.dimensionName = dimensionName;
}

- (void)setIndexName:(NSString *)indexName
{
    _indexName = indexName;
    _detailsView.indexName = indexName;
}

@end
