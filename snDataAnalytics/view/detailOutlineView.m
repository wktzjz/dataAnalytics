//
//  detailOutlineView.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-11-28.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "detailOutlineView.h"
#import "defines.h"

@implementation detailOutlineView
{
    NSMutableArray *_viewArray;
    NSArray *_indexStringArray;
    BOOL _showReferencedLines;
    viewType _viewType;
}

- (instancetype)initWithFrame:(CGRect)frame viewType:(viewType)type
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _showReferencedLines = NO;
        _viewType            = type;
        _viewArray        = [[NSMutableArray alloc] initWithCapacity:10];
        [self setStringArray:_viewType];
        [self addViews];
    }
    
    return self;
}

//- (void)viewDidLoad
//{
//    [self addViews];
//}

- (void)setStringArray:(viewType)type
{
    switch (type) {
            
        case outlineRealTime:
            _indexStringArray = @[@"UV",@"PV",@"VISIT", @"新UV",@"有效UV",@"付款金额",@"有效订单数",@"有效订单转化率"];
            break;
            
        case outlineVisitorGroup:
            _indexStringArray = @[@"UV",@"PV",@"VISIT", @"新UV",@"有效UV",@"平均页面停留时间",@"提交订单转化率",@"有效订单转化率"];
            break;
            
        case outlineSource:
            _indexStringArray = @[@"UV",@"PV",@"VISIT", @"新UV",@"有效UV",@"平均页面停留时间",@"提交订单转化率",@"有效订单转化率",@"间接订单数",@"间接订单转化率"];
            break;
            
        default:
            _indexStringArray = nil;
            break;
    }

}

- (void)addViews
{
    if (!_indexStringArray || _indexStringArray.count == 0) {
        return;
    }
    
    float marginX = 0.0;
    float marginY = 10.0 ;
    float width   = wkScreenWidth - marginX * 2;
    float height  = wkScreenHeight/4 + 10;
    
    [_indexStringArray enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
        
        labelLineChartView *view;
        
        if(idx == 0){
            view = [[labelLineChartView alloc] initWithFrame:CGRectMake(marginX, 0, width, height)];
        }else{
            labelLineChartView *previousView = (labelLineChartView *)_viewArray[idx - 1];
            view = [[labelLineChartView alloc] initWithFrame:CGRectMake(marginX, previousView.frame.origin.y + previousView.frame.size.height + marginY, width, height)];
        }
        
        [_viewArray addObject:view];
        view.labelString = name;
        view.viewMarker  = idx;
        
        if(_viewType != outlineRealTime){
            view.viewClickedBlock =  ^(NSInteger viewMarker) {
                if (_viewClickedBlock) {
                    _viewClickedBlock(viewMarker);
                }
            };
        }
        
        [self addSubview:view];
    }];
    
}

- (void)initViewsWithData:(NSDictionary *)data
{
    if(_viewArray){
        [_viewArray enumerateObjectsUsingBlock:^(labelLineChartView *view, NSUInteger idx, BOOL *stop) {
            [view addViewsWithData:data];
        }];
    }
}

- (void)shouldShowReferencedLines:(BOOL)show
{
    if (_showReferencedLines != show) {
        _showReferencedLines = show;
        
         if(_viewArray){
             [_viewArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                 ((labelLineChartView *)_viewArray[idx]).shouldReferencedLinesShow = show;
             }];
         }
    }
}

- (void)reloadData:(NSDictionary *)info
{
    if(_viewArray){
        [_viewArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [((labelLineChartView *)_viewArray[idx]) relodData:info];
        }];
    }
}

@end
