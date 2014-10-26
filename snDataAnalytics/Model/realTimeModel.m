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
    NSDictionary *_sendDict;
    __weak id      _wself;
    NSTimer      *_timer;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _wself = self;
        
        void (^successefullyBlock)() = ^(NSDictionary *data){
            _groupUV = arc4random() % 20000;
            _validUVRatio = ((arc4random() % 500) + 500) / 1000.0;
            _validGroupUV = _groupUV * _validUVRatio;
            
            _groupPercentArray = @[@15,@30,@55,@23,@33,@40,@20];
            _validSourceUVPercentArray = @[@7,@14,@25,@11,@15,@19,@9];
            
            _groupColorArray = @[PNLightGreen,PNFreshGreen,PNDeepGreen,PNRed,PNTitleColor,PNYellow,PNBrown];
            _validSourceUVColorArray = @[[UIColor robinEggColor],[UIColor pastelBlueColor],[UIColor turquoiseColor],[UIColor steelBlueColor],[UIColor denimColor],[UIColor emeraldColor],[UIColor cardTableColor]];
            
            _arrayOfValues = [[NSMutableArray alloc] init];
            _sendDict = [[NSDictionary alloc] init];
            
            realTimeModel *strongSelf = _wself;
            
            dispatch_async(dispatch_get_main_queue(),^{
                [[NSNotificationCenter defaultCenter] postNotificationName:dataDidInitialize object:strongSelf userInfo:@{@"groupUV":@(_groupUV),@"validUVRatio":@(_validUVRatio),@"validGroupUV":@(_validGroupUV),@"_groupPercentArray":_groupPercentArray,@"validSourceUVPercentArray":_validSourceUVPercentArray,@"groupColorArray":_groupColorArray,@"validSourceUVColorArray":_validSourceUVColorArray}];
            });
//            if(![NSThread isMainThread]){
//                NSLog(@"not in mainThread");
//            }
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                _timer = [NSTimer scheduledTimerWithTimeInterval:6.0f target:strongSelf selector:@selector(getNewData) userInfo:nil repeats:YES];
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
    return self;
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
         
         [_arrayOfValues removeAllObjects];
         for (int i = 0; i < 20; i++) {
             [_arrayOfValues addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
             // Random values for the graph
         }
         
         _sendDict = @{@"groupUV":@(_groupUV),@"validUVRatio":@(_validUVRatio),@"validGroupUV":@(_validGroupUV),@"arrayOfValues":_arrayOfValues,@"dealMoney":@(_dealMoney)};
         
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
            //            [[NSNotificationCenter defaultCenter] postNotificationName:dataDidChanged object:self userInfo:_sendDict];
             [[NSNotificationQueue defaultQueue] enqueueNotification:notification postingStyle:NSPostASAP coalesceMask:NSNotificationCoalescingOnName forModes:@[NSDefaultRunLoopMode]];
             
             //            NSLog(@"finished sending");
         });
     };
    
    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:@"http://news-at.zhihu.com/api/3/news/latest" failureBlock:successefullyBlock successedBlock:successefullyBlock];
}

@end
