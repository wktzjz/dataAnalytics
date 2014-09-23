//
//  indexSwitchController.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-22.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "indexSwitchController.h"
#import "FlatButton.h"
#import "Colours.h"

@interface indexSwitchController ()

@end

@implementation indexSwitchController
{
    UIView *_contentView;
    flatButton *_switchButton1;
    flatButton *_switchButton2;
}

- (instancetype)init
{
//     NSLog(@"0 indexSwitchController init");
    return [self initWithFrame:CGRectMake(0, 0, 280, 160)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( (self = [super init]) ) {
        self.view.frame = frame;
//         NSLog(@"111switchView frame, origin,x:%f, y:%f ,width:%f, height:%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, 280, 160);
    _contentView = [[UIView alloc] initWithFrame:self.view.frame];
//    NSLog(@"222 switchView _contentView, origin,x:%f, y:%f ,width:%f, height:%f",_contentView.frame.origin.x,_contentView.frame.origin.y,_contentView.frame.size.width,_contentView.frame.size.height);

    _contentView.backgroundColor = [UIColor whiteColor];
//    _contentView.alpha = 0.9;

    [self.view addSubview:_contentView];
    [self addButton];
}

- (void)addButton
{
    _switchButton1 = [flatButton button];
    [_switchButton1 setTitleColor:[UIColor blackColor]
               forState:UIControlStateNormal];
    _switchButton1.titleLabel.font = [UIFont fontWithName:@"Avenir-Medium"
                                           size:18];
    _switchButton1.backgroundColor = [UIColor clearColor];
    _switchButton1.translatesAutoresizingMaskIntoConstraints = NO;
    [_switchButton1 setTitle:@"Switch1" forState:UIControlStateNormal];
    [_switchButton1 addTarget:self action:@selector(switchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_switchButton1];
    
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_switchButton1
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_contentView
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.f
                                                           constant:30]];
    
    
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_switchButton1
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_contentView
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0f
                                                           constant:0.f]];
    
    _switchButton2 = [flatButton button];
    [_switchButton2 setTitleColor:[UIColor blackColor]
                        forState:UIControlStateNormal];
    _switchButton2.titleLabel.font = [UIFont fontWithName:@"Avenir-Medium"
                                                    size:18];
    _switchButton2.backgroundColor = [UIColor clearColor];
    _switchButton2.translatesAutoresizingMaskIntoConstraints = NO;
    [_switchButton2 setTitle:@"Switch2" forState:UIControlStateNormal];
    [_switchButton2 addTarget:self action:@selector(switchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_switchButton2];
    
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_switchButton2
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_contentView
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1.f
                                                              constant:-30]];
    
    
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_switchButton2
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_contentView
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0f
                                                              constant:0.f]];


}

- (void)switchButtonClicked:(flatButton *)sender
{
    if(self.switchAction){
        if(sender == _switchButton2){
            self.switchAction(1);
        }else{
            self.switchAction(0);
        }
    }
}

- (CGSize)preferredContentSize
{
    return CGSizeMake(280, 160);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
