//
//  dataDetailsViewController.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-4.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dataOutlineViewContainer.h"

#import "PNChart.h"

@protocol dataDetailsControllerDelegate <NSObject>

@required
- (void)dismissDetailsController;

@end

@interface dataDetailsViewController : UIViewController

@property (nonatomic, weak) id <dataDetailsControllerDelegate> delegate;
@property (nonatomic) PNBarChart * barChart;
@property (nonatomic) dataVisualizedType dataVisualizedType;
@property (nonatomic) UIScrollView *scrollView;

//- (instancetype)init;
//- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame type:(dataVisualizedType)type;

@end
