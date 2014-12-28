//
//  pageAnalyticsModel.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-12-2.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "pageAnalyticsModel.h"
#import "networkManager.h"
#import "networkDefine.h"

@implementation pageAnalyticsModel
{
    __weak id      _wself;
    NSMutableArray *_arrayOfDates;
    NSMutableArray *_groupPercentArray;
    NSMutableArray *_groupValidPercentArray;
    
    NSMutableDictionary *_pageTypeDetailsData;
    NSMutableDictionary *_landPageDetailsData;
    NSMutableDictionary *_exitPageDetailsData;
    
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
        _dimensionDataAvailableArray = [[NSMutableArray alloc] initWithArray:@[@NO,@NO,@NO]];

        _detailsData = [[NSMutableDictionary alloc] initWithCapacity:3];
        _detailsDataMethodsArray  = @[@"getPageTypeDetailsData:",@"getLandPageDetailsData:",@"getExitPageDetailsData:"];

        _fromDate = @"2014-12-08";
        _toDate = @"2014-12-08";
        
        _wself = self;
        
    }
    
    return self;
}

- (void)setAllDetailsDataNeedReload
{
    [_dimensionDataAvailableArray removeAllObjects];
    for (int i = 0; i < 3; i ++) {
        [_dimensionDataAvailableArray addObject:@NO];
    }
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
                        @"页面类型":@{@"tagType":@[@"苏宁易购首页",@"商品四级页面"],
                                   @"indexOptionsArray":indexOptionsArray},
                        @"着陆页":@{@"tagType":@[@"苏宁易购首页"],
                                 @"indexOptionsArray":indexOptionsArray},
                        @"退出页":@{@"tagType":@[@"苏宁易购首页",@"商品四级页面"],
                                 @"indexOptionsArray":indexOptionsArray1},
                        };
    
}

- (void)getOutlineData
{
    void (^successefullyBlock)(NSDictionary *data) = ^(NSDictionary *data) {
        pageAnalyticsModel *strongSelf = _wself;
        
        if(!data){
            _outlineData = @{
                             @"PV":@(arc4random() % 100000),
                             @"fourthPagePV":@(arc4random() % 10000),
                             @"shoppingCartPV":@(arc4random() % 10000)
                            };
        }else{
            _outlineData = @{
                             @"PV":data[@"pvQty"],
                             @"fourthPagePV":data[@"fourthPagePV"],
                             @"shoppingCartPV":data[@"shoppingCartPV"]
                             };
        }
        
        NSNotification *notification = [[NSNotification alloc] initWithName:pageAnalyticsOutlineDataDidInitialize object:strongSelf userInfo:_outlineData];
        
        // 异步处理通知
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                       postingStyle:NSPostASAP
                                                       coalesceMask:NSNotificationCoalescingOnName forModes:@[NSDefaultRunLoopMode]];
        });
    };
    
    NSString *URL = [[NSString alloc] initWithFormat:@"%@/snf-mbbi-web/mbbi/getPageAnalyse.htm?beginTime=%@&endTime=%@",serverAddress,_fromDate,_toDate];
    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:URL failureBlock:successefullyBlock successedBlock:successefullyBlock];
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
    return @{  @"arrayOfDates":data[@"arrayOfDates"],
               @"PV_arrayOfValues":data[@"pvArrayOfValues"],
               @"UV_arrayOfValues":data[@"uvArrayOfValues"],
               @"平均页面停留时间_arrayOfValues":data[@"avgPageTimeArrayOfValues"],
               @"一跳_arrayOfValues":data[@"clickArrayOfValues"],
               @"四级页面PV_arrayOfValues":data[@"fourPagePvArrayOfValues"],
               @"购物车PV_arrayOfValues":data[@"shopCatPVArrayOfValues"],
               @"PV_number":data[@"pvNumber"],
               @"UV_number":data[@"uvNumber"],
               @"平均页面停留时间_number":data[@"avgPageTimeNumber"],
               @"一跳_number":data[@"clickNumber"],
               @"四级页面PV_number":data[@"fourPagePVNumber"],
               @"购物车PV_number":data[@"shopCatPVNumber"],
              };
    
}

- (void)createDetailOutlineData:(void(^)())succeedBlock
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

        if(data){
            _detailInitializeData = [strongSelf handleDetailOutlineData:data];
        }else{
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
        }
        
        _initializeDataReady = YES;
        
        if(succeedBlock){
            succeedBlock();
        }
        
        NSNotification *notification = [[NSNotification alloc] initWithName:pageAnalyticsDetailOutlineDataDidInitialize object:strongSelf userInfo:_detailInitializeData];

        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                       postingStyle:NSPostASAP
                                                       coalesceMask:NSNotificationCoalescingOnName forModes:@[NSDefaultRunLoopMode]];
        });
        
    };
    
    NSString *URL = [[NSString alloc] initWithFormat:@"%@/snf-mbbi-web/mbbi/getPageDesc.htm?beginTime=%@&endTime=%@",serverAddress,_fromDate,_toDate];
    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:URL failureBlock:successefullyBlock successedBlock:successefullyBlock];
}


- (void)reloadDetailOutlineFromDate:(NSString *)fromDate toDate:(NSString *)toDate
{
    void (^successefullyBlock)(NSDictionary *) = ^(NSDictionary *data) {
        pageAnalyticsModel *strongSelf = _wself;
        
        NSDictionary *detailInitializeData = [strongSelf handleDetailOutlineData:data];
        
        NSNotification *notification = [[NSNotification alloc] initWithName:detailOutlineDataDidChange object:strongSelf userInfo:detailInitializeData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                       postingStyle:NSPostASAP
                                                       coalesceMask:NSNotificationCoalescingOnName forModes:@[NSDefaultRunLoopMode]];
        });
        
    };
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@/snf-mbbi-web/mbbi/getPageDesc.htm?beginTime=%@&endTime=%@",serverAddress,fromDate,toDate];
    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:url failureBlock:nil successedBlock:successefullyBlock];
    
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

- (NSDictionary *)handleDetailsData:(NSDictionary *)data
{
    return @{
             @"tagType":data[@"tagType"],
             @"arrayOfDates":data[@"arrayOfDates"],
             @"UV_array":data[@"uvArray"],
             @"PV_array":data[@"pvArray"],
             @"平均页面停留时间_array":data[@"avgPageTimeArray"],
             @"一跳_array":data[@"clickArray"],
             @"四级页面PV_array":data[@"fourPagePvArray"],
             @"购物车PV_array":data[@"shopCatPVArray"],
             @"UV_arrayOfValues":data[@"uvArrayOfValues"],
             @"PV_arrayOfValues":data[@"pvArrayOfValues"],
             @"平均页面停留时间_arrayOfValues":data[@"avgPageTimeArrayOfValues"],
             @"一跳_arrayOfValues":data[@"clickArrayOfValues"],
             @"四级页面PV_arrayOfValues":data[@"fourPagePvArrayOfValues"],
             @"购物车PV_arrayOfValues":data[@"shopCatPVArrayOfValues"],
             @"UV_number":data[@"uvNumber"],
             @"PV_number":data[@"pvNumber"],
             @"平均页面停留时间_number":data[@"avgPageTimeNumber"],
             @"一跳_number":data[@"clickNumber"],
             @"四级页面PV_number":data[@"fourPagePVNumber"],
             @"购物车PV_number":data[@"shopCatPVNumber"],
             };
}

- (void)getPageTypeDetailsData:(void (^)(NSDictionary *data))succeedBlock
{
    if([_dimensionDataAvailableArray[0] isEqual:@NO]){
        
        void (^successfullyBlock)(NSDictionary *) = ^(NSDictionary *data) {
            _pageTypeDetailsData = [[NSMutableDictionary alloc] initWithDictionary: [self handleDetailsData:data]];
            
            [_detailsData setObject:_pageTypeDetailsData forKey: @"页面类型"];
            _dimensionDataAvailableArray[0] = @YES;
            
            if(succeedBlock && _pageTypeDetailsData){
                succeedBlock(_pageTypeDetailsData);
            }
        };
        
        //http://10.27.193.34:80/snf-mbbi-web/page/getPageType.htm?beginTime=2014-12-08&endTime=2014-12-08
        NSString *url = [[NSString alloc] initWithFormat:@"%@/snf-mbbi-web/page/getPageType.htm?beginTime=%@&endTime=%@",serverAddress,_fromDate,_toDate];
        [[networkManager sharedInstance] sendAsynchronousRequestWithURL:url failureBlock:nil successedBlock:successfullyBlock];
    }
}

- (void)getLandPageDetailsData:(void (^)(NSDictionary *data))succeedBlock
{
    if([_dimensionDataAvailableArray[1] isEqual:@NO]){
        
        void (^successfullyBlock)(NSDictionary *) = ^(NSDictionary *data) {
            _landPageDetailsData = [[NSMutableDictionary alloc] initWithDictionary: [self handleDetailsData:data]];
            
            [_detailsData setObject:_landPageDetailsData forKey: @"着陆页"];
            _dimensionDataAvailableArray[1] = @YES;
            
            if(succeedBlock && _landPageDetailsData){
                succeedBlock(_landPageDetailsData);
            }
        };
        
        //http://10.27.193.34:80/snf-mbbi-web/page/getLoadPage.htm?beginTime=2014-12-08&endTime=2014-12-08
        NSString *url = [[NSString alloc] initWithFormat:@"%@/snf-mbbi-web/page/getLoadPage.htm?beginTime=%@&endTime=%@",serverAddress,_fromDate,_toDate];
        [[networkManager sharedInstance] sendAsynchronousRequestWithURL:url failureBlock:nil successedBlock:successfullyBlock];
    }
}


- (void)getExitPageDetailsData:(void (^)(NSDictionary *data))succeedBlock
{
    if([_dimensionDataAvailableArray[2] isEqual:@NO]){
        
        void (^successfullyBlock)(NSDictionary *) = ^(NSDictionary *data) {
            _exitPageDetailsData = [[NSMutableDictionary alloc] initWithDictionary:
                 @{
                    @"tagType":data[@"tagType"],
                    @"arrayOfDates":data[@"arrayOfDates"],
                    @"PV_array":data[@"pvArray"],
                    @"退出次数_array":data[@"exitTimesArray"],
                    @"退出率_array":data[@"exitPercentArray"],
                    @"退出占比_array":data[@"exitPercentOfAllArray"],
                    @"PV_arrayOfValues":data[@"pvArrayOfValues"],
                    @"退出次数_arrayOfValues":data[@"exitTimesArrayOfValues"],
                    @"退出率_arrayOfValues":data[@"exitPercentArrayOfValues"],
                    @"退出占比_arrayOfValues":data[@"exitPercentOfAllArrayOfValues"],
                    @"PV_number":data[@"pvNumber"],
                    @"退出次数_number":data[@"exitTimesNumber"],
                    @"退出率_number":data[@"exitPercentNumber"],
                    @"退出占比_number":data[@"exitPercentOfAllNumber"],
                  }];

            [_detailsData setObject:_exitPageDetailsData forKey: @"退出页"];
            _dimensionDataAvailableArray[2] = @YES;
            
            if(succeedBlock && _exitPageDetailsData){
                succeedBlock(_exitPageDetailsData);
            }
        };
        
        //http://10.27.193.34:80/snf-mbbi-web/page/getExitPage.htm?beginTime=2014-12-08&endTime=2014-12-08
        NSString *url = [[NSString alloc] initWithFormat:@"%@/snf-mbbi-web/page/getExitPage.htm?beginTime=%@&endTime=%@",serverAddress,_fromDate,_toDate];
        [[networkManager sharedInstance] sendAsynchronousRequestWithURL:url failureBlock:nil successedBlock:successfullyBlock];
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
//                        @"页面类型":@{@"tagType":@[@"苏宁易购首页",@"商品四级页面"],
//                                  @"indexOptionsArray":indexOptionsArray},
//                        @"着陆页":@{@"tagType":@[@"苏宁易购首页"],
//                                 @"indexOptionsArray":indexOptionsArray},
//                        @"退出页":@{@"tagType":@[@"苏宁易购首页",@"商品四级页面"],
//                                 @"indexOptionsArray":indexOptionsArray1},
//                        };
    
    
    _detailsData = [[NSMutableDictionary alloc] initWithDictionary:
                   @{ @"页面类型":@{
                               @"tagType":@[@"苏宁易购首页",@"商品四级页面"],
                               @"tagValue":@[@(arc4random() % 20000),@(arc4random() % 20000)],
                               @"arrayOfDates":arrayofDate,
                               @"PV_arrayOfValues":array1,@"UV_arrayOfValues":array2,@"平均页面停留时间_arrayOfValues":array3,@"一跳_arrayOfValues":array4,@"四级页面PV_arrayOfValues":array5,@"购物车PV_arrayOfValues":array6,
                               @"PV_number":@(arc4random() % 20000),@"UV_number":@(arc4random() % 20000),@"平均页面停留时间_number":@(arc4random() % 100),@"一跳_number":@(arc4random() % 10000),@"四级页面PV_number":@(arc4random() % 20000),@"购物车PV_number":@(arc4random() % 20000)
                               },
                       @"着陆页":@{
                               @"tagType":@[@"苏宁易购首页"],
                               @"tagValue":@[@(arc4random() % 20000)],
                               @"arrayOfDates":arrayofDate,
                               @"PV_arrayOfValues":array1,@"UV_arrayOfValues":array2,@"平均页面停留时间_arrayOfValues":array3,@"一跳_arrayOfValues":array4,@"四级页面PV_arrayOfValues":array5,@"购物车PV_arrayOfValues":array6,
                               @"PV_number":@(arc4random() % 20000),@"UV_number":@(arc4random() % 20000),@"平均页面停留时间_number":@(arc4random() % 100),@"一跳_number":@(arc4random() % 10000),@"四级页面PV_number":@(arc4random() % 20000),@"购物车PV_number":@(arc4random() % 20000)
                               },
                       @"退出页":@{
                               @"tagType":@[@"苏宁易购首页",@"商品四级页面"],
                               @"tagValue":@[@(arc4random() % 20000),@(arc4random() % 20000)],
                               @"arrayOfDates":arrayofDate,
                               @"PV_arrayOfValues":array1,@"退出次数_arrayOfValues":array2,@"退出率_arrayOfValues":array3,@"退出占比_arrayOfValues":array4,
                               @"PV_number":@(arc4random() % 20000),@"退出次数_number":@(arc4random() % 20000),@"退出率_number":@(arc4random() % 100),@"退出占比_number":@(arc4random() % 100)
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
