//
//  changefulButton.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-23.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface changefulButton : UIControl

+ (instancetype)button;
+ (instancetype)buttonWithOrigin:(CGPoint)origin;

- (void)animateToMenu;
- (void)animateToClose;
@end
