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

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _showReferencedLines = NO;
        _graphLabelName = @"UV";
//        _lableNameArray = @[@"UV",@"PV",@"Visitor", @"新UV",@"有效UV",@"付款金额",@"有效订单数",@"有效订单转化率"];
        
//        self.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];

        self.backgroundColor = [UIColor whiteColor];
        [self addViews];
        
    }
    
    return self;
}

- (void)addViews
{
    float marginX = 5.0;
    float marginY = 0.0;
    float width   = wkScreenWidth - 15;
    float height  = wkScreenHeight/2;
    
    _lineView = [[labelLineChartView alloc] initWithFrame:CGRectMake(marginX, marginY, width, height) referencedLinesShow:YES];
    _lineView.labelString = _graphLabelName;
    _lineView.shouldReferencedLinesShow = YES;

    [self addSubview:_lineView];

    _detailsView = [[detailsSwitchView alloc] initWithFrame:CGRectMake(marginX, _lineView.frame.origin.y + _lineView.frame.size.height + marginY, width + 5.0, height)];
    
    __weak typeof(self) weakself = self;
    
    _detailsView.dimensionButtonClickedBlock = ^() {
        typeof(weakself) strongSelf = weakself;
        if (strongSelf.dimensionButtonClickedBlock) {
            strongSelf.dimensionButtonClickedBlock();
        }
    };
    
    _detailsView.indexButtonClickedBlock = ^() {
        typeof(weakself) strongSelf = weakself;
        if (strongSelf.indexButtonClickedBlock) {
            strongSelf.indexButtonClickedBlock();
        }
    };
    [self addSubview:_detailsView];
    
}

- (void)setGraphLabelName:(NSString *)labelString
{
    _graphLabelName       = labelString;
    _lineView.labelString = labelString;
}

- (void)addLineViewWithData:(NSDictionary *)data
{
    [_lineView addViewsWithData:data];
}

//添加DetailsViewlabel
- (void)addDetailsViewButtonWithData:(NSDictionary *)data
{
    [_detailsView addLabelsWithData:data];
}

//添加DetailsView具体UI
- (void)addDetailsViewWithData:(NSDictionary *)data
{
    [_detailsView addViewsWithData:data];
}

- (void)reloadViewWithData:(NSDictionary *)data
{
    [_detailsView addViewsWithData:data];
}

//添加维度button名称
- (void)setDimensionName:(NSString *)dimensionName
{
    _dimensionName = dimensionName;
   _detailsView.dimensionName = dimensionName;
}

//添加指标button名称
- (void)setIndexName:(NSString *)indexName
{
    _indexName = indexName;
    _detailsView.indexName = indexName;
}

@end
