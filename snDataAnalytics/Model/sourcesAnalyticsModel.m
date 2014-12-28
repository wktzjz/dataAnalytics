//
//  sourcesAnalytics.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-11-17.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "sourcesAnalyticsModel.h"
#import "networkManager.h"
#import "networkDefine.h"

@implementation sourcesAnalyticsModel
{
     __weak id      _wself;
    NSMutableArray *_groupPercentArray;
    NSMutableArray *_groupValidPercentArray;
    
    NSMutableDictionary *_displayAdvertisingDetailsData;
    NSMutableDictionary *_navigationDetailsData;
    NSMutableDictionary *_searchDetailsData;
    NSMutableDictionary *_ADAllianceDetailsData;
    NSMutableDictionary *_directFlowDetailsData;
    NSMutableDictionary *_EDMDetailsData;

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
        _dimensionDataAvailableArray = [[NSMutableArray alloc] initWithArray:@[@NO,@NO,@NO,@NO,@NO,@NO]];

        _detailsData = [[NSMutableDictionary alloc] initWithCapacity:6];
        _detailsDataMethodsArray  = @[@"getDisplayAdvertisingDetailsData:",@"getNavigationDetailsData:",@"getSearchDetailsData:",@"getADAllianceDetailsData:",@"getDirectFlowDetailsData:",@"getEDMDetailsData:"];
        
        _fromDate = @"2014-12-08";
        _toDate = @"2014-12-08";
        
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
    
    _defineDetails = @{@"dimensionOptionsArray":dimensionOptionsArray,
                        @"硬广":@{@"tagType":@[@"运营商",@"垂直",@"DSP"],
                                  @"indexOptionsArray":indexOptionsArray},
                        @"导航":@{@"tagType":@[@"付费导航",@"免费导航"],
                                  @"indexOptionsArray":indexOptionsArray},
                        @"搜索":@{@"tagType":@[@"SEO",@"SEM"],
                                  @"indexOptionsArray":indexOptionsArray},
                        @"广告联盟":@{@"tagType":@[@"广告联盟"],
                                 @"indexOptionsArray":indexOptionsArray},
                        @"直接流量":@{@"tagType":@[@"直接流量"],
                                 @"indexOptionsArray":indexOptionsArray},
                        @"EDM":@{@"tagType":@[@"会员EDM"],
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
        
        NSMutableArray *sourceNameArray = [[NSMutableArray alloc] initWithCapacity:6];
        [(NSArray *)data[@"sourceArray"] enumerateObjectsUsingBlock:^(NSString *type, NSUInteger idx, BOOL *stop) {
            NSString *typeName;
            switch(type.integerValue){
                case 10:
                    typeName = @"硬广";
                    break;
                case 20:
                    typeName = @"导航";
                    break;
                case 30:
                    typeName = @"搜索";
                    break;
                case 40:
                    typeName = @"广告联盟";
                    break;
                case 50:
                    typeName = @"流量";
                    break;
                case 60:
                    typeName = @"EDM";
                    break;
                default:
                    typeName = @"硬广";
                    break;
            }
            [sourceNameArray addObject:typeName];
        }];

        _outlineData = @{
//                         @"groupPercentArray":_groupPercentArray,
//                         @"groupValidPercentArray":_groupValidPercentArray,
//                         @"sourceArray":@"",
                         @"groupPercentArray":data[@"groupPercentArray"],
                         @"groupValidPercentArray":[[NSMutableArray alloc] initWithArray:data[@"groupValidPercentArray"]],
                         @"sourceArray":sourceNameArray,
                         };
        
        NSNotification *notification = [[NSNotification alloc] initWithName:sourceAnalyticsOutlineDataDidInitialize object:strongSelf userInfo:_outlineData];
        
        // 异步处理通知
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                       postingStyle:NSPostASAP
                                                       coalesceMask:NSNotificationCoalescingOnName forModes:@[NSDefaultRunLoopMode]];
        });
    };
    NSString *URL = [[NSString alloc] initWithFormat:@"%@/snf-mbbi-web/mbbi/getSourceAnalyse.htm?beginTime=%@&endTime=%@",serverAddress,_fromDate,_toDate];
    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:URL failureBlock:nil successedBlock:successefullyBlock];
}


- (NSDictionary *)getDetailOutlineData
{
    if (!_detailInitializeData) {
        [self createDetailOutlineData:nil];
        return _detailInitializeData;
    }else{
        return _detailInitializeData;
    }
}


- (NSDictionary *)handleDetailOutlineData:(NSDictionary *)data
{
    return @{ @"arrayOfDates":data[@"arrayOfDates"],
              @"UV_arrayOfValues":data[@"uvArrayOfValues"],
              @"PV_arrayOfValues":data[@"pvArrayOfValues"],
              @"VISIT_arrayOfValues":data[@"visitArrayOfValues"],
              @"新UV_arrayOfValues":data[@"newUvArrayOfValues"],
              @"有效UV_arrayOfValues":data[@"validUvArrayOfValues"],
              @"平均页面停留时间_arrayOfValues":data[@"arrayOfAvgPageTime"],
              @"提交订单转化率_arrayOfValues":data[@"avgOrderTransPercent"],
              @"有效订单转化率_arrayOfValues":data[@"validOrderTransPercent"],
              @"间接订单数_arrayOfValues":data[@"indirectOrderNum"],
              @"间接订单转化率_arrayOfValues":data[@"indirectOrderTransPercent"],
              @"UV_number":data[@"uvTotal"],
              @"PV_number":data[@"pvTotal"],
              @"VISIT_number":data[@"visitTotal"],
              @"新UV_number":data[@"newUvTotal"],
              @"有效UV_number":data[@"validUvTotal"],
              @"平均页面停留时间_number":data[@"avgPageTime"],
              @"提交订单转化率_number":data[@"orderPercent"],
              @"有效订单转化率_number":data[@"validOrderPercent"],
              @"间接订单数_number":data[@"indirectOrder"],
              @"间接订单转化率_number":data[@"indirectOrdPer"],
              };
}


- (void)createDetailOutlineData:(void(^)())succeedBlock
{
    NSString *url = [[NSString alloc] initWithFormat:@"%@/snf-mbbi-web/mbbi/getSourceDesc.htm?beginTime=%@&endTime=%@",serverAddress,_fromDate,_toDate];

    void (^successefullyBlock)(NSDictionary *) = ^(NSDictionary *data) {
        
        sourcesAnalyticsModel *strongSelf = _wself;
        
//        NSMutableArray *array1 = [[NSMutableArray alloc] init];
//        NSMutableArray *array2 = [[NSMutableArray alloc] init];
//        NSMutableArray *array3 = [[NSMutableArray alloc] init];
//        NSMutableArray *array4 = [[NSMutableArray alloc] init];
//        NSMutableArray *array5 = [[NSMutableArray alloc] init];
//        NSMutableArray *array6 = [[NSMutableArray alloc] init];
//        NSMutableArray *array7 = [[NSMutableArray alloc] init];
//        NSMutableArray *array8 = [[NSMutableArray alloc] init];
//        NSMutableArray *array9 = [[NSMutableArray alloc] init];
//        NSMutableArray *array10 = [[NSMutableArray alloc] init];
//        
//        NSArray *parallelArray = @[array1,array2,array3,array4,array5,array6,array7,array8,array9,array10];
//        NSMutableArray *arrayofDate = [NSMutableArray array];
//        for (int i = 0; i < 20; i++) {
//            [arrayofDate addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:i]]];
//        }
//        
//        //同步并行处理数据
//        dispatch_apply(10, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
//            [strongSelf addNumberToArray:parallelArray[index]];
//        });
        
//        _detailInitializeData =
//                 @{
//                            @"arrayOfDates":arrayofDate,
//                            @"UV_arrayOfValues":array1,
//                            @"PV_arrayOfValues":array2,
//                            @"VISIT_arrayOfValues":array3,
//                            @"新UV_arrayOfValues":array4,
//                            @"有效UV_arrayOfValues":array5,
//                            @"平均页面停留时间_arrayOfValues":array6,
//                            @"提交订单转化率_arrayOfValues":array7,
//                            @"有效订单转化率_arrayOfValues":array8,
//                            @"间接订单数_arrayOfValues":array9,
//                            @"间接订单转化率_arrayOfValues":array10,
//                            @"UV_number":@(arc4random() % 20000),
//                            @"PV_number":@(arc4random() % 20000),
//                            @"VISIT_number":@(arc4random() % 20000),
//                            @"新UV_number":@(arc4random() % 10000),
//                            @"有效UV_number":@(arc4random() % 2000),
//                            @"平均页面停留时间_number":@(arc4random() % 200),
//                            @"提交订单转化率_number":@(arc4random() % 100),
//                            @"有效订单转化率_number":@(arc4random() % 100),
//                            @"间接订单数_number":@(arc4random() % 1000),
//                            @"间接订单转化率_number":@(arc4random() % 100),
//            };
        
        _detailInitializeData = [strongSelf handleDetailOutlineData:data];
        
        _initializeDataReady = YES;
        if(succeedBlock){
            succeedBlock();
        }
        
    };

    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:url failureBlock:nil successedBlock:successefullyBlock];
}


- (void)reloadDetailOutlineFromDate:(NSString *)fromDate toDate:(NSString *)toDate
{
    NSString *url = [[NSString alloc] initWithFormat:@"%@/snf-mbbi-web/mbbi/getSourceDesc.htm?beginTime=%@&endTime=%@",serverAddress,fromDate,toDate];
    
    void (^successefullyBlock)(NSDictionary *) = ^(NSDictionary *data) {
        sourcesAnalyticsModel *strongSelf = _wself;
        
        NSDictionary *detailInitializeData = [strongSelf handleDetailOutlineData:data];
        
        NSNotification *notification = [[NSNotification alloc] initWithName:detailOutlineDataDidChange object:strongSelf userInfo:detailInitializeData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                       postingStyle:NSPostASAP
                                                       coalesceMask:NSNotificationCoalescingOnName forModes:@[NSDefaultRunLoopMode]];
        });
  
    };
    
    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:url failureBlock:nil successedBlock:successefullyBlock];
}


- (void)setAllDetailsDataNeedReload
{
    [_dimensionDataAvailableArray removeAllObjects];
    for (int i = 0; i < 6; i ++) {
        [_dimensionDataAvailableArray addObject:@NO];
    }
}

- (NSDictionary *)handleDetailsData:(NSDictionary *)data
{
    return @{
             @"tagType":data[@"tagType"],
             @"UV_array":data[@"uvArray"],
             @"PV_array":data[@"pvArray"],
             @"VISIT_array":data[@"visitArray"],
             @"新UV_array":data[@"newUvArray"],
             @"有效UV_array":data[@"validUvArray"],
             @"平均页面停留时间_array":data[@"pageTimeArray"],
             @"提交订单转化率_array":data[@"orderArray"],
             @"有效订单转化率_array":data[@"validOrderArray"],
             @"间接订单数_array":data[@"indirectOrderArray"],
             @"间接订单转化率_array":data[@"indirectOrderPerArray"],
             @"arrayOfDates":data[@"arrayOfDates"],
             @"UV_arrayOfValues":data[@"uvArrayOfValues"],
             @"PV_arrayOfValues":data[@"pvArrayOfValues"],
             @"VISIT_arrayOfValues":data[@"visitArrayOfValues"],
             @"新UV_arrayOfValues":data[@"newUvArrayOfValues"],
             @"有效UV_arrayOfValues":data[@"validUvArrayOfValues"],
             @"平均页面停留时间_arrayOfValues":data[@"arrayOfAvgPageTime"],
             @"提交订单转化率_arrayOfValues":data[@"avgOrderTransPercent"],
             @"有效订单转化率_arrayOfValues":data[@"validOrderTransPercent"],
             @"间接订单数_arrayOfValues":data[@"indirectOrderNum"],
             @"间接订单转化率_arrayOfValues":data[@"indirectOrderTransPercent"],
             @"UV_number":data[@"uvTotal"],
             @"PV_number":data[@"pvTotal"],
             @"VISIT_number":data[@"visitTotal"],
             @"新UV_number":data[@"newUvTotal"],
             @"有效UV_number":data[@"validUvTotal"],
             @"平均页面停留时间_number":data[@"avgPageTime"],
             @"提交订单转化率_number":data[@"orderPercent"],
             @"有效订单转化率_number":data[@"validOrderPercent"],
             @"间接订单数_number":data[@"indirectOrder"],
             @"间接订单转化率_number":data[@"indirectOrderPer"],
        };
}

- (void)getDisplayAdvertisingDetailsData:(void (^)(NSDictionary *data))succeedBlock
{
    if([_dimensionDataAvailableArray[0] isEqual:@NO]){
        //http://10.27.193.34//snf-mbbi-web/source/getYingGuang.htm?beginTime=2014-12-08&endTime=2014-12-08&srcCateId1=10
        NSString *url = [[NSString alloc] initWithFormat:@"%@/snf-mbbi-web/source/getYingGuang.htm?beginTime=%@&endTime=%@&srcCateId1=10",serverAddress,_fromDate,_toDate];
        
        void (^successfullyBlock)(NSDictionary *) = ^(NSDictionary *data) {
            
            _displayAdvertisingDetailsData = [[NSMutableDictionary alloc] initWithDictionary: [self handleDetailsData:data]];
            [_detailsData setObject:_displayAdvertisingDetailsData forKey: @"硬广"];
            _dimensionDataAvailableArray[0] = @YES;
            
            if(succeedBlock){
                succeedBlock(_displayAdvertisingDetailsData);
            }
        };
        [[networkManager sharedInstance] sendAsynchronousRequestWithURL:url failureBlock:successfullyBlock successedBlock:successfullyBlock];
    }
}

- (void)getNavigationDetailsData:(void (^)(NSDictionary *data))succeedBlock
{
    if([_dimensionDataAvailableArray[1] isEqual:@NO]){
        
        NSString *url = [[NSString alloc] initWithFormat:@"%@/snf-mbbi-web/source/getYingGuang.htm?beginTime=%@&endTime=%@&srcCateId1=20",serverAddress,_fromDate,_toDate];
        
        void (^successfullyBlock)(NSDictionary *) = ^(NSDictionary *data) {
            
            _navigationDetailsData = [[NSMutableDictionary alloc] initWithDictionary: [self handleDetailsData:data]];
            [_detailsData setObject:_navigationDetailsData forKey: @"导航"];
            _dimensionDataAvailableArray[1] = @YES;
            
            if(succeedBlock){
                succeedBlock(_navigationDetailsData);
            }
        };
        [[networkManager sharedInstance] sendAsynchronousRequestWithURL:url failureBlock:nil successedBlock:successfullyBlock];
    }
}


- (void)getSearchDetailsData:(void (^)(NSDictionary *data))succeedBlock
{
    if([_dimensionDataAvailableArray[2] isEqual:@NO]){
        
        NSString *url = [[NSString alloc] initWithFormat:@"%@/snf-mbbi-web/source/getYingGuang.htm?beginTime=%@&endTime=%@&srcCateId1=30",serverAddress,_fromDate,_toDate];
        
        void (^successfullyBlock)(NSDictionary *) = ^(NSDictionary *data) {
            
            _searchDetailsData = [[NSMutableDictionary alloc] initWithDictionary: [self handleDetailsData:data]];
            [_detailsData setObject:_searchDetailsData forKey: @"搜索"];
            _dimensionDataAvailableArray[2] = @YES;
            
            if(succeedBlock){
                succeedBlock(_searchDetailsData);
            }
        };
        [[networkManager sharedInstance] sendAsynchronousRequestWithURL:url failureBlock:nil successedBlock:successfullyBlock];
    }
}


- (void)getADAllianceDetailsData:(void (^)(NSDictionary *data))succeedBlock
{
    if([_dimensionDataAvailableArray[3] isEqual:@NO]){
        
        NSString *url = [[NSString alloc] initWithFormat:@"%@/snf-mbbi-web/source/getYingGuang.htm?beginTime=%@&endTime=%@&srcCateId1=40",serverAddress,_fromDate,_toDate];
        
        void (^successfullyBlock)(NSDictionary *) = ^(NSDictionary *data) {
  
            _ADAllianceDetailsData = [[NSMutableDictionary alloc] initWithDictionary: [self handleDetailsData:data]];
            [_detailsData setObject:_ADAllianceDetailsData forKey: @"广告联盟"];
            _dimensionDataAvailableArray[3] = @YES;
            
            if(succeedBlock){
                succeedBlock(_ADAllianceDetailsData);
            }
        };
        [[networkManager sharedInstance] sendAsynchronousRequestWithURL:url failureBlock:nil successedBlock:successfullyBlock];
    }
}


- (void)getDirectFlowDetailsData:(void (^)(NSDictionary *data))succeedBlock
{
    if([_dimensionDataAvailableArray[4] isEqual:@NO]){
        
        NSString *url = [[NSString alloc] initWithFormat:@"%@/snf-mbbi-web/source/getYingGuang.htm?beginTime=%@&endTime=%@&srcCateId1=50",serverAddress,_fromDate,_toDate];
        
        void (^successfullyBlock)(NSDictionary *) = ^(NSDictionary *data) {
            
            _directFlowDetailsData = [[NSMutableDictionary alloc] initWithDictionary: [self handleDetailsData:data]];
            [_detailsData setObject:_directFlowDetailsData forKey: @"直接流量"];
            _dimensionDataAvailableArray[4] = @YES;
            
            if(succeedBlock){
                succeedBlock(_directFlowDetailsData);
            }
        };
        [[networkManager sharedInstance] sendAsynchronousRequestWithURL:url failureBlock:nil successedBlock:successfullyBlock];
    }
}


- (void)getEDMDetailsData:(void (^)(NSDictionary *data))succeedBlock
{
    if([_dimensionDataAvailableArray[5] isEqual:@NO]){
        
        NSString *url = [[NSString alloc] initWithFormat:@"%@/snf-mbbi-web/source/getYingGuang.htm?beginTime=%@&endTime=%@&srcCateId1=60",serverAddress,_fromDate,_toDate];
        
        void (^successfullyBlock)(NSDictionary *) = ^(NSDictionary *data) {
            
            _EDMDetailsData = [[NSMutableDictionary alloc] initWithDictionary: [self handleDetailsData:data]];
            [_detailsData setObject:_EDMDetailsData forKey: @"EDM"];
            _dimensionDataAvailableArray[5] = @YES;
            
            if(succeedBlock){
                succeedBlock(_EDMDetailsData);
            }
        };
        [[networkManager sharedInstance] sendAsynchronousRequestWithURL:url failureBlock:nil successedBlock:successfullyBlock];
    }
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
//                        @"硬广":@{@"tagType":@[@"运营商",@"垂直",@"DSP"],
//                                @"indexOptionsArray":indexOptionsArray},
//                        @"导航":@{@"tagType":@[@"付费导航",@"免费导航"],
//                                @"indexOptionsArray":indexOptionsArray},
//                        @"搜索":@{@"tagType":@[@"SEO",@"SEM"],
//                                @"indexOptionsArray":indexOptionsArray},
//                        @"广告联盟":@{@"tagType":@[@"广告联盟"],
//                                  @"indexOptionsArray":indexOptionsArray},
//                        @"直接流量":@{@"tagType":@[@"直接流量"],
//                                  @"indexOptionsArray":indexOptionsArray},
//                        @"EDM":@{@"tagType":@[@"会员EDM"],
//                                 @"indexOptionsArray":indexOptionsArray},
//                        };

    
    _detailsData = [[NSMutableDictionary alloc] initWithDictionary:
                 @{
                   @"硬广":@{
                               @"tagType":@[@"运营商",@"垂直",@"DSP"],
                               @"tagValue":@[@(arc4random() % 2000),@(arc4random() % 2000),@(arc4random() % 2000)],
                               @"arrayOfDates":arrayofDate,
                               @"UV_arrayOfValues":array1,@"PV_arrayOfValues":array2,@"VISIT_arrayOfValues":array3,@"新UV_arrayOfValues":array4,@"有效UV_arrayOfValues":array5,@"平均页面停留时间_arrayOfValues":array6,@"提交订单转化率_arrayOfValues":array7,@"有效订单转化率_arrayOfValues":array8,@"间接订单数_arrayOfValues":array9,@"间接订单转化率_arrayOfValues":array10,
                               @"UV_number":@(arc4random() % 20000),@"PV_number":@(arc4random() % 20000),@"VISIT_number":@(arc4random() % 20000),@"新UV_number":@(arc4random() % 10000),@"有效UV_number":@(arc4random() % 2000),@"平均页面停留时间_number":@(arc4random() % 200),@"提交订单转化率_number":@(arc4random() % 100),@"有效订单转化率_number":@(arc4random() % 100),@"间接订单数_number":@(arc4random() % 10000),@"间接订单转化率_number":@(arc4random() % 100),
                               },
                       @"导航":@{
                               @"tagType":@[@"付费导航",@"免费导航"],
                               @"tagValue":@[@(arc4random() % 2000),@(arc4random() % 2000)],
                               @"arrayOfDates":arrayofDate,
                               @"UV_arrayOfValues":array1,@"PV_arrayOfValues":array2,@"VISIT_arrayOfValues":array3,@"新UV_arrayOfValues":array4,@"有效UV_arrayOfValues":array5,@"平均页面停留时间_arrayOfValues":array6,@"提交订单转化率_arrayOfValues":array7,@"有效订单转化率_arrayOfValues":array8,@"间接订单数_arrayOfValues":array9,@"间接订单转化率_arrayOfValues":array10,
                               @"UV_number":@(arc4random() % 20000),@"PV_number":@(arc4random() % 20000),@"VISIT_number":@(arc4random() % 20000),@"新UV_number":@(arc4random() % 10000),@"有效UV_number":@(arc4random() % 2000),@"平均页面停留时间_number":@(arc4random() % 200),@"提交订单转化率_number":@(arc4random() % 100),@"有效订单转化率_number":@(arc4random() % 100),@"间接订单数_number":@(arc4random() % 10000),@"间接订单转化率_number":@(arc4random() % 100),
                               },
                       @"搜索":@{
                               @"tagType":@[@"SEO",@"SEM"],
                               @"tagValue":@[@(arc4random() % 20000),@(arc4random() % 20000)],
                               @"arrayOfDates":arrayofDate,
                               @"UV_arrayOfValues":array1,@"PV_arrayOfValues":array2,@"VISIT_arrayOfValues":array3,@"新UV_arrayOfValues":array4,@"有效UV_arrayOfValues":array5,@"平均页面停留时间_arrayOfValues":array6,@"提交订单转化率_arrayOfValues":array7,@"有效订单转化率_arrayOfValues":array8,@"间接订单数_arrayOfValues":array9,@"间接订单转化率_arrayOfValues":array10,
                               @"UV_number":@(arc4random() % 20000),@"PV_number":@(arc4random() % 20000),@"VISIT_number":@(arc4random() % 20000),@"新UV_number":@(arc4random() % 10000),@"有效UV_number":@(arc4random() % 2000),@"平均页面停留时间_number":@(arc4random() % 200),@"提交订单转化率_number":@(arc4random() % 100),@"有效订单转化率_number":@(arc4random() % 100),@"间接订单数_number":@(arc4random() % 10000),@"间接订单转化率_number":@(arc4random() % 100),
                               },
                       @"广告联盟":@{
                               @"tagType":@[@"广告联盟"],
                               @"tagValue":@[@(arc4random() % 10000)],
                               @"arrayOfDates":arrayofDate,
                               @"UV_arrayOfValues":array1,@"PV_arrayOfValues":array2,@"VISIT_arrayOfValues":array3,@"新UV_arrayOfValues":array4,@"有效UV_arrayOfValues":array5,@"平均页面停留时间_arrayOfValues":array6,@"提交订单转化率_arrayOfValues":array7,@"有效订单转化率_arrayOfValues":array8,@"间接订单数_arrayOfValues":array9,@"间接订单转化率_arrayOfValues":array10,
                               @"UV_number":@(arc4random() % 20000),@"PV_number":@(arc4random() % 20000),@"VISIT_number":@(arc4random() % 20000),@"新UV_number":@(arc4random() % 10000),@"有效UV_number":@(arc4random() % 2000),@"平均页面停留时间_number":@(arc4random() % 200),@"提交订单转化率_number":@(arc4random() % 100),@"有效订单转化率_number":@(arc4random() % 100),@"间接订单数_number":@(arc4random() % 10000),@"间接订单转化率_number":@(arc4random() % 100),
                               },
                       @"直接流量":@{
                               @"tagType":@[@"直接流量"],
                               @"tagValue":@[@(arc4random() % 20000)],
                               @"arrayOfDates":arrayofDate,
                               @"UV_arrayOfValues":array1,@"PV_arrayOfValues":array2,@"VISIT_arrayOfValues":array3,@"新UV_arrayOfValues":array4,@"有效UV_arrayOfValues":array5,@"平均页面停留时间_arrayOfValues":array6,@"提交订单转化率_arrayOfValues":array7,@"有效订单转化率_arrayOfValues":array8,@"间接订单数_arrayOfValues":array9,@"间接订单转化率_arrayOfValues":array10,
                               @"UV_number":@(arc4random() % 20000),@"PV_number":@(arc4random() % 20000),@"VISIT_number":@(arc4random() % 20000),@"新UV_number":@(arc4random() % 10000),@"有效UV_number":@(arc4random() % 2000),@"平均页面停留时间_number":@(arc4random() % 200),@"提交订单转化率_number":@(arc4random() % 100),@"有效订单转化率_number":@(arc4random() % 100),@"间接订单数_number":@(arc4random() % 10000),@"间接订单转化率_number":@(arc4random() % 100),
                               },
                       @"EDM":@{
                               @"tagType":@[@"会员EDM"],
                               @"tagValue":@[@(arc4random() % 20000)],
                               @"arrayOfDates":arrayofDate,
                               @"UV_arrayOfValues":array1,@"PV_arrayOfValues":array2,@"VISIT_arrayOfValues":array3,@"新UV_arrayOfValues":array4,@"有效UV_arrayOfValues":array5,@"平均页面停留时间_arrayOfValues":array6,@"提交订单转化率_arrayOfValues":array7,@"有效订单转化率_arrayOfValues":array8,@"间接订单数_arrayOfValues":array9,@"间接订单转化率_arrayOfValues":array10,
                               @"UV_number":@(arc4random() % 20000),@"PV_number":@(arc4random() % 20000),@"VISIT_number":@(arc4random() % 20000),@"新UV_number":@(arc4random() % 10000),@"有效UV_number":@(arc4random() % 2000),@"平均页面停留时间_number":@(arc4random() % 200),@"提交订单转化率_number":@(arc4random() % 100),@"有效订单转化率_number":@(arc4random() % 100),@"间接订单数_number":@(arc4random() % 10000),@"间接订单转化率_number":@(arc4random() % 100),
                               },
                        }];
    
}


- (void)addNumberToArray:(NSMutableArray *)array
{
    for (int i = 0; i < 20; i++) {
        [array addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
    }
}

@end
