//
//  loginViewController.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-12.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol loginControllerDelegate <NSObject>

@required
- (void)dismissLoginController;

@end

// Block
typedef void(^dismiss)();

@interface loginViewController : UIViewController

@property (nonatomic, copy) dismiss dismissBlock;
@property (nonatomic, weak) id <loginControllerDelegate> delegate;

@end
