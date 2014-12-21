//
//  authenticationViewController.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-12-8.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "authenticationViewController.h"
#import "defines.h"
#import "Colours.h"
#import "FBShimmeringView.h"
#import "FlatButton.h"

#import <LocalAuthentication/LocalAuthentication.h>
#import <Security/Security.h>


@interface authenticationViewController ()

@end

@implementation authenticationViewController
{
    UILabel *_logo;
    UIScrollView *_contentView;

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
    self.view.backgroundColor = [UIColor clearColor];
    
//    _contentView = [[UIScrollView alloc] initWithFrame:self.view.frame];
//    [_contentView setShowsVerticalScrollIndicator:NO];
//    [_contentView setContentSize:CGSizeMake(0, self.view.bounds.size.height*2)];
//    _contentView.backgroundColor = [UIColor clearColor];
//    
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = self.view.frame;
//    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:0x0D/255.0 green:0x2F/255.0 blue:0x94/255.0 alpha:1].CGColor,(id)[UIColor colorWithRed:0x1F/255.0 green:0xAC/255.0 blue:0xEF/255.0 alpha:1].CGColor,nil];
//    [self.view.layer insertSublayer:gradient atIndex:0];
//    [self.view addSubview:_contentView];
    
//    UIView *blurView;
//    
//    if ([self isIOS8]) {
//        UIVisualEffect *effect;
//        effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//        blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    }else{
//        blurView = [[UIToolbar alloc] initWithFrame:CGRectZero];
//        blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        ((UIToolbar *)blurView).barStyle = UIBarStyleBlack;
//        ((UIToolbar *)blurView).translucent = YES;
//    }
//
//    blurView.frame = wkScreen;
//    [self.view addSubview:blurView];
    
    [self initAuthenticationSettings];

//    [self addLogo];
    [self addButton];
   
    if ([self isIOS8]) {
        [self fingerAuthentication];
    }else{
        [self passwordAuthentication];
    }

}

- (void)addLogo
{
    _logo = [[UILabel alloc] init];
    [_logo setTextColor:[UIColor lightCreamColor]];
    [_logo setText:@"验证身份"];
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
}

- (void)addButton
{
    flatButton *button = [flatButton button];
    button.backgroundColor = [UIColor clearColor];
    button.alpha = 0.7;
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:@"指纹验证" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(fingerAuthentication) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.1f
                                                           constant:0]];
    

}

- (void)initAuthenticationSettings
{
    CFErrorRef error = NULL;
    SecAccessControlRef sacObject;
    sacObject = SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                                kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
                                                kSecAccessControlUserPresence, &error);
    if(sacObject == NULL || error != NULL)
    {
        NSLog(@"can't create sacObject: %@", error);
        //        self.textView.text = [_textView.text stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"SEC_ITEM_ADD_CAN_CREATE_OBJECT", nil), error]];
        return;
    }
    
    NSDictionary *attributes = @{
                                 (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                                 (__bridge id)kSecAttrService: @"SampleService",
                                 (__bridge id)kSecValueData: [@"SECRET_PASSWORD_TEXT" dataUsingEncoding:NSUTF8StringEncoding],
                                 (__bridge id)kSecUseNoAuthenticationUI: @YES,
                                 (__bridge id)kSecAttrAccessControl: (__bridge id)sacObject
                                 };
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        OSStatus status =  SecItemAdd((__bridge CFDictionaryRef)attributes, nil);
        
        NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"SEC_ITEM_ADD_STATUS", nil), [self keychainErrorToString:status]];
        //        [self printResult:self.textView message:msg];
    });

}

- (void)fingerAuthentication
{
    LAContext *myContext = [[LAContext alloc] init];
    NSError   *authError = nil;
    NSString  *myLocalizedReasonString = @"需要验证使用者";

    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]){
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply:^(BOOL succes, NSError *error){
             if (succes) {
                 NSLog(@"yes");
                 if (_dismissBlock) {
                     _dismissBlock();
                 }
             }else{
                 switch (error.code) {
                     case kLAErrorUserFallback:{
                         
                         double delayInSeconds = 0.1;
                         dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                         
                         __weak typeof(self) weakself = self;
                         dispatch_after(popTime, dispatch_get_main_queue(), ^{
                             typeof(weakself) strongSelf = weakself;

                         [strongSelf passwordAuthentication];
                         });
                         break;
                     }
                     case kLAErrorAuthenticationFailed:
                         //指纹错误两次以后，执行此情况
                         break;
                     default:
                         break;
                 }
//                 NSString *str = [NSString stringWithFormat:@"%@",error.localizedDescription];
//
//                 if ([str isEqualToString:@"Fallback authentication mechanism selected."]) {
//                    [self passwordAuthentication];
//
//                 }
//                 else
//                 {
////                     [self tapkey];
//                 }
                 
                 
//                 switch (error.code) {
//                     case LAErrorUserCancel:
////                         alert.message = @"Authentication Cancelled";
//                         break;
//                         
//                     case LAErrorAuthenticationFailed:
////                         alert.message = @"Authentication Failed";
//                         break;
//                         
//                     case LAErrorPasscodeNotSet:
////                         alert.message = @"Passcode is not set";
//                         break;
//                         
//                     case LAErrorSystemCancel:
////                         alert.message = @"System cancelled authentication";
//                         break;
//                         
//                     case LAErrorUserFallback:
////                         alert.message = @"You chosed to try password";
//                         [self tapkey];
//                         break;
//                         
//                     default:
////                         alert.message = @"You cannot access to private content!";
//                         break;
//                 }
             }
         }];
        
    }
    else
    {
        NSLog(@"没有开启TOUCHID设备");
    }
    
}

-(void)delete
{
    NSDictionary *query = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService: @"SampleService"
                            };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        OSStatus status = SecItemDelete((__bridge CFDictionaryRef)(query));
        
        NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"SEC_ITEM_DELETE_STATUS", nil), [self keychainErrorToString:status]];
//        [self printResult:self.textView message:msg];
//        self.strBeDelete = [NSString stringWithFormat:@"%@",msg];
    });
}

-(void)passwordAuthentication
{
    NSDictionary *query = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService: @"SampleService",
                            (__bridge id)kSecUseOperationPrompt: @"用您本机密码验证登陆"
                            };
    
    NSDictionary *changes = @{(__bridge id)kSecValueData: [@"UPDATED_SECRET_PASSWORD_TEXT" dataUsingEncoding:NSUTF8StringEncoding]
                              };
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)changes);
//        NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"SEC_ITEM_UPDATE_STATUS", nil), [self keychainErrorToString:status]];
//        [self printResult:self.textView message:msg];
        if (status == -26276) {//cancel
            NSLog(@"-26276");
            [self fingerAuthentication];
        }
        else if (status == 0){
            NSLog(@"验证成功之后");
            if (_dismissBlock) {
                _dismissBlock();
            }
        }
        else if (status == -25293){
            NSLog(@"-25293");

//            [self fingerAuthentication];
        }
        NSLog(@"------（%d）",(int)status);
    });
}

- (NSString *)keychainErrorToString: (NSInteger)error
{
    
    NSString *msg = [NSString stringWithFormat:@"%ld",(long)error];
    
    switch (error) {
        case errSecSuccess:
            msg = NSLocalizedString(@"SUCCESS", nil);
            break;
        case errSecDuplicateItem:
            msg = NSLocalizedString(@"ERROR_ITEM_ALREADY_EXISTS", nil);
            break;
        case errSecItemNotFound :
            msg = NSLocalizedString(@"ERROR_ITEM_NOT_FOUND", nil);
            break;
        case -26276:
            msg = NSLocalizedString(@"ERROR_ITEM_AUTHENTICATION_FAILED", nil);
            
        default:
            break;
    }
    
    return msg;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)isIOS8
{
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"8.0" options: NSNumericSearch];
    if (order == NSOrderedSame || order == NSOrderedDescending) {
        // OS version >= 8.0
        return YES;
    }
    return NO;
}

- (CGSize)preferredContentSize
{
    return CGSizeMake(280, 160);

}


@end
