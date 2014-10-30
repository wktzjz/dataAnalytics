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
@property (nonatomic) viewType dataVisualizedType;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) NSString *viewTitleString;
@property (nonatomic) UILabel *viewTitle;
@property (nonatomic) dataOutlineViewContainer *dataContentView;

@property (nonatomic) NSDictionary *initializedData;
@property (nonatomic) BOOL initializedDataReady;

//- (instancetype)init;
//- (instancetype)initWithFrame:(CGRect)frame;
//- (instancetype)initWithFrame:(CGRect)frame type:(dataVisualizedType)type;
- (instancetype)initWithFrame:(CGRect)frame type:(viewType)type title:(NSString *)title;
- (void)removeObservers;
@end
