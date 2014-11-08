//
//  lineChartDetailsViewFactory.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-11-5.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "lineChartDetailsViewFactory.h"
#import "visitorGroupModel.h"
#import "defines.h"

@implementation lineChartDetailsViewFactory
{
    NSArray *_visitorGroupDimensionArray;
    NSArray *_visitorGroupIndexArray;

}


+ (instancetype)sharedInstance
{
    static lineChartDetailsViewFactory *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] _init];
    });
    
    return sharedInstance;
}

- (id)_init
{
    self = [super init];
    if (self) {
        _visitorGroupDimensionArray = @[@"访客类型",@"终端类型",@"整体会员",@"新会员",@"老会员",@"会员等级", @"城市分布"];
        _visitorGroupIndexArray = @[@"UV",@"PV",@"Visitor",@"新UV",@"有效UV",@"平均页面停留时间",@"提交订单转化率",@"有效订单转化率"];

        /*@[@"UV",@"UV",@"访问会员数",@"注册数",@"回访数",@"访问会员数",@"UV"]*/
        
    }
    return self;
}

- (lineChartDetailsViewController *)getVisitorGroupControllerByType:(visitorGroupControllerType)type
{
//    _defineDetails =  @{@"dimensionOptionsArray":dimensionOptionsArray,
//                        @"访客类型":@{@"labelStringArray":@[@"新访客",@"回访客"],
//                                  @"indexOptionsArray":indexOptionsArray1},

    lineChartDetailsViewController *vc = [[lineChartDetailsViewController alloc] initWithFrame:wkScreen data:nil];
    __block NSDictionary *detailsData;
    __block NSDictionary *labelData = (NSDictionary *)[[visitorGroupModel sharedInstance] getDefineDetails];
    
    //details views的 维度 指标 名称
    vc.titleString = vc.chartDetailsView.dimensionName = _visitorGroupDimensionArray[0];
    vc.chartDetailsView.indexName = _visitorGroupIndexArray[type];
    
    vc.chartDetailsView.lineView.labelString = _visitorGroupIndexArray[type];
    detailsData = (NSDictionary *)((NSDictionary *)[[visitorGroupModel sharedInstance] getDetailsData])[(NSString *)_visitorGroupDimensionArray[0]];
    
    //detailsview的数值标题
    [vc addDetailsViewButtonWithData:labelData];

    //图表
    [vc addLineViewWithData:detailsData];
    
    //detailsview的数值
    [vc addDetailsViewWithData:detailsData];
    
    vc.dimensionArray = [[NSMutableArray alloc] initWithArray:_visitorGroupDimensionArray];
    vc.indexArray = [[NSMutableArray alloc] initWithArray:_visitorGroupIndexArray];

    __weak typeof(vc) weakVC = vc;
    vc.chartDetailsView.indexButtonClickedBlock = ^{
        typeof (weakVC) strongVC = weakVC;
        int random = arc4random()%7;
        strongVC.chartDetailsView.lineView.labelString = _visitorGroupIndexArray[random];
        strongVC.chartDetailsView.indexName = _visitorGroupIndexArray[random];;
        [strongVC.chartDetailsView.lineView relodData:detailsData];
    };
    

    vc.dimensionChoosedBlock = ^(NSInteger i){
        typeof (weakVC) strongVC = weakVC;
        
        //details views的 指标数组
        NSArray *indexNameArray = (NSArray *)(NSDictionary *)(labelData[_visitorGroupDimensionArray[i]])[@"indexOptionsArray"];
        
        //details views的 维度 指标 名称
        strongVC.titleString = strongVC.chartDetailsView.dimensionName = _visitorGroupDimensionArray[i];
        strongVC.chartDetailsView.indexName = (NSString *)indexNameArray[0];
        
        strongVC.chartDetailsView.lineView.labelString = (NSString *)indexNameArray[0];
        detailsData = (NSDictionary *)((NSDictionary *)[[visitorGroupModel sharedInstance] getDetailsData])[(NSString *)_visitorGroupDimensionArray[i]];

        //detailsview的数值labels
        [strongVC.chartDetailsView.detailsView reloadLabelsWithData:labelData];
        
        //图表
        [strongVC.chartDetailsView.lineView relodData:detailsData];
        
        //detailsview的数值
        [strongVC.chartDetailsView.detailsView reloadValuesWithData:detailsData];
        
//        strongVC.dimensionArray = [[NSMutableArray alloc] initWithArray:_visitorGroupDimensionArray];
        strongVC.indexArray = [[NSMutableArray alloc] initWithArray:indexNameArray];

    };
    
    return vc;
}


//            lineChartDetailsViewController *vc = [[lineChartDetailsViewController alloc] initWithFrame:self.view.frame data:nil];
//            //details views的 维度 指标 名称
//            vc.chartDetailsView.dimensionName = @"访客类型";
//            vc.chartDetailsView.indexName = @"UV";
//
//            //details views的 Lable标题
//            [vc addDetailsViewButtonWithData:[[visitorGroupModel sharedInstance] getDefineDetails]];
//            vc.chartDetailsView.lineView.labelString = @"UV";
//            NSDictionary *data = (NSDictionary *)((NSDictionary *)[[visitorGroupModel sharedInstance] getDetailsData])[@"访客类型"];
//
//            //图表
//            [vc addLineViewWithData:data];
//            //detailsview的数值
//            [vc addDetailsViewWithData:data];
//
//            __weak typeof(vc) weakVC = vc;
//            vc.chartDetailsView.indexButtonClickedBlock = ^{
//                typeof (weakVC) strongVC = weakVC;
//
//                strongVC.chartDetailsView.lineView.labelString = @"PV";
//                strongVC.chartDetailsView.indexName = @"PV";
//                strongVC.chartDetailsView.lineView.labelNumber = @(123);
//                [strongVC.chartDetailsView.lineView relodData:data];
//            };
//
//            vc.chartDetailsView.dimensionButtonClickedBlock = ^{
//                NSLog(@"dimensionButtonClickedBlock");
//            };

@end
