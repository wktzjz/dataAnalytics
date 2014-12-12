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

static NSString *const visitorGroupDataDidChange                  = @"visitorGroupDataDidChanged";
static NSString *const visitorGroupDetailOutlineDataDidInitialize = @"visitorGroupDetailOutlineDataDidInitialize";
static NSString *const visitorGroupOutlineDataDidInitialize       = @"visitorGroupOutlineDataDidInitialize";


@implementation visitorGroupModel
{
    NSDictionary *_sendDict;
    __weak id      _wself;
    NSArray *_groupColorArray;
    NSArray *_groupPercentArray;
    NSDateFormatter *_dateFormatter;
    NSString *_curDate;
    NSString *_fromDate;
    NSString *_toDate;
    
    NSMutableDictionary *_visitorTypeDetailsData;
    NSMutableDictionary *_terminalTypeDetailsData;
    NSMutableDictionary *_allMemberDetailsData;
    NSMutableDictionary *_newMemberDetailsData;
    NSMutableDictionary *_oldMemberDetailsData;
    NSMutableDictionary *_memberGradeDetailsData;
    NSMutableDictionary *_memberCityDetailsData;

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
        _arrayOfDates  = [[NSMutableArray alloc] init];
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
        _curDate     = [_dateFormatter stringFromDate:[NSDate date]];
        _detailsData = [[NSMutableDictionary alloc] initWithCapacity:7];

//        _defineDetails = [NSDictionary dictionary];
        _detailsDataMethodsArray  = @[@"getVisitorTypeDetailsData:",@"getTerminalTypeDetailsData:",@"getAllMemberDetailsData:",@"getNewMemberDetailsData:",@"getOldMemberDetailsData:",@"getMemberGradeDetailsData:",@"getMemberCityDetailsData:"];
        _dimensionDataAvailableArray = [[NSMutableArray alloc] initWithArray:@[@NO,@NO,@NO,@NO,@NO,@NO,@NO]];
    }

    return self;
}

- (void)addNumberToArray:(NSMutableArray *)array
{
    for (int i = 0; i < 20; i++) {
        [array addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
    }
}

- (void)getOutlineData
{
    void (^successefullyBlock)(NSDictionary *data) = ^(NSDictionary *data) {
        visitorGroupModel *strongSelf = _wself;
//        _sendDict = @{};
        
        _outlineData = @{@"visitNumber":@(arc4random() % 100000),
                         @"UVNumber":@(arc4random() % 20000),
                         @"validUVNumber":@(arc4random() % 10000),
                         @"newVISITRatio":@((arc4random() % 1000) / 1000.0),
                         @"newUVRatio":@((arc4random() % 1000) / 1000.0),
                         @"newVaildUVRatio":@((arc4random() % 1000) / 1000.0),
                         };
        
        NSNotification *notification = [[NSNotification alloc] initWithName:visitorGroupOutlineDataDidInitialize object:strongSelf userInfo:_outlineData];

        // 异步处理通知
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                       postingStyle:NSPostASAP
                                                       coalesceMask:NSNotificationCoalescingOnName forModes:@[NSDefaultRunLoopMode]];
        });
    };
//    @"http://10.27.193.34:80/snf-mbbi-web/mbbi/getVistorGroup.htm?beginTime=2014-12-08&endTime=2014-12-08"
    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:@"http://10.27.193.34:80/snf-mbbi-web/mbbi/getVistorGroup.htm?beginTime=2014-12-08&endTime=2014-12-08" failureBlock:successefullyBlock successedBlock:successefullyBlock];
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
        
        _groupUV = arc4random() % 20000;
        float validUVRatio = ((arc4random() % 500) + 500) / 1000.0;
        _validGroupUV = _groupUV * validUVRatio;
        _visitor = arc4random() % 30000;
        
        _groupPercentArray = @[@15,@30,@55];
        _groupColorArray = @[PNLightGreen,PNFreshGreen,PNDeepGreen];
        
        visitorGroupModel *strongSelf = _wself;
        
        NSMutableArray *parallelArray = [[NSMutableArray alloc] initWithCapacity:8];
        for(int i = 0; i < 8; i++){
            [parallelArray addObject:[[NSMutableArray alloc] init]];
        }

        for (int i = 0; i < 20; i++) {
            [_arrayOfDates addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:i]]];
            
        }
        
        //同步并行处理数据
        dispatch_apply(8, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
            [strongSelf addNumberToArray:parallelArray[index]];
        });
        
        _detailInitializeData = @{
//                            @"groupUV":@(_groupUV),
//                            @"visitor":@(_visitor),
//                            @"validGroupUV":@(_validGroupUV),
//                            @"groupPercentArray":_groupPercentArray,
//                            @"groupColorArray":_groupColorArray,
                            @"arrayOfDates":_arrayOfDates,
                            @"UV_arrayOfValues":parallelArray[0],
                            @"PV_arrayOfValues":parallelArray[1],
                            @"VISIT_arrayOfValues":parallelArray[2],
                            @"新UV_arrayOfValues":parallelArray[3],
                            @"有效UV_arrayOfValues":parallelArray[4],
                            @"平均页面停留时间_arrayOfValues":parallelArray[5],
                            @"提交订单转化率_arrayOfValues":parallelArray[6],
                            @"有效订单转化率_arrayOfValues":parallelArray[7],
                            @"UV_number":@(arc4random() % 20000),
                            @"PV_number":@(arc4random() % 20000),
                            @"VISIT_number":@(arc4random() % 20000),
                            @"新UV_number":@(arc4random() % 10000),
                            @"有效UV_number":@(arc4random() % 2000),
                            @"平均页面停留时间_number":@(arc4random() % 200),
                            @"提交订单转化率_number":@(arc4random() % 100),
                            @"有效订单转化率_number":@(arc4random() % 100)
                            };
        
        _initializeDataReady = YES;
        
        NSNotification *notification = [[NSNotification alloc] initWithName:visitorGroupDetailOutlineDataDidInitialize object:strongSelf userInfo:_detailInitializeData];
        
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
    if (!_defineDetails) {
        [self createDefineDetails];
        return _defineDetails;
    }else{
        return _defineDetails;
    }
}

- (void)createDefineDetails
{
    NSArray *dimensionOptionsArray = @[@"访客类型",@"终端类型",@"整体会员",@"新会员",@"老会员",@"会员等级",@"城市分布"];
    NSArray *indexOptionsArray1 = @[@"UV",@"PV",@"VISIT",@"新UV",@"有效UV",@"平均页面停留时间",@"提交订单转化率",@"有效订单转化率"];
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
    if (!_detailsData) {
        [self createDetailsData];
        return _detailsData;
    }else{
        return _detailsData;
    }
}

- (void)getVisitorTypeDetailsData:(void (^)(NSDictionary *data))succeedBlock
{
//    NSString *urlVisitorType = [[NSString alloc] initWithFormat:@"http://10.27.193.34:80/snf-mbbi-web/visitGroup/getVistorType.htm?beginTime=%@&endTime=%@&nvgtnTp=ios",_curDate,_curDate ];
    NSString *urlVisitorType = [[NSString alloc] initWithFormat:@"http://10.27.193.34:80/snf-mbbi-web/visitGroup/getVistorType.htm?beginTime=2014-12-08&endTime=2014-12-08"];
    void (^VisitorTypeBlock)(NSDictionary *) = ^(NSDictionary *data) {
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
        
        _visitorTypeDetailsData = [[NSMutableDictionary alloc] initWithDictionary:
                                   @{
                                     @"tagType":@[@"新访客",@"回访客"],
                                     @"UV_array":@[@(arc4random() % 2000),@(arc4random() % 2000)],
                                     @"PV_array":@[@(arc4random() % 2000),@(arc4random() % 2000)],
                                     @"VISIT_array":@[@(arc4random() % 2000),@(arc4random() % 2000)],
                                     @"新UV_array":@[@(arc4random() % 2000),@(arc4random() % 2000)],
                                     @"有效UV_array":@[@(arc4random() % 2000),@(arc4random() % 2000)],
                                     @"平均页面停留时间_array":@[@(arc4random() % 2000),@(arc4random() % 2000)],
                                     @"提交订单转化率_array":@[@(arc4random() % 2000),@(arc4random() % 2000)],
                                     @"有效订单转化率_array":@[@(arc4random() % 2000),@(arc4random() % 2000)],
//                                     @"tagValue":@[@(arc4random() % 2000),@(arc4random() % 2000)],
                                     @"arrayOfDates":arrayofDate,
                                     @"UV_arrayOfValues":array1,@"PV_arrayOfValues":array2,@"VISIT_arrayOfValues":array3,@"新UV_arrayOfValues":array4,@"有效UV_arrayOfValues":array5,@"平均页面停留时间_arrayOfValues":array6,@"提交订单转化率_arrayOfValues":array7,@"有效订单转化率_arrayOfValues":array8,
                                     @"UV_number":@(arc4random() % 20000),@"PV_number":@(arc4random() % 20000),@"VISIT_number":@(arc4random() % 20000),@"新UV_number":@(arc4random() % 10000),@"有效UV_number":@(arc4random() % 2000),@"平均页面停留时间_number":@(arc4random() % 200),@"提交订单转化率_number":@(arc4random() % 100),@"有效订单转化率_number":@(arc4random() % 100)
                                     }];
        
        [_detailsData setObject:_visitorTypeDetailsData forKey: @"访客类型"];
        _dimensionDataAvailableArray[0] = @YES;
        
        if(succeedBlock){
            succeedBlock(_visitorTypeDetailsData);
        }
    };
    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:urlVisitorType failureBlock:VisitorTypeBlock successedBlock:VisitorTypeBlock];
}

- (void)getTerminalTypeDetailsData:(void (^)(NSDictionary *data))succeedBlock
{
//    NSString *urlTerminalType = [[NSString alloc] initWithFormat:@"http://10.27.193.34:80/snf-mbbi-web/visitGroup/getTagType.htm?beginTime=%@&endTime=%@&nvgtnTp=ios",_curDate,_curDate ];
        NSString *urlTerminalType = [[NSString alloc] initWithFormat:@"http://10.27.193.34:80/snf-mbbi-web/visitGroup/getTagType.htm?beginTime=2014-12-08&endTime=2014-12-08"];
    void (^terminalTypeBlock)(NSDictionary *) = ^(NSDictionary *data) {
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
        
        _terminalTypeDetailsData = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                     @"tagType":@[@"PC",@"WAP",@"APP"],
//                                                                                     @"tagValue":@[@(arc4random() % 2000),@(arc4random() % 2000),@(arc4random() % 2000)],
                                                                                     @"UV_array":@[@(arc4random() % 2000),@(arc4random() % 2000),@(arc4random() % 2000)],
                                                                                     @"PV_array":@[@(arc4random() % 2000),@(arc4random() % 2000),@(arc4random() % 2000)],
                                                                                     @"VISIT_array":@[@(arc4random() % 2000),@(arc4random() % 2000),@(arc4random() % 2000)],
                                                                                     @"新UV_array":@[@(arc4random() % 2000),@(arc4random() % 2000),@(arc4random() % 2000)],
                                                                                     @"有效UV_array":@[@(arc4random() % 2000),@(arc4random() % 2000),@(arc4random() % 2000)],
                                                                                     @"平均页面停留时间_array":@[@(arc4random() % 2000),@(arc4random() % 2000),@(arc4random() % 2000)],
                                                                                     @"提交订单转化率_array":@[@(arc4random() % 2000),@(arc4random() % 2000),@(arc4random() % 2000)],
                                                                                     @"有效订单转化率_array":@[@(arc4random() % 2000),@(arc4random() % 2000),@(arc4random() % 2000)],
                                                                                     @"arrayOfDates":arrayofDate,
                                                                                     @"UV_arrayOfValues":array1,@"PV_arrayOfValues":array2,@"VISIT_arrayOfValues":array3,@"新UV_arrayOfValues":array4,@"有效UV_arrayOfValues":array5,@"平均页面停留时间_arrayOfValues":array6,@"提交订单转化率_arrayOfValues":array7,@"有效订单转化率_arrayOfValues":array8,
                                                                                     @"UV_number":@(arc4random() % 20000),@"PV_number":@(arc4random() % 20000),@"VISIT_number":@(arc4random() % 20000),@"新UV_number":@(arc4random() % 10000),@"有效UV_number":@(arc4random() % 2000),@"平均页面停留时间_number":@(arc4random() % 200),@"提交订单转化率_number":@(arc4random() % 100),@"有效订单转化率_number":@(arc4random() % 100)
                                                                                     }];
        [_detailsData setObject:_terminalTypeDetailsData forKey:@"终端类型"];
        _dimensionDataAvailableArray[1] = @YES;

        if(succeedBlock){
            succeedBlock(_terminalTypeDetailsData);
        }
    };
    
    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:urlTerminalType failureBlock:terminalTypeBlock successedBlock:terminalTypeBlock];

}

- (void)getAllMemberDetailsData:(void (^)(NSDictionary *data))succeedBlock
{
    NSString *urlAllMember = [[NSString alloc] initWithFormat:@"http://10.27.193.34:80/snf-mbbi-web/visitGroup/getAllMember.htm?beginTime=%@&endTime=%@&nvgtnTp=ios",_curDate,_curDate ];
    void (^allMemberBlock)(NSDictionary *) = ^(NSDictionary *data) {
        
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

        _allMemberDetailsData = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                  @"tagType":@[@"会员"],
                                                                                  @"访问会员数_array":@[@(arc4random() % 20000)],@"买家数_array":@[@(arc4random() % 20000)],@"购买率_array":@[@(arc4random() % 20000)],@"客单价_array":@[@(arc4random() % 20000)],@"平均订单收入_array":@[@(arc4random() % 20000)],
//                                                                                  @"tagValue":@[@(arc4random() % 20000)],
                                                                                  @"arrayOfDates":arrayofDate,
                                                                                  @"访问会员数_arrayOfValues":array1,@"买家数_arrayOfValues":array2,@"购买率_arrayOfValues":array3,@"客单价_arrayOfValues":array4,@"平均订单收入_arrayOfValues":array5,
                                                                                  @"访问会员数_number":@(arc4random() % 20000),@"买家数_number":@(arc4random() % 2000),@"购买率_number":@(arc4random() % 100),@"客单价_number":@(arc4random() % 10000),@"平均订单收入_number":@(arc4random() % 200)
                                                                                  }];
        
        [_detailsData setObject:_allMemberDetailsData forKey:@"整体会员"];
        _dimensionDataAvailableArray[2] = @YES;

        if(succeedBlock){
            succeedBlock(_allMemberDetailsData);
        }
    };
    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:nil failureBlock:allMemberBlock successedBlock:allMemberBlock];
}


- (void)getNewMemberDetailsData:(void (^)(NSDictionary *data))succeedBlock
{
    NSString *urlNewMember = [[NSString alloc] initWithFormat:@"http://10.27.193.34:80/snf-mbbi-web/visitGroup/getNewMember.htm?beginTime=%@&endTime=%@&nvgtnTp=ios",_curDate,_curDate ];
    void (^newMemberBlock)(NSDictionary *) = ^(NSDictionary *data) {
        
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

        _newMemberDetailsData = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                  @"tagType":@[@"新会员"],
//                                                                                  @"tagValue":@[@(arc4random() % 10000)],
                                                                                   @"注册数_array":@[@(arc4random() % 10000)],@"买家数_array":@[@(arc4random() % 10000)],@"购买率_array":@[@(arc4random() % 10000)],@"客单价_array":@[@(arc4random() % 10000)],@"平均订单收入_array":@[@(arc4random() % 10000)],
                                                                                  @"arrayOfDates":arrayofDate,
                                                                                  @"注册数_arrayOfValues":array1,@"买家数_arrayOfValues":array2,@"购买率_arrayOfValues":array3,@"客单价_arrayOfValues":array4,@"平均订单收入_arrayOfValues":array5,
                                                                                  @"注册数_number":@(arc4random() % 20000),@"买家数_number":@(arc4random() % 2000),@"购买率_number":@(arc4random() % 100),@"客单价_number":@(arc4random() % 10000),@"平均订单收入_number":@(arc4random() % 200)
                                                                                  }];
        [_detailsData setObject:_newMemberDetailsData forKey:@"新会员"];
        _dimensionDataAvailableArray[3] = @YES;

        if(succeedBlock){
            succeedBlock(_newMemberDetailsData);
        }
    };
    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:nil failureBlock:newMemberBlock successedBlock:newMemberBlock];
    
}


- (void)getOldMemberDetailsData:(void (^)(NSDictionary *data))succeedBlock
{
    NSString *urlOldMember = [[NSString alloc] initWithFormat:@"http://10.27.193.34:80/snf-mbbi-web/visitGroup/getOldMember.htm?beginTime=%@&endTime=%@&nvgtnTp=ios",_curDate,_curDate ];
    void (^oldMemberBlock)(NSDictionary *) = ^(NSDictionary *data) {
        
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

        _oldMemberDetailsData = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                  @"tagType":@[@"老会员"],
//                                                                                  @"tagValue":@[@(arc4random() % 20000)],
                                                                                  @"回访数_array":@[@(arc4random() % 20000)],@"买家数_array":@[@(arc4random() % 20000)],@"首购率_array":@[@(arc4random() % 20000)],@"客单价_array":@[@(arc4random() % 20000)],@"平均订单收入_array":@[@(arc4random() % 20000)],
                                                                                  @"arrayOfDates":arrayofDate,
                                                                                  @"回访数_arrayOfValues":array1,@"买家数_arrayOfValues":array2,@"首购率_arrayOfValues":array3,@"复购率_arrayOfValues":array6,@"客单价_arrayOfValues":array4,@"平均订单收入_arrayOfValues":array5,
                                                                                  @"回访数_number":@(arc4random() % 20000),@"买家数_number":@(arc4random() % 2000),@"首购率_number":@(arc4random() % 100),@"复购率_number":@(arc4random() % 100),@"客单价_number":@(arc4random() % 10000),@"平均订单收入_number":@(arc4random() % 200)
                                                                                  }];
        [_detailsData setObject:_oldMemberDetailsData forKey:@"老会员"];
        _dimensionDataAvailableArray[4] = @YES;

        if(succeedBlock){
            succeedBlock(_oldMemberDetailsData);
        }
    };
    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:nil failureBlock:oldMemberBlock successedBlock:oldMemberBlock];
}


- (void)getMemberGradeDetailsData:(void (^)(NSDictionary *data))succeedBlock
{
    NSString *urlMemberGrade = [[NSString alloc] initWithFormat:@"http://10.27.193.34:80/snf-mbbi-web/visitGroup/getMemberGrade.htm?beginTime=%@&endTime=%@&nvgtnTp=ios",_curDate,_curDate ];
    void (^memberGradeBlock)(NSDictionary *) = ^(NSDictionary *data) {
        
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
        
        _memberGradeDetailsData = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                    @"tagType":@[@"普通会员",@"银卡会员",@"金卡会员",@"白金会员"],
//                                                                                    @"tagValue":@[@(arc4random() % 20000),@(arc4random() % 2000),@(arc4random() % 200),@(arc4random() % 50)],
                                                                                    @"访问会员数_array":@[@(arc4random() % 20000),@(arc4random() % 2000),@(arc4random() % 200),@(arc4random() % 50)],
                                                                                    @"买家数_array":@[@(arc4random() % 20000),@(arc4random() % 2000),@(arc4random() % 200),@(arc4random() % 50)],
                                                                                    @"购买率_array":@[@(arc4random() % 20000),@(arc4random() % 2000),@(arc4random() % 200),@(arc4random() % 50)],
                                                                                    @"客单价_array":@[@(arc4random() % 20000),@(arc4random() % 2000),@(arc4random() % 200),@(arc4random() % 50)],
                                                                                    @"平均订单收入_array":@[@(arc4random() % 20000),@(arc4random() % 2000),@(arc4random() % 200),@(arc4random() % 50)],
                                                                                    @"arrayOfDates":arrayofDate,
                                                                                    @"访问会员数_arrayOfValues":array1,@"买家数_arrayOfValues":array2,@"购买率_arrayOfValues":array3,@"客单价_arrayOfValues":array4,@"平均订单收入_arrayOfValues":array5,
                                                                                    @"访问会员数_number":@(arc4random() % 20000),@"买家数_number":@(arc4random() % 2000),@"购买率_number":@(arc4random() % 100),@"客单价_number":@(arc4random() % 10000),@"平均订单收入_number":@(arc4random() % 200)
                                                                                    }];
        [_detailsData setObject:_memberGradeDetailsData forKey:@"会员等级"];
        _dimensionDataAvailableArray[5] = @YES;

        if(succeedBlock){
            succeedBlock(_memberGradeDetailsData);
        }
    };
    
    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:nil failureBlock:memberGradeBlock successedBlock:memberGradeBlock];
}


- (void)getMemberCityDetailsData:(void (^)(NSDictionary *data))succeedBlock
{
    NSString *urlMemberCity = [[NSString alloc] initWithFormat:@"http://10.27.193.34:80/snf-mbbi-web/visitGroup/getMemberCity.htm?beginTime=%@&endTime=%@&nvgtnTp=ios",_curDate,_curDate ];
    void (^memberCityBlock)(NSDictionary *) = ^(NSDictionary *data) {
        
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
        
        _memberCityDetailsData = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                   @"tagType":@[@"南京",@"上海",@"北京"],
//                                                                                   @"tagValue":@[@(arc4random() % 20000),@(arc4random() % 20000),@(arc4random() % 20000)],
                                                                                   @"UV_array":@[@(arc4random() % 20000),@(arc4random() % 20000),@(arc4random() % 20000)],
                                                                                   @"PV_array":@[@(arc4random() % 20000),@(arc4random() % 20000),@(arc4random() % 20000)],
                                                                                   @"VISIT_array":@[@(arc4random() % 20000),@(arc4random() % 20000),@(arc4random() % 20000)],
                                                                                   @"新UV_array":@[@(arc4random() % 20000),@(arc4random() % 20000),@(arc4random() % 20000)],
                                                                                   @"有效UV_array":@[@(arc4random() % 20000),@(arc4random() % 20000),@(arc4random() % 20000)],
                                                                                   @"平均页面停留时间_array":@[@(arc4random() % 20000),@(arc4random() % 20000),@(arc4random() % 20000)],
                                                                                   @"提交订单转化率_array":@[@(arc4random() % 20000),@(arc4random() % 20000),@(arc4random() % 20000)],
                                                                                   @"有效订单转化率_array":@[@(arc4random() % 20000),@(arc4random() % 20000),@(arc4random() % 20000)],
                                                                                   @"arrayOfDates":arrayofDate,
                                                                                   @"UV_arrayOfValues":array1,@"PV_arrayOfValues":array2,@"VISIT_arrayOfValues":array3,@"新UV_arrayOfValues":array4,@"有效UV_arrayOfValues":array5,@"平均页面停留时间_arrayOfValues":array6,@"提交订单转化率_arrayOfValues":array7,@"有效订单转化率_arrayOfValues":array8,
                                                                                   @"UV_number":@(arc4random() % 20000),@"PV_number":@(arc4random() % 20000),@"VISIT_number":@(arc4random() % 20000),@"新UV_number":@(arc4random() % 10000),@"有效UV_number":@(arc4random() % 2000),@"平均页面停留时间_number":@(arc4random() % 200),@"提交订单转化率_number":@(arc4random() % 100),@"有效订单转化率_number":@(arc4random() % 100)
                                                                                   }];
        [_detailsData setObject:_memberCityDetailsData forKey:@"城市分布"];
        _dimensionDataAvailableArray[6] = @YES;

        if(succeedBlock){
            succeedBlock(_memberCityDetailsData);
        }
    };
    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:nil failureBlock:memberCityBlock successedBlock:memberCityBlock];
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
    
    
//    
//    NSString *urlTerminalType = [[NSString alloc] initWithFormat:@"http://10.27.193.34:80/snf-mbbi-web/visitGroup/getTagType.htm?beginTime=%@&endTime=%@&nvgtnTp=ios",_curDate,_curDate ];
//    void (^terminalTypeBlock)(NSDictionary *) = ^(NSDictionary *data) {
//        _terminalTypeDetailsData = [[NSMutableDictionary alloc] initWithDictionary:@{
//                                                                                   @"tagType":@[@"PC",@"WAP",@"APP"],
//                                                                                   @"tagValue":@[@(arc4random() % 2000),@(arc4random() % 2000),@(arc4random() % 2000)],
//                                                                                   @"arrayOfDates":arrayofDate,
//                                                                                   @"UV_arrayOfValues":array1,@"PV_arrayOfValues":array2,@"VISIT_arrayOfValues":array3,@"新UV_arrayOfValues":array4,@"有效UV_arrayOfValues":array5,@"平均页面停留时间_arrayOfValues":array6,@"提交订单转化率_arrayOfValues":array7,@"有效订单转化率_arrayOfValues":array8,
//                                                                                   @"UV_number":@(arc4random() % 20000),@"PV_number":@(arc4random() % 20000),@"VISIT_number":@(arc4random() % 20000),@"新UV_number":@(arc4random() % 10000),@"有效UV_number":@(arc4random() % 2000),@"平均页面停留时间_number":@(arc4random() % 200),@"提交订单转化率_number":@(arc4random() % 100),@"有效订单转化率_number":@(arc4random() % 100)
//                                                                                   }];
//        [_detailsData setObject:_terminalTypeDetailsData forKey:@"终端类型"];
//    };
//    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:urlTerminalType failureBlock:terminalTypeBlock successedBlock:terminalTypeBlock];
//
//    NSString *urlAllMember = [[NSString alloc] initWithFormat:@"http://10.27.193.34:80/snf-mbbi-web/visitGroup/getAllMember.htm?beginTime=%@&endTime=%@&nvgtnTp=ios",_curDate,_curDate ];
//    void (^allMemberBlock)(NSDictionary *) = ^(NSDictionary *data) {
//        _allMemberDetailsData = [[NSMutableDictionary alloc] initWithDictionary:@{
//                                                                                  @"tagType":@[@"会员"],
//                                                                                  @"tagValue":@[@(arc4random() % 20000)],
//                                                                                  @"arrayOfDates":arrayofDate,
//                                                                                  @"访问会员数_arrayOfValues":array1,@"买家数_arrayOfValues":array2,@"购买率_arrayOfValues":array3,@"客单价_arrayOfValues":array4,@"平均订单收入_arrayOfValues":array5,
//                                                                                  @"访问会员数_number":@(arc4random() % 20000),@"买家数_number":@(arc4random() % 2000),@"购买率_number":@(arc4random() % 100),@"客单价_number":@(arc4random() % 10000),@"平均订单收入_number":@(arc4random() % 200)
//                                                                                  }];
//
//        [_detailsData setObject:_allMemberDetailsData forKey:@"整体会员"];
//    };
//    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:urlAllMember failureBlock:allMemberBlock successedBlock:allMemberBlock];
    
//    NSString *urlNewMember = [[NSString alloc] initWithFormat:@"http://10.27.193.34:80/snf-mbbi-web/visitGroup/getNewMember.htm?beginTime=%@&endTime=%@&nvgtnTp=ios",_curDate,_curDate ];
//    void (^newMemberBlock)(NSDictionary *) = ^(NSDictionary *data) {
//        _newMemberDetailsData = [[NSMutableDictionary alloc] initWithDictionary:@{
//                                                                                  @"tagType":@[@"新会员"],
//                                                                                  @"tagValue":@[@(arc4random() % 10000)],
//                                                                                  @"arrayOfDates":arrayofDate,
//                                                                                  @"注册数_arrayOfValues":array1,@"买家数_arrayOfValues":array2,@"购买率_arrayOfValues":array3,@"客单价_arrayOfValues":array4,@"平均订单收入_arrayOfValues":array5,
//                                                                                  @"注册数_number":@(arc4random() % 20000),@"买家数_number":@(arc4random() % 2000),@"购买率_number":@(arc4random() % 100),@"客单价_number":@(arc4random() % 10000),@"平均订单收入_number":@(arc4random() % 200)
//                                                                                  }];
//        [_detailsData setObject:_newMemberDetailsData forKey:@"新会员"];
//    };
//    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:urlNewMember failureBlock:newMemberBlock successedBlock:newMemberBlock];
    
//    NSString *urlOldMember = [[NSString alloc] initWithFormat:@"http://10.27.193.34:80/snf-mbbi-web/visitGroup/getOldMember.htm?beginTime=%@&endTime=%@&nvgtnTp=ios",_curDate,_curDate ];
//    void (^oldMemberBlock)(NSDictionary *) = ^(NSDictionary *data) {
//        _oldMemberDetailsData = [[NSMutableDictionary alloc] initWithDictionary:@{
//                                                                                  @"tagType":@[@"老会员"],
//                                                                                  @"tagValue":@[@(arc4random() % 20000)],
//                                                                                  @"arrayOfDates":arrayofDate,
//                                                                                  @"回访数_arrayOfValues":array1,@"买家数_arrayOfValues":array2,@"首购率_arrayOfValues":array3,@"复购率_arrayOfValues":array6,@"客单价_arrayOfValues":array4,@"平均订单收入_arrayOfValues":array5,
//                                                                                  @"回访数_number":@(arc4random() % 20000),@"买家数_number":@(arc4random() % 2000),@"首购率_number":@(arc4random() % 100),@"复购率_number":@(arc4random() % 100),@"客单价_number":@(arc4random() % 10000),@"平均订单收入_number":@(arc4random() % 200)
//                                                                                  }];
//        [_detailsData setObject:_oldMemberDetailsData forKey:@"老会员"];
//    };
//    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:urlOldMember failureBlock:oldMemberBlock successedBlock:oldMemberBlock];
//    
//    NSString *urlMemberGrade = [[NSString alloc] initWithFormat:@"http://10.27.193.34:80/snf-mbbi-web/visitGroup/getMemberGrade.htm?beginTime=%@&endTime=%@&nvgtnTp=ios",_curDate,_curDate ];
//    void (^memberGradeBlock)(NSDictionary *) = ^(NSDictionary *data) {
//        _memberGradeDetailsData = [[NSMutableDictionary alloc] initWithDictionary:@{
//                                                                                    @"tagType":@[@"普通会员",@"银卡会员",@"金卡会员",@"白金会员"],
//                                                                                    @"tagValue":@[@(arc4random() % 20000),@(arc4random() % 2000),@(arc4random() % 200),@(arc4random() % 50)],
//                                                                                    @"arrayOfDates":arrayofDate,
//                                                                                    @"访问会员数_arrayOfValues":array1,@"买家数_arrayOfValues":array2,@"购买率_arrayOfValues":array3,@"客单价_arrayOfValues":array4,@"平均订单收入_arrayOfValues":array5,
//                                                                                    @"访问会员数_number":@(arc4random() % 20000),@"买家数_number":@(arc4random() % 2000),@"购买率_number":@(arc4random() % 100),@"客单价_number":@(arc4random() % 10000),@"平均订单收入_number":@(arc4random() % 200)
//                                                                                    }];
//        [_detailsData setObject:_memberGradeDetailsData forKey:@"会员等级"];
//    };
//    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:urlMemberGrade failureBlock:memberGradeBlock successedBlock:memberGradeBlock];

//    NSString *urlMemberCity = [[NSString alloc] initWithFormat:@"http://10.27.193.34:80/snf-mbbi-web/visitGroup/getMemberCity.htm?beginTime=%@&endTime=%@&nvgtnTp=ios",_curDate,_curDate ];
//    void (^memberCityBlock)(NSDictionary *) = ^(NSDictionary *data) {
//        _memberCityDetailsData = [[NSMutableDictionary alloc] initWithDictionary:@{
//                                                                                   @"tagType":@[@"南京",@"上海",@"北京"],
//                                                                                   @"tagValue":@[@(arc4random() % 20000),@(arc4random() % 20000),@(arc4random() % 20000)],
//                                                                                   @"arrayOfDates":arrayofDate,
//                                                                                   @"UV_arrayOfValues":array1,@"PV_arrayOfValues":array2,@"VISIT_arrayOfValues":array3,@"新UV_arrayOfValues":array4,@"有效UV_arrayOfValues":array5,@"平均页面停留时间_arrayOfValues":array6,@"提交订单转化率_arrayOfValues":array7,@"有效订单转化率_arrayOfValues":array8,
//                                                                                   @"UV_number":@(arc4random() % 20000),@"PV_number":@(arc4random() % 20000),@"VISIT_number":@(arc4random() % 20000),@"新UV_number":@(arc4random() % 10000),@"有效UV_number":@(arc4random() % 2000),@"平均页面停留时间_number":@(arc4random() % 200),@"提交订单转化率_number":@(arc4random() % 100),@"有效订单转化率_number":@(arc4random() % 100)
//                                                                                   }];
//        [_detailsData setObject:_memberCityDetailsData forKey:@"会员等级"];
//    };
//    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:urlMemberCity failureBlock:memberCityBlock successedBlock:memberCityBlock];
    
    _detailsData = [[NSMutableDictionary alloc] initWithDictionary: @{
                        @"访客类型":@{
                                @"tagType":@[@"新访客",@"回访客"],
                                @"tagValue":@[@(arc4random() % 2000),@(arc4random() % 2000)],
                                @"arrayOfDates":arrayofDate,
                                @"UV_arrayOfValues":array1,@"PV_arrayOfValues":array2,@"VISIT_arrayOfValues":array3,@"新UV_arrayOfValues":array4,@"有效UV_arrayOfValues":array5,@"平均页面停留时间_arrayOfValues":array6,@"提交订单转化率_arrayOfValues":array7,@"有效订单转化率_arrayOfValues":array8,
                                @"UV_number":@(arc4random() % 20000),@"PV_number":@(arc4random() % 20000),@"VISIT_number":@(arc4random() % 20000),@"新UV_number":@(arc4random() % 10000),@"有效UV_number":@(arc4random() % 2000),@"平均页面停留时间_number":@(arc4random() % 200),@"提交订单转化率_number":@(arc4random() % 100),@"有效订单转化率_number":@(arc4random() % 100)
                                },
                        @"终端类型":@{
                                @"tagType":@[@"PC",@"WAP",@"APP"],
                                @"tagValue":@[@(arc4random() % 2000),@(arc4random() % 2000),@(arc4random() % 2000)],
                                @"arrayOfDates":arrayofDate,
                                @"UV_arrayOfValues":array1,@"PV_arrayOfValues":array2,@"VISIT_arrayOfValues":array3,@"新UV_arrayOfValues":array4,@"有效UV_arrayOfValues":array5,@"平均页面停留时间_arrayOfValues":array6,@"提交订单转化率_arrayOfValues":array7,@"有效订单转化率_arrayOfValues":array8,
                                @"UV_number":@(arc4random() % 20000),@"PV_number":@(arc4random() % 20000),@"VISIT_number":@(arc4random() % 20000),@"新UV_number":@(arc4random() % 10000),@"有效UV_number":@(arc4random() % 2000),@"平均页面停留时间_number":@(arc4random() % 200),@"提交订单转化率_number":@(arc4random() % 100),@"有效订单转化率_number":@(arc4random() % 100)
                                },
                        @"整体会员":@{
                                @"tagType":@[@"会员"],
                                @"tagValue":@[@(arc4random() % 20000)],
                                @"arrayOfDates":arrayofDate,
                                @"访问会员数_arrayOfValues":array1,@"买家数_arrayOfValues":array2,@"购买率_arrayOfValues":array3,@"客单价_arrayOfValues":array4,@"平均订单收入_arrayOfValues":array5,
                                @"访问会员数_number":@(arc4random() % 20000),@"买家数_number":@(arc4random() % 2000),@"购买率_number":@(arc4random() % 100),@"客单价_number":@(arc4random() % 10000),@"平均订单收入_number":@(arc4random() % 200)
                                },
                        @"新会员":@{
                                @"tagType":@[@"新会员"],
                                @"tagValue":@[@(arc4random() % 10000)],
                                @"arrayOfDates":arrayofDate,
                                @"注册数_arrayOfValues":array1,@"买家数_arrayOfValues":array2,@"购买率_arrayOfValues":array3,@"客单价_arrayOfValues":array4,@"平均订单收入_arrayOfValues":array5,
                                @"注册数_number":@(arc4random() % 20000),@"买家数_number":@(arc4random() % 2000),@"购买率_number":@(arc4random() % 100),@"客单价_number":@(arc4random() % 10000),@"平均订单收入_number":@(arc4random() % 200)
                                },
                        @"老会员":@{
                                @"tagType":@[@"老会员"],
                                @"tagValue":@[@(arc4random() % 20000)],
                                @"arrayOfDates":arrayofDate,
                                @"回访数_arrayOfValues":array1,@"买家数_arrayOfValues":array2,@"首购率_arrayOfValues":array3,@"复购率_arrayOfValues":array6,@"客单价_arrayOfValues":array4,@"平均订单收入_arrayOfValues":array5,
                                @"回访数_number":@(arc4random() % 20000),@"买家数_number":@(arc4random() % 2000),@"首购率_number":@(arc4random() % 100),@"复购率_number":@(arc4random() % 100),@"客单价_number":@(arc4random() % 10000),@"平均订单收入_number":@(arc4random() % 200)
                                },
                        @"会员等级":@{
                                @"tagType":@[@"普通会员",@"银卡会员",@"金卡会员",@"白金会员"],
                                @"tagValue":@[@(arc4random() % 20000),@(arc4random() % 2000),@(arc4random() % 200),@(arc4random() % 50)],
                                @"arrayOfDates":arrayofDate,
                                @"访问会员数_arrayOfValues":array1,@"买家数_arrayOfValues":array2,@"购买率_arrayOfValues":array3,@"客单价_arrayOfValues":array4,@"平均订单收入_arrayOfValues":array5,
                                @"访问会员数_number":@(arc4random() % 20000),@"买家数_number":@(arc4random() % 2000),@"购买率_number":@(arc4random() % 100),@"客单价_number":@(arc4random() % 10000),@"平均订单收入_number":@(arc4random() % 200)
                                },
                        @"城市分布":@{
                                @"tagType":@[@"南京",@"上海",@"北京"],
                                @"tagValue":@[@(arc4random() % 20000),@(arc4random() % 20000),@(arc4random() % 20000)],
                                @"arrayOfDates":arrayofDate,
                                @"UV_arrayOfValues":array1,@"PV_arrayOfValues":array2,@"VISIT_arrayOfValues":array3,@"新UV_arrayOfValues":array4,@"有效UV_arrayOfValues":array5,@"平均页面停留时间_arrayOfValues":array6,@"提交订单转化率_arrayOfValues":array7,@"有效订单转化率_arrayOfValues":array8,
                                @"UV_number":@(arc4random() % 20000),@"PV_number":@(arc4random() % 20000),@"VISIT_number":@(arc4random() % 20000),@"新UV_number":@(arc4random() % 10000),@"有效UV_number":@(arc4random() % 2000),@"平均页面停留时间_number":@(arc4random() % 200),@"提交订单转化率_number":@(arc4random() % 100),@"有效订单转化率_number":@(arc4random() % 100)
                                },
                        }];
    
}

- (void)getDataFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:fromDate];
    NSInteger day = [components day];
    NSInteger month= [components month];
    NSInteger year= [components year];
    
    NSString *fromDateString = [NSString stringWithFormat:@"%li-%li-%li",day,month,year];
    NSLog(@"fromDate:%@",fromDateString);
    
    components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:fromDate];
    day = [components day];
    month= [components month];
    year= [components year];
    
    NSString *toDateString = [NSString stringWithFormat:@"%li-%li-%li",day,month,year];
    NSLog(@"toDate:%@",toDateString);
    
    void (^successefullyBlock)(NSDictionary *) = ^(NSDictionary *json){
        visitorGroupModel *strongSelf = _wself;
        
        NSNotification *notification = [[NSNotification alloc] initWithName:visitorGroupDataDidChange object:strongSelf userInfo:_detailInitializeData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                       postingStyle:NSPostASAP
                                                       coalesceMask:NSNotificationCoalescingOnName forModes:@[NSDefaultRunLoopMode]];
        });
    };
    void (^failureBlock)(NSDictionary *) = ^(NSDictionary *json){
        
    };
    
    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:nil failureBlock:failureBlock successedBlock:successefullyBlock];
}

@end
