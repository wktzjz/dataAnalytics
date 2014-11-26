//
//  sourcesAnalytics.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-11-17.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//


@interface sourcesAnalyticsModel : NSObject

@property (nonatomic) NSDictionary *defineDetails;
@property (nonatomic) NSDictionary *outlineData;
@property (nonatomic) NSDictionary *detailInitializeData;
@property (nonatomic) NSDictionary *detailsData;

@property (nonatomic,readonly) BOOL initializeDataReady;
@property (nonatomic,readonly) BOOL detailsDataReady;

+ (instancetype)sharedInstance;
- (void)getOutlineData;

- (NSDictionary *)getDetailInitializeData;
- (void)createDetailInitializeData;

- (void)initDefineDetails;
-(NSDictionary *)getDefineDetails;

- (void)initDetailsData;
- (NSDictionary *)getDetailsData;

@end
