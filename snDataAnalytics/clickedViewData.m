//
//  clickedViewData.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-9.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "clickedViewData.h"

@implementation clickedViewData

+ (instancetype)sharedInstance
{
    static clickedViewData *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] _init];
    });
    
    return sharedInstance;
}

- (instancetype)_init
{
    if (self = [super init]) {
    }
    
    return self;
}

- (instancetype)init
{
    [NSException raise:NSStringFromClass([self class]) format:@"Use sharedInstance instead of New And Init."];
    return nil;
}

+ (instancetype)new
{
    [NSException raise:NSStringFromClass([self class]) format:@"Use sharedInstance instead of New And Init."];
    return nil;
}
@end
