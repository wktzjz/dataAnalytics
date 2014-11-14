//
//  timeView.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-11-14.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//


typedef void(^timeViewChoosed)();

@interface timeView : UIView

@property (nonatomic,copy) timeViewChoosed timeViewChoosedBlock;

@property (nonatomic) NSDate *fromTime;
@property (nonatomic) NSDate *toTime;

- (instancetype)initWithFrame:(CGRect)frame;

@end
