//
//  authenticationManager.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-12-9.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

typedef void(^dismiss)();

@interface authenticationManager : NSObject

@property (nonatomic, copy) dismiss dismissBlock;
@property (nonatomic) BOOL isAuthenticating;

+ (instancetype)sharedInstance;

- (void)startAuthentication;
- (void)fingerAuthentication;
- (void)passwordAuthentication;

@end
