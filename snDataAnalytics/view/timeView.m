//
//  timeView.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-11-14.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "timeView.h"
#import "BFPaperButton.h"
#import "PNColor.h"

@implementation timeView
{
    NSDate *_curDate;
    NSDateFormatter *_formatter;
    
    NSMutableArray  *_fromTimeArray;
    NSMutableArray  *_toTimeArray;
    
    NSString        *_fromString;
    NSString        *_toString;
    BFPaperButton   *_fromTimeButton;
    BFPaperButton   *_toTimeButton;
    
}

#pragma mark - initWithFrame

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor whiteColor];
        _fromString = @"";
        _toString = @"";
        
        [self initTime];
        [self addViews];
        [self addGestures];
    }
    
    return self;
}

- (void)initTime
{
    _curDate = [NSDate date];
    _formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"dd/MM/yyyy --- HH:mm"];
    _fromTime = _curDate;
    
    _fromTimeArray = [[NSMutableArray alloc] initWithArray:@[@0,@0,@0]];
    _toTimeArray   = [[NSMutableArray alloc] initWithArray:@[@0,@0,@0]];
    
    [self setFromTimeString];
}


- (void)addViews
{
    _fromTimeButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(0.0, 10.0, self.frame.size.width/2 - 10.0, 40) raised:NO];
    [_fromTimeButton setTitle:_fromString forState:UIControlStateNormal];
    //    [_dimensionButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_fromTimeButton setTitleColor:PNTwitterColor forState:UIControlStateNormal];
    [_fromTimeButton addTarget:self action:@selector(handleTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_fromTimeButton];
    
    
    _toTimeButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(0.0, 10.0, self.frame.size.width/2 - 10.0, 40) raised:NO];
    [_toTimeButton setTitle:_fromString forState:UIControlStateNormal];
    //    [_dimensionButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_toTimeButton setTitleColor:PNTwitterColor forState:UIControlStateNormal];
    [_toTimeButton addTarget:self action:@selector(handleTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_toTimeButton];
}


#pragma mark - set time

- (void)setFromTime:(NSDate *)date
{
    _fromTime = date;
    [self setFromTimeString];
    
    [_fromTimeButton setTitle:_fromString forState:UIControlStateNormal];
}

- (void)setFromTimeString
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:_fromTime];
    NSInteger day = [components day];
    NSInteger month= [components month];
    NSInteger year= [components year];
    
    _fromTimeArray[2] = @(day);
    _fromTimeArray[1] = @(month);
    _fromTimeArray[0] = @(year);
    
    _fromString = [NSString stringWithFormat:@"%i年%i月%i日",((NSNumber *)_fromTimeArray[0]).intValue,((NSNumber *)_fromTimeArray[1]).intValue,((NSNumber *)_fromTimeArray[2]).intValue];
    
    NSLog(@"fromDate:%@",_fromString);
}

- (void)setToTime:(NSDate *)date
{
    _toTime = date;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:_toTime];
    NSInteger day = [components day];
    NSInteger month= [components month];
    NSInteger year= [components year];
    
    _toTimeArray[2] = @(day);
    _toTimeArray[1] = @(month);
    _toTimeArray[0] = @(year);
    
    _toString = [NSString stringWithFormat:@"%i年%i月%i日",((NSNumber *)_toTimeArray[0]).intValue,((NSNumber *)_toTimeArray[1]).intValue,((NSNumber *)_toTimeArray[2]).intValue];
    
    NSLog(@"toDate:%@",_toString);

}


#pragma mark - gestures

- (void)addGestures
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self addGestureRecognizer:tapGesture];
}


- (void)handleTap
{
    if(_timeViewChoosedBlock){
        _timeViewChoosedBlock();
    }
}

@end
