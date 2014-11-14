//
//  visitorGroupData.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-21.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "visitorGroupModel.h"
#import "networkManager.h"
#import "PNColor.h"

static NSString *const dataDidChange     = @"visitorGroupDataDidChanged";
static NSString *const dataDidInitialize = @"visitorGroupDataDidInitialize";

@implementation visitorGroupModel
{
    NSDictionary *_sendDict;
    __weak id      _wself ;
    NSArray *_groupColorArray;
    NSArray *_groupPercentArray;
}

+ (instancetype)sharedInstance
{
    static visitorGroupModel *sharedInstance = nil;
    
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
        _arrayOfDates = [[NSMutableArray alloc] init];
//        _defineDetails = [NSDictionary dictionary];

    }

    return self;
}

- (void)addNumberToArray:(NSMutableArray *)array
{
    for (int i = 0; i < 20; i++) {
        [array addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
    }
}

- (void)getDetailOutlineData
{
    void (^successefullyBlock)(NSDictionary *data) = ^(NSDictionary *data){
        visitorGroupModel *strongSelf = _wself;
        _sendDict = @{};
        
        NSNotification *notification = [[NSNotification alloc] initWithName:dataDidChange object:strongSelf userInfo:_sendDict];

        // 异步处理通知
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                       postingStyle:NSPostASAP
                                                       coalesceMask:NSNotificationCoalescingOnName forModes:@[NSDefaultRunLoopMode]];
        });
    };
    
    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:nil failureBlock:successefullyBlock successedBlock:successefullyBlock];
}

- (NSDictionary *)getInitializeData
{
    if(!_initializeData){
        [self createInitializeData];
        return _initializeData;
    }else{
        return _initializeData;
    }
}

- (void)createInitializeData
{
    void (^successefullyBlock)(NSDictionary *) = ^(NSDictionary *data){
        
        _groupUV = arc4random() % 20000;
        float validUVRatio = ((arc4random() % 500) + 500) / 1000.0;
        _validGroupUV = _groupUV * validUVRatio;
        _visitor = arc4random() % 30000;
        
        _groupPercentArray = @[@15,@30,@55];
        _groupColorArray = @[PNLightGreen,PNFreshGreen,PNDeepGreen];
        
        visitorGroupModel *strongSelf = _wself;
        
        NSMutableArray *array1 = [[NSMutableArray alloc] init];
        NSMutableArray *array2 = [[NSMutableArray alloc] init];
        NSMutableArray *array3 = [[NSMutableArray alloc] init];
        NSMutableArray *array4 = [[NSMutableArray alloc] init];
        NSMutableArray *array5 = [[NSMutableArray alloc] init];
        NSMutableArray *array6 = [[NSMutableArray alloc] init];
        NSMutableArray *array7 = [[NSMutableArray alloc] init];
        NSMutableArray *array8 = [[NSMutableArray alloc] init];
        
        NSArray *parallelArray = @[array1,array2,array3,array4,array5,array6,array7,array8];
        for (int i = 0; i < 20; i++) {
            [_arrayOfDates addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:i]]];
            
            //                [array1 addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
            //                [array2 addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
            //                [array3 addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
            //                [array4 addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
            //                [array5 addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
            //                [array6 addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
            //                [array7 addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
            //                [array8 addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
            
            // Random values for the graph
        }
        
        //同步并行处理数据
        dispatch_apply(8, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
            [strongSelf addNumberToArray:parallelArray[index]];
        });
        
        _initializeData = @{@"groupUV":@(_groupUV),@"visitor":@(_visitor),@"validGroupUV":@(_validGroupUV),@"groupPercentArray":_groupPercentArray,@"groupColorArray":_groupColorArray,@"arrayOfDates":_arrayOfDates,@"UV_arrayOfValues":array1,@"PV_arrayOfValues":array2,@"Visitor_arrayOfValues":array3,@"新UV_arrayOfValues":array4,@"有效UV_arrayOfValues":array5,@"平均页面停留时间_arrayOfValues":array6,@"提交订单转化率_arrayOfValues":array7,@"有效订单转化率_arrayOfValues":array8,
                            @"UV_number":@(arc4random() % 20000),@"PV_number":@(arc4random() % 20000),@"Visitor_number":@(arc4random() % 20000),@"新UV_number":@(arc4random() % 10000),@"有效UV_number":@(arc4random() % 2000),@"平均页面停留时间_number":@(arc4random() % 200),@"提交订单转化率_number":@(arc4random() % 100),@"有效订单转化率_number":@(arc4random() % 100)};
        
        _initializeDataReady = YES;
        
        NSNotification *notification = [[NSNotification alloc] initWithName:dataDidInitialize object:strongSelf userInfo:_initializeData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                       postingStyle:NSPostASAP
                                                       coalesceMask:NSNotificationCoalescingOnName forModes:@[NSDefaultRunLoopMode]];
        });
        
    };
    
    
    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:nil failureBlock:successefullyBlock successedBlock:successefullyBlock];
}

- (NSDictionary *)getDefineDetails
{
    if(!_defineDetails){
        [self initDefineDetails];
        return _defineDetails;
    }else{
        return _defineDetails;
    }
}

- (void)initDefineDetails
{
    NSArray *dimensionOptionsArray = @[@"访客类型",@"终端类型",@"整体会员",@"新会员",@"老会员",@"会员等级",@"城市分布"];
    NSArray *indexOptionsArray1 = @[@"UV",@"PV",@"Visitor",@"新UV",@"有效UV",@"平均页面停留时间",@"提交订单转化率",@"有效订单转化率"];
    NSArray *indexOptionsArray2 = @[@"访问会员数",@"买家数",@"购买率",@"客单价",@"平均订单收入"];
    NSArray *indexOptionsArray3 = @[@"注册数",@"买家数",@"购买率",@"客单价",@"平均订单收入"];
    NSArray *indexOptionsArray4 = @[@"回访数",@"买家数",@"首购率",@"复购率",@"客单价",@"平均订单收入"];
    NSArray *indexOptionsArray5 = @[@"访问会员数",@"买家数",@"购买率",@"客单价",@"平均订单收入"];
    
    _defineDetails =  @{@"dimensionOptionsArray":dimensionOptionsArray,
                       @"访客类型":@{@"labelStringArray":@[@"新访客",@"回访客"],
                                 @"indexOptionsArray":indexOptionsArray1},
                       @"终端类型":@{@"labelStringArray":@[@"PC",@"WAP",@"APP"],
                                 @"indexOptionsArray":indexOptionsArray1},
                       @"整体会员":@{@"labelStringArray":@[@"会员"],
                                  @"indexOptionsArray":indexOptionsArray2},
                       @"新会员":@{@"labelStringArray":@[@"新会员"],
                                @"indexOptionsArray":indexOptionsArray3},
                       @"老会员":@{@"labelStringArray":@[@"老会员"],
                                @"indexOptionsArray":indexOptionsArray4},
                       @"会员等级":@{@"labelStringArray":@[@"普通会员",@"银卡会员",@"金卡会员",@"白金会员"],
                                 @"indexOptionsArray":indexOptionsArray5},
                       @"城市分布":@{@"labelStringArray":@[@"南京",@"上海",@"北京"],
                                 @"indexOptionsArray":indexOptionsArray1},
                       };

}

- (NSDictionary *)getDetailsData
{
    if(!_detailsData){
        [self initDetailsData];
        return _detailsData;
    }else{
        return _detailsData;
    }
}

- (void)initDetailsData
{
    NSMutableArray *array1 = [[NSMutableArray alloc] init];
    NSMutableArray *array2 = [[NSMutableArray alloc] init];
    NSMutableArray *array3 = [[NSMutableArray alloc] init];
    NSMutableArray *array4 = [[NSMutableArray alloc] init];
    NSMutableArray *array5 = [[NSMutableArray alloc] init];
    NSMutableArray *array6 = [[NSMutableArray alloc] init];
    NSMutableArray *array7 = [[NSMutableArray alloc] init];
    NSMutableArray *array8 = [[NSMutableArray alloc] init];
    
    NSArray *parallelArray = @[array1,array2,array3,array4,array5,array6,array7,array8];

    //同步并行处理数据
    dispatch_apply(8, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
        [self addNumberToArray:parallelArray[index]];
    });
    
    NSMutableArray *arrayofDate = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        [arrayofDate addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:i]]];
    }
    
//    NSArray *dimensionOptionsArray = @[@"访客类型",@"终端类型",@"整体会员",@"新会员",@"老会员",@"会员等级",@"城市分布"];
//    NSArray *indexOptionsArray1 = @[@"UV",@"PV",@"VISIT",@"新UV",@"有效UV",@"平均页面停留时间",@"提交订单转化率",@"有效订单转化率"];
//    NSArray *indexOptionsArray2 = @[@"访问会员数",@"买家数",@"购买率",@"客单价",@"平均订单收入"];
//    NSArray *indexOptionsArray3 = @[@"注册数",@"买家数",@"购买率",@"客单价",@"平均订单收入"];
//    NSArray *indexOptionsArray4 = @[@"回访数",@"买家数",@"首购率",@"复购率",@"客单价",@"平均订单收入"];
//    NSArray *indexOptionsArray5 = @[@"访问会员数",@"买家数",@"购买率",@"客单价",@"平均订单收入"];
    
    _detailsData =  @{ @"访客类型":@{
                                @"labelValues":@[@(arc4random() % 2000),@(arc4random() % 2000)],
                                @"arrayOfDates":arrayofDate,
                                @"UV_arrayOfValues":array1,@"PV_arrayOfValues":array2,@"Visitor_arrayOfValues":array3,@"新UV_arrayOfValues":array4,@"有效UV_arrayOfValues":array5,@"平均页面停留时间_arrayOfValues":array6,@"提交订单转化率_arrayOfValues":array7,@"有效订单转化率_arrayOfValues":array8,
                                @"UV_number":@(arc4random() % 20000),@"PV_number":@(arc4random() % 20000),@"Visitor_number":@(arc4random() % 20000),@"新UV_number":@(arc4random() % 10000),@"有效UV_number":@(arc4random() % 2000),@"平均页面停留时间_number":@(arc4random() % 200),@"提交订单转化率_number":@(arc4random() % 100),@"有效订单转化率_number":@(arc4random() % 100)
                                },
                        @"终端类型":@{
                                @"labelValues":@[@(arc4random() % 2000),@(arc4random() % 2000),@(arc4random() % 2000)],
                                @"arrayOfDates":arrayofDate,
                                @"UV_arrayOfValues":array1,@"PV_arrayOfValues":array2,@"Visitor_arrayOfValues":array3,@"新UV_arrayOfValues":array4,@"有效UV_arrayOfValues":array5,@"平均页面停留时间_arrayOfValues":array6,@"提交订单转化率_arrayOfValues":array7,@"有效订单转化率_arrayOfValues":array8,
                                @"UV_number":@(arc4random() % 20000),@"PV_number":@(arc4random() % 20000),@"Visitor_number":@(arc4random() % 20000),@"新UV_number":@(arc4random() % 10000),@"有效UV_number":@(arc4random() % 2000),@"平均页面停留时间_number":@(arc4random() % 200),@"提交订单转化率_number":@(arc4random() % 100),@"有效订单转化率_number":@(arc4random() % 100)
                                },
                        @"整体会员":@{
                                 @"labelValues":@[@(arc4random() % 20000)],
                                @"arrayOfDates":arrayofDate,
                                @"访问会员数_arrayOfValues":array1,@"买家数_arrayOfValues":array2,@"购买率_arrayOfValues":array3,@"客单价_arrayOfValues":array4,@"平均订单收入_arrayOfValues":array5,
                                @"访问会员数_number":@(arc4random() % 20000),@"买家数_number":@(arc4random() % 2000),@"购买率_number":@(arc4random() % 100),@"客单价_number":@(arc4random() % 10000),@"平均订单收入_number":@(arc4random() % 200)
                                },
                        @"新会员":@{
                                 @"labelValues":@[@(arc4random() % 10000)],
                                @"arrayOfDates":arrayofDate,
                                @"注册数_arrayOfValues":array1,@"买家数_arrayOfValues":array2,@"购买率_arrayOfValues":array3,@"客单价_arrayOfValues":array4,@"平均订单收入_arrayOfValues":array5,
                                @"注册数_number":@(arc4random() % 20000),@"买家数_number":@(arc4random() % 2000),@"购买率_number":@(arc4random() % 100),@"客单价_number":@(arc4random() % 10000),@"平均订单收入_number":@(arc4random() % 200)
                                },
                        @"老会员":@{
                                 @"labelValues":@[@(arc4random() % 20000)],
                                @"arrayOfDates":arrayofDate,
                                @"回访数_arrayOfValues":array1,@"买家数_arrayOfValues":array2,@"首购率_arrayOfValues":array3,@"复购率_arrayOfValues":array6,@"客单价_arrayOfValues":array4,@"平均订单收入_arrayOfValues":array5,
                                @"回访数_number":@(arc4random() % 20000),@"买家数_number":@(arc4random() % 2000),@"首购率_number":@(arc4random() % 100),@"复购率_number":@(arc4random() % 100),@"客单价_number":@(arc4random() % 10000),@"平均订单收入_number":@(arc4random() % 200)
                                },
                        @"会员等级":@{
                                 @"labelValues":@[@(arc4random() % 20000),@(arc4random() % 2000),@(arc4random() % 200),@(arc4random() % 50)],
                                @"arrayOfDates":arrayofDate,
                                @"访问会员数_arrayOfValues":array1,@"买家数_arrayOfValues":array2,@"购买率_arrayOfValues":array3,@"客单价_arrayOfValues":array4,@"平均订单收入_arrayOfValues":array5,
                                @"访问会员数_number":@(arc4random() % 20000),@"买家数_number":@(arc4random() % 2000),@"购买率_number":@(arc4random() % 100),@"客单价_number":@(arc4random() % 10000),@"平均订单收入_number":@(arc4random() % 200)
                                },
                        @"城市分布":@{
                                @"labelValues":@[@(arc4random() % 20000),@(arc4random() % 20000),@(arc4random() % 20000)],
                                @"arrayOfDates":arrayofDate,
                                @"UV_arrayOfValues":array1,@"PV_arrayOfValues":array2,@"Visitor_arrayOfValues":array3,@"新UV_arrayOfValues":array4,@"有效UV_arrayOfValues":array5,@"平均页面停留时间_arrayOfValues":array6,@"提交订单转化率_arrayOfValues":array7,@"有效订单转化率_arrayOfValues":array8,
                                @"UV_number":@(arc4random() % 20000),@"PV_number":@(arc4random() % 20000),@"Visitor_number":@(arc4random() % 20000),@"新UV_number":@(arc4random() % 10000),@"有效UV_number":@(arc4random() % 2000),@"平均页面停留时间_number":@(arc4random() % 200),@"提交订单转化率_number":@(arc4random() % 100),@"有效订单转化率_number":@(arc4random() % 100)
                                },
                        };
    
}

@end
