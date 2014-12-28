//
//  ConditionInquireController.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-12-22.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, inquireViewType) {
    inquireVisitorGroup1 = 0,
    inquireVisitorGroup2,
    inquireSourceAnalytics,
    inquirePageAnalytics,
    inquireTransformAnalytics,
};

// Block
typedef void(^chooseAction)(NSDictionary *resultDict);

@interface ConditionInquireController : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic, copy) chooseAction chooseActionBlock;
- (instancetype)initWithFrame:(CGRect)frame type:(inquireViewType)type;

@end
