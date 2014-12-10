//
//  authenticationViewController.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-12-8.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

typedef void(^dismiss)();

@interface authenticationViewController : UIViewController

@property (nonatomic, copy) dismiss dismissBlock;
- (instancetype)initWithFrame:(CGRect)frame;

@end
