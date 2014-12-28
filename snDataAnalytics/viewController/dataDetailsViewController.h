//
//  dataDetailsViewController.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-4.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dataOutlineViewContainer.h"
#import "detailOutlineView.h"

#import "PNChart.h"

@protocol dataDetailsControllerDelegate <NSObject>

@required
- (void)dismissDetailsController;

@end

typedef void(^dateChoosed)(NSString *fromDate, NSString *toString);

@interface dataDetailsViewController : UIViewController

@property (nonatomic, weak) id <dataDetailsControllerDelegate> delegate;
@property (nonatomic) viewType dataVisualizedType;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSString *viewTitleString;
@property (nonatomic, strong) UILabel *viewTitle;
@property (nonatomic, strong) dataOutlineViewContainer *dataContentView;
@property (nonatomic, strong) detailOutlineView *detailOutlineView;

@property (nonatomic, strong) NSDictionary *initializedData;
@property (nonatomic, assign) BOOL initializedDataReady;
@property (nonatomic, copy) dateChoosed dateChoosedBlock;

//- (instancetype)init;
//- (instancetype)initWithFrame:(CGRect)frame;
//- (instancetype)initWithFrame:(CGRect)frame type:(dataVisualizedType)type;
- (instancetype)initWithFrame:(CGRect)frame type:(viewType)type data:(id)data title:(NSString *)title;
- (void)addDetailOutlineViewWithData:(NSDictionary *)data Type:(viewType)type;
- (void)removeObservers;
@end
