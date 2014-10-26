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

- (instancetype)init
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
            
            NSTimer *timer = [NSTimer timerWithTimeInterval:6.0f target:self selector:@selector(getNewData) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        };
        
        [[networkManager sharedInstance] sendAsynchronousRequestWithURL:nil failureBlock:successefullyBlock successedBlock:successefullyBlock];

    }

    return self;
}

- (void)getNewData
{
    
}

@end
