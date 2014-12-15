//
//  DBManager.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-12-13.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseAdditions.h"

#define DATABASENAME @"city.sqlite"

@implementation DBManager
{
    FMDatabase *_db;
}

+ (instancetype)sharedInstance
{
    static DBManager *sharedInstance = nil;
    
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
    FMResultSet *resultSet=[_db executeQuery:@"SELECT * FROM city"];
    NSString *tempName;
    NSString *tempNumber;
    NSString *cityName;
    
    while ([resultSet next]) {
        tempName = [resultSet stringForColumn:@"city_name"];
        tempNumber = [resultSet stringForColumn:@"city_id"];

        if([tempNumber isEqualToString:ID]){
            cityName = tempName;
        }
    }
    
    NSLog(@"cityname:%@",cityName);
    return cityName;
}

- (NSMutableArray *)getCityArrayByIDArray:(NSArray *)IDArray
{
    FMResultSet *resultSet=[_db executeQuery:@"SELECT * FROM city"];
    NSString *tempName;
    NSString *tempNumber;
    NSMutableArray *cityNameArray = [[NSMutableArray alloc] initWithCapacity:20];
    
    while ([resultSet next]) {
        tempName = [resultSet stringForColumn:@"city_name"];
        tempNumber = [resultSet stringForColumn:@"city_id"];
        
        [IDArray enumerateObjectsUsingBlock:^(NSString *ID, NSUInteger idx, BOOL *stop) {
            if([tempNumber isEqualToString:ID]){
                NSLog(@"cityname:%@",tempName);
                [cityNameArray addObject:tempName];
            }
        }];
    }
    
    return cityNameArray;
}


- (NSString *)getIDByCityName:(NSString *)cityName
{
    FMResultSet *resultSet=[_db executeQuery:@"SELECT * FROM city"];
    NSString *tempName;
    NSString *tempNumber;
    NSString *ID;
    
    while ([resultSet next]) {
        tempName = [resultSet stringForColumn:@"city_name"];
        tempNumber = [resultSet stringForColumn:@"city_id"];
        
        if([tempName isEqualToString:cityName]){
            ID = tempNumber;
        }
    }
    
    NSLog(@"cityID:%@",ID);
    return ID;
}

@end
