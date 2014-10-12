//
//  realTimeOutlineView.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-8.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "BEMSimpleLineGraphView.h"

@interface realTimeOutlineView : UIView

@property (nonatomic) NSInteger dealNumber;
@property (nonatomic) BEMSimpleLineGraphView *lineGraph;
- (id)initWithFrame:(CGRect)frame;

@end
