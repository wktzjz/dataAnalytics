//
//  authenticationManager.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-12-9.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "authenticationManager.h"
#import "defines.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <Security/Security.h>

@implementation authenticationManager

+ (instancetype)sharedInstance
{
    static authenticationManager *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] _init];
    });
    
    return sharedInstance;
}

- (instancetype)_init
{
    self = [super init];
    
    if (self) {
        [self initAuthenticationSettings];
    }
    
    return self;
}

- (void)startAuthentication
{
    if ([self isIOS8] && wkScreenHeight > 568) {
        [self fingerAuthentication];
    }else{
        [self passwordAuthentication];
    }
    
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
     _isAuthenticationg = YES;
    
    LAContext *myContext = [[LAContext alloc] init];
    NSError   *authError = nil;
    NSString  *myLocalizedReasonString = @"需要验证使用者";
    
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]){
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply:^(BOOL succes, NSError *error){
                                if (succes) {
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


- (void)delete
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

- (void)passwordAuthentication
{
     _isAuthenticationg = YES;
    
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
//            NSLog(@"-26276");
            [self fingerAuthentication];
        }
        else if (status == 0){
//            NSLog(@"验证成功之后");
            if (_dismissBlock) {
                _dismissBlock();
            }
        }
        else if (status == -25293){
//            NSLog(@"-25293");
            
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


- (BOOL)isIOS8
{
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"8.0" options: NSNumericSearch];
    if (order == NSOrderedSame || order == NSOrderedDescending) {
        // OS version >= 8.0
        return YES;
    }
    return NO;
}

@end
