//
//  dataDetailsViewController.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-4.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "dataDetailsViewController.h"
#import "dataOutlineViewContainer.h"
#import "BEMSimpleLineGraphView.h"
#import "defines.h"
#import "dataOutlineViewContainer.h"


@interface dataDetailsViewController ()<BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@property (strong, nonatomic) NSMutableArray *ArrayOfValues;
@property (strong, nonatomic) NSMutableArray *ArrayOfDates;
@property (nonatomic)  BEMSimpleLineGraphView *myGraph;

@end

@implementation dataDetailsViewController
{
    int previousStepperValue;
    int totalNumber;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero type:outlineTypeLine];
}

- (instancetype)initWithFrame:(CGRect)frame type:(dataVisualizedType)type
{
    if ( (self = [super init]) ) {
        
        _dataVisualizedType = type;

        self.view.frame = frame;
//        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *contentView = [[UIView alloc] initWithFrame:self.view.frame];
    contentView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    [self.view addSubview:contentView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    [_scrollView setDelegate:self];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setContentSize:CGSizeMake(0, self.view.bounds.size.height * 3)];
    [contentView addSubview:_scrollView];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 0, 160.0, 40.0);
    button.center = CGPointMake(self.view.center.x, self.view.center.y+150);
    [button setTitle:@"swipe or click" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:button];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handleTap:)];
//    [contentView addGestureRecognizer:tapGestureRecognizer];
    float marginX = 20.0;
    float marginY = 10.0;
    float width   = wkScreenWidth - marginX * 2;
    float height  = wkScreenHeight/2 + 10;
    
    if (_dataVisualizedType == outlineTypeLine) {
        NSLog(@"wkScreenWidth:%f",wkScreenWidth);
        
        UIView *view = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(marginX, marginY, width, height) dataType:outlineTypeLine inControllerType:detailView];
        view.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:view];
        
        
        //Add LineChart
//        UILabel * lineChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 30)];
//        lineChartLabel.text = @"Line Chart";
//        lineChartLabel.textColor = PNFreshGreen;
//        lineChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
//        lineChartLabel.textAlignment = NSTextAlignmentCenter;
//        
//        PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, detailViewHeight)];
//        lineChart.yLabelFormat = @"%1.1f";
//        lineChart.backgroundColor = [UIColor clearColor];
//        [lineChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5",@"SEP 6",@"SEP 7"]];
//        lineChart.showCoordinateAxis = YES;
//        
//        // Line Chart Nr.1
//        NSArray * data01Array = @[@60.1, @160.1, @126.4, @262.2, @186.2, @127.2, @176.2];
//        PNLineChartData *data01 = [PNLineChartData new];
//        data01.color = PNFreshGreen;
//        data01.itemCount = lineChart.xLabels.count;
//        data01.inflexionPointStyle = PNLineChartPointStyleCycle;
//        data01.getData = ^(NSUInteger index) {
//            CGFloat yValue = [data01Array[index] floatValue];
//            return [PNLineChartDataItem dataItemWithY:yValue];
//        };
//        
//        // Line Chart Nr.2
//        NSArray * data02Array = @[@20.1, @180.1, @26.4, @202.2, @126.2, @167.2, @276.2];
//        PNLineChartData *data02 = [PNLineChartData new];
//        data02.color = PNTwitterColor;
//        data02.itemCount = lineChart.xLabels.count;
//        data02.inflexionPointStyle = PNLineChartPointStyleSquare;
//        data02.getData = ^(NSUInteger index) {
//            CGFloat yValue = [data02Array[index] floatValue];
//            return [PNLineChartDataItem dataItemWithY:yValue];
//        };
//        
//        lineChart.chartData = @[data01, data02];
//        [lineChart strokeChart];
//        
//        lineChart.delegate = self;
//        
//        [contentView addSubview:lineChartLabel];
//        [contentView addSubview:lineChart];
//        NSLog(@"lineChart.center.x:%f, y:%f",lineChart.center.x,lineChart.center.y);
        
    }else if (_dataVisualizedType == outlineTypeBar){
        //Add BarChart
        UIView *view = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(marginX, marginY, width, height) dataType:outlineTypeBar inControllerType:detailView];
        [_scrollView addSubview:view];
        
//        UILabel * barChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 30)];
//        barChartLabel.text = @"Bar Chart";
//        barChartLabel.textColor = PNFreshGreen;
//        barChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
//        barChartLabel.textAlignment = NSTextAlignmentCenter;
//        
//        self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, detailViewHeight)];
//        self.barChart.backgroundColor = [UIColor clearColor];
//        self.barChart.yLabelFormatter = ^(CGFloat yValue){
//            CGFloat yValueParsed = yValue;
//            NSString * labelText = [NSString stringWithFormat:@"%1.f",yValueParsed];
//            return labelText;
//        };
//        self.barChart.labelMarginTop = 5.0;
//        [self.barChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5",@"SEP 6",@"SEP 7"]];
//        [self.barChart setYValues:@[@1,@24,@12,@18,@30,@10,@21]];
//        [self.barChart setStrokeColors:@[PNGreen,PNGreen,PNRed,PNGreen,PNGreen,PNYellow,PNGreen]];
//        // Adding gradient
//        self.barChart.barColorGradientStart = [UIColor magentaColor];
//        
//        [self.barChart strokeChart];
//        
//        self.barChart.delegate = self;
//        
//        [contentView addSubview:barChartLabel];
//        [contentView addSubview:self.barChart];
//        
//        
//        double delayInSeconds = 2.0;
//        __weak id wself = self;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^{
//            dataOutlineViewContainer *strongSelf = wself;
//            [self.barChart setYValues:@[@13,@4,@17,@18,@10,@50,@5]];
//            [self.barChart strokeChart];
//            
//        });
        
    }else if (_dataVisualizedType == outlineTypeCircle){
        
        //Add CircleChart
        UIView *view = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(marginX, marginY, width, height) dataType:outlineTypeCircle inControllerType:detailView];
        [_scrollView addSubview:view];
        
        
//        UILabel * circleChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 30)];
//        circleChartLabel.text = @"Circle Chart";
//        circleChartLabel.textColor = PNFreshGreen;
//        circleChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
//        circleChartLabel.textAlignment = NSTextAlignmentCenter;
//        
//        PNCircleChart * circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 80.0, SCREEN_WIDTH, detailViewHeight) andTotal:@100 andCurrent:@60 andClockwise:YES andShadow:YES];
//        circleChart.backgroundColor = [UIColor clearColor];
//        [circleChart setStrokeColor:PNGreen];
//        [circleChart setStrokeColorGradientStart:[UIColor blueColor]];
//        [circleChart strokeChart];
//        
//        [contentView addSubview:circleChartLabel];
//        
//        [contentView addSubview:circleChart];
        
    }else if (_dataVisualizedType == outlineTypePie){
        
        //Add PieChart
        
        UIView *view = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(marginX, marginY, width, height) dataType:outlineTypePie inControllerType:detailView];
        [_scrollView addSubview:view];
        
//        UILabel * pieChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 30)];
//        pieChartLabel.text = @"Pie Chart";
//        pieChartLabel.textColor = PNFreshGreen;
//        pieChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
//        pieChartLabel.textAlignment = NSTextAlignmentCenter;
//        
//        
//        
//        NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:PNLightGreen],
//                           [PNPieChartDataItem dataItemWithValue:20 color:PNFreshGreen description:@"WWDC"],
//                           [PNPieChartDataItem dataItemWithValue:40 color:PNDeepGreen description:@"GOOL I/O"],
//                           ];
//        
//        
//        
//        PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(40.0, 155.0, 240.0, 240.0) items:items];
//        pieChart.descriptionTextColor = [UIColor whiteColor];
//        pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
//        pieChart.descriptionTextShadowColor = [UIColor clearColor];
//        [pieChart strokeChart];
//        
//        [contentView addSubview:pieChartLabel];
//        [contentView addSubview:pieChart];
//        
    }else{
        UIView *view = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(marginX, marginY, width, height) dataType:outlineTypeLine1 inControllerType:detailView];
        [_scrollView addSubview:view];
//        self.ArrayOfValues = [[NSMutableArray alloc] init];
//        self.ArrayOfDates = [[NSMutableArray alloc] init];
//        
//        totalNumber = 0;
//        
//        for (int i = 0; i < 9; i++) {
//            [self.ArrayOfValues addObject:[NSNumber numberWithInteger:(arc4random() % 10000)]]; // Random values for the graph
//            [self.ArrayOfDates addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:2000 + i]]]; // Dates for the X-Axis of the graph
//            
//            totalNumber = totalNumber + [[self.ArrayOfValues objectAtIndex:i] intValue]; // All of the values added together
//        }
//        
//        /* This is commented out because the graph is created in the interface with this sample app. However, the code remains as an example for creating the graph using code. */
//        self.myGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 15.0, outlineViewWidth, 270.0)];
//        _myGraph.delegate = self;
//        _myGraph.dataSource = self;
//
//        self.myGraph.backgroundColor = [UIColor clearColor];
//        
//        // Customization of the graph
//        
//        self.myGraph.colorLine = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
//        
//        self.myGraph.colorXaxisLabel = [UIColor clearColor];
//        self.myGraph.colorYaxisLabel = [UIColor clearColor];
//        self.myGraph.widthLine = 1.5;
//        self.myGraph.enableTouchReport = YES;
//        self.myGraph.enablePopUpReport = YES;
//        self.myGraph.enableBezierCurve = YES;
//        
//        self.myGraph.enableYAxisLabel = NO;
//        self.myGraph.enableReferenceAxisLines = NO;
//        
//        self.myGraph.autoScaleYAxis = YES;
//        self.myGraph.alwaysDisplayDots = NO;
//        self.myGraph.enableReferenceAxisLines = NO;
//        self.myGraph.enableReferenceAxisFrame = YES;
//        self.myGraph.animationGraphStyle = BEMLineAnimationDraw;
//        
//        self.myGraph.colorTop = [UIColor whiteColor];
//        self.myGraph.colorBottom = [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.2];
//        //            self.myGraph.backgroundColor = [UIColor whiteColor];
////        self.tintColor = [UIColor whiteColor];
//        
//        [contentView addSubview:_myGraph];
    }
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

- (void)handleTap:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(dismissDetailsController)]){
        [self.delegate dismissDetailsController];
    }
}

- (void)buttonClicked:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(dismissDetailsController)]){
        [self.delegate dismissDetailsController];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
