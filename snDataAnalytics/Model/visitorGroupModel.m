//
//  visitorGroupData.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-21.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "visitorGroupModel.h"
#import "networkManager.h"

static NSString *const dataDidChange     = @"visitorGroupDataDidChanged";
static NSString *const dataDidInitialize = @"visitorGroupDataDidInitialize";

@implementation visitorGroupModel
{
    NSDictionary *_sendDict;
    __weak id      _wself ;
    
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
        _defineDetails = [NSDictionary dictionary];
        
        void (^successefullyBlock)(NSDictionary *) = ^(NSDictionary *data){
            
            visitorGroupModel *strongSelf = _wself;
            
            dispatch_async(dispatch_get_main_queue(),^{
                [[NSNotificationCenter defaultCenter] postNotificationName:dataDidInitialize object:strongSelf userInfo:@{}];
            });
            
        };
        
        [[networkManager sharedInstance] sendAsynchronousRequestWithURL:nil failureBlock:successefullyBlock successedBlock:successefullyBlock];

    }

    return self;
}

- (void)getNewData
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
    NSArray *indexOptionsArray1 = @[@"UV",@"PV",@"VISIT",@"新UV",@"有效UV",@"平均页面停留时间",@"提交订单转化率",@"有效订单转化率"];
    NSArray *indexOptionsArray2 = @[@"访问会员数",@"买家数",@"购买率",@"客单价",@"平均订单收入"];
    NSArray *indexOptionsArray3 = @[@"注册数",@"买家数",@"购买率",@"客单价",@"平均订单收入"];
    NSArray *indexOptionsArray4 = @[@"回访数",@"买家数",@"购买率",@"客单价",@"平均订单收入"];
    NSArray *indexOptionsArray5 = @[@"访问会员数",@"买家数",@"购买率",@"客单价",@"平均订单收入"];
    
    _defineDetails =  @{@"dimensionOptionsArray":dimensionOptionsArray,
                       @"访客类型":@{@"labelStringArray":@[@"新访客",@"回访客"],
                                 @"indexOptionsArray":indexOptionsArray1},
                       @"终端类型":@{@"labelStringArray":@[@"PC",@"WAP",@"APP"],
                                 @"indexOptionsArray":indexOptionsArray1},
                       @"会员-整体":@{@"labelStringArray":@[@"会员"],
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

@end
