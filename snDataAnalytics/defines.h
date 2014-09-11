//
//  defines.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-1.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#ifndef snDataAnalytics_defines_h
#define snDataAnalytics_defines_h

#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

#define __IPHONE_OS_VERSION_SOFT_MAX_REQUIRED __IPHONE_7_0

//Location Info
#define  WKLastTitle    @"WKLastTitle"
#define  WKLastUrl      @"WKLastUrl"
#define  WKLastImgUrl   @"WKLastImgUrl"

#define ENABLE_LOGGING_DEBUG 1

#if ENABLE_LOGGING_DEBUG
#define PSLog NSLog
#else
#define PSLog(...)
#endif

#define wkScreen [[UIScreen mainScreen] bounds]
#define wkScreenWidth  ([UIScreen mainScreen].bounds.size.width)
#define wkScreenHeight CGRectGetHeight(wkScreen)
#define navigationBarHeight 44.0

#define frontViewRemainHeight       100
#define backgroundInitialScale      0.93
#define blackViewMaximumAlpha       1.0
#define mainDataScrollViewMargin    20.0
#define mainViewPullSuccessedRatio  0.2

#define outlineViewWidth  280
#define outlineViewHeight 240
#define outleineContainerViewWidth  (wkScreenWidth - mainDataScrollViewMargin * 2);
#define dataViewHeightWidthRatio (240/280)
#define detailViewHeight (wkScreenWidth * 240/280)
#define detailViewUpMargin 50.0

#endif
