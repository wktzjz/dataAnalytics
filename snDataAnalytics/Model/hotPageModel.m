//
//  hotPageModel.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-12-4.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "hotPageModel.h"
#import "networkManager.h"

static NSString *const hotPageDataDidChange                  = @"hotPageDataDidChange";
static NSString *const hotPageDetailOutlineDataDidInitialize = @"hotPageDetailOutlineDataDidInitialize";
static NSString *const hotPageOutlineDataDidInitialize       = @"hotPageOutlineDataDidInitialize";

@implementation hotPageModel
{
    __weak id      _wself;
    
    NSMutableArray *_hotPageNameArray;
    NSMutableArray *_hotPagePVArray;
    NSMutableArray *_arrayOfValue;
    NSMutableArray *_arrayOfDates;
}

+ (instancetype)sharedInstance
{
    static hotPageModel *sharedInstance = nil;
    
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
        hotPageModel *strongSelf = _wself;
        
        _hotPageNameArray = [[NSMutableArray alloc] initWithArray:@[@"页面1",@"页面2",@"页面3",@"页面4",@"页面5"]];
        _arrayOfValue = [[NSMutableArray alloc] init];
        _arrayOfDates = [[NSMutableArray alloc] init];
        _hotPagePVArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 5; i++) {
            [_hotPagePVArray addObject:@(arc4random() % 100000)];
            [_arrayOfDates addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:i]]];
            [_arrayOfValue addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
        }
        _outlineData = @{@"hotPageNameArray":_hotPageNameArray,
                         @"hotPagePVArray":_hotPagePVArray,
                         @"clickRatioArrayOfValue":_arrayOfValue,
                         @"clickRatioArrayOfDates":_arrayOfDates,
                         };
        
        NSNotification *notification = [[NSNotification alloc] initWithName:hotPageOutlineDataDidInitialize object:strongSelf userInfo:_outlineData];
        
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
