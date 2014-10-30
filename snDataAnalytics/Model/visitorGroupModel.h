//
//  visitorGroupData.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-21.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface visitorGroupModel : NSObject

@property (nonatomic) NSDictionary *initializeData;
@property (nonatomic) NSDictionary *sendDict;

@property (nonatomic,readonly) BOOL initializeDataReady;

+ (instancetype)sharedInstance;
- (void)getNewData;
@end
