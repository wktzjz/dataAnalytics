//
//  dataOutlineViewController.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-4.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "dataOutlineViewController.h"
#import "dataOutlineViewContainer.h"

@interface dataOutlineViewController ()

@end

@implementation dataOutlineViewController
{
    dataOutlineViewContainer *_dataOutlineViewContainer;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( (self = [super init]) ) {
        
        self.view.frame = frame;
        self.view.backgroundColor = [UIColor clearColor];
        
        _dataOutlineViewContainer = [[dataOutlineViewContainer alloc] initWithFrame:frame];
        [self.view addSubview: _dataOutlineViewContainer];
        
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
