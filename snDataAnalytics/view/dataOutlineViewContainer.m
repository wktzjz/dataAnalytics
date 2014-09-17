//
//  dataOutlineViewContainer.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-4.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "dataOutlineViewContainer.h"
#import "defines.h"

#import "PNChart.h"
#import "PNLineChartData.h"
#import "PNLineChartDataItem.h"

#import "BEMSimpleLineGraphView.h"
#import "FBShimmeringView.h"
#import "UIColor+CustomColors.h"

@implementation UIView (Screenshot)

- (UIImage *)graphSnapshotImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    //    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES]; // Pre-iOS 7 Style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    if([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
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
@property (nonatomic)  BEMSimpleLineGraphView *myGraph;

@end

@implementation dataOutlineViewContainer
{
    int previousStepperValue;
    int totalNumber;
    FBShimmeringView *_loadingLogo;
    BOOL _ifLoadingLogoShowing;
}

#pragma mark - init loadingView
- (instancetype)initWithFrame:(CGRect)frame ifLoading:(BOOL)ifLoading
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor whiteColor];
        
        if(ifLoading){
            UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, frame.size.width - 20, 50)];
            [text setText:@"Loading"];
            [text setTextColor:[UIColor blackColor]];
            text.font = [UIFont boldSystemFontOfSize:33];
            text.textAlignment = NSTextAlignmentCenter;
            _loadingLogo = [[FBShimmeringView alloc] initWithFrame:CGRectMake(20, 100, frame.size.width - 20, 50)];
            _loadingLogo.contentView = text;
            _loadingLogo.shimmeringSpeed = 180;
            _loadingLogo.center = CGPointMake(self.center.x, self.frame.size.height/2);
            _loadingLogo.shimmering = YES;
            
            [self addSubview:_loadingLogo];
            _ifLoadingLogoShowing = YES;
        }
    }
    
    return  self;
}

#pragma mark - init dataView
- (instancetype)initWithFrame:(CGRect)frame dataType:(dataVisualizedType)dataType inControllerType:(inViewType)inViewType
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor whiteColor];
        [self addDataViewType:dataType inControllerType:inViewType data:nil];
        
//        UIView *contentView = [[UIView alloc] initWithFrame:self.frame];
//        contentView.backgroundColor = [UIColor whiteColor];
//        [self addSubview:contentView];
        
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

#pragma mark - add dataView
- (void)addDataViewType:(dataVisualizedType)dataType inControllerType:(inViewType)inViewType data:(id)data
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
//    contentView.center = CGPointMake(self.frame.size.width * 1.5, 0);
    
    if (dataType == outlineTypeLine) {
        
        //            float width  = (inViewType == outlineView) ? outlineViewWidth:SCREEN_WIDTH;
        //            float height = (inViewType == outlineView) ? outlineViewHeight:detailViewHeight;
        
        //Add LineChart
        UILabel * lineChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, outlineViewWidth, 30)];
        lineChartLabel.text = @"Line Chart";
        lineChartLabel.textColor = PNFreshGreen;
        lineChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
        lineChartLabel.textAlignment = NSTextAlignmentCenter;
        
        PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 55.0, outlineViewWidth, outlineViewHeight)];
        lineChart.yLabelFormat = @"%1.1f";
        lineChart.backgroundColor = [UIColor clearColor];
        [lineChart setXLabels:@[@"9.1",@"9.2",@"9.3",@"9.4",@"9.5",@"9.6",@"9.7"]];
        lineChart.showCoordinateAxis = YES;
        
        // Line Chart Nr.1
        NSArray * data01Array = @[@60.1, @160.1, @126.4, @262.2, @186.2, @127.2, @176.2];
        PNLineChartData *data01 = [PNLineChartData new];
        data01.color = PNFreshGreen;
        data01.itemCount = lineChart.xLabels.count;
        data01.inflexionPointStyle = PNLineChartPointStyleCycle;
        data01.getData = ^(NSUInteger index) {
            CGFloat yValue = [data01Array[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        
        // Line Chart Nr.2
        NSArray * data02Array = @[@20.1, @180.1, @26.4, @202.2, @126.2, @167.2, @276.2];
        PNLineChartData *data02 = [PNLineChartData new];
        data02.color = PNTwitterColor;
        data02.itemCount = lineChart.xLabels.count;
        data02.inflexionPointStyle = PNLineChartPointStyleSquare;
        data02.getData = ^(NSUInteger index) {
            CGFloat yValue = [data02Array[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        
        lineChart.chartData = @[data01, data02];
        [lineChart strokeChart];
        
//        lineChart.delegate = self;
        
        [contentView addSubview:lineChartLabel];
        [contentView addSubview:lineChart];
//        [self addSubview:lineChartLabel];
//        [self addSubview:lineChart];
        
        
        //            double delayInSeconds = 1.5;
        //            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        //            dispatch_after(popTime, dispatch_get_main_queue(), ^{
        //
        //                UIImage *snapShotImage = [lineChart graphSnapshotImage];
        //                UIImageView *snapView = [[UIImageView alloc] initWithFrame:lineChart.frame];
        //                snapView.image = snapShotImage;
        //
        //                [self addSubview:snapView];
        //            });
        
    }else if (dataType == outlineTypeBar)
    {
        //Add BarChart
        
        UILabel * barChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, outlineViewWidth, 30)];
        barChartLabel.text = @"Bar Chart";
        barChartLabel.textColor = PNFreshGreen;
        barChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
        barChartLabel.textAlignment = NSTextAlignmentCenter;
        
        self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 55.0, outlineViewWidth, outlineViewHeight)];
        self.barChart.backgroundColor = [UIColor clearColor];
        self.barChart.yLabelFormatter = ^(CGFloat yValue){
            CGFloat yValueParsed = yValue;
            NSString * labelText = [NSString stringWithFormat:@"%1.f",yValueParsed];
            return labelText;
        };
        self.barChart.labelMarginTop = 5.0;
        [self.barChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5",@"SEP 6",@"SEP 7"]];
        [self.barChart setYValues:@[@1,@24,@12,@18,@30,@10,@21]];
        [self.barChart setStrokeColors:@[PNGreen,PNGreen,PNRed,PNGreen,PNGreen,PNYellow,PNGreen]];
        // Adding gradient
        self.barChart.barColorGradientStart = [UIColor customYellowColor];
        
        [self.barChart strokeChart];
        
//        self.barChart.delegate = self;
        
//        [self addSubview:barChartLabel];
//        [self addSubview:self.barChart];
        [contentView addSubview:barChartLabel];
        [contentView addSubview:self.barChart];
        
        //            UIImage *snapShotImage = [self.barChart graphSnapshotImage];
        //            UIImageView *snapView = [[UIImageView alloc] initWithFrame:self.barChart.frame];
        //            snapView.image = snapShotImage;
        //            [self addSubview:snapView];
        
        //            double delayInSeconds = 2.0;
        //            __weak id wself = self;
        //            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        //            dispatch_after(popTime, dispatch_get_main_queue(), ^{
        //                dataOutlineViewContainer *strongSelf = wself;
        //                [self.barChart setYValues:@[@13,@4,@17,@18,@10,@50,@5]];
        //                [self.barChart strokeChart];
        //
        //            });
        //
    }else if (dataType == outlineTypeCircle){
        
        //Add CircleChart
        
        
        UILabel * circleChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, outlineViewWidth, 30)];
        circleChartLabel.text = @"Circle Chart";
        circleChartLabel.textColor = PNFreshGreen;
        circleChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
        circleChartLabel.textAlignment = NSTextAlignmentCenter;
        
        PNCircleChart * circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 30.0, outlineViewWidth, 100.0) andTotal:@100 andCurrent:@60 andClockwise:YES andShadow:YES];
        circleChart.backgroundColor = [UIColor clearColor];
        [circleChart setStrokeColor:PNGreen];
        [circleChart setStrokeColorGradientStart:[UIColor blueColor]];
        [circleChart strokeChart];
        
//        [self addSubview:circleChartLabel];
//        [self addSubview:circleChart];
        [contentView addSubview:circleChartLabel];
        [contentView addSubview:circleChart];
        
        //            UIImage *snapShotImage = [self.barChart graphSnapshotImage];
        //            UIImageView *snapView = [[UIImageView alloc] initWithFrame:self.barChart.frame];
        //            snapView.image = snapShotImage;
        //            [self addSubview:circleChart];
        
    }else if (dataType == outlineTypePie)
    {
        //Add PieChart
        UILabel * pieChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, outlineViewWidth, 30)];
        pieChartLabel.text = @"Pie Chart";
        pieChartLabel.textColor = PNFreshGreen;
        pieChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
        pieChartLabel.textAlignment = NSTextAlignmentCenter;
        
        NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:PNLightGreen],
                           [PNPieChartDataItem dataItemWithValue:20 color:PNFreshGreen description:@"WWDC"],
                           [PNPieChartDataItem dataItemWithValue:40 color:PNDeepGreen description:@"GOOL I/O"],
                           ];
        
        
        PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(40.0, 55.0, 240.0, 240.0) items:items];
        pieChart.descriptionTextColor = [UIColor whiteColor];
        pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
        pieChart.descriptionTextShadowColor = [UIColor clearColor];
        [pieChart strokeChart];
        
//        [self addSubview:pieChartLabel];
//        [self addSubview:pieChart];
        [contentView addSubview:pieChartLabel];
        [contentView addSubview:pieChart];

        
    }else{
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
        
        self.myGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 25.0, outlineViewWidth, 270.0)];
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
        
        [contentView addSubview:_myGraph];

        if (inViewType == detailView){
            _myGraph.alpha = 0.0;
            [UIView animateWithDuration:0.8 animations:^{
                _myGraph.alpha = 1.0;
            }];
        }
    }

    [self addSubview:contentView];
    CGPoint centerPoint = contentView.center;
    centerPoint.x = self.frame.size.width/2;
    centerPoint.y = self.frame.size.height/2;
    
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.5
                        options:(UIViewAnimationOptionCurveEaseInOut)
                     animations:^{
                         if(_ifLoadingLogoShowing){
                             _loadingLogo.center = CGPointMake(-_loadingLogo.center.x, _loadingLogo.center.y);
                         }
                         contentView.center = centerPoint;
                     } completion:^(BOOL finished) {
                         _ifLoadingLogoShowing = NO;
//                             [self addSubview:contentView];
//                         NSLog(@"contentView.center.x :%f, y:%f",contentView.center.x,contentView.center.y);

                     }];
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

