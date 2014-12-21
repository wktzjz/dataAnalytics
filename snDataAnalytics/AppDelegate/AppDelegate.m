//
//  AppDelegate.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-1.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "AppDelegate.h"
#import "TSMessage.h"
#import "baseViewController.h"
#import "flatButton.h"
#import "authenticationManager.h"
#import "defines.h"

static NSInteger const blurViewTag  = 1211;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Lauched in %f seconds.", CFAbsoluteTimeGetCurrent());
    });
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    baseViewController *viewController = [[baseViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.window.rootViewController = navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [TSMessage setDefaultViewController: self.window.rootViewController];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    UIView *blurView;
    
    if ([self isIOS8]) {
        UIVisualEffect *effect;
        effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
    }else{
        blurView = [[UIToolbar alloc] initWithFrame:CGRectZero];
        blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        ((UIToolbar *)blurView).barStyle = UIBarStyleBlack;
        ((UIToolbar *)blurView).translucent = YES;
    }
    
    blurView.frame = [[UIScreen mainScreen] bounds];
    blurView.alpha = 0.95;
    blurView.tag = blurViewTag;
    [[[UIApplication sharedApplication] keyWindow] addSubview:blurView];

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if ([self isIOS8]) {
        
        // 注意[authenticationManager sharedInstance].dismissBlock会被这里的block实现替代
        if (![authenticationManager sharedInstance].isAuthenticating) {
            UIView *blurView;
            UIVisualEffect *effect;
            effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
            blurView.frame = [[UIScreen mainScreen] bounds];
            [[[UIApplication sharedApplication] keyWindow]  addSubview:blurView];
            blurView.alpha = 0.0;
            
            flatButton *button = [flatButton button];
            button.backgroundColor = [UIColor clearColor];
            button.alpha = 0.7;
            button.translatesAutoresizingMaskIntoConstraints = NO;
            [button setTitle:@"点击验证身份" forState:UIControlStateNormal];
            [button setTextColor:[UIColor blackColor]];
            [button addTarget:[authenticationManager sharedInstance] action:@selector(fingerAuthentication) forControlEvents:UIControlEventTouchUpInside];
            [blurView addSubview:button];
            
            [blurView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:blurView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0f
                                                                  constant:0]];
            
            [blurView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:blurView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0f
                                                                  constant:-50]];
            
            
            [UIView animateWithDuration:0.3
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 blurView.alpha = 0.90;
                                 
                             }
                             completion: ^(BOOL finished){
                                 [[authenticationManager sharedInstance] startAuthentication];
                                 
                                 [authenticationManager sharedInstance].dismissBlock = ^{
                                     //dismissBlock 为非主线程
                                     dispatch_main_async_safe(^{
                                         [authenticationManager sharedInstance].isAuthenticating = NO;
                                         
                                         [UIView animateWithDuration:0.5
                                                               delay:0.0
                                                             options:UIViewAnimationOptionCurveEaseInOut
                                                          animations:^{
                                                              blurView.alpha = 0.0;
                                                          }completion:^(BOOL finished){
                                                              [blurView removeFromSuperview];
                                                          }];
                                     })
                                 };
                             }];
           }

    }
   

//    NSNotification *notification = [[NSNotification alloc] initWithName:@"applicationNeedToAuthenticate" object:self userInfo:nil];
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [[NSNotificationQueue defaultQueue] enqueueNotification:notification
//                                                   postingStyle:NSPostASAP
//                                                   coalesceMask:NSNotificationCoalescingOnName forModes:@[NSDefaultRunLoopMode]];
//    });

       // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSArray* array = [[UIApplication sharedApplication] keyWindow].subviews;
    
    for(id view in array){
        if ([view isKindOfClass:[UIView class]]){
            UIView* myView = view;
            if (myView.tag == blurViewTag){
                [myView removeFromSuperview];
            }
        }
    }

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)isIOS8
{
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"8.0" options: NSNumericSearch];
    if (order == NSOrderedSame || order == NSOrderedDescending) {
        // OS version >= 8.0
        return YES;
    }
    return NO;
}

@end
