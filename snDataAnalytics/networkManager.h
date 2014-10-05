//
//  networkManager.h
//  shudu
//
//  Created by Stan on 14-6-30.
//  Copyright (c) 2014年 Stan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol networkDelegate <NSObject>
@required
- (BOOL)handleInfoFromNetwork:(NSDictionary *)info;
@end


typedef void(^failureBlock)();

@interface networkManager : NSObject

@property (nonatomic, weak) id <networkDelegate> delegate;
@property (nonatomic, copy) failureBlock failureBlock;

+ (instancetype)sharedInstance;

- (void)obtainWeaterInfoLocationBased;

- (BOOL)getNetworkInfo:(NSString *)URLString;

- (void)sendAsynchronousRequestWithURL:(NSString *)urlString failureBlock:(void (^)())failBlock successedBlock:(void (^)())succeedBlock;
@end


