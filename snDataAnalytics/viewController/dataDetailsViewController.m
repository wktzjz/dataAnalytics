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

#import "wkBlurPopover.h"
#import "indexSwitchController.h"


#import "Colours.h"
#import "FBShimmeringView.h"
#import "flatButton.h"
#import "changefulButton.h"

const static CGFloat titleViewHeight = 44.0f;


@interface dataDetailsViewController ()<BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@property (strong, nonatomic) NSMutableArray *ArrayOfValues;
@property (strong, nonatomic) NSMutableArray *ArrayOfDates;
@property (nonatomic)  BEMSimpleLineGraphView *myGraph;

@end

@implementation dataDetailsViewController
{
    int previousStepperValue;
    int totalNumber;
    
    UIView *_contentView;
    UIView *_barView;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero type:outlineTypeLine title:nil];
}

- (instancetype)initWithFrame:(CGRect)frame type:(dataVisualizedType)type
{
    return [self initWithFrame:CGRectZero type:type title:nil];
}

- (instancetype)initWithFrame:(CGRect)frame type:(dataVisualizedType)type title:(NSString *)title
{
    if ( (self = [super init]) ) {
        
        _dataVisualizedType = type;
        _viewTitleString   = title;
        self.view.frame = frame;
//        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    
   _contentView = [[UIView alloc] initWithFrame:self.view.frame];
    _contentView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    [self.view addSubview:_contentView];
    
    [self addTitleView];
    [self addSettingButton];
    [self addScrollView];
    [self addOutlineDataView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handleTap:)];
}

#pragma mark add views
- (void)addTitleView
{
    _barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, titleViewHeight)];
    _barView.backgroundColor = [UIColor colorWithRed:0xbf/255.0 green:0xef/255.0 blue:0xff/255.0 alpha:1];
    [_contentView addSubview:_barView];
    
    _viewTitle = [[UILabel alloc] init];
    [_viewTitle setTextColor:[UIColor blackColor]];
    [_viewTitle setText:_viewTitleString];
    _viewTitle.textAlignment = NSTextAlignmentCenter;
    _viewTitle.font   = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    CGSize sz    = [_viewTitle.text sizeWithAttributes:@{NSFontAttributeName:_viewTitle.font}];
    _viewTitle.frame  = CGRectMake(0, 0, sz.width*2, sz.height);
    _viewTitle.center = CGPointMake(_barView.center.x,_barView.center.y);
//    [titleView addSubview:_viewTitle];

    FBShimmeringView *shimmeringLogo = [[FBShimmeringView alloc] initWithFrame:_viewTitle.frame];
    shimmeringLogo.contentView     = _viewTitle;
    shimmeringLogo.shimmeringSpeed = 180;
    shimmeringLogo.shimmering      = YES;
    shimmeringLogo.center          = CGPointMake(_barView.center.x,_barView.center.y);
    [_barView addSubview:shimmeringLogo];
}

- (void)setViewTitleString:(NSString *)titleString
{
    _viewTitleString = titleString;
    [_viewTitle setText:titleString];
}

- (void)addSettingButton
{
//    changefulButton *settingButton = [changefulButton button];
//    settingButton.tintColor = [UIColor blackColor];
//    settingButton.center = CGPointMake(290.0f,22.0f);


    flatButton *settingButton = [flatButton button];
    settingButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Medium"size:18];

    settingButton.backgroundColor = [UIColor clearColor];
    settingButton.translatesAutoresizingMaskIntoConstraints = NO;
    [settingButton setTitle:@"Settings" forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(settingButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [_barView addSubview:settingButton];
    
    [_barView addConstraint:[NSLayoutConstraint constraintWithItem:settingButton
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_barView
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1.f
                                                              constant:0.0f]];
    
    
    [_barView addConstraint:[NSLayoutConstraint constraintWithItem:settingButton
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_barView
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0f
                                                              constant:0.f]];

}

- (void)addScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, titleViewHeight, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    [_scrollView setDelegate:self];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setContentSize:CGSizeMake(0, self.view.bounds.size.height * 3)];
    [_contentView addSubview:_scrollView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 0, 160.0, 40.0);
    button.center = CGPointMake(self.view.center.x, self.view.center.y+150);
    [button setTitle:@"swipe or click" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:button];
}

- (void)addOutlineDataView
{
    float marginX = 20.0;
    float marginY = 10.0;
    float width   = wkScreenWidth - marginX * 2;
    float height  = wkScreenHeight/2 + 10;
    
    if (_dataVisualizedType == outlineTypeLine) {
        NSLog(@"wkScreenWidth:%f",wkScreenWidth);
        
        _dataContentView = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(marginX, marginY, width, height) dataType:outlineTypeLine inControllerType:detailView];
        _dataContentView.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:_dataContentView];
        
        
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
        _dataContentView = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(marginX, marginY, width, height) dataType:outlineTypeBar inControllerType:detailView];
        [_scrollView addSubview:_dataContentView];
        
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
        _dataContentView = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(marginX, marginY, width, height) dataType:outlineTypeCircle inControllerType:detailView];
        [_scrollView addSubview:_dataContentView];
        
        
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
        
        _dataContentView = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(marginX, marginY, width, height) dataType:outlineTypePie inControllerType:detailView];
        [_scrollView addSubview:_dataContentView];
        
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
        _dataContentView = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(marginX, marginY, width, height) dataType:outlineTypeLine1 inControllerType:detailView];
        [_scrollView addSubview:_dataContentView];
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

#pragma mark settingButtonClicked
- (void)settingButtonClicked
{
    indexSwitchController *vc = [[indexSwitchController alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    vc.switchAction =^(NSInteger clickedButtonIndex){
        typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf dismissViewControllerAnimated:YES completion:nil];
        
        [strongSelf modifyDataView:clickedButtonIndex];
        };
    
    wkBlurPopover *popover = [[wkBlurPopover alloc] initWithContentViewController:vc];
    [self presentViewController:popover animated:YES completion:nil];
}

#pragma mark modifyDataView
- (void)modifyDataView:(NSInteger)clickedButtonIndex
{
    if(_dataVisualizedType == outlineTypeLine){
        if (clickedButtonIndex == 0) {
            [_dataContentView modifyLineChartWithDataArray1:@[@160.1, @260.1, @36.4, @162.2, @86.2, @227.2, @76.2] dataArray2:@[@260.1, @60.1, @26.4, @262.2, @186.2, @227.2, @76.2] xLabelArray:@[@"10.1",@"10.2",@"10.3",@"10.4",@"10.5",@"10.6",@"10.7"]];
        }else if(clickedButtonIndex == 1){
            [_dataContentView modifyLineChartWithDataArray1: @[@60.1, @160.1, @126.4, @262.2, @186.2, @127.2, @176.2] dataArray2:@[@20.1, @180.1, @26.4, @202.2, @126.2, @167.2, @276.2] xLabelArray:@[@"9.1",@"9.2",@"9.3",@"9.4",@"9.5",@"9.6",@"9.7"]];
        }
        
    }else if(_dataVisualizedType == outlineTypeBar){
        if (clickedButtonIndex == 0) {
            [_dataContentView modifyBarChartWithDataArray:@[@22,@51,@12,@10,@10,@30,@11] xLabelArray:@[@"OCT 1",@"OCT 2",@"OCT 3",@"OCT 4",@"OCT 5",@"OCT 6",@"OCT 7"]];
        }else if(clickedButtonIndex == 1){
            [_dataContentView modifyBarChartWithDataArray: @[@1,@24,@12,@18,@30,@10,@21] xLabelArray:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5",@"SEP 6",@"SEP 7"]];
        }
        
    }else if(_dataVisualizedType == outlineTypeCircle){
        if (clickedButtonIndex == 0) {
            [_dataContentView modifyCircleChartWithData:@20];
        }else if(clickedButtonIndex == 1){
            [_dataContentView modifyCircleChartWithData:@60];
        }
        
    }else if(_dataVisualizedType == outlineTypePie){
        if (clickedButtonIndex == 0) {
            [_dataContentView modifyPieChartWithDataArray:@[[PNPieChartDataItem dataItemWithValue:10 color:PNBlue],[PNPieChartDataItem dataItemWithValue:40 color:PNLightBlue description:@"SMALL"],[PNPieChartDataItem dataItemWithValue:50 color:PNTwitterColor description:@"BIG"]]];
        }else if(clickedButtonIndex == 1){
            [_dataContentView modifyPieChartWithDataArray: @[[PNPieChartDataItem dataItemWithValue:10 color:PNLightGreen],[PNPieChartDataItem dataItemWithValue:20 color:PNFreshGreen description:@"SMALL"],[PNPieChartDataItem dataItemWithValue:40 color:PNDeepGreen description:@"BIG"]]];
        }
        
    }else if(_dataVisualizedType == outlineTypeLine1){
        if (clickedButtonIndex == 0) {
            [_dataContentView modifyLineChartWithValueArray:nil dateArray:nil];
        }else if(clickedButtonIndex == 1){
            [_dataContentView modifyLineChartWithValueArray:nil dateArray:nil];
        }
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
