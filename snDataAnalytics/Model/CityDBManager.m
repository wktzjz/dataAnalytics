//
//  CityDBManager.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-12-13.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "CityDBManager.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseAdditions.h"

#define DATABASENAME @"city.sqlite"

@implementation CityDBManager
{
    FMDatabase *_db;
    NSMutableArray *_allCities;
}

+ (instancetype)sharedInstance
{
    static CityDBManager *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] _init];
    });
    
    return sharedInstance;
}

- (instancetype)_init
{
    self = [super init];
    if (self) {
        
        [self openDataBase:@"cityname.sqlite"];
    }
    return self;
}

- (void)openDataBase:(NSString *)dataBaseName
{
    //寻找路径
    NSString *doc_path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    //数据库路径
    NSString *sqlPath = [doc_path stringByAppendingPathComponent:@"city.sqlite"];
    //原始路径
    NSString *orignFilePath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"sqlite"];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if([fm fileExistsAtPath:sqlPath] == NO){
        NSError *err = nil;
        
        if([fm copyItemAtPath:orignFilePath toPath:sqlPath error:&err] == NO){
            NSLog(@"open database error %@",[err localizedDescription]);
        }
    }

    _db =[FMDatabase databaseWithPath:sqlPath];
    if (![_db open]) {
        NSLog(@"Init DB failed");
    }

}


- (NSString *)getCityNameByID:(NSString *)ID
{
    NSString *cityName;
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * from city where city_id = '%@'", ID];
    
    FMResultSet *resultSet=[_db executeQuery:sqlString];
    while ([resultSet next]) {
        cityName = [resultSet stringForColumn:@"city_name"];
    }
    
    NSLog(@"cityname:%@",cityName);
    return cityName;
}


- (NSMutableArray *)getCityArrayByIDArray:(NSArray *)IDArray
{
    __block NSString *tempName;
    NSMutableArray *cityNameArray = [[NSMutableArray alloc] initWithCapacity:20];
    
    @autoreleasepool{
            [IDArray enumerateObjectsUsingBlock:^(NSString *ID, NSUInteger idx, BOOL *stop) {
    
                NSString *sqlString = [NSString stringWithFormat:@"SELECT * from city where city_id = '%@'", ID];
                FMResultSet *resultSet=[_db executeQuery:sqlString];
                while ([resultSet next]) {
                        tempName = [resultSet stringForColumn:@"city_name"];
//                        NSLog(@"cityname:%@",tempName);
                        [cityNameArray addObject:tempName];
                }
            }];

    }
    
    return cityNameArray;
}


- (NSMutableArray *)getAllCities
{
    if(_allCities){
        return _allCities;
    }else{
        [self initAllCities];
        return _allCities;
    }
}

- (void)initAllCities
{
    FMResultSet *resultSet=[_db executeQuery:@"SELECT * FROM city"];
    _allCities = [[NSMutableArray alloc] initWithCapacity:350];
    
    while ([resultSet next]) {
        [_allCities addObject:[resultSet stringForColumn:@"city_name"]];
    }
}


- (NSString *)getIDByCityName:(NSString *)cityName
{
    NSString *ID;
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * from city where city_name = '%@'", cityName];
    
    FMResultSet *resultSet=[_db executeQuery:sqlString];
    while ([resultSet next]) {
        ID = [resultSet stringForColumn:@"city_name"];
    }
    
    NSLog(@"ID:%@",ID);
    return ID;
}

@end
