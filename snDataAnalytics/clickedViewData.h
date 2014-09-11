//
//  clickedViewData.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-9.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface clickedViewData : NSObject

@property (nonatomic) UIView  *clickedView;
@property (nonatomic) CGPoint viewCenter;

+ (instancetype)sharedInstance;
@end
