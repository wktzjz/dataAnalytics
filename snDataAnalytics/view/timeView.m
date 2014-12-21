//
//  timeView.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-11-14.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "timeView.h"
//#import "BFPaperButton.h"
#import "PNColor.h"
#import <snDataAnalytics-swift.h>


@implementation timeView
{
    NSDate *_curDate;
    NSDateFormatter *_formatter;
    
    NSMutableArray *_fromTimeArray;
    NSMutableArray *_toTimeArray;
    
    UIView         *_fromTimeView;
    UIView         *_toTimeView;
    
    UILabel        *_fromDay;
    UILabel        *_fromMonth;
    UILabel        *_toDay;
    UILabel        *_toMonth;
    
    BOOL           _showToTime;
}

#pragma mark - initWithFrame

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
//        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor colorWithRed:0x6a/255.0 green:0xb9/255.0 blue:0xff/255.0 alpha:1.0];
        _fromString = @"";
        _toString = @"";
        _showToTime = NO;
        
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
    [_formatter setDateFormat:@"yyyy-MM-dd"];
    _fromTime = _curDate;
    
    _fromTimeArray = [[NSMutableArray alloc] initWithArray:@[@0,@0,@0]];
    _toTimeArray   = [[NSMutableArray alloc] initWithArray:@[@0,@0,@0]];
    
    [self setFromTimeString];
}


- (void)addViews
{
//    _fromTimeButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(0.0, 10.0, self.frame.size.width/2 - 10.0, 40) raised:NO];
//    [_fromTimeButton setTitle:_fromString forState:UIControlStateNormal];
//    //    [_dimensionButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    [_fromTimeButton setTitleColor:PNTwitterColor forState:UIControlStateNormal];
//    [_fromTimeButton addTarget:self action:@selector(handleTap) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_fromTimeButton];
//    
//    
//    _toTimeButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(0.0, 10.0, self.frame.size.width/2 - 10.0, 40) raised:NO];
//    [_toTimeButton setTitle:_fromString forState:UIControlStateNormal];
//    //    [_dimensionButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    [_toTimeButton setTitleColor:PNTwitterColor forState:UIControlStateNormal];
//    [_toTimeButton addTarget:self action:@selector(handleTap) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_toTimeButton];
    
    _fromTimeView = [[UIView alloc] initWithFrame:CGRectMake(20, 0,self.frame.size.width/3, self.frame.size.height)];
    CGPoint p = _fromTimeView.center;
    p.x = self.frame.size.width/2;
    p.y = self.frame.size.height/2;
    _fromTimeView.center = p;
//    _fromTimeView.backgroundColor = [UIColor grayColor];
    [self addSubview:_fromTimeView];
    
    _toTimeView = [[UIView alloc] initWithFrame:CGRectMake(20, 0,self.frame.size.width/3, self.frame.size.height)];
    p = _toTimeView.center;
    p.x = 3 * self.frame.size.width/4;
    p.y = self.frame.size.height/2;
    _toTimeView.center = p;
//    _toTimeView.backgroundColor = [UIColor grayColor];
    [self addSubview:_toTimeView];
    
    _fromDay = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 50, self.frame.size.height/2)];
    _fromDay.text = [NSString stringWithFormat:@"%i",((NSNumber *)_fromTimeArray[2]).intValue];
    _fromDay.textColor = [UIColor whiteColor];
    _fromDay.font = [UIFont fontWithName:@"Avenir-Medium" size:25.0];
    _fromDay.textAlignment = NSTextAlignmentCenter;
//    _fromDay.backgroundColor = [UIColor blueColor];
    
    CGSize size = [_fromDay.text sizeWithFont:_fromDay.font];
    CGRect r = _fromDay.frame;
    r.size = size;
    _fromDay.frame = r;
    p = _fromDay.center;
    p.y = self.frame.size.height/2;
    _fromDay.center = p;
    
    _fromMonth = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 80, 45)];
    _fromMonth.text = [NSString stringWithFormat:@"%i月\n%i", ((NSNumber *)_fromTimeArray[1]).intValue, ((NSNumber *)_fromTimeArray[0]).intValue];
    _fromMonth.textColor = [UIColor whiteColor];
    _fromMonth.font = [UIFont fontWithName:@"Avenir-Medium" size:15.0];
    _fromMonth.textAlignment = NSTextAlignmentCenter;
    _fromMonth.numberOfLines =2;
//    size = [_fromMonth.text sizeWithFont:_fromMonth.font];
//    r = _fromMonth.frame;
//    r.size = size;
//    _fromMonth.frame = r;

    p = _fromMonth.center;
    p.y = self.frame.size.height/2;
    _fromMonth.center = p;
    
    [_fromTimeView addSubview:_fromDay];
    [_fromTimeView addSubview:_fromMonth];
    
    _toDay = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 50, 40)];
    _toDay.text = @"";
    _toDay.textColor = [UIColor whiteColor];
    _toDay.font = [UIFont fontWithName:@"Avenir-Medium" size:25.0];
    _toDay.textAlignment = NSTextAlignmentCenter;
    size = [_toDay.text sizeWithFont:_toDay.font];
    r = _toDay.frame;
    r.size = size;
    _toDay.frame = r;
    p = _toDay.center;
    p.y = self.frame.size.height/2;
    _toDay.center = p;

    _toMonth = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 80, 45)];
    _toMonth.text = @"";
    _toMonth.textColor = [UIColor whiteColor];
    _toMonth.font = [UIFont fontWithName:@"Avenir-Medium" size:15.0];
    _toMonth.textAlignment = NSTextAlignmentCenter;
    _toMonth.numberOfLines =2;
    p = _toMonth.center;
    p.y = self.frame.size.height/2;
    _toMonth.center = p;
    
    [_toTimeView addSubview:_toDay];
    [_toTimeView addSubview:_toMonth];
    
    _toTimeView.alpha = 0.0;
    _toTimeView.hidden = YES;
}


#pragma mark - set time

- (void)setFromTime:(NSDate *)date
{
    _fromTime = date;
    [self setFromTimeString];
    
//    [_fromTimeButton setTitle:_fromString forState:UIControlStateNormal];
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
    
//    _fromString = [NSString stringWithFormat:@"%li年%li月%li日",year,month,day];
    _fromString = [_formatter stringFromDate:_fromTime];

    NSLog(@"fromDate:%@",_fromString);

    _fromDay.text = [NSString stringWithFormat:@"%li",day];
    _fromMonth.text = [NSString stringWithFormat:@"%li月\n%li", month, year];

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
    
//    _toString = [NSString stringWithFormat:@"%li年%li月%li日",year,month,day];
    _toString = [_formatter stringFromDate:_toTime];

    
    NSLog(@"toDate:%@",_toString);

    _toDay.text = [NSString stringWithFormat:@"%li",day];
    _toMonth.text = [NSString stringWithFormat:@"%li月\n%li", month, year];
    CGSize size = [_toDay.text sizeWithFont:_toDay.font];
    CGRect r = _toDay.frame;
    r.size = size;
    _toDay.frame = r;
//    CGPoint p = _toDay.center;
//    p.y = self.frame.size.height/2;
//    _toDay.center = p;

//    CGPoint p = _toMonth.center;
//    p.y = self.frame.size.height/2;
//    _toMonth.center = p;
    
    if(!_showToTime){
        [self showToTimeView];
    }
}

- (void)showToTimeView
{
    _showToTime = YES;
    _toTimeView.hidden = NO;

    [UIView animateWithDuration:1.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _toTimeView.alpha = 1.0;
                         _fromTimeView.center = CGPointMake(self.frame.size.width/4 - 10.0,self.frame.size.height/2);
                         
                     } completion:nil];
    
    CAShapeLayer *referenceLine = [CAShapeLayer layer];
    referenceLine.lineCap      = kCALineCapButt;
    referenceLine.fillColor    = nil;
    referenceLine.lineWidth    = 1.0;
    referenceLine.strokeEnd    = 0.0;
    
    UIBezierPath *progressline = [UIBezierPath bezierPath];
    
    [progressline moveToPoint:CGPointMake(self.frame.size.width/2,0)];
    [progressline addLineToPoint:CGPointMake(self.frame.size.width/2 + 15,  self.frame.size.height/2)];
    [progressline addLineToPoint:CGPointMake(self.frame.size.width/2,  self.frame.size.height)];

    [progressline setLineWidth:1.0];
    [progressline setLineCapStyle:kCGLineCapSquare];
    referenceLine.path = progressline.CGPath;
    
    referenceLine.strokeColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.2;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = @0.0f;
    pathAnimation.toValue = @1.0f;
    [referenceLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    referenceLine.strokeEnd = 1.0;
    
//    [self.la animateForLayer:referenceLine isAnimatingReferenceLine:YES];
    
    [self.layer addSublayer:referenceLine];


}


#pragma mark - gestures

- (void)addGestures
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self addGestureRecognizer:tapGesture];
}


- (void)handleTap
{
    if (_timeViewChoosedBlock) {
        _timeViewChoosedBlock();
    }
}

@end
