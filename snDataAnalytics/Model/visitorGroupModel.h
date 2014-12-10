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

@property (nonatomic) NSMutableArray *arrayOfDates;
@property (nonatomic) NSDictionary *outlineData;
@property (nonatomic) NSDictionary *detailInitializeData;
@property (nonatomic) NSMutableDictionary *detailsData;
@property (nonatomic) NSDictionary *sendDict;

@property (nonatomic) NSDictionary *defineDetails;

@property (nonatomic,readonly) BOOL initializeDataReady;
@property (nonatomic,readonly) BOOL detailsDataReady;

+ (instancetype)sharedInstance;
- (void)getOutlineData;

- (NSDictionary *)getDetailOutlineData;
- (void)createDetailOutlineData;

- (void)createDefineDetails;
-(NSDictionary *)getDefineDetails;

- (void)createDetailsData;
- (NSDictionary *)getDetailsData;

- (void)getDataFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

@end
