//
//  CityDBManager.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-12-13.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityDBManager : NSObject

+ (instancetype)sharedInstance;

- (NSString *)getCityNameByID:(NSString *)ID;
- (NSString *)getIDByCityName:(NSString *)cityName;
- (NSMutableArray *)getCityArrayByIDArray:(NSArray *)IDArray;

- (void)initAllCities;
- (NSMutableArray *)getAllCities;

@end
