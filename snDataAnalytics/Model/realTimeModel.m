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

static NSString *const dataDidChange     = @"realTimeDataDidChanged";
static NSString *const dataDidInitialize = @"realTimeDataDidInitialize";


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
        
        [self getInitializedRealTimeDeatilsData];
    }
    return self;
}


#pragma mark - getInitializedRealTimeDeatilsData

- (void)getInitializedRealTimeDeatilsData
{
    void (^successefullyBlock)(NSDictionary *) = ^(NSDictionary *data){
        _groupUV = arc4random() % 20000;
        _validUVRatio = ((arc4random() % 500) + 500) / 1000.0;
        _validGroupUV = _groupUV * _validUVRatio;
        
        _groupPercentArray = @[@15,@30,@55,@23,@33,@40,@20];
        _validSourceUVPercentArray = @[@7,@14,@25,@11,@15,@19,@9];
        
        _groupColorArray = @[PNLightGreen,PNFreshGreen,PNDeepGreen,PNRed,PNTitleColor,PNYellow,PNBrown];
        _validSourceUVColorArray = @[[UIColor robinEggColor],[UIColor pastelBlueColor],[UIColor turquoiseColor],[UIColor steelBlueColor],[UIColor denimColor],[UIColor emeraldColor],[UIColor cardTableColor]];
        
        _arrayOfValues = [[NSMutableArray alloc] init];
        _arrayOfDates = [[NSMutableArray alloc] init];
        _sendDict = [[NSDictionary alloc] init];
        
        realTimeModel *strongSelf = _wself;
        
        NSMutableArray *array1 = [[NSMutableArray alloc] init];
        NSMutableArray *array2 = [[NSMutableArray alloc] init];
        NSMutableArray *array3 = [[NSMutableArray alloc] init];
        NSMutableArray *array4 = [[NSMutableArray alloc] init];
        NSMutableArray *array5 = [[NSMutableArray alloc] init];
        NSMutableArray *array6 = [[NSMutableArray alloc] init];
        NSMutableArray *array7 = [[NSMutableArray alloc] init];
        NSMutableArray *array8 = [[NSMutableArray alloc] init];
        
        [_arrayOfValues removeAllObjects];
        for (int i = 0; i < 20; i++) {
            [_arrayOfDates addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:i]]];
            
            [_arrayOfValues addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
            [array1 addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
            [array2 addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
            [array3 addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
            [array4 addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
            [array5 addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
            [array6 addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
            [array7 addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
            [array8 addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
            
            // Random values for the graph
        }
        _initializeData = @{@"groupUV":@(_groupUV),@"validUVRatio":@(_validUVRatio),@"validGroupUV":@(_validGroupUV),@"groupPercentArray":_groupPercentArray,@"validSourceUVPercentArray":_validSourceUVPercentArray,@"groupColorArray":_groupColorArray,@"validSourceUVColorArray":_validSourceUVColorArray,@"arrayOfDates":_arrayOfDates,@"UV_arrayOfValues":array1,@"PV_arrayOfValues":array2,@"Visitor_arrayOfValues":array3,@"新UV_arrayOfValues":array4,@"有效UV_arrayOfValues":array5,@"付款金额_arrayOfValues":array6,@"有效订单数_arrayOfValues":array7,@"有效订单转化率_arrayOfValues":array8,
           @"UV_number":@(arc4random() % 20000),@"PV_number":@(arc4random() % 20000),@"Visitor_number":@(arc4random() % 20000),@"新UV_number":@(arc4random() % 10000),@"有效UV_number":@(arc4random() % 2000),@"付款金额_number":@(arc4random() % 20000),@"有效订单数_number":@(arc4random() % 200),@"有效订单转化率_number":@(arc4random() % 100)};
        
        _initializeDataReady = YES;
        
//        dispatch_async(dispatch_get_main_queue(),^{
//            [[NSNotificationCenter defaultCenter] postNotificationName:dataDidInitialize object:strongSelf userInfo:_initializeData];
//        });
        
        NSNotification *notification = [[NSNotification alloc] initWithName:dataDidInitialize object:strongSelf userInfo:_initializeData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                       postingStyle:NSPostASAP
                                                       coalesceMask:NSNotificationCoalescingOnName forModes:@[NSDefaultRunLoopMode]];
            
        });

        //            if(![NSThread isMainThread]){
        //                NSLog(@"not in mainThread");
        //            }
        //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _timer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:strongSelf selector:@selector(getNewData) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] run];
        //            });
        //             [NSThread detachNewThreadSelector:@selector(startTimer) toTarget:self withObject:nil];
        
    };
    
    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:nil failureBlock:^(NSDictionary *data){
        successefullyBlock(data);
    }successedBlock:^(NSDictionary *data){
        successefullyBlock(data);
    }];
}

- (void)startTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:6.0f target:self selector:@selector(getNewData) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] run];
}

- (void)getNewData
{
     void (^successefullyBlock)(NSDictionary *data) = ^(NSDictionary *data){
         realTimeModel *strongSelf = _wself;
         
         _groupUV = arc4random() % 20000;
         _validUVRatio = ((arc4random() % 500) + 500) / 1000.0;
         _validGroupUV = _groupUV * _validUVRatio;
         
         _dealMoney = arc4random() % 20000;
         
         NSMutableArray *array1 = [[NSMutableArray alloc] init];
         NSMutableArray *array2 = [[NSMutableArray alloc] init];
         NSMutableArray *array3 = [[NSMutableArray alloc] init];
         NSMutableArray *array4 = [[NSMutableArray alloc] init];
         NSMutableArray *array5 = [[NSMutableArray alloc] init];
         NSMutableArray *array6 = [[NSMutableArray alloc] init];
         NSMutableArray *array7 = [[NSMutableArray alloc] init];
         NSMutableArray *array8 = [[NSMutableArray alloc] init];
         NSArray *parallelArray = @[array1,array2,array3,array4,array5,array6,array7,array8];
         
         [_arrayOfValues removeAllObjects];
         for (int i = 0; i < 20; i++) {
             [_arrayOfValues addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
//             [array1 addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
//             [array2 addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
//             [array3 addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
//             [array4 addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
//             [array5 addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
//             [array6 addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
//             [array7 addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
//             [array8 addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];

             // Random values for the graph
         }
         
         //同步的并行处理
         dispatch_apply(8, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
//             NSLog(@"parallel %i",index);
             [strongSelf addNumberToArray:parallelArray[index]];
         });
         
//         NSLog(@"after dispatch_apply");
         
         _sendDict = @{@"groupUV":@(_groupUV),@"validUVRatio":@(_validUVRatio),@"validGroupUV":@(_validGroupUV),@"arrayOfValues":_arrayOfValues,@"dealMoney":@(_dealMoney),@"UV_arrayOfValues":array1,@"PV_arrayOfValues":array2,@"Visitor_arrayOfValues":array3,@"新UV_arrayOfValues":array4,@"有效UV_arrayOfValues":array5,@"付款金额_arrayOfValues":array6,@"有效订单数_arrayOfValues":array7,@"有效订单转化率_arrayOfValues":array8,
            @"UV_number":@(arc4random() % 20000),@"PV_number":@(arc4random() % 20000),@"Visitor_number":@(arc4random() % 20000),@"新UV_number":@(arc4random() % 10000),@"有效UV_number":@(arc4random() % 2000),@"付款金额_number":@(arc4random() % 20000),@"有效订单数_number":@(arc4random() % 200),@"有效订单转化率_number":@(arc4random() % 100)};
         
         NSNotification *notification = [[NSNotification alloc] initWithName:dataDidChange object:strongSelf userInfo:_sendDict];
         
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
    
    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:@"http://news-at.zhihu.com/api/3/news/latest" failureBlock:successefullyBlock successedBlock:successefullyBlock];
}

- (void)addNumberToArray:(NSMutableArray *)array
{
    for (int i = 0; i < 20; i++) {
        [array addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
    }
}

@end
