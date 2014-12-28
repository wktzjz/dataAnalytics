//
//  sourcesAnalytics.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-11-17.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//


@interface sourcesAnalyticsModel : NSObject

@property (nonatomic,strong) NSDictionary *defineDetails;
@property (nonatomic,strong) NSDictionary *outlineData;
@property (nonatomic,strong) NSDictionary *detailInitializeData;
@property (nonatomic,strong) NSMutableDictionary *detailsData;

@property (nonatomic,readonly) BOOL initializeDataReady;
@property (nonatomic,readonly) BOOL detailsDataReady;

@property (nonatomic,strong) NSArray *detailsDataMethodsArray;
@property (nonatomic,strong) NSMutableArray *dimensionDataAvailableArray;

@property (nonatomic, strong) NSString *fromDate;
@property (nonatomic, strong) NSString *toDate;

+ (instancetype)sharedInstance;

- (void)getOutlineData;

- (void)createDetailOutlineData:(void(^)())succeedBlock;
- (NSDictionary *)getDetailOutlineData;
- (void)reloadDetailOutlineFromDate:(NSString *)fromDate toDate:(NSString *)toDate;

- (void)createDefineDetails;
-(NSDictionary *)getDefineDetails;

- (void)createDetailsData;
- (NSDictionary *)getDetailsData;

- (void)getDisplayAdvertisingDetailsData:(void (^)(NSDictionary *data))succeedBlock;

- (void)setAllDetailsDataNeedReload;

@end
