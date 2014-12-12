//
//  realTimeModel.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-17.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "realTimeModel.h"
#import "Colours.h"
#import "PNColor.h"
#import "networkManager.h"
#import "defines.h"

static NSString *const realTimeDataDidChange            = @"realTimeDataDidChanged";
static NSString *const realTimeOutlineDataDidInitialize = @"realTimeOutlineDataDidInitialize";


@implementation realTimeModel
{
    __weak id    _wself;
    NSTimer      *_timer;
}

#pragma mark - sharedInstance

+ (instancetype)sharedInstance
{
    static realTimeModel *sharedInstance = nil;
    
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
        _initializeDataReady = NO;
        
        [self getOutlineData];
    }
    return self;
}


#pragma mark - getInitializedRealTimeDeatilsData

- (void)getOutlineData
{
    void (^successefullyBlock)(NSDictionary *) = ^(NSDictionary *data) {
        _groupUV      = arc4random() % 20000;
        _validUVRatio = ((arc4random() % 500) + 500) / 1000.0;
        _validGroupUV = _groupUV * _validUVRatio;
        _visit        = arc4random() % 100000;

        _dealMoney               = arc4random() % 20000;
        _validDealNumber         = (arc4random() % 1000);
        _validDealTransformRatio = ((arc4random() % 1000)/1000.0) * 100;
        
        _groupPercentArray      = [[NSMutableArray alloc] initWithArray:@[@(arc4random() % 100),
                                                                          @(arc4random() % 100),
                                                                          @(arc4random() % 100),
                                                                          @(arc4random() % 100),
                                                                          @(arc4random() % 100),
                                                                          @(arc4random() % 100)]];
        
        _groupValidPercentArray = [[NSMutableArray alloc] initWithArray:@[@(arc4random() % 20),
                                                                          @(arc4random() % 20),
                                                                          @(arc4random() % 20),
                                                                          @(arc4random() % 20),
                                                                          @(arc4random() % 20),
                                                                          @(arc4random() % 20)]];
        
        _cityValueArray         = [[NSMutableArray alloc] initWithArray:@[@(arc4random() % 100),
                                                                          @(arc4random() % 100),
                                                                          @(arc4random() % 100),
                                                                          @(arc4random() % 100),
                                                                          @(arc4random() % 100)]];
        
        _pagesValueArray        = [[NSMutableArray alloc] initWithArray:@[@(arc4random() % 100),
                                                                          @(arc4random() % 100),
                                                                          @(arc4random() % 100),
                                                                          @(arc4random() % 100),
                                                                          @(arc4random() % 100)]];
        
        _cityNameArray          =  [[NSMutableArray alloc] initWithArray:@[@"北京",@"上海",@"广州",@"深圳",@"南京"]];
        _pagesNameArray         =  [[NSMutableArray alloc] initWithArray:@[@"页面1",@"页面2",@"页面3",@"页面4",@"页面5"]];

        
        _groupColorArray = @[PNLightGreen,PNFreshGreen,PNDeepGreen,PNRed,PNTitleColor,PNYellow,PNBrown];
        _validSourceUVColorArray = @[[UIColor robinEggColor],[UIColor pastelBlueColor],[UIColor turquoiseColor],[UIColor steelBlueColor],[UIColor denimColor],[UIColor emeraldColor],[UIColor cardTableColor]];
        
        _arrayOfValues = [[NSMutableArray alloc] init];
        _arrayOfDates  = [[NSMutableArray alloc] init];
        _sendDict      = [[NSDictionary alloc] init];
        
        realTimeModel *strongSelf = _wself;

        for (int i = 0; i < 20; i++) {
            [_arrayOfDates addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:i]]];
            
            [_arrayOfValues addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
        }
        
        NSMutableArray *parallelArray = [[NSMutableArray alloc] initWithCapacity:8];
        for(int i = 0; i < 8; i++){
            [parallelArray addObject:[[NSMutableArray alloc] init]];
        }
    
        dispatch_apply(8, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
            [strongSelf addNumberToArray:parallelArray[index]];
        });
        
        
        _initializeData = @{@"groupUV":@(_groupUV),
                            @"validUVRatio":@(_validUVRatio),
                            @"validGroupUV":@(_validGroupUV),
                            @"VISIT":@(_visit),
                            @"dealMoney":@(_dealMoney),
                            @"validDealNumber":@(_validDealNumber),
                            @"validDealTransformRatio":@(_validDealTransformRatio),
                            @"groupPercentArray":_groupPercentArray,
                            @"groupValidPercentArray":_groupValidPercentArray,
                            @"groupColorArray":_groupColorArray,
                            @"validSourceUVColorArray":_validSourceUVColorArray,
                            @"cityNameArray":_cityNameArray,
                            @"cityValueArray":_cityValueArray,
                            @"pagesNameArray":_pagesNameArray,
                            @"pagesValueArray":_pagesValueArray,
                            @"arrayOfValues":_arrayOfValues,
                            @"arrayOfDates":_arrayOfDates,
                            @"UV_arrayOfValues":parallelArray[0],
                            @"PV_arrayOfValues":parallelArray[1],
                            @"VISIT_arrayOfValues":parallelArray[2],
                            @"新UV_arrayOfValues":parallelArray[3],
                            @"有效UV_arrayOfValues":parallelArray[4],
                            @"付款金额_arrayOfValues":parallelArray[5],
                            @"有效订单数_arrayOfValues":parallelArray[6],
                            @"有效订单转化率_arrayOfValues":parallelArray[7],
                            @"UV_number":@(arc4random() % 20000),
                            @"PV_number":@(arc4random() % 20000),
                            @"VISIT_number":@(arc4random() % 20000),
                            @"新UV_number":@(arc4random() % 10000),
                            @"有效UV_number":@(arc4random() % 2000),
                            @"付款金额_number":@(arc4random() % 20000),
                            @"有效订单数_number":@(arc4random() % 200),
                            @"有效订单转化率_number":@(arc4random() % 100)
                            };
        
        _initializeDataReady = YES;
        
//        dispatch_async(dispatch_get_main_queue(),^{
//            [[NSNotificationCenter defaultCenter] postNotificationName:dataDidInitialize object:strongSelf userInfo:_initializeData];
//        });
        
        NSNotification *notification = [[NSNotification alloc] initWithName:realTimeOutlineDataDidInitialize object:strongSelf userInfo:_initializeData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                       postingStyle:NSPostASAP
                                                       coalesceMask:NSNotificationCoalescingOnName forModes:@[NSDefaultRunLoopMode]];
        });

        //            if (![NSThread isMainThread]) {
        //                NSLog(@"not in mainThread");
        //            }
        //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _timer = [NSTimer scheduledTimerWithTimeInterval:6.0f target:strongSelf selector:@selector(getNewData) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] run];
        
        //            });
        //             [NSThread detachNewThreadSelector:@selector(startTimer) toTarget:self withObject:nil];
        
    };
    
    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:nil failureBlock:^(NSDictionary *data) {
        successefullyBlock(data);
    }successedBlock:^(NSDictionary *data) {
        successefullyBlock(data);
    }];
}

- (void)getNewData
{
     void (^successefullyBlock)(NSDictionary *data) = ^(NSDictionary *data) {
         realTimeModel *strongSelf = _wself;
         
         _groupUV = arc4random() % 20000;
         _validUVRatio = ((arc4random() % 500) + 500) / 1000.0;
         _validGroupUV = _groupUV * _validUVRatio;
         _visit = arc4random() % 100000;
         _dealMoney = arc4random() % 20000;
         _validDealNumber = (arc4random() % 1000);
         _validDealTransformRatio = ((arc4random() % 1000)/1000.0) * 100;

         _groupPercentArray = [[NSMutableArray alloc] initWithArray:@[@(arc4random() % 100),
                                                                      @(arc4random() % 100),
                                                                      @(arc4random() % 100),
                                                                      @(arc4random() % 100),
                                                                      @(arc4random() % 100),
                                                                      @(arc4random() % 100)
                                                                      ]];

         _groupValidPercentArray = [[NSMutableArray alloc] initWithArray:@[@(arc4random() % 20),
                                                                           @(arc4random() % 20),
                                                                           @(arc4random() % 20),
                                                                           @(arc4random() % 20),
                                                                           @(arc4random() % 20),
                                                                           @(arc4random() % 20)]];
         _cityValueArray              = [[NSMutableArray alloc] initWithArray:@[@(arc4random() % 100),
                                                                           @(arc4random() % 100),
                                                                           @(arc4random() % 100),
                                                                           @(arc4random() % 100),
                                                                           @(arc4random() % 100)]];
         
         _pagesValueArray         = [[NSMutableArray alloc] initWithArray:@[@(arc4random() % 100),
                                                                           @(arc4random() % 100),
                                                                           @(arc4random() % 100),
                                                                           @(arc4random() % 100),
                                                                           @(arc4random() % 100)]];

         
         NSMutableArray *parallelArray = [[NSMutableArray alloc] initWithCapacity:8];
         for(int i = 0; i < 8; i++){
             [parallelArray addObject:[[NSMutableArray alloc] init]];
         }
         
         [_arrayOfValues removeAllObjects];
         for (int i = 0; i < 20; i++) {
             [_arrayOfValues addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
         }
         
         //同步的并行处理
         dispatch_apply(8, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
//             NSLog(@"parallel %i",index);
             [strongSelf addNumberToArray:parallelArray[index]];
         });
                  
         _sendDict = @{@"groupUV":@(_groupUV),
                       @"validUVRatio":@(_validUVRatio),
                       @"validGroupUV":@(_validGroupUV),
                       @"groupPercentArray":_groupPercentArray,
                       @"groupValidPercentArray":_groupValidPercentArray,
                       @"cityNameArray" :_cityNameArray,
                       @"cityValueArray":_cityValueArray,
                       @"pagesNameArray":_pagesNameArray,
                       @"pagesValueArray":_pagesValueArray,
                       @"arrayOfValues":_arrayOfValues,
                       @"VISIT":@(_visit),
                       @"dealMoney":@(_dealMoney),
                       @"validDealNumber":@(_validDealNumber),
                       @"validDealTransformRatio":@(_validDealTransformRatio),
                       @"UV_arrayOfValues":parallelArray[0],
                       @"PV_arrayOfValues":parallelArray[1],
                       @"VISIT_arrayOfValues":parallelArray[2],
                       @"新UV_arrayOfValues":parallelArray[3],
                       @"有效UV_arrayOfValues":parallelArray[4],
                       @"付款金额_arrayOfValues":parallelArray[5],
                       @"有效订单数_arrayOfValues":parallelArray[6],
                       @"有效订单转化率_arrayOfValues":parallelArray[7],
                       @"UV_number":@(arc4random() % 20000),
                       @"PV_number":@(arc4random() % 20000),
                       @"VISIT_number":@(arc4random() % 20000),
                       @"新UV_number":@(arc4random() % 10000),
                       @"有效UV_number":@(arc4random() % 2000),
                       @"付款金额_number":@(arc4random() % 20000),
                       @"有效订单数_number":@(arc4random() % 200),
                       @"有效订单转化率_number":@(arc4random() % 100)
                       };
         
         NSNotification *notification = [[NSNotification alloc] initWithName:realTimeDataDidChange object:strongSelf userInfo:_sendDict];
         
         //这是同步处理通知
         //        [[NSNotificationQueue defaultQueue]
         //         enqueueNotification:notification
         //         postingStyle:NSPostNow
         //         coalesceMask:NSNotificationCoalescingOnName
         //         forModes:@[NSDefaultRunLoopMode]];
         //        NSLog(@"finished sending");
         
         // 异步处理通知
         dispatch_async(dispatch_get_main_queue(), ^{
             [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                        postingStyle:NSPostASAP
                                                        coalesceMask:NSNotificationCoalescingOnName forModes:@[NSDefaultRunLoopMode]];
             
             //            NSLog(@"finished sending");
         });
     };
    
    //@"http://news-at.zhihu.com/api/3/news/latest"
    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:nil failureBlock:successefullyBlock successedBlock:successefullyBlock];
}

- (void)addNumberToArray:(NSMutableArray *)array
{
    for (int i = 0; i < 20; i++) {
        [array addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
    }
}

@end
