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

#import "realTimeOutlineView.h"

const static CGFloat loadingAnimationDuration = 0.7f;

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

@end

@implementation dataOutlineViewContainer
{
    int previousStepperValue;
    int totalNumber;
    FBShimmeringView *_loadingLogo;
    BOOL _ifLoadingLogoShowing;
    
    UIView *_contentView;
    
    UILabel *_realtimeVistorGroupLabel;
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
        
        if(ifLoading){
            UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, frame.size.width - 20, 50)];
            [text setText:@"Loading"];
            [text setTextColor:[UIColor blackColor]];
            text.font = [UIFont boldSystemFontOfSize:33];
            text.textAlignment = NSTextAlignmentCenter;
            _loadingLogo = [[FBShimmeringView alloc] initWithFrame:CGRectMake(20, 100, frame.size.width - 20, 50)];
            _loadingLogo.contentView = text;
            _loadingLogo.shimmeringSpeed = 180;
            _loadingLogo.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
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
        self.dataType = dataType;
        [self addDataViewType:dataType inControllerType:inViewType data:nil];
        
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


#pragma mark - add dataView
- (void)addView:(UIView *)view inControllerType:(inViewType)inViewType
{
    [_contentView addSubview:view];
    [self addSubview:_contentView];
}

#pragma mark - add chart dataView
- (void)addDataViewType:(viewType)dataType inControllerType:(inViewType)inViewType data:(id)data
{
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    
    self.dataType = dataType;

       if (dataType == outlineTypeRealTime) {
        
           _contentView = nil;
           _contentView = [[realTimeOutlineView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
           
           //[self addRealtimeView:data];
           
       }else if (dataType == outlinePageAnalytics) {
           
           _pageView = [[pageAnalyticsOutlineView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
           [_contentView addSubview:_pageView];
           
           _pieChart = _pageView.pieChart;
           _myGraph  = _pageView.lineGraph;
        
        //            float width  = (inViewType == outlineView) ? outlineViewWidth:SCREEN_WIDTH;
        //            float height = (inViewType == outlineView) ? outlineViewHeight:detailViewHeight;
        
//        //Add LineChart
//        _chartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, outlineViewWidth, 30)];
//        _chartLabel.text = (NSString *)data[dataType]?(NSString *)data[dataType]: @"Line Chart";
//        _chartLabel.textColor = PNFreshGreen;
//        _chartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
//        _chartLabel.textAlignment = NSTextAlignmentCenter;
//        
//        _lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 55.0, outlineViewWidth, outlineViewHeight)];
//        _lineChart.yLabelFormat = @"%1.1f";
//        _lineChart.backgroundColor = [UIColor clearColor];
//        [_lineChart setXLabels:@[@"9.1",@"9.2",@"9.3",@"9.4",@"9.5",@"9.6",@"9.7"]];
//        _lineChart.showCoordinateAxis = YES;
//        
//        // Line Chart Nr.1
//        NSArray * data01Array = @[@60.1, @160.1, @126.4, @262.2, @186.2, @127.2, @176.2];
//        PNLineChartData *data01 = [PNLineChartData new];
//        data01.color = PNFreshGreen;
//        data01.itemCount = _lineChart.xLabels.count;
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
//        data02.itemCount = _lineChart.xLabels.count;
//        data02.inflexionPointStyle = PNLineChartPointStyleSquare;
//        data02.getData = ^(NSUInteger index) {
//            CGFloat yValue = [data02Array[index] floatValue];
//            return [PNLineChartDataItem dataItemWithY:yValue];
//        };
//        
//        _lineChart.chartData = @[data01, data02];
//        [_lineChart strokeChart];
//    
////        lineChart.delegate = self;
//        
//        [_contentView addSubview:_chartLabel];
//        [_contentView addSubview:_lineChart];
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
        
    }else if (dataType == outlineHotCity)
    {
        //Add BarChart
        
        _chartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, outlineViewWidth, 30)];
//        _chartLabel.text =(NSString *)data[dataType]?(NSString *)data[dataType]: @"Bar Chart";
        _chartLabel.text = @"热门城市";
        _chartLabel.textColor = PNFreshGreen;
        _chartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
        _chartLabel.textAlignment = NSTextAlignmentCenter;
        
        _barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 55.0, outlineViewWidth, outlineViewHeight)];
        _barChart.backgroundColor = [UIColor clearColor];
        _barChart.yLabelFormatter = ^(CGFloat yValue){
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
        
        [_barChart strokeChart];
        
//        _barChart.delegate = self;
        
//        [self addSubview:barChartLabel];
//        [self addSubview:self.barChart];
        [_contentView addSubview:_chartLabel];
        [_contentView addSubview:self.barChart];

    }else if (dataType == outlineSource){
        
        _chartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, outlineViewWidth, 30)];
        _chartLabel.text = (NSString *)data[dataType]?(NSString *)data[dataType]: @"Circle Chart";
        _chartLabel.textColor = PNFreshGreen;
        _chartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
        _chartLabel.textAlignment = NSTextAlignmentCenter;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10 + _chartLabel.frame.origin.y + _chartLabel.frame.size.height, outlineViewWidth, 30)];
        label.text = @"Vistor占比:";
        label.textColor = PNDeepGrey;
        label.font = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
        label.textAlignment = NSTextAlignmentLeft;
        
        _circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0,label.frame.origin.y + label.frame.size.height - 30.0, outlineViewWidth, 100.0) andTotal:@100 andCurrent:@60 andClockwise:YES andShadow:YES];
        _circleChart.backgroundColor = [UIColor clearColor];

        [_circleChart setStrokeColor:[UIColor colorWithRed:77.0 / 255.0 green:106.0 / 255.0 blue:122.0 / 255.0 alpha:1.0f]];
        [_circleChart setStrokeColorGradientStart:[UIColor colorWithRed:77.0 / 255.0 green:236.0 / 255.0 blue:122.0 / 255.0 alpha:1.0f]];
        _circleChart.isRestroke = NO;
        [_circleChart strokeChart];
        
//        [self addSubview:circleChartLabel];
//        [self addSubview:circleChart];
        [_contentView addSubview:label];
        [_contentView addSubview:_chartLabel];
        [_contentView addSubview:_circleChart];
        
    }else if (dataType == outlineVistorGroup)
    {
//        _contentView = nil;
        _vistorGroupView = [[vistorGroupOutlineView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [_contentView addSubview:_vistorGroupView];
        
        _pieChart = _vistorGroupView.pieChart;
        
//        //Add PieChart
//        _chartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, outlineViewWidth, 30)];
//        _chartLabel.text = (NSString *)data[dataType]?(NSString *)data[dataType]: @"Pie Chart";
//        _chartLabel.textColor = PNFreshGreen;
//        _chartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
//        _chartLabel.textAlignment = NSTextAlignmentCenter;
//        
//        NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:PNLightGreen],
//                           [PNPieChartDataItem dataItemWithValue:20 color:PNFreshGreen description:@"SMALL"],
//                           [PNPieChartDataItem dataItemWithValue:40 color:PNDeepGreen description:@"BIG"],
//                           ];
//        
//        
//        _pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(15.0, 40.0, outlineViewWidth - 30,outlineViewWidth - 30) items:items];
//        _pieChart.descriptionTextColor = [UIColor whiteColor];
//        _pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
//        _pieChart.descriptionTextShadowColor = [UIColor clearColor];
//        [_pieChart strokeChart];
//        
////        [self addSubview:pieChartLabel];
////        [self addSubview:pieChart];
//        [_contentView addSubview:_chartLabel];
//        [_contentView addSubview:_pieChart];
//
        
    }else if(dataType == outlineHotPage){
        _chartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, outlineViewWidth, 30)];
        //        _chartLabel.text =(NSString *)data[dataType]?(NSString *)data[dataType]: @"Bar Chart";
        _chartLabel.text = @"热门页面";
        _chartLabel.textColor = PNFreshGreen;
        _chartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
        _chartLabel.textAlignment = NSTextAlignmentCenter;
        
        _barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 55.0, outlineViewWidth, outlineViewHeight)];
        _barChart.backgroundColor = [UIColor clearColor];
        _barChart.yLabelFormatter = ^(CGFloat yValue){
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
        
        if (inViewType == detailView){
            _myGraph.alpha = 0.0;
            [UIView animateWithDuration:0.8 animations:^{
                _myGraph.alpha = 1.0;
            }];
        }
    }
    else if(dataType == outlineTransform){
        
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

        if (inViewType == detailView){
            _myGraph.alpha = 0.0;
            [UIView animateWithDuration:0.8 animations:^{
                _myGraph.alpha = 1.0;
            }];
        }
    }

    [self addSubview:_contentView];
    
    [self endLoadingAnimation];
 }

- (void)endLoadingAnimation
{
    CGPoint centerPoint = _contentView.center;
    centerPoint.x = self.frame.size.width/2;
    centerPoint.y = self.frame.size.height/2;

    [UIView animateWithDuration:loadingAnimationDuration
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.5
                        options:(UIViewAnimationOptionCurveEaseInOut)
                     animations:^{
                         if(_ifLoadingLogoShowing){
                             _loadingLogo.center = CGPointMake(-_loadingLogo.center.x, _loadingLogo.center.y);
                         }
                         _contentView.center = centerPoint;
                     } completion:^(BOOL finished) {
                         _ifLoadingLogoShowing = NO;
                         //                             [self addSubview:_contentView];
                         //                         NSLog(@"_contentView.center.x :%f, y:%f",_contentView.center.x,_contentView.center.y);
                         
                     }];
}


- (void)addRealtimeView:(id)data
{
    _chartLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, outlineViewWidth, 30)];
    _chartLabel.text = (NSString *)data[_dataType]?(NSString *)data[_dataType]: @"Line Chart";
    _chartLabel.textColor = [UIColor blackColor];
    _chartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:24.0];
    _chartLabel.textAlignment = NSTextAlignmentLeft;
    
    [_contentView addSubview:_chartLabel];
//    访客群体分析
//    成交
//    来源渠道
//    城市分布
//    TOP5页面
    _realtimeVistorGroupLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 3 + _chartLabel.frame.origin.y +_chartLabel.frame.size.height, outlineViewWidth, 30)];
    _realtimeVistorGroupLabel.text =@"访客群体分析";
    _realtimeVistorGroupLabel.textColor = PNDeepGrey;
    _realtimeVistorGroupLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
    _realtimeVistorGroupLabel.textAlignment = NSTextAlignmentLeft;

    _realtimeDealLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 3 + _realtimeVistorGroupLabel.frame.origin.y +_realtimeVistorGroupLabel.frame.size.height, outlineViewWidth, 30)];
    _realtimeDealLabel.text =@"成交";
    _realtimeDealLabel.textColor = PNDeepGrey;
    _realtimeDealLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
    _realtimeDealLabel.textAlignment = NSTextAlignmentLeft;
    
    _realtimeSourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 3 + _realtimeDealLabel.frame.origin.y +_realtimeDealLabel.frame.size.height, outlineViewWidth, 30)];
    _realtimeSourceLabel.text =@"来源渠道";
    _realtimeSourceLabel.textColor = PNDeepGrey;
    _realtimeSourceLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
    _realtimeSourceLabel.textAlignment = NSTextAlignmentLeft;
    
    _realtimeCityLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 3 + _realtimeSourceLabel.frame.origin.y +_realtimeSourceLabel.frame.size.height, outlineViewWidth, 30)];
    _realtimeCityLabel.text =@"城市分布";
    _realtimeCityLabel.textColor = PNDeepGrey;
    _realtimeCityLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
    _realtimeCityLabel.textAlignment = NSTextAlignmentLeft;
    
    _realtimeTop5Label = [[UILabel alloc] initWithFrame:CGRectMake(20, 3 + _realtimeCityLabel.frame.origin.y +_realtimeCityLabel.frame.size.height, outlineViewWidth, 30)];
    _realtimeTop5Label.text =@"TOP5页面";
    _realtimeTop5Label.textColor = PNDeepGrey;
    _realtimeTop5Label.font = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
    _realtimeTop5Label.textAlignment = NSTextAlignmentLeft;
    
    [_contentView addSubview:_realtimeVistorGroupLabel];
    [_contentView addSubview:_realtimeDealLabel];
    [_contentView addSubview:_realtimeSourceLabel];
    [_contentView addSubview:_realtimeCityLabel];
    [_contentView addSubview:_realtimeTop5Label];

   NSMutableArray *ArrayOfValues = [[NSMutableArray alloc] init];
   NSMutableArray *ArrayOfDates = [[NSMutableArray alloc] init];
    
    totalNumber = 0;
    
    for (int i = 0; i < 9; i++) {
        [ArrayOfValues addObject:[NSNumber numberWithInteger:(arc4random() % 10000)]]; // Random values for the graph
        [ArrayOfDates addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:2000 + i]]]; // Dates for the X-Axis of the graph
        
        totalNumber = totalNumber + [[ArrayOfValues objectAtIndex:i] intValue]; // All of the values added together
    }
    
    //            self.ArrayOfValues = [[NSMutableArray alloc] initWithArray:@[@24444,@10000,@64213,@52341,@34445,@423,@81114,@22342,@33333]];
    
    /* This is commented out because the graph is created in the interface with this sample app. However, the code remains as an example for creating the graph using code. */
    
   BEMSimpleLineGraphView *lineGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 3.0+_realtimeTop5Label.frame.origin.y +_realtimeTop5Label.frame.size.height, outlineViewWidth, 30.0)];
    lineGraph.delegate = self;
    lineGraph.dataSource = self;
    
    lineGraph.backgroundColor = [UIColor clearColor];
    
    // Customization of the graph
    
    lineGraph.colorLine = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
    
    lineGraph.colorXaxisLabel = [UIColor clearColor];
    lineGraph.colorYaxisLabel = [UIColor clearColor];
    lineGraph.widthLine = 1.5;
    lineGraph.enableTouchReport = YES;
    lineGraph.enablePopUpReport = YES;
    lineGraph.enableBezierCurve = YES;
    
    lineGraph.enableYAxisLabel = NO;
    lineGraph.enableReferenceAxisLines = NO;
    
    lineGraph.autoScaleYAxis = YES;
    lineGraph.alwaysDisplayDots = NO;
    lineGraph.enableReferenceAxisLines = NO;
    lineGraph.enableReferenceAxisFrame = YES;
    lineGraph.animationGraphStyle = BEMLineAnimationDraw;
    
    lineGraph.colorTop = [UIColor whiteColor];
    lineGraph.colorBottom = [UIColor whiteColor];
    //            self.myGraph.backgroundColor = [UIColor whiteColor];
    self.tintColor = [UIColor whiteColor];
    
    [_contentView addSubview:lineGraph];
    
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
        
        if(type == outlineVistorGroup){
            _vistorGroupView.groupColorArray = colorArray;
            _vistorGroupView.groupPercentArray = percentArray;
            [_vistorGroupView modifyGroupView];
            
        }else if (type == outlinePageAnalytics){
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
        if(type == outlinePageAnalytics){
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

