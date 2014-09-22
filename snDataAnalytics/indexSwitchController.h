//
//  indexSwitchController.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-22.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <UIKit/UIKit.h>

// Block
typedef void(^switchAction)(NSInteger index);


@interface indexSwitchController : UIViewController

@property (nonatomic, copy) switchAction switchAction;
- (instancetype)initWithFrame:(CGRect)frame;

@end
