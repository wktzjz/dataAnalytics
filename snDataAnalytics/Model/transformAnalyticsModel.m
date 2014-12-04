//
//  transformAnalyticsModel.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-12-3.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "transformAnalyticsModel.h"
#import "networkManager.h"

static NSString *const transformAnalyticsDataDidChange                  = @"transformAnalyticsDataDidChanged";
static NSString *const transformAnalyticsDetailOutlineDataDidInitialize = @"transformAnalyticsDetailOutlineDataDidInitialize";
static NSString *const transformAnalyticsOutlineDataDidInitialize       = @"transformAnalyticsOutlineDataDidInitialize";

@implementation transformAnalyticsModel
{
    __weak id      _wself;
}

+ (instancetype)sharedInstance
{
    static transformAnalyticsModel *sharedInstance = nil;
    
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
    NSArray *dimensionOptionsArray = @[@"来源",@"城市分布",@"访客类型",@"商品分析"];
    NSArray *indexOptionsArray     = @[@"UV",@"PV",@"VISIT",@"新UV",@"有效UV",@"平均页面停留时间",@"注册数",@"注册转化率",@"提交订单数",@"提交订单转化率",@"有效订单数",@"有效订单转化率",@"付款金额"];
    
    _defineDetails =  @{@"dimensionOptionsArray":dimensionOptionsArray,
                        @"来源":@{@"labelStringArray":@[@"硬广",@"导航"],
                                  @"indexOptionsArray":indexOptionsArray},
                        @"城市分布":@{@"labelStringArray":@[@"南京市",@"上海市"],
                                 @"indexOptionsArray":indexOptionsArray},
                        @"访客类型":@{@"labelStringArray":@[@"新访客",@"回访客"],
                                 @"indexOptionsArray":indexOptionsArray},
                        @"商品分析":@{@"labelStringArray":@[@"通讯",@"黑电"],
                                  @"indexOptionsArray":indexOptionsArray},
                        };
    
}

- (void)getOutlineData
{
    void (^successefullyBlock)(NSDictionary *data) = ^(NSDictionary *data) {
        transformAnalyticsModel *strongSelf = _wself;
        
        _outlineData = @{@"paidMoney":@(arc4random() % 1000000),
                         @"validDeal":@(arc4random() % 100000),
                         @"validDealConversion":@(arc4random() % 100)
                         };
        
        NSNotification *notification = [[NSNotification alloc] initWithName:transformAnalyticsOutlineDataDidInitialize object:strongSelf userInfo:_outlineData];
        
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
        
        transformAnalyticsModel *strongSelf = _wself;
        
        NSMutableArray *parallelArray = [[NSMutableArray alloc] initWithCapacity:13];
        for(int i = 0; i < 13; i++){
            [parallelArray addObject:[[NSMutableArray alloc] init]];
        }
        
        NSMutableArray *arrayofDate = [NSMutableArray array];
        for (int i = 0; i < 20; i++) {
            [arrayofDate addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:i]]];
        }
        
        //同步并行处理数据
        dispatch_apply(13, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
            [strongSelf addNumberToArray:parallelArray[index]];
        });
        
        _detailInitializeData = @{
                                  @"arrayOfDates":arrayofDate,
                                  @"UV_arrayOfValues":parallelArray[0],
                                  @"PV_arrayOfValues":parallelArray[1],
                                  @"VISIT_arrayOfValues":parallelArray[2],
                                  @"新UV_arrayOfValues":parallelArray[3],
                                  @"有效UV_arrayOfValues":parallelArray[4],
                                  @"平均页面停留时间_arrayOfValues":parallelArray[5],
                                  @"注册数_arrayOfValues":parallelArray[6],
                                  @"注册转化率_arrayOfValues":parallelArray[7],
                                  @"提交订单数_arrayOfValues":parallelArray[8],
                                  @"提交订单转化率_arrayOfValues":parallelArray[9],
                                  @"有效订单数_arrayOfValues":parallelArray[10],
                                  @"有效订单转化率_arrayOfValues":parallelArray[11],
                                  @"付款金额_arrayOfValues":parallelArray[12],
                                  @"UV_number":@(arc4random() % 20000),
                                  @"PV_number":@(arc4random() % 20000),
                                  @"VISIT_number":@(arc4random() % 20000),
                                  @"新UV_number":@(arc4random() % 10000),
                                  @"有效UV_number":@(arc4random() % 2000),
                                  @"平均页面停留时间_number":@(arc4random() % 200),
                                  @"注册数_number":@(arc4random() % 2000),
                                  @"注册转化率_number":@(arc4random() % 100),
                                  @"提交订单数_number":@(arc4random() % 10000),
                                  @"提交订单转化率_number":@(arc4random() % 100),
                                  @"有效订单数_number":@(arc4random() % 10000),
                                  @"有效订单转化率_number":@(arc4random() % 100),
                                  @"付款金额_number":@(arc4random() % 10000),

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
    NSMutableArray *parallelArray = [[NSMutableArray alloc] initWithCapacity:13];
    for(int i = 0; i < 13; i++){
        [parallelArray addObject:[[NSMutableArray alloc] init]];
    }
    
    //同步并行处理数据
    dispatch_apply(13, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
        [self addNumberToArray:parallelArray[index]];
    });
    
    NSMutableArray *arrayofDate = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        [arrayofDate addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:i]]];
    }
    
//    NSArray *dimensionOptionsArray = @[@"来源",@"城市分布",@"访客类型",@"商品分析"];
//    NSArray *indexOptionsArray     = @[@"UV",@"PV",@"VISIT",@"新UV",@"有效UV",@"平均页面停留时间",@"注册数",@"注册转化率",@"提交订单数",@"提交订单转化率",@"有效订单数",@"有效订单转化率",@"付款金额"];
//    
//    _defineDetails =  @{@"dimensionOptionsArray":dimensionOptionsArray,
//                        @"来源":@{@"labelStringArray":@[@"硬广",@"导航"],
//                                @"indexOptionsArray":indexOptionsArray},
//                        @"城市分布":@{@"labelStringArray":@[@"南京市",@"上海市"],
//                                  @"indexOptionsArray":indexOptionsArray},
//                        @"访客类型":@{@"labelStringArray":@[@"新访客",@"回访客"],
//                                  @"indexOptionsArray":indexOptionsArray},
//                        @"商品分析":@{@"labelStringArray":@[@"通讯",@"黑电"],
//                                  @"indexOptionsArray":indexOptionsArray},
//                        };
    
    
    _detailsData =  @{ @"来源":@{
                               @"labelValues":@[@(arc4random() % 20000),@(arc4random() % 20000)],
                               @"arrayOfDates":arrayofDate,
                               @"UV_arrayOfValues":parallelArray[0],
                               @"PV_arrayOfValues":parallelArray[1],
                               @"VISIT_arrayOfValues":parallelArray[2],
                               @"新UV_arrayOfValues":parallelArray[3],
                               @"有效UV_arrayOfValues":parallelArray[4],
                               @"平均页面停留时间_arrayOfValues":parallelArray[5],
                               @"注册数_arrayOfValues":parallelArray[6],
                               @"注册转化率_arrayOfValues":parallelArray[7],
                               @"提交订单数_arrayOfValues":parallelArray[8],
                               @"提交订单转化率_arrayOfValues":parallelArray[9],
                               @"有效订单数_arrayOfValues":parallelArray[10],
                               @"有效订单转化率_arrayOfValues":parallelArray[11],
                               @"付款金额_arrayOfValues":parallelArray[12],
                               @"UV_number":@(arc4random() % 20000),
                               @"PV_number":@(arc4random() % 20000),
                               @"VISIT_number":@(arc4random() % 20000),
                               @"新UV_number":@(arc4random() % 10000),
                               @"有效UV_number":@(arc4random() % 2000),
                               @"平均页面停留时间_number":@(arc4random() % 200),
                               @"注册数_number":@(arc4random() % 2000),
                               @"注册转化率_number":@(arc4random() % 100),
                               @"提交订单数_number":@(arc4random() % 10000),
                               @"提交订单转化率_number":@(arc4random() % 100),
                               @"有效订单数_number":@(arc4random() % 10000),
                               @"有效订单转化率_number":@(arc4random() % 100),
                               @"付款金额_number":@(arc4random() % 10000),

                               },
                       @"城市分布":@{
                               @"labelValues":@[@(arc4random() % 20000),@(arc4random() % 20000)],
                               @"UV_arrayOfValues":parallelArray[0],
                               @"PV_arrayOfValues":parallelArray[1],
                               @"VISIT_arrayOfValues":parallelArray[2],
                               @"新UV_arrayOfValues":parallelArray[3],
                               @"有效UV_arrayOfValues":parallelArray[4],
                               @"平均页面停留时间_arrayOfValues":parallelArray[5],
                               @"注册数_arrayOfValues":parallelArray[6],
                               @"注册转化率_arrayOfValues":parallelArray[7],
                               @"提交订单数_arrayOfValues":parallelArray[8],
                               @"提交订单转化率_arrayOfValues":parallelArray[9],
                               @"有效订单数_arrayOfValues":parallelArray[10],
                               @"有效订单转化率_arrayOfValues":parallelArray[11],
                               @"付款金额_arrayOfValues":parallelArray[12],
                               @"UV_number":@(arc4random() % 20000),
                               @"PV_number":@(arc4random() % 20000),
                               @"VISIT_number":@(arc4random() % 20000),
                               @"新UV_number":@(arc4random() % 10000),
                               @"有效UV_number":@(arc4random() % 2000),
                               @"平均页面停留时间_number":@(arc4random() % 200),
                               @"注册数_number":@(arc4random() % 2000),
                               @"注册转化率_number":@(arc4random() % 100),
                               @"提交订单数_number":@(arc4random() % 10000),
                               @"提交订单转化率_number":@(arc4random() % 100),
                               @"有效订单数_number":@(arc4random() % 10000),
                               @"有效订单转化率_number":@(arc4random() % 100),
                               @"付款金额_number":@(arc4random() % 10000),

                               },
                       @"访客类型":@{
                               @"labelValues":@[@(arc4random() % 20000),@(arc4random() % 20000)],
                               @"UV_arrayOfValues":parallelArray[0],
                               @"PV_arrayOfValues":parallelArray[1],
                               @"VISIT_arrayOfValues":parallelArray[2],
                               @"新UV_arrayOfValues":parallelArray[3],
                               @"有效UV_arrayOfValues":parallelArray[4],
                               @"平均页面停留时间_arrayOfValues":parallelArray[5],
                               @"注册数_arrayOfValues":parallelArray[6],
                               @"注册转化率_arrayOfValues":parallelArray[7],
                               @"提交订单数_arrayOfValues":parallelArray[8],
                               @"提交订单转化率_arrayOfValues":parallelArray[9],
                               @"有效订单数_arrayOfValues":parallelArray[10],
                               @"有效订单转化率_arrayOfValues":parallelArray[11],
                               @"付款金额_arrayOfValues":parallelArray[12],
                               @"UV_number":@(arc4random() % 20000),
                               @"PV_number":@(arc4random() % 20000),
                               @"VISIT_number":@(arc4random() % 20000),
                               @"新UV_number":@(arc4random() % 10000),
                               @"有效UV_number":@(arc4random() % 2000),
                               @"平均页面停留时间_number":@(arc4random() % 200),
                               @"注册数_number":@(arc4random() % 2000),
                               @"注册转化率_number":@(arc4random() % 100),
                               @"提交订单数_number":@(arc4random() % 10000),
                               @"提交订单转化率_number":@(arc4random() % 100),
                               @"有效订单数_number":@(arc4random() % 10000),
                               @"有效订单转化率_number":@(arc4random() % 100),
                               @"付款金额_number":@(arc4random() % 10000),

                               },
                       @"商品分析":@{
                               @"labelValues":@[@(arc4random() % 20000),@(arc4random() % 20000)],
                               @"UV_arrayOfValues":parallelArray[0],
                               @"PV_arrayOfValues":parallelArray[1],
                               @"VISIT_arrayOfValues":parallelArray[2],
                               @"新UV_arrayOfValues":parallelArray[3],
                               @"有效UV_arrayOfValues":parallelArray[4],
                               @"平均页面停留时间_arrayOfValues":parallelArray[5],
                               @"注册数_arrayOfValues":parallelArray[6],
                               @"注册转化率_arrayOfValues":parallelArray[7],
                               @"提交订单数_arrayOfValues":parallelArray[8],
                               @"提交订单转化率_arrayOfValues":parallelArray[9],
                               @"有效订单数_arrayOfValues":parallelArray[10],
                               @"有效订单转化率_arrayOfValues":parallelArray[11],
                               @"付款金额_arrayOfValues":parallelArray[12],
                               @"UV_number":@(arc4random() % 20000),
                               @"PV_number":@(arc4random() % 20000),
                               @"VISIT_number":@(arc4random() % 20000),
                               @"新UV_number":@(arc4random() % 10000),
                               @"有效UV_number":@(arc4random() % 2000),
                               @"平均页面停留时间_number":@(arc4random() % 200),
                               @"注册数_number":@(arc4random() % 2000),
                               @"注册转化率_number":@(arc4random() % 100),
                               @"提交订单数_number":@(arc4random() % 10000),
                               @"提交订单转化率_number":@(arc4random() % 100),
                               @"有效订单数_number":@(arc4random() % 10000),
                               @"有效订单转化率_number":@(arc4random() % 100),
                               @"付款金额_number":@(arc4random() % 10000),

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
