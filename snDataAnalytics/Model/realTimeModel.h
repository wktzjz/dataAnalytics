//
//  realTimeModel.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-17.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface realTimeModel : NSObject

@property (nonatomic) NSInteger dealMoney;
@property (nonatomic) NSInteger validDealNumber;
@property (nonatomic) NSInteger validDealTransformRatio;
@property (nonatomic) int   groupUV;
@property (nonatomic) int   validGroupUV;
@property (nonatomic) float validUVRatio;

@property (nonatomic) NSArray *groupColorArray;
@property (nonatomic) NSArray *groupPercentArray;
@property (nonatomic) NSArray *validSourceUVColorArray;
@property (nonatomic) NSArray *validSourceUVPercentArray;

@property (nonatomic) NSMutableArray *arrayOfValues;
@property (nonatomic) NSMutableArray *arrayOfDates;

@property (nonatomic) NSDictionary *initializeData;
@property (nonatomic) NSDictionary *sendDict;

@property (nonatomic,readonly) BOOL initializeDataReady;

+ (instancetype)sharedInstance;

- (void)getInitializedRealTimeDeatilsData;
- (void)getNewData;

@end
