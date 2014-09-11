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



@interface baseViewController : UIViewController <networkDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,dataDetailsControllerDelegate,outLineViewTransitionProtocol>

@property (nonatomic,strong) UIView *settingView;
@property (nonatomic) NSMutableArray *outLineViewArray;
@property (nonatomic,strong) dataOutlineViewContainer *outlineView1;
@property (nonatomic,strong) dataOutlineViewContainer *outlineView2;
@property (nonatomic,strong) dataOutlineViewContainer *outlineView3;
@property (nonatomic,strong) dataOutlineViewContainer *outlineView4;

@property (nonatomic,strong) dataDetailsViewController *detailsViewController;

@property (nonatomic) NSNumber *clickedOutLineViewIndex;

//- (NSNumber *)clickedOutlineIndex;
//- (NSMutableArray *)outLineViewArray;

@end
