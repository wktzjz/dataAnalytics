//
//  visitorGroupData.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-21.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface visitorGroupModel : NSObject

@property (nonatomic) int groupUV;
@property (nonatomic) int validGroupUV;
@property (nonatomic) int visitor;

@property (nonatomic, strong) NSMutableArray *arrayOfDates;
@property (nonatomic, strong) NSMutableDictionary *outlineData;
@property (nonatomic, strong) NSDictionary *detailInitializeData;
@property (nonatomic, strong) NSMutableDictionary *detailsData;
@property (nonatomic, strong) NSDictionary *sendDict;

@property (nonatomic, strong) NSDictionary *defineDetails;

@property (nonatomic, readonly) BOOL initializeDataReady;
@property (nonatomic, readonly) BOOL detailsDataReady;

@property (nonatomic, strong) NSArray *detailsDataMethodsArray;
@property (nonatomic, strong) NSMutableArray *dimensionDataAvailableArray;

@property (nonatomic, strong) NSString *fromDate;
@property (nonatomic, strong) NSString *toDate;

+ (instancetype)sharedInstance;
- (void)getOutlineData;

- (void)createDetailOutlineData;
- (NSDictionary *)getDetailOutlineData;

- (void)createDefineDetails;
-(NSDictionary *)getDefineDetails;

- (void)createDetailsData;
- (NSDictionary *)getDetailsData;

- (void)setAllDetailsDataNeedReload;

- (void)getVisitorTypeDetailsData:(void (^)(NSDictionary *data))succeedBlock;
//- (void)getTerminalTypeDetailsData:(void (^)(NSDictionary *data))succeedBlock;
//- (void)getAllMemberDetailsData:(void (^)(NSDictionary *data))succeedBlock;
//- (void)getNewMemberDetailsData:(void (^)(NSDictionary *data))succeedBlock;
//- (void)getOldMemberDetailsData:(void (^)(NSDictionary *data))succeedBlock;
//- (void)getMemberGradeDetailsData:(void (^)(NSDictionary *data))succeedBlock;
//- (void)getMemberCityDetailsData:(void (^)(NSDictionary *data))succeedBlock;

@end
