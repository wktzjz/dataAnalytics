//
//  loginViewController.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-12.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "loginViewController.h"
#import "FlatButton.h"
#import "UIColor+CustomColors.h"
#import "POP.h"
#import "defines.h"
#import "UIView+snapShot.h"
#import "UIImage+Blur.h"

@interface loginViewController ()
@property (nonatomic) UILabel *errorLabel;
@property (nonatomic) flatButton *button;
@property (nonatomic) UIActivityIndicatorView *activityIndicatorView;

- (void)addButton;
- (void)addLabel;
- (void)addActivityIndicatorView;
- (void)showLabel;
- (void)hideLabel;
- (void)shakeButton;
@end

@implementation loginViewController
{
    UIImageView *_contentView;
}

- (instancetype)init
{
    return [self initWithFrame:wkScreen];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( (self = [super init]) ) {
        self.view.frame = frame;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _contentView = [[UIImageView alloc] initWithFrame:self.view.frame];
    _contentView.backgroundColor = [UIColor customGrayColor];
    [self.view addSubview:_contentView];
    
    [self backgroudImageSetting];
    [self addButton];
    [self addLabel];
    [self addActivityIndicatorView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backgroudImageSetting
{
    UIImageView *imageView =  [[UIImageView alloc] initWithFrame:self.view.frame];
    
    NSLog(@"parentViewController:%@",self.parentViewController);
    UIImage *blurImage = [[self.parentViewController.view snapshot] applyBlurWithRadius:5 tintColor:nil saturationDeltaFactor:1.8 maskImage:nil];
    imageView.image = blurImage;
    
    NSLog(@"iamgeView.frame, width:%f, height;%f",imageView.frame.size.width,imageView.frame.size.height);

    [_contentView addSubview:imageView];
}
- (void)addButton
{
    self.button = [flatButton button];
    self.button.backgroundColor = [UIColor customBlueColor];
    self.button.translatesAutoresizingMaskIntoConstraints = NO;
    [self.button setTitle:@"Log in" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f
                                                           constant:0.f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.f
                                                           constant:0.f]];
    
    flatButton *dismissButton = [flatButton button];
    dismissButton.backgroundColor = [UIColor customGrayColor];
    dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
    [dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
    [dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    dismissButton.center = CGPointMake(self.view.center.x,400);
    [self.view addSubview:dismissButton];
    
//    [dismissButton addConstraint:[NSLayoutConstraint constraintWithItem:dismissButton
//                                                          attribute:NSLayoutAttributeBottom
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeBottom
//                                                         multiplier:1.f
//                                                           constant:0.f]];
    
//    [dismissButton addConstraint:[NSLayoutConstraint constraintWithItem:self.button
//                                                          attribute:NSLayoutAttributeBottom
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeBottom
//                                                         multiplier:1.f
//                                                           constant:0.f]];

}

- (void)dismiss
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(dismissLoginController)]){
        [self.delegate dismissLoginController];
    }
}

- (void)addLabel
{
    self.errorLabel = [UILabel new];
    self.errorLabel.font = [UIFont fontWithName:@"Avenir-Light" size:18];
    self.errorLabel.textColor = [UIColor customRedColor];
    self.errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.errorLabel.text = @"Just a serious login error.";
    self.errorLabel.textAlignment = NSTextAlignmentCenter;
    [self.view insertSubview:self.errorLabel belowSubview:self.button];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.errorLabel
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.button
                              attribute:NSLayoutAttributeCenterX
                              multiplier:1
                              constant:0.f]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.errorLabel
                              attribute:NSLayoutAttributeCenterY
                              relatedBy:NSLayoutRelationEqual toItem:self.button
                              attribute:NSLayoutAttributeCenterY
                              multiplier:1
                              constant:0]];
    
    self.errorLabel.layer.transform = CATransform3DMakeScale(0.5f, 0.5f, 1.f);
}

- (void)addActivityIndicatorView
{
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicatorView];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)touchUpInside:(flatButton *)button
{
    [self hideLabel];
    [self.activityIndicatorView startAnimating];
    button.userInteractionEnabled = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.activityIndicatorView stopAnimating];
        [self shakeButton];
        [self showLabel];
    });
}

#pragma mark Animations

- (void)shakeButton
{
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.velocity = @2000;
    positionAnimation.springBounciness = 20;
    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        self.button.userInteractionEnabled = YES;
    }];
    [self.button.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
}

- (void)showLabel
{
    self.errorLabel.layer.opacity = 1.0;
    POPSpringAnimation *layerScaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerScaleAnimation.springBounciness = 18;
    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    [self.errorLabel.layer pop_addAnimation:layerScaleAnimation forKey:@"labelScaleAnimation"];
    
    POPSpringAnimation *layerPositionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    layerPositionAnimation.toValue = @(self.button.layer.position.y + self.button.intrinsicContentSize.height);
    layerPositionAnimation.springBounciness = 12;
    [self.errorLabel.layer pop_addAnimation:layerPositionAnimation forKey:@"layerPositionAnimation"];
}

- (void)hideLabel
{
    POPBasicAnimation *layerScaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.5f, 0.5f)];
    [self.errorLabel.layer pop_addAnimation:layerScaleAnimation forKey:@"layerScaleAnimation"];
    
    POPBasicAnimation *layerPositionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    layerPositionAnimation.toValue = @(self.button.layer.position.y);
    [self.errorLabel.layer pop_addAnimation:layerPositionAnimation forKey:@"layerPositionAnimation"];
}


#pragma mark barSetting
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
