//
//  realTimeDetailsView.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-29.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "realTimeDetailsView.h"
#import "defines.h"
#import "lineChartDetailsView.h"

@implementation realTimeDetailsView
{
    NSArray *_viewArray;
    BOOL    _showReferencedLines;
    NSArray *_lableNameArray;
    
    void (^_handleViewClickBlock)(NSString *);
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _showReferencedLines = NO;
        _lableNameArray = @[@"UV",@"PV",@"Visitor", @"新UV",@"有效UV",@"付款金额",@"有效订单数",@"有效订单转化率"];
//        _hostController = controller;
        
        [self addViews];
        
    }
    
    return self;
}

- (void)addViews
{
    float marginX = 0.0;
    float marginY = 10.0 ;
    float width   = wkScreenWidth - marginX * 2;
    float height  = wkScreenHeight/4 + 10;

    _UVView = [[labelLineChartView alloc] initWithFrame:CGRectMake(marginX, 0, width, height)];

//    
    _PVView = [[labelLineChartView alloc] initWithFrame:CGRectMake(marginX, _UVView.frame.origin.y + _UVView.frame.size.height + marginY, width, height) ];

//    
    _visitorView = [[labelLineChartView alloc] initWithFrame:CGRectMake(marginX, _PVView.frame.origin.y + _PVView.frame.size.height + marginY, width, height) ];

//    
    _newlyUVView = [[labelLineChartView alloc] initWithFrame:CGRectMake(marginX, _visitorView.frame.origin.y + _visitorView.frame.size.height + marginY, width, height) ];

//    
    _validUVView = [[labelLineChartView alloc] initWithFrame:CGRectMake(marginX, _newlyUVView.frame.origin.y + _newlyUVView.frame.size.height + marginY, width, height) ];

//    
    _payMoneyView = [[labelLineChartView alloc] initWithFrame:CGRectMake(marginX, _validUVView.frame.origin.y + _validUVView.frame.size.height + marginY, width, height) ];

//    
    _vaildDealAmountView = [[labelLineChartView alloc] initWithFrame:CGRectMake(marginX, _payMoneyView.frame.origin.y + _payMoneyView.frame.size.height + marginY, width, height) ];

//    
    _validDealConversionView = [[labelLineChartView alloc] initWithFrame:CGRectMake(marginX, _vaildDealAmountView.frame.origin.y + _vaildDealAmountView.frame.size.height + marginY, width, height) ];
    
    _viewArray = @[_UVView,_PVView,_visitorView,_newlyUVView,_validUVView,_payMoneyView,_vaildDealAmountView,_validDealConversionView];
    
    [_viewArray enumerateObjectsUsingBlock:^(labelLineChartView *view, NSUInteger idx, BOOL *stop) {
        view.labelString = (NSString *)_lableNameArray[idx];
        view.viewMarker  = idx;
        
//        view.viewClickedBlock = ^(NSInteger viewMarker) {
////            NSLog(@"%@ clicked",(NSString *)_lableNameArray[viewMarker]);
//            
//            if (_viewClickedBlock) {
//                _viewClickedBlock(viewMarker);
//            }
//        };
        
        [self addSubview:view];
    }];
    
}

- (void)initViewsWithData:(NSDictionary *)data
{
    [_viewArray enumerateObjectsUsingBlock:^(labelLineChartView *view, NSUInteger idx, BOOL *stop) {
        [view addViewsWithData:data];
    }];
}

- (void)shouldShowReferencedLines:(BOOL)show
{
    if (_showReferencedLines != show) {
        _showReferencedLines = show;
        
        [_viewArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ((labelLineChartView *)_viewArray[idx]).shouldReferencedLinesShow = show;
        }];
    }
}

- (void)reloadData:(NSDictionary *)data
{
    [_viewArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [((labelLineChartView *)_viewArray[idx]) relodData:data];
    }];
}


@end
