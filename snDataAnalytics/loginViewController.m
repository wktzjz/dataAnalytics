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
#import "Colours.h"
#import "JVFloatLabeledTextField.h"
#import "JVFloatLabeledTextView.h"

const static CGFloat fieldHeight = 44.0f;
const static CGFloat fieldHMargin = 20.0f;
const static CGFloat fieldFontSize = 25.0f;
const static CGFloat fieldFloatingLabelFontSize = 11.0f;


@interface loginViewController () <UITextFieldDelegate>
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
    UIView *_inputView;
    UITextField *_accountField;
    UITextField *_passwordField;
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
    _contentView.backgroundColor = [UIColor indigoColor];

    //[UIColor colorWithRed:175/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    [self.view addSubview:_contentView];
    
//    [self backgroudImageSetting];
    [self addTextField];
    [self addButton];
    [self addLabel];
    [self addActivityIndicatorView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addTextField
{
    CGFloat topOffset = 210;
    
    UILabel *logo = [[UILabel alloc] init];
    [logo setTextColor:[UIColor lightCreamColor]];
    [logo setText:@"Analytics"];
    logo.textAlignment = NSTextAlignmentCenter;
    logo.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:50];
    CGSize sz = [logo.text sizeWithAttributes:@{NSFontAttributeName:logo.font}];
    logo.frame = CGRectMake(0, 0, sz.width, sz.height);
    logo.center = CGPointMake(self.view.center.x,100);
    
    [self.view addSubview:logo];
    
    
    _inputView = [[UIView alloc] initWithFrame:CGRectMake(0, topOffset, self.view.frame.size.width, 300)];
    _inputView.backgroundColor = [UIColor indigoColor];
    [_contentView addSubview:_inputView];
    
    _accountField = [[UITextField alloc] initWithFrame:CGRectMake(fieldHMargin, topOffset, self.view.frame.size.width - 2 * fieldHMargin, fieldHeight)];
    _accountField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Account", @"") attributes:@{NSForegroundColorAttributeName: [UIColor coolGrayColor]}];
    _accountField.font = [UIFont systemFontOfSize:fieldFontSize];
//    _accountField.text.font = [UIFont boldSystemFontOfSize:fieldFloatingLabelFontSize];
    _accountField.textColor = [UIColor whiteColor];
    _accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _accountField.delegate = self;
    [self.view addSubview:_accountField];
    
    UIView *div1 = [UIView new];
    div1.frame = CGRectMake(14, _accountField.frame.origin.y + _accountField.frame.size.height + 10,
                            self.view.frame.size.width - 2 * 14, 1.0f);
    div1.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6f];
    [self.view addSubview:div1];
    
    _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(fieldHMargin, div1.frame.origin.y + div1.frame.size.height +5, self.view.frame.size.width - 2 * fieldHMargin, fieldHeight)];
    _passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Password", @"")attributes:@{NSForegroundColorAttributeName: [UIColor coolGrayColor]}];
    _passwordField.font = [UIFont systemFontOfSize:fieldFontSize];
//    passwordField.font = [UIFont boldSystemFontOfSize:fieldFloatingLabelFontSize];
    _passwordField.textColor = [UIColor whiteColor];
    _passwordField.secureTextEntry = YES;
    _passwordField.delegate = self;
    [self.view addSubview:_passwordField];
   
    [_accountField becomeFirstResponder];
    
//    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
//    tapGr.cancelsTouchesInView = NO;
//    [self.view addGestureRecognizer:tapGr];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_accountField resignFirstResponder];

    return YES;
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
    [self.button setTitle:@" Log in " forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.button];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.f
                                                           constant:self.view.frame.size.width/12]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.5f
                                                           constant:8.f]];
    
    flatButton *dismissButton = [flatButton button];
    dismissButton.backgroundColor = [UIColor customRedColor];
    dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
    [dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
    [dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissButton];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dismissButton
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.f
                                                           constant:-self.view.frame.size.width/12]];

    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dismissButton
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.5f
                                                           constant:8.f]];

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
    self.errorLabel.font = [UIFont fontWithName:@"Avenir-Light" size:20];
    self.errorLabel.textColor = [UIColor customRedColor];
    self.errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.errorLabel.text = @"Just a serious login error.";
    self.errorLabel.textAlignment = NSTextAlignmentCenter;
    [self.view insertSubview:self.errorLabel belowSubview:_inputView];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.errorLabel
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                              toItem:_inputView
                              attribute:NSLayoutAttributeCenterX
                              multiplier:1
                              constant:0.f]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.errorLabel
                              attribute:NSLayoutAttributeCenterY
                              relatedBy:NSLayoutRelationEqual toItem:_inputView
                              attribute:NSLayoutAttributeCenterY
                              multiplier:1
                              constant:-20]];
    
    self.errorLabel.layer.transform = CATransform3DMakeScale(0.5f, 0.5f, 1.f);
    self.errorLabel.alpha = 0.0;
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
        [self shake:_passwordField];
        [self showLabel];
    });
}

#pragma mark Animations

- (void)shake:(UIView *)sender
{
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.velocity = @2000;
    positionAnimation.springBounciness = 20;
    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        sender.userInteractionEnabled = YES;
    }];
    [sender.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
}

- (void)showLabel
{
    self.errorLabel.layer.opacity = 1.0;
    POPSpringAnimation *layerScaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerScaleAnimation.springBounciness = 18;
    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    [self.errorLabel.layer pop_addAnimation:layerScaleAnimation forKey:@"labelScaleAnimation"];
    
    POPSpringAnimation *layerPositionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    layerPositionAnimation.toValue = @(_inputView.layer.position.y + 20);
    layerPositionAnimation.springBounciness = 12;
    [self.errorLabel.layer pop_addAnimation:layerPositionAnimation forKey:@"layerPositionAnimation"];
}

- (void)hideLabel
{
    POPBasicAnimation *layerScaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.5f, 0.5f)];
    [self.errorLabel.layer pop_addAnimation:layerScaleAnimation forKey:@"layerScaleAnimation"];
    
    POPBasicAnimation *layerPositionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    layerPositionAnimation.toValue = @(_inputView.layer.position.y);
    [self.errorLabel.layer pop_addAnimation:layerPositionAnimation forKey:@"layerPositionAnimation"];
    
    self.errorLabel.layer.opacity = 0.0;
}


#pragma mark barSetting
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
