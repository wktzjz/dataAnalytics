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

@property (nonatomic) UIView *settingView;
@property (nonatomic) UIView *contentView;
@property (nonatomic) NSMutableArray *outLineViewArray;

@property (nonatomic) dataOutlineViewContainer *realTimeView;
@property (nonatomic) dataOutlineViewContainer *visitorGruopView;
@property (nonatomic) dataOutlineViewContainer *sourceView;
@property (nonatomic) dataOutlineViewContainer *pageView;
@property (nonatomic) dataOutlineViewContainer *hotCityView;
@property (nonatomic) dataOutlineViewContainer *hotPageView;
@property (nonatomic) dataOutlineViewContainer *transformView;

@property (nonatomic,strong) dataDetailsViewController *detailsViewController;

@property (nonatomic, strong) id observeToken;


@property (nonatomic) NSNumber *clickedOutLineViewIndex;

//- (NSNumber *)clickedOutlineIndex;
//- (NSMutableArray *)outLineViewArray;

@end
