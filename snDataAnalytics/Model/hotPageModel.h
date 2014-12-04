//
//  hotPageModel.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-12-4.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hotPageModel : NSObject

@property (nonatomic) NSDictionary *defineDetails;
@property (nonatomic) NSDictionary *outlineData;
@property (nonatomic) NSDictionary *detailInitializeData;
@property (nonatomic) NSDictionary *detailsData;

@property (nonatomic,readonly) BOOL initializeDataReady;
@property (nonatomic,readonly) BOOL detailsDataReady;

+ (instancetype)sharedInstance;

- (void)getOutlineData;

@end
