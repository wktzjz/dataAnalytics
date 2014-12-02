//
//  dataOutlineViewContainer.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-4.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "dataOutlineViewContainer.h"
#import "defines.h"

#import "FBShimmeringView.h"
#import "UIColor+CustomColors.h"

#import "loadingView.h"

const static CGFloat loadingAnimationDuration = 1.0f;

@implementation UIView (Screenshot)

- (UIImage *)graphSnapshotImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    //    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES]; // Pre-iOS 7 Style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    }
    else{
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

@interface dataOutlineViewContainer () <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@property (strong, nonatomic) NSMutableArray *ArrayOfValues;
@property (strong, nonatomic) NSMutableArray *ArrayOfDates;

@end

@implementation dataOutlineViewContainer
{
    int previousStepperValue;
    int totalNumber;
    FBShimmeringView *_loadingLogo;
    BOOL _ifLoadingLogoShowing;
    
    UIView *_contentView;
    
    UILabel *_realtimevisitorGroupLabel;
    UILabel *_realtimeDealLabel;
    UILabel *_realtimeSourceLabel;
    UILabel *_realtimeCityLabel;
    UILabel *_realtimeTop5Label;
    
}

#pragma mark - init loadingView
- (instancetype)initWithFrame:(CGRect)frame ifLoading:(BOOL)ifLoading
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor whiteColor];
        
        if (ifLoading) {
            UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, frame.size.width - 20, 50)];
            [text setText:@"Loading"];
            [text setTextColor:[UIColor blackColor]];
            text.font = [UIFont boldSystemFontOfSize:33];
            text.textAlignment = NSTextAlignmentCenter;
            _loadingLogo = [[FBShimmeringView alloc] initWithFrame:CGRectMake(20, 100, frame.size.width - 20, 50)];
            _loadingLogo.contentView = text;
            _loadingLogo.shimmeringSpeed = 220;
            _loadingLogo.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
            _loadingLogo.shimmering = YES;
            
            _ifLoadingLogoShowing = YES;

            [self addSubview:_loadingLogo];
            
            [self addLoadingView];
        }
    }
    
    return  self;
}

#pragma mark - init dataView
- (instancetype)initWithFrame:(CGRect)frame dataType:(viewType)dataType data:(id)data inControllerType:(inViewType)inViewType
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor whiteColor];
        self.dataType = dataType;
        [self addDataViewType:dataType inControllerType:inViewType data:data];
        
//        UIView *_contentView = [[UIView alloc] initWithFrame:self.frame];
//        _contentView.backgroundColor = [UIColor whiteColor];
//        [self addSubview:_contentView];
        
        //disable the shadow and alpha to improve the performance.
//        self.alpha = 0.6;
//        self.layer.shadowOpacity = 0.5;
//        self.layer.shadowRadius = 5;
//        self.layer.shadowColor = [UIColor blackColor].CGColor;
//        self.layer.shadowOffset = CGSizeMake(-3, 3);
        
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = [[UIColor colorWithWhite:0.2 alpha:1] CGColor];
        
        }
    
    return self;
}

- (void)addLoadingView
{
    _loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(10,10,20,20)];
    _loadingView.lineColor = PNTwitterColor;
    [self addSubview:_loadingView];
    
    [_loadingView startAnimation];
}


#pragma mark - add dataView
- (void)addView:(UIView *)view inControllerType:(inViewType)inViewType
{
    [_contentView addSubview:view];
    [self addSubview:_contentView];
}

#pragma mark - add chart dataView
- (void)addDataViewType:(viewType)dataType inControllerType:(inViewType)inViewType data:(id)data
{
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    self.dataType = dataType;

    if (dataType == outlineTypeRealTime) {
        
           _realTimeView = [[realTimeOutlineView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) withData:data];
          [_contentView addSubview:_realTimeView];  
        
    }else if (dataType == outlinePageAnalytics) {
           
           _pageView = [[pageAnalyticsOutlineView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) withData:data];
           [_contentView addSubview:_pageView];
           
           _pieChart = _pageView.pieChart;
           _myGraph  = _pageView.lineGraph;
        
    }else if (dataType == outlineHotCity) {
        //Add BarChart
        
        _chartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, outlineViewWidth, 30)];
//        _chartLabel.text =(NSString *)data[dataType]?(NSString *)data[dataType]: @"Bar Chart";
        _chartLabel.text = @"热门城市";
        _chartLabel.textColor = PNFreshGreen;
        _chartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
        _chartLabel.textAlignment = NSTextAlignmentCenter;
        
        _barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 55.0, outlineViewWidth, outlineViewHeight)];
        _barChart.backgroundColor = [UIColor clearColor];
        _barChart.yLabelFormatter = ^(CGFloat yValue) {
            CGFloat yValueParsed = yValue;
            NSString * labelText = [NSString stringWithFormat:@"%1.f",yValueParsed];
            return labelText;
        };
        _barChart.labelMarginTop = 5.0;
        [_barChart setXLabels:@[@"北京",@"上海",@"广州",@"深圳",@"南京"]];
        [_barChart setYValues:@[@24,@12,@18,@10,@21]];
        [_barChart setStrokeColors:@[PNGreen,PNRed,PNTwitterColor,PNYellow,PNGreen]];
        // Adding gradient
        _barChart.barColorGradientStart = [UIColor customYellowColor];
        
        _barChart.showReferenceLines = YES;
        [_barChart strokeChart];
        
//        _barChart.delegate = self;
        
//        [self addSubview:barChartLabel];
//        [self addSubview:self.barChart];
        [_contentView addSubview:_chartLabel];
        [_contentView addSubview:self.barChart];

    }else if (dataType == outlineSource) {
        
        _sourceView= [[sourceAnalyticsOutlineView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) withData:data];
        [_contentView addSubview:_sourceView];
        _circleChart = _sourceView.circleChart;
        
    }else if (dataType == outlineVisitorGroup)
    {
//        _contentView = nil;
        _visitorGroupView = [[visitorGroupOutlineView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) withData:data];
        [_contentView addSubview:_visitorGroupView];
        
        _pieChart = _visitorGroupView.pieChart;
        
        
    }else if (dataType == outlineHotPage) {
        _chartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, outlineViewWidth, 30)];
        //        _chartLabel.text =(NSString *)data[dataType]?(NSString *)data[dataType]: @"Bar Chart";
        _chartLabel.text = @"热门页面";
        _chartLabel.textColor = PNFreshGreen;
        _chartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
        _chartLabel.textAlignment = NSTextAlignmentCenter;
        
        _barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 55.0, outlineViewWidth, outlineViewHeight)];
        _barChart.backgroundColor = [UIColor clearColor];
        _barChart.yLabelFormatter = ^(CGFloat yValue) {
            CGFloat yValueParsed = yValue;
            NSString * labelText = [NSString stringWithFormat:@"%1.f",yValueParsed];
            return labelText;
        };
        _barChart.labelMarginTop = 5.0;
        [_barChart setXLabels:@[@"页面1\n50%",@"页面2",@"页面3",@"页面4",@"页面5"]];
        [_barChart setYValues:@[@15,@10,@20,@30,@11]];
        [_barChart setStrokeColors:@[PNGreen,PNRed,PNTwitterColor,PNYellow,PNGreen]];
        // Adding gradient
        _barChart.barColorGradientStart = [UIColor customYellowColor];
        
        [_barChart strokeChart];
        
        //        _barChart.delegate = self;
        
        //        [self addSubview:barChartLabel];
        //        [self addSubview:self.barChart];
        [_contentView addSubview:_chartLabel];
        [_contentView addSubview:self.barChart];
        self.ArrayOfValues = [[NSMutableArray alloc] init];
        self.ArrayOfDates = [[NSMutableArray alloc] init];
//        self.ArrayOfValues = @[@5,@10,@30,@23,@15];
        totalNumber = 0;
        
        for (int i = 0; i < 5; i++) {
            [self.ArrayOfValues addObject:[NSNumber numberWithInteger:(arc4random() % 10000)]]; // Random values for the graph
            [self.ArrayOfDates addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:2000 + i]]]; // Dates for the X-Axis of the graph
            
            totalNumber = totalNumber + [[self.ArrayOfValues objectAtIndex:i] intValue]; // All of the values added together
        }
        
        //            self.ArrayOfValues = [[NSMutableArray alloc] initWithArray:@[@24444,@10000,@64213,@52341,@34445,@423,@81114,@22342,@33333]];
        
        /* This is commented out because the graph is created in the interface with this sample app. However, the code remains as an example for creating the graph using code. */
        
        float width  = (inViewType == outlineView) ? outlineViewWidth:SCREEN_WIDTH;
        
        self.myGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(40, 45.0, outlineViewWidth-80, 250.0)];
        _myGraph.delegate = self;
        _myGraph.dataSource = self;
        
        self.myGraph.backgroundColor = [UIColor clearColor];
        
        // Customization of the graph
        
        self.myGraph.colorLine = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
        
        self.myGraph.colorXaxisLabel = [UIColor clearColor];
        self.myGraph.colorYaxisLabel = [UIColor clearColor];
        self.myGraph.widthLine = 1.5;
        self.myGraph.enableTouchReport = YES;
        self.myGraph.enablePopUpReport = YES;
        self.myGraph.enableBezierCurve = NO;
        
        self.myGraph.enableYAxisLabel = NO;
        self.myGraph.enableReferenceAxisLines = NO;
        
        self.myGraph.autoScaleYAxis = YES;
        self.myGraph.alwaysDisplayDots = NO;
        self.myGraph.enableReferenceAxisLines = NO;
        self.myGraph.enableReferenceAxisFrame = YES;
        self.myGraph.animationGraphStyle = BEMLineAnimationDraw;
        
        self.myGraph.colorTop = [UIColor clearColor];
        self.myGraph.colorBottom = [UIColor clearColor];
        //            self.myGraph.backgroundColor = [UIColor whiteColor];
        self.tintColor = [UIColor whiteColor];
        
        [_contentView addSubview:_myGraph];
        
        if (inViewType == detailView) {
            _myGraph.alpha = 0.0;
            [UIView animateWithDuration:0.8 animations:^{
                _myGraph.alpha = 1.0;
            }];
        }
    }
    else if (dataType == outlineTransform) {
        
        _chartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, outlineViewWidth, 30)];
        _chartLabel.text = (NSString *)data[dataType]?(NSString *)data[dataType]: @"Line Chart";
        _chartLabel.textColor = PNFreshGreen;
        _chartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
        _chartLabel.textAlignment = NSTextAlignmentCenter;

        [_contentView addSubview:_chartLabel];
        self.ArrayOfValues = [[NSMutableArray alloc] init];
        self.ArrayOfDates = [[NSMutableArray alloc] init];
        
        totalNumber = 0;
        
        for (int i = 0; i < 9; i++) {
            [self.ArrayOfValues addObject:[NSNumber numberWithInteger:(arc4random() % 10000)]]; // Random values for the graph
            [self.ArrayOfDates addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:2000 + i]]]; // Dates for the X-Axis of the graph
            
            totalNumber = totalNumber + [[self.ArrayOfValues objectAtIndex:i] intValue]; // All of the values added together
        }
        
        //            self.ArrayOfValues = [[NSMutableArray alloc] initWithArray:@[@24444,@10000,@64213,@52341,@34445,@423,@81114,@22342,@33333]];
        
        /* This is commented out because the graph is created in the interface with this sample app. However, the code remains as an example for creating the graph using code. */
        
        float width  = (inViewType == outlineView) ? outlineViewWidth:SCREEN_WIDTH;
        
        self.myGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 45.0, outlineViewWidth, 250.0)];
        _myGraph.delegate = self;
        _myGraph.dataSource = self;
        
        self.myGraph.backgroundColor = [UIColor clearColor];
        
        // Customization of the graph
        
        self.myGraph.colorLine = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
        
        self.myGraph.colorXaxisLabel = [UIColor clearColor];
        self.myGraph.colorYaxisLabel = [UIColor clearColor];
        self.myGraph.widthLine = 1.5;
        self.myGraph.enableTouchReport = YES;
        self.myGraph.enablePopUpReport = YES;
        self.myGraph.enableBezierCurve = YES;
        
        self.myGraph.enableYAxisLabel = NO;
        self.myGraph.enableReferenceAxisLines = NO;
        
        self.myGraph.autoScaleYAxis = YES;
        self.myGraph.alwaysDisplayDots = NO;
        self.myGraph.enableReferenceAxisLines = NO;
        self.myGraph.enableReferenceAxisFrame = YES;
        self.myGraph.animationGraphStyle = BEMLineAnimationDraw;
        
        self.myGraph.colorTop = [UIColor whiteColor];
        self.myGraph.colorBottom = [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.2];
        //            self.myGraph.backgroundColor = [UIColor whiteColor];
        self.tintColor = [UIColor whiteColor];
        
        [_contentView addSubview:_myGraph];

        if (inViewType == detailView) {
            _myGraph.alpha = 0.0;
            [UIView animateWithDuration:0.8 animations:^{
                _myGraph.alpha = 1.0;
            }];
        }
    }
    
    [self addSubview:_contentView];
    
    if (_ifLoadingLogoShowing) {
        _contentView.alpha = 0.0;
        
        //模拟网络数据加载
        double delayInSeconds = 1.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [self endLoadingAnimation];
//            [self addLoadingView];
        });

    }
}

- (void)endLoadingAnimation
{
    CGPoint centerPoint = _contentView.center;
    centerPoint.x = self.frame.size.width/2;
    centerPoint.y = self.frame.size.height/2;
    
    _contentView.transform = CGAffineTransformMakeScale(1.3,1.3);

    [UIView animateWithDuration:loadingAnimationDuration
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.5
                        options:(UIViewAnimationOptionCurveEaseInOut)
                     animations:^{
                         _loadingLogo.alpha = 0.0;
                         _contentView.transform = CGAffineTransformIdentity;
                         _contentView.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         _ifLoadingLogoShowing = NO;
                         _loadingLogo.hidden = YES;
                         
                     }];
}



#pragma mark - reloadRealTimeData
- (void)reloadRealTimeData:(NSDictionary *)info
{
    if (_realTimeView) {
        [_realTimeView relodData:info];
    }
}

#pragma mark - modifyLineChart
- (void)modifyLineChartWithDataArray1:(NSArray *)dataArray1 dataArray2:(NSArray *)dataArray2 xLabelArray:(NSArray *)labelArray
{
    double delayInSeconds = 0.5;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(delayTime,dispatch_get_main_queue(), ^{
        
//        [_lineChart removeXlabelView];
//        [_lineChart removeYlabelView];
        [_lineChart removeLabelView];

        [_lineChart setXLabels:labelArray];
        
        NSArray * data01Array = dataArray1;
        PNLineChartData *data01 = [PNLineChartData new];
        data01.color = PNFreshGreen;
        data01.itemCount = _lineChart.xLabels.count;
        data01.inflexionPointStyle = PNLineChartPointStyleCycle;
        data01.getData = ^(NSUInteger index) {
            CGFloat yValue = [data01Array[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        
        // Line Chart Nr.2
        NSArray * data02Array = dataArray2;
        PNLineChartData *data02 = [PNLineChartData new];
        data02.color = PNTwitterColor;
        data02.itemCount = _lineChart.xLabels.count;
        data02.inflexionPointStyle = PNLineChartPointStyleSquare;
        data02.getData = ^(NSUInteger index) {
            CGFloat yValue = [data02Array[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        
        _lineChart.chartData = @[data01, data02];
        [_lineChart strokeChart];
    });
}


#pragma mark - modifyBarChart

- (void)modifyBarChartWithDataArray:(NSArray *)dataArray xLabelArray:(NSArray *)labelArray
{
    double delayInSeconds = 0.5;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(delayTime,dispatch_get_main_queue(), ^{
        
        [_barChart removeLabelView];
        [_barChart setXLabels:labelArray];
        [_barChart setYValues:dataArray];
        
        [_barChart strokeChart];
    });
}


#pragma mark - modifyCircleChart

- (void)modifyCircleChartWithData:(NSNumber *)data
{
    double delayInSeconds = 0.5;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(delayTime,dispatch_get_main_queue(), ^{
        
        _circleChart.current = data;
        _circleChart.isRestroke = YES;
//        [_circleChart.circle removeFromSuperlayer];
//        _circleChart.circle = nil;
        [_circleChart strokeChart];

    });
}


#pragma mark - modifyPieChart

- (void)modifyPieChartInView:(UIView *)view type:(viewType)type WithDataArray:(NSArray *)dataArray groupColorArray:(NSArray *)colorArray groupPercentArray:(NSArray *)percentArray
{
    double delayInSeconds = 0.5;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(delayTime,dispatch_get_main_queue(), ^{
        
        if (type == outlineVisitorGroup) {
            _visitorGroupView.groupColorArray = colorArray;
            _visitorGroupView.groupPercentArray = percentArray;
            [_visitorGroupView reloadViewWithData:nil];
            
        }else if (type == outlinePageAnalytics) {
            _pageView.groupColorArray = colorArray;
            _pageView.groupPercentArray = percentArray;
            [_pageView modifyPageView];
        }
        
        _pieChart.items = dataArray;
        [_pieChart strokeChart];
        
    });
}

#pragma mark - modifyLine1Chart

- (void)modifyLineChartInView:(UIView *)view type:(viewType)type WithValueArray:(NSMutableArray *)valueArray dateArray:(NSMutableArray *)dateArray
{
    double delayInSeconds = 0.5;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(delayTime,dispatch_get_main_queue(), ^{
        
//        self.ArrayOfValues = valueArray;
//        self.ArrayOfDates = dateArray;
        if (type == outlinePageAnalytics) {
            self.ArrayOfValues = ((pageAnalyticsOutlineView *)view).ArrayOfValues;
            self.ArrayOfDates = ((pageAnalyticsOutlineView *)view).ArrayOfDates;
        }
        
        [self.ArrayOfValues removeAllObjects];
        [self.ArrayOfDates removeAllObjects];
        
        for (int i = 0; i < 20; i++) {
            [self.ArrayOfValues addObject:[NSNumber numberWithInteger:(arc4random() % 10000)]]; // Random values for the graph
            [self.ArrayOfDates addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:2000 + i]]]; // Dates for the X-Axis of the graph
            
            totalNumber = totalNumber + [[self.ArrayOfValues objectAtIndex:i] intValue]; // All of the values added together
        }

        [self.myGraph reloadGraph];
    });
}

#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return (int)[self.ArrayOfValues count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[self.ArrayOfValues objectAtIndex:index] floatValue];
}

#pragma mark - SimpleLineGraph Delegate

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 1;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    NSString *label = [self.ArrayOfDates objectAtIndex:index];
    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
    //    self.labelValues.text = [NSString stringWithFormat:@"%@", [self.ArrayOfValues objectAtIndex:index]];
    //    self.labelDates.text = [NSString stringWithFormat:@"in %@", [self.ArrayOfDates objectAtIndex:index]];
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        //        self.labelValues.alpha = 0.0;
        //        self.labelDates.alpha = 0.0;
    } completion:^(BOOL finished) {
        //        self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSum] intValue]];
        //        self.labelDates.text = [NSString stringWithFormat:@"between 2000 and %@", [self.ArrayOfDates lastObject]];
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            //            self.labelValues.alpha = 1.0;
            //            self.labelDates.alpha = 1.0;
        } completion:nil];
    }];
}

- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph {
    //    self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSum] intValue]];
    //    self.labelDates.text = [NSString stringWithFormat:@"between 2000 and %@", [self.ArrayOfDates lastObject]];
}
@end

