//
//  outLineViewTransitionProtocol.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-9.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol outLineViewTransitionProtocol <NSObject>

@optional
- (NSMutableArray *)outLineViewArray;
- (NSNumber *)clickedOutlineIndex;

@end
