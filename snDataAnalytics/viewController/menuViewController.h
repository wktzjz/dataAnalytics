//
//  menuViewController.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-1.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dataDetailsViewController.h"

typedef NS_ENUM(NSUInteger, cellType) {
    account = 0,
    chooseSource,
    realTime,
    visitorGroup,
    source,
    pageAnalytics,
    transform,
};

@interface menuViewController : UIViewController<dataDetailsControllerDelegate>

- (instancetype)initWithType:(cellType)type;
@end
