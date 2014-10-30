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
        
        void (^successefullyBlock)(NSDictionary *) = ^(NSDictionary *data){
           
            _sendDict = [[NSDictionary alloc] init];
            
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
    
}

@end
