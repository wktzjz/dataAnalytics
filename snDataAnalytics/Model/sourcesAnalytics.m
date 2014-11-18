//
//  sourcesAnalytics.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-11-17.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "sourcesAnalytics.h"

@implementation sourcesAnalytics
{
    __weak id      _wself;

}

+ (instancetype)sharedInstance
{
    static sourcesAnalytics *sharedInstance = nil;
    
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

@end
