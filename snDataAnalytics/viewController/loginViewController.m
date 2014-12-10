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
#import "FBShimmeringView.h"

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
    UIScrollView *_contentView;
    UIView *_inputView;
    
    UILabel *_logo;
    UITextField *_accountField;
    UITextField *_passwordField;
    
    BOOL _keyboardShowed;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _contentView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [_contentView setShowsVerticalScrollIndicator:NO];
    [_contentView setContentSize:CGSizeMake(0, self.view.bounds.size.height*2)];
    _contentView.backgroundColor = [UIColor clearColor];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.frame;
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:0x0D/255.0 green:0x2F/255.0 blue:0x94/255.0 alpha:1].CGColor,(id)[UIColor colorWithRed:0x1F/255.0 green:0xAC/255.0 blue:0xEF/255.0 alpha:1].CGColor,nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    //(id)[UIColor indigoColor].CGColor,(id)[UIColor robinEggColor].CGColor,
    //(id)[UIColor colorWithRed:0x0D/255.0 green:0x2F/255.0 blue:0x94/255.0 alpha:1].CGColor,(id)[UIColor colorWithRed:0x1F/255.0 green:0xAC/255.0 blue:0xEF/255.0 alpha:1].CGColor,
    //[UIColor colorWithRed:175/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    [self.view addSubview:_contentView];
    
    [self addTextField];
    [self addButton];
    [self addErrorLabel];
    [self addActivityIndicatorView];
    [self addObserver];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)addTextField
{
    CGFloat topOffsetRatio = 230.0/568.0;
//    NSLog(@"(110/568)*self.view.frame.size.height:%f",(110.0/568.0)*self.view.frame.size.height);
    _logo = [[UILabel alloc] init];
    [_logo setTextColor:[UIColor lightCreamColor]];
    [_logo setText:@"Analytics"];
    _logo.textAlignment = NSTextAlignmentCenter;
    _logo.font   = [UIFont fontWithName:@"HelveticaNeue-Light" size:50];
    CGSize sz    = [_logo.text sizeWithAttributes:@{NSFontAttributeName:_logo.font}];
    _logo.frame  = CGRectMake(0, 0, sz.width, sz.height);
    _logo.center = CGPointMake(self.view.center.x,(110.0/568.0)*self.view.frame.size.height);
    
    FBShimmeringView *shimmeringLogo = [[FBShimmeringView alloc] initWithFrame:_logo.frame];
    shimmeringLogo.contentView     = _logo;
    shimmeringLogo.shimmeringSpeed = 140;
    shimmeringLogo.shimmering      = YES;
    shimmeringLogo.center          = CGPointMake(self.view.center.x,(110.0/568.0)*self.view.bounds.size.height);
//    [self.view addSubview:_logo];
    [self.view addSubview:shimmeringLogo];
    
    _inputView = [[UIView alloc] initWithFrame:CGRectMake(0, topOffsetRatio*self.view.bounds.size.height, self.view.frame.size.width, 200)];
    _inputView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_inputView];
    
    _accountField = [[UITextField alloc] initWithFrame:CGRectMake(fieldHMargin, 0, self.view.frame.size.width - 2 * fieldHMargin, fieldHeight)];
    _accountField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Account", @"") attributes:@{NSForegroundColorAttributeName: [UIColor black75PercentColor]}];
    _accountField.font            = [UIFont systemFontOfSize:fieldFontSize];
    _accountField.textColor       = [UIColor whiteColor];
    _accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _accountField.delegate        = self;
    _accountField.returnKeyType   = UIReturnKeyNext;
    _accountField.keyboardType    = UIKeyboardTypeEmailAddress;
    [_inputView addSubview:_accountField];
    
    UIView *div1 = [[UIView alloc] init];
    div1.frame = CGRectMake(14, _accountField.frame.origin.y + _accountField.frame.size.height + 10,self.view.frame.size.width - 2 * 14, 1.0f);
    div1.backgroundColor = [[UIColor lightCreamColor] colorWithAlphaComponent:0.4f];
    [_inputView addSubview:div1];
    
    _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(fieldHMargin, div1.frame.origin.y + div1.frame.size.height +5, self.view.frame.size.width - 2 * fieldHMargin, fieldHeight)];
    _passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Password", @"")attributes:@{NSForegroundColorAttributeName: [UIColor black75PercentColor]}];
    _passwordField.font = [UIFont systemFontOfSize:fieldFontSize];
//    passwordField.font = [UIFont boldSystemFontOfSize:fieldFloatingLabelFontSize];
    _passwordField.textColor       = [UIColor whiteColor];
    _passwordField.secureTextEntry = YES;
    _passwordField.delegate        = self;
    _passwordField.returnKeyType   = UIReturnKeySend;
    [_inputView addSubview:_passwordField];
    
    _contentView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _accountField) {
        [_passwordField becomeFirstResponder];
    }else{
         [self.view endEditing:YES];
         [self login:nil];
    }
      return YES;
}

#pragma mark Add all the views
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
    self.button.backgroundColor = [UIColor clearColor];
    self.button.alpha = 0.7;
    self.button.translatesAutoresizingMaskIntoConstraints = NO;
    [self.button setTitle:@" Log in " forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
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
                                                         multiplier:1.7f
                                                           constant:8.f]];
    
    flatButton *dismissButton = [flatButton button];
    dismissButton.backgroundColor = [UIColor clearColor];
    dismissButton.alpha = 0.7;
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
                                                         multiplier:1.7f
                                                           constant:8.f]];

}

- (void)addErrorLabel
{
    self.errorLabel = [UILabel new];
    self.errorLabel.font = [UIFont fontWithName:@"Avenir-Light" size:20];
    self.errorLabel.textColor = [UIColor customRedColor];
    self.errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.errorLabel.text = @"Login Error";
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
                              constant:40]];
    
    self.errorLabel.layer.transform = CATransform3DMakeScale(0.5f, 0.5f, 1.f);
    self.errorLabel.alpha = 0.0;
}

- (void)addActivityIndicatorView
{
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicatorView];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark LoginControllerDelegate

- (void)dismiss
{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissLoginController)]) {
//        [self.delegate dismissLoginController];
//    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"logInSucceeded"];
    
    if (_dismissBlock) {
        _dismissBlock();
    }
    
//    UIView *snapshotView = [self.view snapshotViewAfterScreenUpdates:NO];
//    snapshotView.frame = self.view.bounds;
//    snapshotView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [self.view insertSubview:snapshotView atIndex:0];
//    
//    UIToolbar *blurView = [[UIToolbar alloc] initWithFrame:CGRectZero];
//    blurView.frame = self.view.bounds;
//    blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    blurView.barStyle = UIBarStyleBlack;
//    blurView.translucent = YES;
//    [self.view insertSubview:blurView aboveSubview:self.view];
//    
//    blurView.alpha = 0;
//    blurView.userInteractionEnabled = YES;
//    [UIView animateWithDuration:3.0 animations:^{
//        blurView.alpha = 0.9;
//    }];
}


#pragma mark Login

- (void)login:(flatButton *)button
{
    [self hideLabel];
//    [self.activityIndicatorView startAnimating];
    button.userInteractionEnabled = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURL *url1 = [NSURL URLWithString:@""];
    NSURLRequest *request1 = [[NSURLRequest alloc]initWithURL:url1 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    __block NSDictionary *json;
    
    [NSURLConnection sendAsynchronousRequest:request1 queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data) {
            json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&connectionError];
        }else{
            json = nil;
        }
        
        if (nil == json) {
            NSLog(@"json is nil");
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//               [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//               [self.activityIndicatorView stopAnimating];
                [self shake:_inputView];
                [self showLabel];
            });
            return ;
        }
        
        // print all the obtained info
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    }];
}


#pragma mark Login
- (void)handleTap:(id)sender
{
    if (sender != _accountField && sender != _passwordField) {
        [self.view endEditing:YES];
    }
}


#pragma mark Animations

- (void)shake:(UIView *)sender
{
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.velocity = @2000;
    positionAnimation.springBounciness = 20;
    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        self.button.userInteractionEnabled = YES;
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
    layerPositionAnimation.toValue = @(_inputView.layer.position.y + 30);
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

#pragma mark Keyboard Notification
- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlekeyboardShowed) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlekeyboardHided) name:UIKeyboardWillHideNotification object:nil];
}

- (void)handlekeyboardShowed
{
    [self hideLabel];
    
    if (!_keyboardShowed) {
        _keyboardShowed = YES;
        
        CGRect r = _inputView.frame;
        r.origin.y -= 80;
        CGRect r1 = _logo.frame;
        r1.origin.y -= 40;
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _inputView.frame = r;
            _logo.frame = r1;
        } completion:nil];
    }
}

- (void)handlekeyboardHided
{
    if (_keyboardShowed) {
        _keyboardShowed = NO;

        CGRect r = _inputView.frame;
        r.origin.y += 80;
        CGRect r1 = _logo.frame;
        r1.origin.y += 50;
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _inputView.frame = r;
            _logo.frame = r1;
        } completion:nil];
    }
}

#pragma mark barSetting
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
