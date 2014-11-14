//
//  DismissingAnimator.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-21.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^dismissModalViewController)();

@interface DismissingAnimator : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning>

@property (nonatomic) BOOL interacting;
@property (nonatomic,copy) dismissModalViewController dismissModalViewControllerBlock;

-(void)wireToViewController:(UIViewController *)viewController;

@end
