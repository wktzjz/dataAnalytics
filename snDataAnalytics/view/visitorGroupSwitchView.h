//
//  visitorGroupSwitchView.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-9.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQMultistageTableView.h"
// Block
typedef void(^switchAction)(NSInteger index);


@interface visitorGroupSwitchView : UIView <TQTableViewDataSource,TQTableViewDelegate>

@property (nonatomic, copy) switchAction switchAction;
@property (nonatomic, strong) TQMultistageTableView *mTableView;

- (instancetype)initWithFrame:(CGRect)frame;

@end
