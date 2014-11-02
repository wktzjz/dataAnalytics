//
//  lineChartDetailsViewController.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-31.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "lineChartDetailsViewController.h"

@implementation lineChartDetailsViewController
{
    
}

- (instancetype)initWithFrame:(CGRect)frame data:(NSDictionary *)data
{
    if ( (self = [super init]) ) {
        self.view.frame = frame;
        _data = data;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _chartDetailsView = [[lineChartDetailsView alloc] initWithFrame:self.view.frame];
    
    [self.view addSubview:_chartDetailsView];
}

- (void)reloadViewWithData:(NSDictionary *)data
{
    [_chartDetailsView reloadViewWithData:data];
}

@end
