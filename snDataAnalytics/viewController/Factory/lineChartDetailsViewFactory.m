//
//  lineChartDetailsViewFactory.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-11-5.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "lineChartDetailsViewFactory.h"
#import "visitorGroupModel.h"
#import "sourcesAnalyticsModel.h"
#import "pageAnalyticsModel.h"
#import "transformAnalyticsModel.h"
#import "defines.h"
#import <objc/message.h>

@implementation lineChartDetailsViewFactory
{
    NSArray *_visitorGroupDimensionArray;
    NSArray *_visitorGroupIndexArray;
    NSArray *_sourceAnalyticsDimensionArray;
    NSArray *_sourceAnalyticsIndexArray;
    NSArray *_pageAnalyticsDimensionArray;
    NSArray *_pageAnalyticsIndexArray;
    NSArray *_transformAnalyticsDimensionArray;
    NSArray *_transformAnalyticsIndexArray;
    
    NSInteger _visitorGroupChosenDimension;
    NSInteger _visitorGroupChosenIndex;
    NSInteger _sourceAnalyticsChosenDimension;
    NSInteger _sourceAnalyticsChosenIndex;
    NSInteger _pageAnalyticsChosenDimension;
    NSInteger _pageAnalyticsChosenIndex;
    NSInteger _transformAnalyticsChosenDimension;
    NSInteger _transformAnalyticsChosenIndex;
    

    NSNumber *_visitorGroupChosenDimensionNumber;
    NSNumber *_visitorGroupChosenIndexNumber;
    NSNumber *_sourceAnalyticsChosenDimensionNumber;
    NSNumber *_sourceAnalyticsChosenIndexNumber;
    NSNumber *_pageAnalyticsChosenDimensionNumber;
    NSNumber *_pageAnalyticsChosenIndexNumber;
    NSNumber *_transformAnalyticsChosenDimensionNumber;
    NSNumber *_transformAnalyticsChosenIndexNumber;
    
     __weak id      _weakSelf;

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
        _visitorGroupIndexArray     = @[@"UV",@"PV",@"VISIT",@"新UV",@"有效UV",@"平均页面停留时间",@"提交订单转化率",@"有效订单转化率"];
        
        _sourceAnalyticsDimensionArray = @[@"硬广",@"导航",@"搜索",@"广告联盟",@"直接流量",@"EDM"];
        _sourceAnalyticsIndexArray     = @[@"UV",@"PV",@"VISIT",@"新UV",@"有效UV",@"平均页面停留时间",@"提交订单转化率",@"有效订单转化率",@"间接订单数",@"间接订单转化率"];
        
        _pageAnalyticsDimensionArray = @[@"页面类型",@"着陆页",@"退出页"];
        _pageAnalyticsIndexArray     = @[@"PV",@"UV",@"平均页面停留时间",@"一跳",@"四级页面PV",@"购物车PV"];
        
        _transformAnalyticsDimensionArray = @[@"来源",@"城市分布",@"访客类型",@"商品分析"];
        _transformAnalyticsIndexArray     = @[@"UV",@"PV",@"VISIT",@"新UV",@"有效UV",@"平均页面停留时间",@"注册数",@"注册转化率",@"提交订单数",@"提交订单转化率",@"有效订单数",@"有效订单转化率",@"付款金额"];

        _visitorGroupChosenDimension = 0;
        _visitorGroupChosenIndex     = 0;
        _sourceAnalyticsChosenDimension = 0;
        _sourceAnalyticsChosenIndex     = 0;
        _pageAnalyticsChosenDimension = 0;
        _pageAnalyticsChosenIndex     = 0;
        _transformAnalyticsChosenDimension = 0;
        _transformAnalyticsChosenIndex     = 0;
        
       
        _visitorGroupChosenDimensionNumber = @(0);
        _visitorGroupChosenIndexNumber = @(0);
        _sourceAnalyticsChosenDimensionNumber = @(0);
        _sourceAnalyticsChosenIndexNumber = @(0);
        _pageAnalyticsChosenDimensionNumber = @(0);
        _pageAnalyticsChosenIndexNumber = @(0);
        _transformAnalyticsChosenDimensionNumber = @(0);
        _transformAnalyticsChosenIndexNumber = @(0);
        
         _weakSelf = self;

    }
    
    return self;
}

- (lineChartDetailsViewController *)getControllerFromView:(viewType)viewType detailsType:(NSInteger)detailsType
{
    return [self getControllerFromView:viewType ByType:detailsType];

//    switch (viewType) {
//            
//        case outlineVisitorGroup:{
//            return [self getVisitorGroupControllerByType:detailsType];
//            break;
//        }
//        case outlineSource:{
//            return [self getSourceAnalyticsControllerByType:detailsType];
//            break;
//        }
//        case outlinePageAnalytics:{
//            return [self getPageAnalyticsControllerByType:detailsType];
//            break;
//        }
//        case outlineTransform:{
//            return [self getTransformAnalyticsControllerByType:detailsType];
//            break;
//        }
//
//        default:
//            return nil;
//            break;
//    }
}



- (lineChartDetailsViewController *)getControllerFromView:(viewType)viewType ByType:(NSInteger)type
{
    __block NSNumber *chosenDimension;
    __block NSNumber *chosenIndex;
    NSArray  *dimensionArray;
    NSArray  *indexArray;
    id model;
    
    lineChartDetailsViewController *vc = [[lineChartDetailsViewController alloc] initWithFrame:wkScreen data:nil];
    __weak typeof(vc) weakVC = vc;
    lineChartDetailsViewFactory *strongSelf = _weakSelf;
    
    switch (viewType) {
        case outlineVisitorGroup:{
            chosenDimension = _visitorGroupChosenDimensionNumber;
            chosenIndex     = _visitorGroupChosenIndexNumber;
            dimensionArray  = _visitorGroupDimensionArray;
            indexArray      = _visitorGroupIndexArray;
            model = [visitorGroupModel sharedInstance];
            break;
        }
        case outlineSource:{
            chosenDimension = _sourceAnalyticsChosenDimensionNumber;
            chosenIndex     = _sourceAnalyticsChosenIndexNumber;
            dimensionArray  = _sourceAnalyticsDimensionArray;
            indexArray      = _sourceAnalyticsIndexArray;
            model = [sourcesAnalyticsModel sharedInstance];
            break;
        }
        case outlinePageAnalytics:{
            chosenDimension = _pageAnalyticsChosenDimensionNumber;
            chosenIndex     = _pageAnalyticsChosenIndexNumber;
            dimensionArray  = _pageAnalyticsDimensionArray;
            indexArray      = _pageAnalyticsIndexArray;
            model = [pageAnalyticsModel sharedInstance];
            break;
        }
        case outlineTransform:{
            chosenDimension = _transformAnalyticsChosenDimensionNumber;
            chosenIndex     = _transformAnalyticsChosenIndexNumber;
            dimensionArray  = _transformAnalyticsDimensionArray;
            indexArray      = _transformAnalyticsIndexArray;
            model = [transformAnalyticsModel sharedInstance];
            break;
        }
            
        default:
            return nil;
            break;
    }
    
    __block NSMutableDictionary *detailsData;
    __block NSDictionary *labelData = (NSDictionary *)[model getDefineDetails];
    
    detailsData = (NSMutableDictionary *)((NSDictionary *)[model getDetailsData])[(NSString *)dimensionArray[0]];
    
    ///details views的 title 和 当前维度 名称
    vc.titleString = vc.chartDetailsView.dimensionName = dimensionArray[0];
    //details views的 当前指标 名称
    vc.chartDetailsView.indexName = indexArray[type];
    vc.chartDetailsView.lineView.labelString = indexArray[type];
    //detailsview的数值标题
    [vc addDetailsViewButtonWithData:detailsData];
    //图表 根据label找到数据 绘制
    [vc addLineViewWithData:detailsData];
    //detailsview的数值
    [vc addDetailsViewWithData:detailsData];
    
    vc.dimensionArray = [[NSMutableArray alloc] initWithArray:dimensionArray];
    vc.indexArray = [[NSMutableArray alloc] initWithArray:indexArray];
    
    vc.indexChoosedBlock = ^(NSInteger i) {
        if (chosenIndex.integerValue != i) {
            chosenIndex = @(i);
            
            typeof(weakVC) strongVC = weakVC;
            
            NSString *chosenDimensionName = (NSString *)dimensionArray[chosenDimension.integerValue];
            NSArray *indexNameArray = (NSArray *)(NSDictionary *)(labelData[chosenDimensionName])[@"indexOptionsArray"];
            
            strongVC.chartDetailsView.indexName = (NSString *)indexNameArray[i];
            strongVC.chartDetailsView.lineView.labelString = (NSString *)indexNameArray[i];
            
            //此时的detailsData已经添加了最新请求的demension的数据
            detailsData = (NSMutableDictionary *)((NSDictionary *)[model getDetailsData])[chosenDimensionName];
            if (detailsData){
                //图表自动根据labelString 筛选detailsData中得数据 用以绘图
                [strongVC.chartDetailsView.lineView relodData:detailsData];
                //detailsview的数值
                [strongVC.chartDetailsView.detailsView reloadValuesWithData:detailsData];

            }
        }
    };
    
    
    vc.dimensionChoosedBlock = ^(NSInteger i) {
        
        if (chosenDimension.integerValue != i) {
            chosenDimension = @(i);
            typeof (weakVC) strongVC = weakVC;
            
            [strongSelf reloadController:strongVC dimensionIndex:i withModel:model withLabelData:labelData withDimensionArray:dimensionArray];
            
//            //details views的 指标数组
//            NSArray *indexNameArray = (NSArray *)(NSDictionary *)(labelData[dimensionArray[i]])[@"indexOptionsArray"];
//            
//            //details views的 title 和 当前维度 名称
//            strongVC.titleString = strongVC.chartDetailsView.dimensionName = dimensionArray[i];
//            //details views的 当前指标 名称
//            strongVC.chartDetailsView.indexName = (NSString *)indexNameArray[0];
//            strongVC.chartDetailsView.lineView.labelString = (NSString *)indexNameArray[0];
//            //添加detailsview的index array选项
//            strongVC.indexArray = [[NSMutableArray alloc] initWithArray:indexNameArray];
//
//            /*没有数据时，通过model的方法名称列表 获得获取请求数据的方法SEL，再通过该方法请求数据，同时将回调block传入
//             */
//            if([model respondsToSelector:@selector(dimensionDataAvailableArray)]){
//                if([((NSArray *)[model dimensionDataAvailableArray])[i] isEqual:@NO]){
//                    
//                    NSString *getDataMethodString = ((NSArray *)[model detailsDataMethodsArray])[i];
//                    SEL getDataMethodSEL = NSSelectorFromString(getDataMethodString);
//                    
//                    void (^successefullyGetDataBlock)(NSDictionary *) = ^(NSDictionary *data) {
//                        
//                        //如果网络处理在非主线程，回调需要在主线程更新UI
//                        dispatch_main_async_safe(^{
//                            //detailsview的labels
//                            [strongVC.chartDetailsView.detailsView reloadLabelsWithData:data];
//                            //detailsview的数值
//                            [strongVC.chartDetailsView.detailsView reloadValuesWithData:data];
//                            //图表
//                            [strongVC.chartDetailsView.lineView relodData:data];
//                        })
//                    };
//                    
//                    //getDataMethodSEL 例如 - (void)getVisitorTypeDetailsData:(void (^)(NSDictionary *data))succeedBlock方法
//                    //[model performSelector:getDataMethodSEL withObject:successefullyGetDataBlock];
//                    // id (*typed_msgSend)(id, SEL, id) = (void *)objc_msgSend;
//                    
//#if !TARGET_IPHONE_SIMULATOR
//                    ((id (*)(id, SEL, id))objc_msgSend)(model,getDataMethodSEL,successefullyGetDataBlock);
//#else
//                    objc_msgSend(model,getDataMethodSEL,successefullyGetDataBlock);
//#endif
//                    
//                    }else{
//                /*已有数据时，直接处理
//                 */
//                    detailsData = (NSMutableDictionary *)((NSDictionary *)[model getDetailsData])[(NSString *)dimensionArray[i]];
//                    //detailsview的labels
//                    [strongVC.chartDetailsView.detailsView reloadLabelsWithData:detailsData];
//                    //detailsview的数值
//                    [strongVC.chartDetailsView.detailsView reloadValuesWithData:detailsData];
//                    //图表
//                    [strongVC.chartDetailsView.lineView relodData:detailsData];
//                }
//            }
        }
    };
    
    vc.dateChoosedBlock = ^(NSString *fromDate, NSString *toDate){
        typeof (weakVC) strongVC = weakVC;
        
        [model setFromDate:fromDate];
        [model setToDate:toDate];
        [model setAllDetailsDataNeedReload];
        
        [strongSelf reloadController:strongVC dimensionIndex:chosenDimension.integerValue withModel:model withLabelData:labelData withDimensionArray:dimensionArray];
    };
    
    vc.conditionChoosedBlock = ^(NSDictionary *data){
        data;
    };
    
    return vc;
}


- (void)reloadController:(lineChartDetailsViewController *)strongVC dimensionIndex:(NSInteger)i withModel:(id)model withLabelData:(NSDictionary *)labelData withDimensionArray:(NSArray *)dimensionArray
{
    //details views的 指标数组
    NSArray *indexNameArray = (NSArray *)(NSDictionary *)(labelData[dimensionArray[i]])[@"indexOptionsArray"];
    
    //details views的 title 和 当前维度 名称
    strongVC.titleString = strongVC.chartDetailsView.dimensionName = dimensionArray[i];
    //details views的 当前指标名称
    strongVC.chartDetailsView.indexName = (NSString *)indexNameArray[0];
    strongVC.chartDetailsView.lineView.labelString = (NSString *)indexNameArray[0];
    //添加detailsview的index array选项
    strongVC.indexArray = [[NSMutableArray alloc] initWithArray:indexNameArray];
    
    /*没有数据时，通过model的方法名称列表 获得获取请求数据的方法SEL，再通过该方法请求数据，同时将回调block传入
     */
    if([model respondsToSelector:@selector(dimensionDataAvailableArray)]){
        if([((NSArray *)[model dimensionDataAvailableArray])[i] isEqual:@NO]){
            
            NSString *getDataMethodString = ((NSArray *)[model detailsDataMethodsArray])[i];
            SEL getDataMethodSEL = NSSelectorFromString(getDataMethodString);
            
            void (^successefullyGetDataBlock)(NSDictionary *) = ^(NSDictionary *data) {
                
                if (data){
                    //如果网络处理在非主线程，回调需要在主线程更新UI
                    dispatch_main_async_safe(^{
                        //detailsview的labels
                        [strongVC.chartDetailsView.detailsView reloadLabelsWithData:data];
                        //detailsview的数值
                        [strongVC.chartDetailsView.detailsView reloadValuesWithData:data];
                        //图表
                        [strongVC.chartDetailsView.lineView relodData:data];
                    })
                }
            };
            
            //getDataMethodSEL 例如 - (void)getVisitorTypeDetailsData:(void (^)(NSDictionary *data))succeedBlock方法
            //[model performSelector:getDataMethodSEL withObject:successefullyGetDataBlock];
            // id (*typed_msgSend)(id, SEL, id) = (void *)objc_msgSend;
            
#if !TARGET_IPHONE_SIMULATOR
            ((id (*)(id, SEL, id))objc_msgSend)(model,getDataMethodSEL,successefullyGetDataBlock);
#else
            objc_msgSend(model,getDataMethodSEL,successefullyGetDataBlock);
#endif
            
        }else{
            /*已有数据时，直接处理
             */
            NSMutableDictionary *detailsData = (NSMutableDictionary *)((NSDictionary *)[model getDetailsData])[(NSString *)dimensionArray[i]];
            dispatch_main_async_safe(^{
                //detailsview的labels
                [strongVC.chartDetailsView.detailsView reloadLabelsWithData:detailsData];
                //detailsview的数值
                [strongVC.chartDetailsView.detailsView reloadValuesWithData:detailsData];
                //图表
                [strongVC.chartDetailsView.lineView relodData:detailsData];
            });
        }
    }
}


- (lineChartDetailsViewController *)getVisitorGroupControllerByType:(NSInteger)type
{
/*
    _defineDetails =  @{@"dimensionOptionsArray":dimensionOptionsArray,
                        @"访客类型":@{@"labelStringArray":@[@"新访客",@"回访客"],
                                  @"indexOptionsArray":indexOptionsArray1},
 
    _detailsData =  @{ @"访客类型":@{
                               @"labelValues":@[@(arc4random() % 2000),@(arc4random() % 2000)],
                               @"arrayOfDates":arrayofDate,
                               @"UV_arrayOfValues":array1,@"PV_arrayOfValues":array2,@"Visitor_arrayOfValues":array3,@"新UV_arrayOfValues":array4,@"有效UV_arrayOfValues":array5,@"平均页面停留时间_arrayOfValues":array6,@"提交订单转化率_arrayOfValues":array7,@"有效订单转化率_arrayOfValues":array8,
                               @"UV_number":@(arc4random() % 20000),@"PV_number":@(arc4random() % 20000),@"Visitor_number":@(arc4random() % 20000),@"新UV_number":@(arc4random() % 10000),@"有效UV_number":@(arc4random() % 2000),@"平均页面停留时间_number":@(arc4random() % 200),@"提交订单转化率_number":@(arc4random() % 100),@"有效订单转化率_number":@(arc4random() % 100)
                               },
*/


    _visitorGroupChosenDimension = 0;
    
    lineChartDetailsViewController *vc = [[lineChartDetailsViewController alloc] initWithFrame:wkScreen data:nil];
    __block NSDictionary *detailsData;
    __block NSDictionary *labelData = (NSDictionary *)[[visitorGroupModel sharedInstance] getDefineDetails];
    
    ///details views的 title 和 当前维度 名称
    vc.titleString = vc.chartDetailsView.dimensionName = _visitorGroupDimensionArray[0];
    
    //details views的 当前指标 名称
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
    
    vc.indexChoosedBlock = ^(NSInteger i) {
        if (_visitorGroupChosenIndex != i) {
            _visitorGroupChosenIndex = i;
            
            typeof(weakVC) strongVC = weakVC;
            NSString *chosenDimensionName = (NSString *)_visitorGroupDimensionArray[_visitorGroupChosenDimension];
            
            NSArray *indexNameArray = (NSArray *)(NSDictionary *)(labelData[chosenDimensionName])[@"indexOptionsArray"];
            
            strongVC.chartDetailsView.indexName = (NSString *)indexNameArray[i];
            strongVC.chartDetailsView.lineView.labelString = (NSString *)indexNameArray[i];
            
            detailsData = (NSDictionary *)((NSDictionary *)[[visitorGroupModel sharedInstance] getDetailsData])[chosenDimensionName];
            
            //图表自动根据labelString 筛选detailsData中得数据 用以绘图
            [strongVC.chartDetailsView.lineView relodData:detailsData];
        }
    };
    
    vc.dimensionChoosedBlock = ^(NSInteger i) {
        if (_visitorGroupChosenDimension != i) {
            typeof (weakVC) strongVC = weakVC;
            
            _visitorGroupChosenDimension = i;
            
            //details views的 指标数组
            NSArray *indexNameArray = (NSArray *)(NSDictionary *)(labelData[_visitorGroupDimensionArray[i]])[@"indexOptionsArray"];
            
            //details views的 title 和 当前维度 名称
            strongVC.titleString = strongVC.chartDetailsView.dimensionName = _visitorGroupDimensionArray[i];
            
            //details views的 当前指标 名称
            strongVC.chartDetailsView.indexName = (NSString *)indexNameArray[0];
            strongVC.chartDetailsView.lineView.labelString = (NSString *)indexNameArray[0];
            
            detailsData = (NSDictionary *)((NSDictionary *)[[visitorGroupModel sharedInstance] getDetailsData])[(NSString *)_visitorGroupDimensionArray[i]];

            //detailsview的labels
            [strongVC.chartDetailsView.detailsView reloadLabelsWithData:labelData];
            
            //图表
            [strongVC.chartDetailsView.lineView relodData:detailsData];
            
            //detailsview的数值
            [strongVC.chartDetailsView.detailsView reloadValuesWithData:detailsData];
            
            //添加detailsview的index array选项
            strongVC.indexArray = [[NSMutableArray alloc] initWithArray:indexNameArray];

        }
    };
    
    return vc;
}

- (lineChartDetailsViewController *)getSourceAnalyticsControllerByType:(NSInteger)type
{
    _sourceAnalyticsChosenDimension = 0;
    
    lineChartDetailsViewController *vc = [[lineChartDetailsViewController alloc] initWithFrame:wkScreen data:nil];
    __block NSDictionary *detailsData;
    __block NSDictionary *labelData = (NSDictionary *)[[sourcesAnalyticsModel sharedInstance] getDefineDetails];
    
    ///details views的 title 和 当前维度 名称
    vc.titleString = vc.chartDetailsView.dimensionName = _sourceAnalyticsDimensionArray[0];
    
    //details views的 当前指标 名称
    vc.chartDetailsView.indexName = _sourceAnalyticsIndexArray[type];
    vc.chartDetailsView.lineView.labelString = _sourceAnalyticsIndexArray[type];
    
    detailsData = (NSDictionary *)((NSDictionary *)[[sourcesAnalyticsModel sharedInstance] getDetailsData])[(NSString *)_sourceAnalyticsDimensionArray[0]];
    
    //detailsview的数值标题
    [vc addDetailsViewButtonWithData:labelData];
    
    //图表
    [vc addLineViewWithData:detailsData];
    
    //detailsview的数值
    [vc addDetailsViewWithData:detailsData];
    
    vc.dimensionArray = [[NSMutableArray alloc] initWithArray:_sourceAnalyticsDimensionArray];
    vc.indexArray = [[NSMutableArray alloc] initWithArray:_sourceAnalyticsIndexArray];
    
    __weak typeof(vc) weakVC = vc;
    
    vc.indexChoosedBlock = ^(NSInteger i) {
        if (_sourceAnalyticsChosenIndex != i) {
            _sourceAnalyticsChosenIndex = i;
            
            typeof(weakVC) strongVC = weakVC;
            NSString *chosenDimensionName = (NSString *)_sourceAnalyticsDimensionArray[_sourceAnalyticsChosenDimension];
            
            NSArray *indexNameArray = (NSArray *)(NSDictionary *)(labelData[chosenDimensionName])[@"indexOptionsArray"];
            
            strongVC.chartDetailsView.indexName = (NSString *)indexNameArray[i];
            strongVC.chartDetailsView.lineView.labelString = (NSString *)indexNameArray[i];
            
            detailsData = (NSDictionary *)((NSDictionary *)[[sourcesAnalyticsModel sharedInstance] getDetailsData])[chosenDimensionName];
            
            //图表自动根据labelString 筛选detailsData中得数据 用以绘图
            [strongVC.chartDetailsView.lineView relodData:detailsData];
        }
    };
    
    
    vc.dimensionChoosedBlock = ^(NSInteger i) {
        if (_sourceAnalyticsChosenDimension != i) {
            typeof (weakVC) strongVC = weakVC;
            
            _sourceAnalyticsChosenDimension = i;
            
            //details views的 指标数组
            NSArray *indexNameArray = (NSArray *)(NSDictionary *)(labelData[_sourceAnalyticsDimensionArray[i]])[@"indexOptionsArray"];
            
            //details views的 title 和 当前维度 名称
            strongVC.titleString = strongVC.chartDetailsView.dimensionName = _sourceAnalyticsDimensionArray[i];
            
            //details views的 当前指标 名称
            strongVC.chartDetailsView.indexName = (NSString *)indexNameArray[0];
            strongVC.chartDetailsView.lineView.labelString = (NSString *)indexNameArray[0];
            
            detailsData = (NSDictionary *)((NSDictionary *)[[sourcesAnalyticsModel sharedInstance] getDetailsData])[(NSString *)_sourceAnalyticsDimensionArray[i]];
            
            //detailsview的labels
            [strongVC.chartDetailsView.detailsView reloadLabelsWithData:labelData];
            
            //图表
            [strongVC.chartDetailsView.lineView relodData:detailsData];
            
            //detailsview的数值
            [strongVC.chartDetailsView.detailsView reloadValuesWithData:detailsData];
            
            //添加detailsview的index array选项
            strongVC.indexArray = [[NSMutableArray alloc] initWithArray:indexNameArray];
            
        }
    };
    
    return vc;
}

- (lineChartDetailsViewController *)getPageAnalyticsControllerByType:(NSInteger)type
{
    _pageAnalyticsChosenDimension = 0;
    
    lineChartDetailsViewController *vc = [[lineChartDetailsViewController alloc] initWithFrame:wkScreen data:nil];
    __block NSDictionary *detailsData;
    __block NSDictionary *labelData = (NSDictionary *)[[pageAnalyticsModel sharedInstance] getDefineDetails];
    
    ///details views的 title 和 当前维度 名称
    vc.titleString = vc.chartDetailsView.dimensionName = _pageAnalyticsDimensionArray[0];
    
    //details views的 当前指标 名称
    vc.chartDetailsView.indexName = _pageAnalyticsIndexArray[type];
    vc.chartDetailsView.lineView.labelString = _pageAnalyticsIndexArray[type];
    
    detailsData = (NSDictionary *)((NSDictionary *)[[pageAnalyticsModel sharedInstance] getDetailsData])[(NSString *)_pageAnalyticsDimensionArray[0]];
    
    //detailsview的数值标题
    [vc addDetailsViewButtonWithData:labelData];
    
    //图表
    [vc addLineViewWithData:detailsData];
    
    //detailsview的数值
    [vc addDetailsViewWithData:detailsData];
    
    vc.dimensionArray = [[NSMutableArray alloc] initWithArray:_pageAnalyticsDimensionArray];
    vc.indexArray = [[NSMutableArray alloc] initWithArray:_pageAnalyticsIndexArray];
    
    __weak typeof(vc) weakVC = vc;
    
    vc.indexChoosedBlock = ^(NSInteger i) {
        if (_pageAnalyticsChosenIndex != i) {
            _pageAnalyticsChosenIndex = i;
            
            typeof(weakVC) strongVC = weakVC;
            NSString *chosenDimensionName = (NSString *)_pageAnalyticsDimensionArray[_pageAnalyticsChosenDimension];
            
            NSArray *indexNameArray = (NSArray *)(NSDictionary *)(labelData[chosenDimensionName])[@"indexOptionsArray"];
            
            strongVC.chartDetailsView.indexName = (NSString *)indexNameArray[i];
            strongVC.chartDetailsView.lineView.labelString = (NSString *)indexNameArray[i];
            
            detailsData = (NSDictionary *)((NSDictionary *)[[pageAnalyticsModel sharedInstance] getDetailsData])[chosenDimensionName];
            
            //图表自动根据labelString 筛选detailsData中得数据 用以绘图
            [strongVC.chartDetailsView.lineView relodData:detailsData];
        }
    };
    
    
    vc.dimensionChoosedBlock = ^(NSInteger i) {
        if (_pageAnalyticsChosenDimension != i) {
            typeof (weakVC) strongVC = weakVC;
            
            _pageAnalyticsChosenDimension = i;
            
            //details views的 指标数组
            NSArray *indexNameArray = (NSArray *)(NSDictionary *)(labelData[_pageAnalyticsDimensionArray[i]])[@"indexOptionsArray"];
            
            //details views的 title 和 当前维度 名称
            strongVC.titleString = strongVC.chartDetailsView.dimensionName = _pageAnalyticsDimensionArray[i];
            
            //details views的 当前指标 名称
            strongVC.chartDetailsView.indexName = (NSString *)indexNameArray[0];
            strongVC.chartDetailsView.lineView.labelString = (NSString *)indexNameArray[0];
            
            detailsData = (NSDictionary *)((NSDictionary *)[[pageAnalyticsModel sharedInstance] getDetailsData])[(NSString *)_pageAnalyticsDimensionArray[i]];
            
            //detailsview的labels
            [strongVC.chartDetailsView.detailsView reloadLabelsWithData:labelData];
            
            //图表
            [strongVC.chartDetailsView.lineView relodData:detailsData];
            
            //detailsview的数值
            [strongVC.chartDetailsView.detailsView reloadValuesWithData:detailsData];
            
            //添加detailsview的index array选项
            strongVC.indexArray = [[NSMutableArray alloc] initWithArray:indexNameArray];
            
        }
    };
    
    return vc;
}

- (lineChartDetailsViewController *)getTransformAnalyticsControllerByType:(NSInteger)type
{
    _transformAnalyticsChosenDimension = 0;
    
    lineChartDetailsViewController *vc = [[lineChartDetailsViewController alloc] initWithFrame:wkScreen data:nil];
    __block NSDictionary *detailsData;
    __block NSDictionary *labelData = (NSDictionary *)[[transformAnalyticsModel sharedInstance] getDefineDetails];
    
    ///details views的 title 和 当前维度 名称
    vc.titleString = vc.chartDetailsView.dimensionName = _transformAnalyticsDimensionArray[0];
    
    //details views的 当前指标 名称
    vc.chartDetailsView.indexName = _transformAnalyticsIndexArray[type];
    vc.chartDetailsView.lineView.labelString = _transformAnalyticsIndexArray[type];
    
    detailsData = (NSDictionary *)((NSDictionary *)[[transformAnalyticsModel sharedInstance] getDetailsData])[(NSString *)_transformAnalyticsDimensionArray[0]];
    
    //detailsview的数值标题
    [vc addDetailsViewButtonWithData:labelData];
    
    //图表
    [vc addLineViewWithData:detailsData];
    
    //detailsview的数值
    [vc addDetailsViewWithData:detailsData];
    
    vc.dimensionArray = [[NSMutableArray alloc] initWithArray:_transformAnalyticsDimensionArray];
    vc.indexArray = [[NSMutableArray alloc] initWithArray:_transformAnalyticsIndexArray];
    
    __weak typeof(vc) weakVC = vc;
    
    vc.indexChoosedBlock = ^(NSInteger i) {
        if (_transformAnalyticsChosenIndex != i) {
            _transformAnalyticsChosenIndex = i;
            
            typeof(weakVC) strongVC = weakVC;
            NSString *chosenDimensionName = (NSString *)_transformAnalyticsDimensionArray[_transformAnalyticsChosenDimension];
            
            NSArray *indexNameArray = (NSArray *)(NSDictionary *)(labelData[chosenDimensionName])[@"indexOptionsArray"];
            
            strongVC.chartDetailsView.indexName = (NSString *)indexNameArray[i];
            strongVC.chartDetailsView.lineView.labelString = (NSString *)indexNameArray[i];
            
            detailsData = (NSDictionary *)((NSDictionary *)[[transformAnalyticsModel sharedInstance] getDetailsData])[chosenDimensionName];
            
            //图表自动根据labelString 筛选detailsData中得数据 用以绘图
            [strongVC.chartDetailsView.lineView relodData:detailsData];
        }
    };
    
    
    vc.dimensionChoosedBlock = ^(NSInteger i) {
        if (_transformAnalyticsChosenDimension != i) {
            typeof (weakVC) strongVC = weakVC;
            
            _transformAnalyticsChosenDimension = i;
            
            //details views的 指标数组
            NSArray *indexNameArray = (NSArray *)(NSDictionary *)(labelData[_transformAnalyticsDimensionArray[i]])[@"indexOptionsArray"];
            
            //details views的 title 和 当前维度 名称
            strongVC.titleString = strongVC.chartDetailsView.dimensionName = _transformAnalyticsDimensionArray[i];
            
            //details views的 当前指标 名称
            strongVC.chartDetailsView.indexName = (NSString *)indexNameArray[0];
            strongVC.chartDetailsView.lineView.labelString = (NSString *)indexNameArray[0];
            
            detailsData = (NSDictionary *)((NSDictionary *)[[transformAnalyticsModel sharedInstance] getDetailsData])[(NSString *)_transformAnalyticsDimensionArray[i]];
            
            //detailsview的labels
            [strongVC.chartDetailsView.detailsView reloadLabelsWithData:labelData];
            
            //图表
            [strongVC.chartDetailsView.lineView relodData:detailsData];
            
            //detailsview的数值
            [strongVC.chartDetailsView.detailsView reloadValuesWithData:detailsData];
            
            //添加detailsview的index array选项
            strongVC.indexArray = [[NSMutableArray alloc] initWithArray:indexNameArray];
            
        }
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
