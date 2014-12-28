//
//  baseViewController.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-1.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dataOutlineViewContainer.h"
#import "dataDetailsViewController.h"
#import "networkManager.h"
#import "outLineViewTransitionProtocol.h"
#import "KeyValueObserver.h"

@interface baseViewController : UIViewController <networkDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,dataDetailsControllerDelegate,outLineViewTransitionProtocol>

@property (nonatomic, strong) UIView *settingView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *outLineViewArray;

@property (nonatomic, strong) dataOutlineViewContainer *realTimeView;
@property (nonatomic, strong) dataOutlineViewContainer *visitorGruopView;
@property (nonatomic, strong) dataOutlineViewContainer *sourceView;
@property (nonatomic, strong) dataOutlineViewContainer *pageView;
@property (nonatomic, strong) dataOutlineViewContainer *hotCityView;
@property (nonatomic, strong) dataOutlineViewContainer *hotPageView;
@property (nonatomic, strong) dataOutlineViewContainer *transformView;

@property (nonatomic, strong) dataDetailsViewController *detailsViewController;

@property (nonatomic, strong) id observeToken;

@property (nonatomic, strong) NSNumber *clickedOutLineViewIndex;

//- (NSNumber *)clickedOutlineIndex;
//- (NSMutableArray *)outLineViewArray;

@end
