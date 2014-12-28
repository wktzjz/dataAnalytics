//
//  pageAnalyticsModel.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-12-2.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

@interface pageAnalyticsModel : NSObject

@property (nonatomic) NSDictionary *defineDetails;
@property (nonatomic) NSDictionary *outlineData;
@property (nonatomic) NSDictionary *detailInitializeData;
@property (nonatomic) NSMutableDictionary *detailsData;

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

- (void)getPageTypeDetailsData:(void (^)(NSDictionary *data))succeedBlock;

- (void)setAllDetailsDataNeedReload;

@end
