//
//  pageAnalyticsModel.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-12-2.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "pageAnalyticsModel.h"

#import "networkManager.h"

static NSString *const pageAnalyticsDataDidChange                  = @"pageAnalyticsDataDidChanged";
static NSString *const pageAnalyticsDetailOutlineDataDidInitialize = @"pageAnalyticsDetailOutlineDataDidInitialize";
static NSString *const pageAnalyticsOutlineDataDidInitialize       = @"pageAnalyticsOutlineDataDidInitialize";

@implementation pageAnalyticsModel
{
    __weak id      _wself;
    NSMutableArray *_arrayOfDates;
    NSMutableArray *_groupPercentArray;
    NSMutableArray *_groupValidPercentArray;
    
}

+ (instancetype)sharedInstance
{
    static pageAnalyticsModel *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] _init];
    });
    
    return sharedInstance;
}

- (instancetype)_init
{
    self = [super init];
    
    if (self) {
        _groupPercentArray = [[NSMutableArray alloc] initWithCapacity:6];
        _groupValidPercentArray = [[NSMutableArray alloc] initWithCapacity:6];
        
        _wself = self;
        
    }
    
    return self;
}

- (NSDictionary *)getDefineDetails
{
    if (!_defineDetails) {
        [self createDefineDetails];
        return _defineDetails;
    }else{
        return _defineDetails;
    }
}

- (void)createDefineDetails
{
    NSArray *dimensionOptionsArray = @[@"页面类型",@"着陆页",@"退出页"];
    NSArray *indexOptionsArray     = @[@"PV",@"UV",@"平均页面停留时间",@"一跳",@"四级页面PV",@"购物车PV"];
    NSArray *indexOptionsArray1    = @[@"PV",@"退出次数",@"退出率",@"退出占比"];
    
    _defineDetails =  @{@"dimensionOptionsArray":dimensionOptionsArray,
                        @"页面类型":@{@"labelStringArray":@[@"苏宁易购首页",@"商品四级页面"],
                                   @"indexOptionsArray":indexOptionsArray},
                        @"着陆页":@{@"labelStringArray":@[@"苏宁易购首页"],
                                 @"indexOptionsArray":indexOptionsArray},
                        @"退出页":@{@"labelStringArray":@[@"苏宁易购首页",@"商品四级页面"],
                                 @"indexOptionsArray":indexOptionsArray1},
                        };
    
}

- (void)getOutlineData
{
    void (^successefullyBlock)(NSDictionary *data) = ^(NSDictionary *data) {
        pageAnalyticsModel *strongSelf = _wself;
        
        _outlineData = @{@"PV":@(arc4random() % 100000),
                         @"fourthPagePV":@(arc4random() % 10000),
                         @"shoppingCartPV":@(arc4random() % 10000)
                         };
        
        NSNotification *notification = [[NSNotification alloc] initWithName:pageAnalyticsOutlineDataDidInitialize object:strongSelf userInfo:_outlineData];
        
        // 异步处理通知
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                       postingStyle:NSPostASAP
                                                       coalesceMask:NSNotificationCoalescingOnName forModes:@[NSDefaultRunLoopMode]];
        });
    };
    
    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:nil failureBlock:successefullyBlock successedBlock:successefullyBlock];
}

- (NSDictionary *)getDetailOutlineData
{
    if (!_detailInitializeData) {
        [self createDetailOutlineData];
        return _detailInitializeData;
    }else{
        return _detailInitializeData;
    }
}

- (void)createDetailOutlineData
{
    void (^successefullyBlock)(NSDictionary *) = ^(NSDictionary *data) {
        
        pageAnalyticsModel *strongSelf = _wself;
        
        NSMutableArray *array1 = [[NSMutableArray alloc] init];
        NSMutableArray *array2 = [[NSMutableArray alloc] init];
        NSMutableArray *array3 = [[NSMutableArray alloc] init];
        NSMutableArray *array4 = [[NSMutableArray alloc] init];
        NSMutableArray *array5 = [[NSMutableArray alloc] init];
        NSMutableArray *array6 = [[NSMutableArray alloc] init];

        NSArray *parallelArray = @[array1,array2,array3,array4,array5,array6];
        NSMutableArray *arrayofDate = [NSMutableArray array];
        for (int i = 0; i < 20; i++) {
            [arrayofDate addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:i]]];
        }
        
        //同步并行处理数据
        dispatch_apply(6, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
            [strongSelf addNumberToArray:parallelArray[index]];
        });

        _detailInitializeData = @{
                                  @"arrayOfDates":arrayofDate,
                                  @"PV_arrayOfValues":array1,
                                  @"UV_arrayOfValues":array2,
                                  @"平均页面停留时间_arrayOfValues":array3,
                                  @"一跳_arrayOfValues":array4,
                                  @"四级页面PV_arrayOfValues":array5,
                                  @"购物车PV_arrayOfValues":array6,
                                  @"PV_number":@(arc4random() % 20000),
                                  @"UV_number":@(arc4random() % 10000),
                                  @"平均页面停留时间_number":@(arc4random() % 200),
                                  @"一跳_number":@(arc4random() % 1000),
                                  @"四级页面PV_number":@(arc4random() % 10000),
                                  @"购物车PV_number":@(arc4random() % 10000),
                                  };
        
        _initializeDataReady = YES;
        
        //        NSNotification *notification = [[NSNotification alloc] initWithName:dataDidInitialize object:strongSelf userInfo:_initializeData];
        //
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            [[NSNotificationQueue defaultQueue] enqueueNotification:notification
        //                                                       postingStyle:NSPostASAP
        //                                                       coalesceMask:NSNotificationCoalescingOnName forModes:@[NSDefaultRunLoopMode]];
        //        });
        
    };
    
    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:nil failureBlock:successefullyBlock successedBlock:successefullyBlock];
}

- (NSDictionary *)getDetailsData
{
    if (!_detailsData) {
        [self createDetailsData];
        return _detailsData;
    }else{
        return _detailsData;
    }
}

- (void)createDetailsData
{
    NSMutableArray *array1 = [[NSMutableArray alloc] init];
    NSMutableArray *array2 = [[NSMutableArray alloc] init];
    NSMutableArray *array3 = [[NSMutableArray alloc] init];
    NSMutableArray *array4 = [[NSMutableArray alloc] init];
    NSMutableArray *array5 = [[NSMutableArray alloc] init];
    NSMutableArray *array6 = [[NSMutableArray alloc] init];
    
    NSArray *parallelArray = @[array1,array2,array3,array4,array5,array6];
    
    //同步并行处理数据
    dispatch_apply(6, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
        [self addNumberToArray:parallelArray[index]];
    });
    
    NSMutableArray *arrayofDate = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        [arrayofDate addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:i]]];
    }
    
//    NSArray *dimensionOptionsArray = @[@"页面类型",@"着陆页",@"退出页"];
//    NSArray *indexOptionsArray     = @[@"PV",@"UV",@"平均页面停留时间",@"一跳",@"四级页面PV",@"购物车PV"];
//    NSArray *indexOptionsArray1    = @[@"PV",@"退出次数",@"退出率",@"退出占比"];
//
//    _defineDetails =  @{@"dimensionOptionsArray":dimensionOptionsArray,
//                        @"页面类型":@{@"labelStringArray":@[@"苏宁易购首页",@"商品四级页面"],
//                                  @"indexOptionsArray":indexOptionsArray},
//                        @"着陆页":@{@"labelStringArray":@[@"苏宁易购首页"],
//                                 @"indexOptionsArray":indexOptionsArray},
//                        @"退出页":@{@"labelStringArray":@[@"苏宁易购首页",@"商品四级页面"],
//                                 @"indexOptionsArray":indexOptionsArray1},
//                        };
    
    
    _detailsData =  @{ @"页面类型":@{
                               @"labelValues":@[@(arc4random() % 20000),@(arc4random() % 20000)],
                               @"arrayOfDates":arrayofDate,
                               @"PV_arrayOfValues":array1,@"UV_arrayOfValues":array2,@"平均页面停留时间_arrayOfValues":array3,@"一跳_arrayOfValues":array4,@"四级页面PV_arrayOfValues":array5,@"购物车PV_arrayOfValues":array6,
                               @"PV_number":@(arc4random() % 20000),@"UV_number":@(arc4random() % 20000),@"平均页面停留时间_number":@(arc4random() % 100),@"一跳_number":@(arc4random() % 10000),@"四级页面PV_number":@(arc4random() % 20000),@"购物车PV_number":@(arc4random() % 20000)
                               },
                       @"着陆页":@{
                               @"labelValues":@[@(arc4random() % 20000)],
                               @"arrayOfDates":arrayofDate,
                               @"PV_arrayOfValues":array1,@"UV_arrayOfValues":array2,@"平均页面停留时间_arrayOfValues":array3,@"一跳_arrayOfValues":array4,@"四级页面PV_arrayOfValues":array5,@"购物车PV_arrayOfValues":array6,
                               @"PV_number":@(arc4random() % 20000),@"UV_number":@(arc4random() % 20000),@"平均页面停留时间_number":@(arc4random() % 100),@"一跳_number":@(arc4random() % 10000),@"四级页面PV_number":@(arc4random() % 20000),@"购物车PV_number":@(arc4random() % 20000)
                               },
                       @"退出页":@{
                               @"labelValues":@[@(arc4random() % 20000),@(arc4random() % 20000)],
                               @"arrayOfDates":arrayofDate,
                               @"PV_arrayOfValues":array1,@"退出次数_arrayOfValues":array2,@"退出率_arrayOfValues":array3,@"退出占比_arrayOfValues":array4,
                               @"PV_number":@(arc4random() % 20000),@"退出次数_number":@(arc4random() % 20000),@"退出率_number":@(arc4random() % 100),@"退出占比_number":@(arc4random() % 100)
                               },
                };
    
}


- (void)addNumberToArray:(NSMutableArray *)array
{
    for (int i = 0; i < 20; i++) {
        [array addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
    }
}

@end
