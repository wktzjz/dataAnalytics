//
//  labelLineChartView.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-29.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "labelLineChartView.h"
#import "PNColor.h"
#import "Colours.h"
#import "FBShimmeringView.h"

@implementation labelLineChartView
{
    FBShimmeringView *_loadingLogo;
    BOOL _ifLoadingLogoShowing;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _labelString = @"NeedData";
        _labelNumber = @0;
        _arrayOfValues = [[NSMutableArray alloc] init];
        _arrayOfDates = [[NSMutableArray alloc] init];
        _shouldReferencedLinesShow = NO;
        _lineGraphHeight = 80.0;
        _viewMarker = 0;
        _ifLoadingLogoShowing = YES;
        
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor whiteColor];
        
        [self addLoadingView];
        [self addGestures];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame referencedLinesShow:(BOOL)show
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _labelString = @"NeedData";
        _labelNumber = @0;
        _arrayOfValues = [[NSMutableArray alloc] init];
        _arrayOfDates = [[NSMutableArray alloc] init];
        _shouldReferencedLinesShow = show;
        _lineGraphHeight = 80.0;
        _viewMarker = 0;
        _ifLoadingLogoShowing = YES;
        
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor whiteColor];
        
        [self addLoadingView];
        [self addGestures];
    }
    
    return self;
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//
//    _label.frame = CGRectMake(20.0, 5, self.frame.size.width - 20, 30);
//    _lineGraph.frame = CGRectMake(0, 5.0 + _label.frame.origin.y +_label.frame.size.height, self.frame.size.width, _lineGraphHeight);
//    
//    [_lineGraph reloadGraph];
//}

- (void)addLoadingView
{
    _label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 5, self.frame.size.width/2 + 20, 30)];
    _label.text = _labelString;
    _label.textColor = PNDeepGrey;
    _label.font = [UIFont fontWithName:@"OpenSans-Light" size:20.0];
    _label.textAlignment = NSTextAlignmentLeft;
    
    [self addSubview:_label];
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.frame.size.width - 20, 50)];
    [text setText:@"Loading"];
    [text setTextColor:[UIColor blackColor]];
    text.font = [UIFont boldSystemFontOfSize:25];
    text.textAlignment = NSTextAlignmentCenter;

    _loadingLogo = [[FBShimmeringView alloc] initWithFrame:CGRectMake(20, 100, self.frame.size.width - 20, 50)];
    _loadingLogo.contentView = text;
    _loadingLogo.shimmeringSpeed = 130;
    _loadingLogo.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _loadingLogo.shimmering = YES;
    
    [self addSubview:_loadingLogo];
    _ifLoadingLogoShowing = YES;

}

- (void)addViewsWithData:(NSDictionary *)data
{
    if (_ifLoadingLogoShowing) {
        [UIView animateWithDuration:0.7 animations:^{
            _loadingLogo.alpha = 0.0;
        } completion:^(BOOL finished) {
            _ifLoadingLogoShowing = NO;
            [_loadingLogo removeFromSuperview];
        }];
    }
    
//    NSString *keyofLabel = [NSString stringWithFormat:@"%@_labelString",_labelString];
//    _labelString = data[keyofLabel];
    
    NSString *keyofValues = [NSString stringWithFormat:@"%@_arrayOfValues",_labelString];
    NSString *keyofDates  = @"arrayOfDates";
    NSString *keyofNumber = [NSString stringWithFormat:@"%@_number",_labelString];
    
    if ((NSMutableArray *)data[keyofNumber]) {
        self.labelNumber = (NSNumber *)data[keyofNumber];
    }else{
        NSLog(@"%@ _labelNumber is nil",_labelString);
    }
    if ((NSMutableArray *)data[keyofValues]) {
        _arrayOfValues = (NSMutableArray *)data[keyofValues];
    }else{
        NSLog(@"%@ arrayOfValues is nil",_labelString);
    }
    
    assert((NSMutableArray *)data[keyofDates]);
    if ((NSMutableArray *)data[keyofDates]) {
        _arrayOfDates  = (NSMutableArray *)data[keyofDates];
    }else{
         NSLog(@"%@ arrayOfDates is nil",_labelString);
    }


    [self addLabel];
    [self addLineGraph];
}

- (void)addLabel
{
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2, 5, self.frame.size.width/2 - 20, 30)];
    _numberLabel.text = [NSString stringWithFormat:@"%@", _labelNumber];
    _numberLabel.textColor = [UIColor fadedBlueColor];
    _numberLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:20.0];
    _numberLabel.textAlignment = NSTextAlignmentRight;
    
    
    [self addSubview:_numberLabel];

}

- (void)addLineGraph
{
    float totalNumber = 0;
    
//    for (int i = 0; i < 20; i++) {
//        [_arrayOfValues addObject:[NSNumber numberWithInteger:(arc4random() % 100)]]; // Random values for the graph
//        [_arrayOfDates addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:i]]]; // Dates for the X-Axis of the graph
//        
//        totalNumber = totalNumber + [[_arrayOfValues objectAtIndex:i] intValue]; // All of the values added together
//    }
    
    float originY =  5.0 + _label.frame.origin.y +_label.frame.size.height;
    _lineGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, originY, self.frame.size.width, self.frame.size.height - originY - 10.0 )];
    
    _lineGraph.delegate = self;
    _lineGraph.dataSource = self;
    
    _lineGraph.backgroundColor = [UIColor clearColor];
    
    // Customization of the graph
    
    _lineGraph.colorLine = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
    
    _lineGraph.colorXaxisLabel = (_shouldReferencedLinesShow == NO) ? [UIColor clearColor] : [UIColor grayColor];
    _lineGraph.colorYaxisLabel = [UIColor grayColor];
    _lineGraph.widthLine = 1.5;
    //    _lineGraph.labelFont = [UIFont fontWithName:@"Avenir-Medium" size:13.0];
    _lineGraph.alwaysDisplayDots = NO;
    _lineGraph.enableTouchReport = NO;
    _lineGraph.enableBezierCurve = YES;
    _lineGraph.enablePopUpReport = _shouldReferencedLinesShow;
    _lineGraph.autoScaleYAxis    = YES;
    _lineGraph.enableReferenceAxisLines = _shouldReferencedLinesShow;
    _lineGraph.enableReferenceAxisFrame = NO;
    _lineGraph.enableYAxisLabel    = _shouldReferencedLinesShow;
    _lineGraph.animationGraphStyle = BEMLineAnimationDraw;
    
    _lineGraph.colorTop = [UIColor whiteColor];
    _lineGraph.colorBottom = [UIColor whiteColor];

//    _lineGraph.colorBottom = (_shouldReferencedLinesShow == NO) ? [UIColor whiteColor] :[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.2];

    [self addSubview:_lineGraph];
}

- (void)setShouldReferencedLinesShow:(BOOL)show
{
    if (_shouldReferencedLinesShow != show) {
        _shouldReferencedLinesShow = show;
        
        if (_lineGraph) {
            _lineGraph.enableReferenceAxisLines = show;
            _lineGraph.enableYAxisLabel = show;
            _lineGraph.colorXaxisLabel = (_shouldReferencedLinesShow == NO) ? [UIColor clearColor] : [UIColor grayColor];
            
            [_lineGraph reloadGraph];
        }
    }
}

- (void)relodData:(NSDictionary *)data
{
    NSString *keyofValues = [NSString stringWithFormat:@"%@_arrayOfValues",_labelString];
    NSString *keyofDates  = [NSString stringWithFormat:@"%@_arrayOfDates",_labelString];
    NSString *keyofNumber = [NSString stringWithFormat:@"%@_number",_labelString];
    
    if ((NSMutableArray *)data[keyofNumber]) {
        self.labelNumber = (NSNumber *)data[keyofNumber];
    }else{
        NSLog(@"%@ _labelNumber is nil",_labelString);
    }
    
    if ((NSMutableArray *)data[keyofValues]) {
        _arrayOfValues = (NSMutableArray *)data[keyofValues];
    }else{
        NSLog(@"%@ arrayOfValues is nil",_labelString);
    }
    
    if ((NSMutableArray *)data[keyofDates]) {
       _arrayOfDates  = (NSMutableArray *)data[keyofDates];
    }else{
//        NSLog(@"%@ arrayOfDates is nil",_labelString);
    }
    
    if ((NSMutableArray *)data[keyofValues] || (NSMutableArray *)data[keyofDates]) {
        [_lineGraph reloadGraph];
    }
}

- (void)setLabelString:(NSString *)labelString
{
    _labelString = labelString;
    _label.text = _labelString;
}

- (void)setLabelNumber:(NSNumber *)labelNumber
{
    _labelNumber = labelNumber;
    _numberLabel.text = [NSString stringWithFormat:@"%@",_labelNumber ];
}

- (void)addGestures
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)handleTap:(UIGestureRecognizer *)gesture
{
    if (_viewClickedBlock) {
        _viewClickedBlock(_viewMarker);
    }
}

#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return (int)[_arrayOfValues count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[_arrayOfValues objectAtIndex:index] floatValue];
}

#pragma mark - SimpleLineGraph Delegate

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 1;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    NSString *label = [_arrayOfDates objectAtIndex:index];
    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}

//- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
//    //    self.labelValues.text = [NSString stringWithFormat:@"%@", [self.ArrayOfValues objectAtIndex:index]];
//    //    self.labelDates.text = [NSString stringWithFormat:@"in %@", [self.ArrayOfDates objectAtIndex:index]];
//}
//
//- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
//    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        //        self.labelValues.alpha = 0.0;
//        //        self.labelDates.alpha = 0.0;
//    } completion:^(BOOL finished) {
//        //        self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSum] intValue]];
//        //        self.labelDates.text = [NSString stringWithFormat:@"between 2000 and %@", [self.ArrayOfDates lastObject]];
//        
//        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            //            self.labelValues.alpha = 1.0;
//            //            self.labelDates.alpha = 1.0;
//        } completion:nil];
//    }];
//}


@end
