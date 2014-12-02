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
@property (nonatomic) int   visit;

@property (nonatomic,strong) NSArray *groupColorArray;
@property (nonatomic,strong) NSMutableArray *groupPercentArray;
@property (nonatomic,strong) NSArray *validSourceUVColorArray;
@property (nonatomic,strong) NSMutableArray *groupValidPercentArray;
@property (nonatomic,strong) NSMutableArray *cityNameArray;
@property (nonatomic,strong) NSMutableArray *cityValueArray;
@property (nonatomic,strong) NSMutableArray *pagesNameArray;
@property (nonatomic,strong) NSMutableArray *pagesValueArray;

@property (nonatomic,strong) NSMutableArray *arrayOfValues;
@property (nonatomic,strong) NSMutableArray *arrayOfDates;


//use the folling methods
@property (nonatomic,strong) NSDictionary *initializeData;
@property (nonatomic,strong) NSDictionary *sendDict;
@property (nonatomic,readonly) BOOL initializeDataReady;

+ (instancetype)sharedInstance;

- (void)getOutlineData;

//the Timer will automaticlly getNewData every 10s,and send async notifications to update;
- (void)getNewData;

@end
