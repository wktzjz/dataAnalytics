//
//  sourcesAnalytics.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-11-17.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "sourcesAnalyticsModel.h"
#import "networkManager.h"

static NSString *const sourceAnalyticsDataDidChange                  = @"sourceAnalyticsDataDidChanged";
static NSString *const sourceAnalyticsDetailOutlineDataDidInitialize = @"sourceAnalyticsDetailOutlineDataDidInitialize";
static NSString *const sourceAnalyticsOutlineDataDidInitialize       = @"sourceAnalyticsOutlineDataDidInitialize";

@implementation sourcesAnalyticsModel
{
    __weak id      _wself;
   NSMutableArray *_arrayOfDates;
   NSMutableArray *_groupPercentArray;
   NSMutableArray *_groupValidPercentArray;

}

+ (instancetype)sharedInstance
{
    static sourcesAnalyticsModel *sharedInstance = nil;
    
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
    NSArray *dimensionOptionsArray = @[@"硬广",@"导航",@"搜索",@"广告联盟",@"直接流量",@"EDM"];
    NSArray *indexOptionsArray = @[@"UV",@"PV",@"VISIT",@"新UV",@"有效UV",@"平均页面停留时间",@"提交订单转化率",@"有效订单转化率",@"间接订单数",@"间接订单转化率"];
    
    _defineDetails =  @{@"dimensionOptionsArray":dimensionOptionsArray,
                        @"硬广":@{@"labelStringArray":@[@"运营商",@"垂直",@"DSP"],
                                  @"indexOptionsArray":indexOptionsArray},
                        @"导航":@{@"labelStringArray":@[@"付费导航",@"免费导航"],
                                  @"indexOptionsArray":indexOptionsArray},
                        @"搜索":@{@"labelStringArray":@[@"SEO",@"SEM"],
                                  @"indexOptionsArray":indexOptionsArray},
                        @"广告联盟":@{@"labelStringArray":@[@"广告联盟"],
                                 @"indexOptionsArray":indexOptionsArray},
                        @"直接流量":@{@"labelStringArray":@[@"直接流量"],
                                 @"indexOptionsArray":indexOptionsArray},
                        @"EDM":@{@"labelStringArray":@[@"会员EDM"],
                                  @"indexOptionsArray":indexOptionsArray},
                      };
    
}

- (void)getOutlineData
{
    void (^successefullyBlock)(NSDictionary *data) = ^(NSDictionary *data) {
        sourcesAnalyticsModel *strongSelf = _wself;
        
        for (int i = 0; i < 6; i++) {
            [_groupPercentArray addObject:@(arc4random() % 100)];
            [_groupValidPercentArray addObject:@(arc4random() % 100)];
        }
        
        _outlineData = @{@"groupPercentArray":_groupPercentArray,
                         @"groupValidPercentArray":_groupValidPercentArray,
                         };
        
        NSNotification *notification = [[NSNotification alloc] initWithName:sourceAnalyticsOutlineDataDidInitialize object:strongSelf userInfo:_outlineData];
        
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
        
        sourcesAnalyticsModel *strongSelf = _wself;
        
        NSMutableArray *array1 = [[NSMutableArray alloc] init];
        NSMutableArray *array2 = [[NSMutableArray alloc] init];
        NSMutableArray *array3 = [[NSMutableArray alloc] init];
        NSMutableArray *array4 = [[NSMutableArray alloc] init];
        NSMutableArray *array5 = [[NSMutableArray alloc] init];
        NSMutableArray *array6 = [[NSMutableArray alloc] init];
        NSMutableArray *array7 = [[NSMutableArray alloc] init];
        NSMutableArray *array8 = [[NSMutableArray alloc] init];
        NSMutableArray *array9 = [[NSMutableArray alloc] init];
        NSMutableArray *array10 = [[NSMutableArray alloc] init];
        
        NSArray *parallelArray = @[array1,array2,array3,array4,array5,array6,array7,array8,array9,array10];
        NSMutableArray *arrayofDate = [NSMutableArray array];
        for (int i = 0; i < 20; i++) {
            [arrayofDate addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:i]]];
        }
        
        //同步并行处理数据
        dispatch_apply(10, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
            [strongSelf addNumberToArray:parallelArray[index]];
        });
        
        _detailInitializeData = @{
                            @"arrayOfDates":arrayofDate,
                            @"UV_arrayOfValues":array1,
                            @"PV_arrayOfValues":array2,
                            @"VISIT_arrayOfValues":array3,
                            @"新UV_arrayOfValues":array4,
                            @"有效UV_arrayOfValues":array5,
                            @"平均页面停留时间_arrayOfValues":array6,
                            @"提交订单转化率_arrayOfValues":array7,
                            @"有效订单转化率_arrayOfValues":array8,
                            @"间接订单数_arrayOfValues":array9,
                            @"间接订单转化率_arrayOfValues":array10,
                            @"UV_number":@(arc4random() % 20000),
                            @"PV_number":@(arc4random() % 20000),
                            @"VISIT_number":@(arc4random() % 20000),
                            @"新UV_number":@(arc4random() % 10000),
                            @"有效UV_number":@(arc4random() % 2000),
                            @"平均页面停留时间_number":@(arc4random() % 200),
                            @"提交订单转化率_number":@(arc4random() % 100),
                            @"有效订单转化率_number":@(arc4random() % 100),
                            @"间接订单数_number":@(arc4random() % 1000),
                            @"间接订单转化率_number":@(arc4random() % 100),

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
    NSMutableArray *array7 = [[NSMutableArray alloc] init];
    NSMutableArray *array8 = [[NSMutableArray alloc] init];
    NSMutableArray *array9 = [[NSMutableArray alloc] init];
    NSMutableArray *array10 = [[NSMutableArray alloc] init];
    
    NSArray *parallelArray = @[array1,array2,array3,array4,array5,array6,array7,array8,array9,array10];
    
    //同步并行处理数据
    dispatch_apply(10, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
        [self addNumberToArray:parallelArray[index]];
    });
    
    NSMutableArray *arrayofDate = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        [arrayofDate addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:i]]];
    }
    
//    NSArray *dimensionOptionsArray = @[@"硬广",@"导航",@"搜索",@"广告联盟",@"直接流量",@"EDM"];
//    NSArray *indexOptionsArray = @[@"UV",@"PV",@"VISIT",@"新UV",@"有效UV",@"平均页面停留时间",@"提交订单转化率",@"有效订单转化率",@"间接订单数",@"间接订单转化率"];
//    
//    _defineDetails =  @{@"dimensionOptionsArray":dimensionOptionsArray,
//                        @"硬广":@{@"labelStringArray":@[@"运营商",@"垂直",@"DSP"],
//                                @"indexOptionsArray":indexOptionsArray},
//                        @"导航":@{@"labelStringArray":@[@"付费导航",@"免费导航"],
//                                @"indexOptionsArray":indexOptionsArray},
//                        @"搜索":@{@"labelStringArray":@[@"SEO",@"SEM"],
//                                @"indexOptionsArray":indexOptionsArray},
//                        @"广告联盟":@{@"labelStringArray":@[@"广告联盟"],
//                                  @"indexOptionsArray":indexOptionsArray},
//                        @"直接流量":@{@"labelStringArray":@[@"直接流量"],
//                                  @"indexOptionsArray":indexOptionsArray},
//                        @"EDM":@{@"labelStringArray":@[@"会员EDM"],
//                                 @"indexOptionsArray":indexOptionsArray},
//                        };

    
    _detailsData =  @{ @"硬广":@{
                               @"labelValues":@[@(arc4random() % 2000),@(arc4random() % 2000),@(arc4random() % 2000)],
                               @"arrayOfDates":arrayofDate,
                               @"UV_arrayOfValues":array1,@"PV_arrayOfValues":array2,@"VISIT_arrayOfValues":array3,@"新UV_arrayOfValues":array4,@"有效UV_arrayOfValues":array5,@"平均页面停留时间_arrayOfValues":array6,@"提交订单转化率_arrayOfValues":array7,@"有效订单转化率_arrayOfValues":array8,@"间接订单数_arrayOfValues":array9,@"间接订单转化率_arrayOfValues":array10,
                               @"UV_number":@(arc4random() % 20000),@"PV_number":@(arc4random() % 20000),@"VISIT_number":@(arc4random() % 20000),@"新UV_number":@(arc4random() % 10000),@"有效UV_number":@(arc4random() % 2000),@"平均页面停留时间_number":@(arc4random() % 200),@"提交订单转化率_number":@(arc4random() % 100),@"有效订单转化率_number":@(arc4random() % 100),@"间接订单数_number":@(arc4random() % 10000),@"间接订单转化率_number":@(arc4random() % 100),
                               },
                       @"导航":@{
                               @"labelValues":@[@(arc4random() % 2000),@(arc4random() % 2000)],
                               @"arrayOfDates":arrayofDate,
                               @"UV_arrayOfValues":array1,@"PV_arrayOfValues":array2,@"VISIT_arrayOfValues":array3,@"新UV_arrayOfValues":array4,@"有效UV_arrayOfValues":array5,@"平均页面停留时间_arrayOfValues":array6,@"提交订单转化率_arrayOfValues":array7,@"有效订单转化率_arrayOfValues":array8,@"间接订单数_arrayOfValues":array9,@"间接订单转化率_arrayOfValues":array10,
                               @"UV_number":@(arc4random() % 20000),@"PV_number":@(arc4random() % 20000),@"VISIT_number":@(arc4random() % 20000),@"新UV_number":@(arc4random() % 10000),@"有效UV_number":@(arc4random() % 2000),@"平均页面停留时间_number":@(arc4random() % 200),@"提交订单转化率_number":@(arc4random() % 100),@"有效订单转化率_number":@(arc4random() % 100),@"间接订单数_number":@(arc4random() % 10000),@"间接订单转化率_number":@(arc4random() % 100),
                               },
                       @"搜索":@{
                               @"labelValues":@[@(arc4random() % 20000),@(arc4random() % 20000)],
                               @"arrayOfDates":arrayofDate,
                               @"UV_arrayOfValues":array1,@"PV_arrayOfValues":array2,@"VISIT_arrayOfValues":array3,@"新UV_arrayOfValues":array4,@"有效UV_arrayOfValues":array5,@"平均页面停留时间_arrayOfValues":array6,@"提交订单转化率_arrayOfValues":array7,@"有效订单转化率_arrayOfValues":array8,@"间接订单数_arrayOfValues":array9,@"间接订单转化率_arrayOfValues":array10,
                               @"UV_number":@(arc4random() % 20000),@"PV_number":@(arc4random() % 20000),@"VISIT_number":@(arc4random() % 20000),@"新UV_number":@(arc4random() % 10000),@"有效UV_number":@(arc4random() % 2000),@"平均页面停留时间_number":@(arc4random() % 200),@"提交订单转化率_number":@(arc4random() % 100),@"有效订单转化率_number":@(arc4random() % 100),@"间接订单数_number":@(arc4random() % 10000),@"间接订单转化率_number":@(arc4random() % 100),
                               },
                       @"广告联盟":@{
                               @"labelValues":@[@(arc4random() % 10000)],
                               @"arrayOfDates":arrayofDate,
                               @"UV_arrayOfValues":array1,@"PV_arrayOfValues":array2,@"VISIT_arrayOfValues":array3,@"新UV_arrayOfValues":array4,@"有效UV_arrayOfValues":array5,@"平均页面停留时间_arrayOfValues":array6,@"提交订单转化率_arrayOfValues":array7,@"有效订单转化率_arrayOfValues":array8,@"间接订单数_arrayOfValues":array9,@"间接订单转化率_arrayOfValues":array10,
                               @"UV_number":@(arc4random() % 20000),@"PV_number":@(arc4random() % 20000),@"VISIT_number":@(arc4random() % 20000),@"新UV_number":@(arc4random() % 10000),@"有效UV_number":@(arc4random() % 2000),@"平均页面停留时间_number":@(arc4random() % 200),@"提交订单转化率_number":@(arc4random() % 100),@"有效订单转化率_number":@(arc4random() % 100),@"间接订单数_number":@(arc4random() % 10000),@"间接订单转化率_number":@(arc4random() % 100),
                               },
                       @"直接流量":@{
                               @"labelValues":@[@(arc4random() % 20000)],
                               @"arrayOfDates":arrayofDate,
                               @"UV_arrayOfValues":array1,@"PV_arrayOfValues":array2,@"VISIT_arrayOfValues":array3,@"新UV_arrayOfValues":array4,@"有效UV_arrayOfValues":array5,@"平均页面停留时间_arrayOfValues":array6,@"提交订单转化率_arrayOfValues":array7,@"有效订单转化率_arrayOfValues":array8,@"间接订单数_arrayOfValues":array9,@"间接订单转化率_arrayOfValues":array10,
                               @"UV_number":@(arc4random() % 20000),@"PV_number":@(arc4random() % 20000),@"VISIT_number":@(arc4random() % 20000),@"新UV_number":@(arc4random() % 10000),@"有效UV_number":@(arc4random() % 2000),@"平均页面停留时间_number":@(arc4random() % 200),@"提交订单转化率_number":@(arc4random() % 100),@"有效订单转化率_number":@(arc4random() % 100),@"间接订单数_number":@(arc4random() % 10000),@"间接订单转化率_number":@(arc4random() % 100),
                               },
                       @"EDM":@{
                               @"labelValues":@[@(arc4random() % 20000)],
                               @"arrayOfDates":arrayofDate,
                               @"UV_arrayOfValues":array1,@"PV_arrayOfValues":array2,@"VISIT_arrayOfValues":array3,@"新UV_arrayOfValues":array4,@"有效UV_arrayOfValues":array5,@"平均页面停留时间_arrayOfValues":array6,@"提交订单转化率_arrayOfValues":array7,@"有效订单转化率_arrayOfValues":array8,@"间接订单数_arrayOfValues":array9,@"间接订单转化率_arrayOfValues":array10,
                               @"UV_number":@(arc4random() % 20000),@"PV_number":@(arc4random() % 20000),@"VISIT_number":@(arc4random() % 20000),@"新UV_number":@(arc4random() % 10000),@"有效UV_number":@(arc4random() % 2000),@"平均页面停留时间_number":@(arc4random() % 200),@"提交订单转化率_number":@(arc4random() % 100),@"有效订单转化率_number":@(arc4random() % 100),@"间接订单数_number":@(arc4random() % 10000),@"间接订单转化率_number":@(arc4random() % 100),
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
