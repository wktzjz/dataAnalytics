//
//  hotCityModel.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-12-4.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "hotCityModel.h"
#import "networkManager.h"
#import "networkDefine.h"

@implementation hotCityModel
{
    __weak id      _wself;
    
    NSMutableArray *_hotCityNameArray;
    NSMutableArray *_hotCityUVArray;
    NSMutableArray *_arrayOfValue;
    NSMutableArray *_arrayOfDates;

}

+ (instancetype)sharedInstance
{
    static hotCityModel *sharedInstance = nil;
    
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

- (void)getOutlineData
{
    void (^successefullyBlock)(NSDictionary *data) = ^(NSDictionary *data) {
        hotCityModel *strongSelf = _wself;
        
        _hotCityNameArray = [[NSMutableArray alloc] initWithArray:@[@"北京",@"上海",@"广州",@"深圳",@"南京"]];
        _arrayOfValue = [[NSMutableArray alloc] init];
        _arrayOfDates = [[NSMutableArray alloc] init];
        _hotCityUVArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 5; i++) {
            [_hotCityUVArray addObject:@(arc4random() % 100000)];
            [_arrayOfDates addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:i]]];
            [_arrayOfValue addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
        }
        
        
        _outlineData = @{@"hotCityNameArray":_hotCityNameArray,
                         @"hotCityUVArray":_hotCityUVArray,
                         @"validDealConversionArrayOfValue":_arrayOfValue,
                         @"validDealConversionArrayOfDates":_arrayOfDates,
                         };
        
        NSNotification *notification = [[NSNotification alloc] initWithName:hotCityOutlineDataDidInitialize object:strongSelf userInfo:_outlineData];
        
        // 异步处理通知
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                       postingStyle:NSPostASAP
                                                       coalesceMask:NSNotificationCoalescingOnName forModes:@[NSDefaultRunLoopMode]];
        });
    };
    
    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:nil failureBlock:successefullyBlock successedBlock:successefullyBlock];
}


@end
