//
//  networkDefine.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-20.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#ifndef snDataAnalytics_networkDefine_h
#define snDataAnalytics_networkDefine_h

#if !TARGET_IPHONE_SIMULATOR
static NSString *const serverAddress                  = @"http://sasssit.cnsuning.com:4080";
#else
static NSString *const serverAddress                  = @"http://10.27.193.34:80";
#endif

static NSString *const realTimeDataDidInitialize  = @"realTimeOutlineDataDidInitialize";
static NSString *const realTimeDetailOutlineDataDidInitialize = @"realTimeDetailOutlineDataDidInitialize";
static NSString *const realTimeDataDidChange             = @"realTimeDataDidChange";

static NSString *const visitorGroupOutlineDataDidInitialize       = @"visitorGroupOutlineDataDidInitialize";
static NSString *const visitorGroupDetailOutlineDataDidInitialize = @"visitorGroupDetailOutlineDataDidInitialize";
static NSString *const visitorGroupDetailOutlineDataDidChange = @"visitorGroupDetailOutlineDataDidChange";
static NSString *const visitorGroupDataDidChange                  = @"visitorGroupDataDidChange";

static NSString *const sourceAnalyticsOutlineDataDidInitialize       = @"sourceAnalyticsOutlineDataDidInitialize";
static NSString *const sourceAnalyticsDetailOutlineDataDidInitialize = @"sourceAnalyticsDetailOutlineDataDidInitialize";
static NSString *const sourceAnalyticsDetailOutlineDataDidChange = @"sourceAnalyticsDetailOutlineDataDidChange";

static NSString *const sourceAnalyticsDataDidChange                  = @"sourceAnalyticsDataDidChange";

static NSString *const pageAnalyticsDataDidChange                  = @"pageAnalyticsDataDidChange";
static NSString *const pageAnalyticsDetailOutlineDataDidInitialize = @"pageAnalyticsDetailOutlineDataDidInitialize";
static NSString *const pageAnalyticsOutlineDataDidInitialize       = @"pageAnalyticsOutlineDataDidInitialize";

static NSString *const hotCityDataDidChange                  = @"hotCityDataDidChange";
static NSString *const hotCityDetailOutlineDataDidInitialize = @"hotCityDetailOutlineDataDidInitialize";
static NSString *const hotCityOutlineDataDidInitialize       = @"hotCityOutlineDataDidInitialize";

static NSString *const hotPageDataDidChange                  = @"hotPageDataDidChange";
static NSString *const hotPageDetailOutlineDataDidInitialize = @"hotPageDetailOutlineDataDidInitialize";
static NSString *const hotPageOutlineDataDidInitialize       = @"hotPageOutlineDataDidInitialize";

static NSString *const transformAnalyticsDataDidChange                  = @"transformAnalyticsDataDidChange";
static NSString *const transformAnalyticsDetailOutlineDataDidInitialize = @"transformAnalyticsDetailOutlineDataDidInitialize";
static NSString *const transformAnalyticsOutlineDataDidInitialize       = @"transformAnalyticsOutlineDataDidInitialize";


static NSString *const detailOutlineDataDidChange = @"detailOutlineDataDidChange";

#endif
