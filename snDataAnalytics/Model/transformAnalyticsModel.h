//
//  transformAnalyticsModel.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-12-3.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

@interface transformAnalyticsModel : NSObject

@property (nonatomic) NSDictionary *defineDetails;
@property (nonatomic) NSDictionary *outlineData;
@property (nonatomic) NSDictionary *detailInitializeData;
@property (nonatomic) NSDictionary *detailsData;

@property (nonatomic,readonly) BOOL initializeDataReady;
@property (nonatomic,readonly) BOOL detailsDataReady;

+ (instancetype)sharedInstance;

- (void)getOutlineData;

- (void)createDetailOutlineData;
- (NSDictionary *)getDetailOutlineData;

- (void)createDefineDetails;
-(NSDictionary *)getDefineDetails;

- (void)createDetailsData;
- (NSDictionary *)getDetailsData;

@end
