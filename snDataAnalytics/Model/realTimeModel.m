//
//  realTimeModel.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-17.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "realTimeModel.h"
#import "Colours.h"
#import "PNColor.h"
#import "networkManager.h"
#import "defines.h"
#import "networkDefine.h"
#import "CityDBManager.h"

static NSInteger const timeInterval = 10.0f;


@implementation realTimeModel
{
    __weak id    _wself;
    NSTimer      *_timer;
}

#pragma mark - sharedInstance

+ (instancetype)sharedInstance
{
    static realTimeModel *sharedInstance = nil;
    
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
        _wself = self;
        _initializeDataReady = NO;
        
        [self getOutlineData];
    }
    return self;
}


#pragma mark - getInitializedRealTimeDeatilsData

- (void)getOutlineData
{
    void (^successefullyBlock)(NSDictionary *) = ^(NSDictionary *data) {
        
        @autoreleasepool{
            _groupUV      = arc4random() % 20000;
            _validUVRatio = ((arc4random() % 500) + 500) / 1000.0;
            _validGroupUV = _groupUV * _validUVRatio;
            _visit        = arc4random() % 100000;

            _dealMoney               = arc4random() % 20000;
            _validDealNumber         = (arc4random() % 1000);
            _validDealTransformRatio = ((arc4random() % 1000)/1000.0) * 100;
            
            _sourceVisitArray      = [[NSMutableArray alloc] initWithArray:@[@(arc4random() % 100),
                                                                              @(arc4random() % 100),
                                                                              @(arc4random() % 100),
                                                                              @(arc4random() % 100),
                                                                              @(arc4random() % 100),
                                                                              @(arc4random() % 100)]];
            
            _sourceValidUVArray = [[NSMutableArray alloc] initWithArray:@[@(arc4random() % 20),
                                                                              @(arc4random() % 20),
                                                                              @(arc4random() % 20),
                                                                              @(arc4random() % 20),
                                                                              @(arc4random() % 20),
                                                                              @(arc4random() % 20)]];
            
            _cityValueArray         = [[NSMutableArray alloc] initWithArray:@[@(arc4random() % 100),
                                                                              @(arc4random() % 100),
                                                                              @(arc4random() % 100),
                                                                              @(arc4random() % 100),
                                                                              @(arc4random() % 100)]];
            
            _pagesValueArray        = [[NSMutableArray alloc] initWithArray:@[@(arc4random() % 100),
                                                                              @(arc4random() % 100),
                                                                              @(arc4random() % 100),
                                                                              @(arc4random() % 100),
                                                                              @(arc4random() % 100)]];
            
            _cityNameArray          =  [[NSMutableArray alloc] initWithArray:@[@"北京",@"上海",@"广州",@"深圳",@"南京"]];
            _pagesNameArray         =  [[NSMutableArray alloc] initWithArray:@[@"页面1",@"页面2",@"页面3",@"页面4",@"页面5"]];

            
            _groupColorArray = @[PNLightGreen,PNFreshGreen,PNDeepGreen,PNRed,PNTitleColor,PNYellow,PNBrown];
            _validSourceUVColorArray = @[[UIColor robinEggColor],[UIColor pastelBlueColor],[UIColor turquoiseColor],[UIColor steelBlueColor],[UIColor denimColor],[UIColor emeraldColor],[UIColor cardTableColor]];
            
            _arrayOfValues = [[NSMutableArray alloc] init];
            _arrayOfDates  = [[NSMutableArray alloc] init];
            _sendDict      = [[NSDictionary alloc] init];
            
            realTimeModel *strongSelf = _wself;

            for (int i = 0; i <19; i++) {
                [_arrayOfDates addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:i]]];
                
                [_arrayOfValues addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
            }
            
            NSMutableArray *parallelArray = [[NSMutableArray alloc] initWithCapacity:8];
            for(int i = 0; i < 8; i++){
                [parallelArray addObject:[[NSMutableArray alloc] init]];
            }
        
            dispatch_apply(8, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
                [strongSelf addNumberToArray:parallelArray[index]];
            });
            
            if (data) {
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
                NSLog(@"jsonData %@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
                
                _initializeData = [strongSelf handleData:data];
            }else{
                _initializeData = @{
                                    @"groupUV":@(_groupUV),
                                    @"validUVRatio":@(_validUVRatio),
                                    @"validGroupUV":@(_validGroupUV),
                                    @"VISIT":@(_visit),
                                    @"newVISITRatio":@(((arc4random() % 400) + 600) / 1000.0 ),
                                    @"newUVRatio":@(((arc4random() % 400) + 600) / 1000.0 ),
                                    @"newVaildUVRatio":@(((arc4random() % 400) + 600) / 1000.0 ),
                                    @"dealMoney":@(_dealMoney),
                                    @"validDealNumber":@(_validDealNumber),
                                    @"validDealTransformRatio":@(_validDealTransformRatio),
                                    @"sourceVisitArray":_sourceVisitArray,
                                    @"sourceValidUVArray":_sourceValidUVArray,
                                    @"cityNameArray":_cityNameArray,
                                    @"cityValueArray":_cityValueArray,
                                    @"pagesNameArray":_pagesNameArray,
                                    @"pagesValueArray":_pagesValueArray,
                                    @"arrayOfValues":_arrayOfValues,
                                    @"arrayOfDates":_arrayOfDates,
                                    @"UV_arrayOfValues":parallelArray[0],
                                    @"PV_arrayOfValues":parallelArray[1],
                                    @"VISIT_arrayOfValues":parallelArray[2],
                                    @"新UV_arrayOfValues":parallelArray[3],
                                    @"有效UV_arrayOfValues":parallelArray[4],
                                    @"付款金额_arrayOfValues":parallelArray[5],
                                    @"有效订单数_arrayOfValues":parallelArray[6],
                                    @"有效订单转化率_arrayOfValues":parallelArray[7],
                                    @"UV_number":@(arc4random() % 20000),
                                    @"PV_number":@(arc4random() % 20000),
                                    @"VISIT_number":@(arc4random() % 20000),
                                    @"新UV_number":@(arc4random() % 10000),
                                    @"有效UV_number":@(arc4random() % 2000),
                                    @"付款金额_number":@(arc4random() % 20000),
                                    @"有效订单数_number":@(arc4random() % 200),
                                    @"有效订单转化率_number":@(arc4random() % 100)
                                    };

            }
            
            _initializeDataReady = YES;
            
    //        dispatch_async(dispatch_get_main_queue(),^{
    //            [[NSNotificationCenter defaultCenter] postNotificationName:dataDidInitialize object:strongSelf userInfo:_initializeData];
    //        });
            
            NSNotification *notification = [[NSNotification alloc] initWithName:realTimeDataDidInitialize object:strongSelf userInfo:_initializeData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                           postingStyle:NSPostASAP
                                                           coalesceMask:NSNotificationCoalescingOnName forModes:@[NSDefaultRunLoopMode]];
            });


            //            if (![NSThread isMainThread]) {
            //                NSLog(@"not in mainThread");
            //            }
            //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:strongSelf selector:@selector(getNewData) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] run];
        }
        //            });
        //             [NSThread detachNewThreadSelector:@selector(startTimer) toTarget:self withObject:nil];
        
    };
    
    //http://10.27.193.34:80/snf-mbbi-web/mbbi/getRealTimeData.htm
     NSString *url = [[NSString alloc] initWithFormat:@"%@/snf-mbbi-web/mbbi/getRealTimeData.htm",serverAddress];
    
    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:url failureBlock:successefullyBlock successedBlock:successefullyBlock];
}

- (NSDictionary *)handleData:(NSDictionary *)data
{
    NSString *newVISITRatio;
    NSString *newUVRatio;
    NSString *newVaildUVRatio;
    if([((NSArray *)data[@"groupTypeArray"])[0] isEqualToString:@"0"]){
        newVISITRatio = ((NSArray *)data[@"groupVisitPercentArray"])[1];
        newUVRatio = ((NSArray *)data[@"groupPercentArray"])[1];
        newVaildUVRatio = ((NSArray *)data[@"groupValidPercentArray"])[1];
    }else{
        newVISITRatio = ((NSArray *)data[@"groupVisitPercentArray"])[0];
        newUVRatio = ((NSArray *)data[@"groupPercentArray"])[0];
        newVaildUVRatio = ((NSArray *)data[@"groupValidPercentArray"])[0];
    }
    
    NSArray *originalDealValues = data[@"arrayOfValues"];
    NSMutableArray *modifedDealValues = [[NSMutableArray alloc] initWithCapacity:19];
    __block float lastValue;
    [originalDealValues enumerateObjectsUsingBlock:^(NSString *value, NSUInteger idx, BOOL *stop) {
        if (idx != 0){
            float ratio = (value.floatValue - lastValue) * 1000 / lastValue;
            [modifedDealValues addObject:@(ratio)];
            lastValue = value.floatValue;
        }else{
            lastValue = value.floatValue;
        }
    }];
    
    NSArray *sourceVisitOriginalArray = (NSArray *)data[@"sourceVisitArray"];
    NSMutableArray *sourceVisitModifiedArray = [[NSMutableArray alloc] initWithCapacity:6];
    
    [(NSArray *)data[@"sourceVisitTypeArray"] enumerateObjectsUsingBlock:^(NSString *type, NSUInteger idx, BOOL *stop) {
        switch(type.integerValue){
            case 10:
                //"硬广"
                sourceVisitModifiedArray[0] = sourceVisitOriginalArray[idx];
                break;
            case 20:
                //"导航";
                sourceVisitModifiedArray[1] = sourceVisitOriginalArray[idx];
                break;
            case 30:
                //"搜索";
                sourceVisitModifiedArray[2] = sourceVisitOriginalArray[idx];
                break;
            case 40:
                //@"广告联盟";
                sourceVisitModifiedArray[3] = sourceVisitOriginalArray[idx];
                break;
            case 50:
                //"流量";
                sourceVisitModifiedArray[4] = sourceVisitOriginalArray[idx];
                break;
            case 60:
                //"EDM";
                sourceVisitModifiedArray[5] = sourceVisitOriginalArray[idx];
                break;
            default:
                //"硬广";
                break;
        }
    }];
    
    NSArray *cityArray = [[NSArray alloc] initWithArray:[[CityDBManager sharedInstance] getCityArrayByIDArray:data[@"cityNameArray"]]];
    
    NSArray *originalPageArray = data[@"pagesNameArray"];
    __block NSMutableString *string;
    NSMutableArray *modifedPageArray = [[NSMutableArray alloc] initWithCapacity:5];
    [originalPageArray enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
        string = [[NSMutableString alloc] initWithString:name];
        [string insertString:@"\n" atIndex:name.length/2];
        [modifedPageArray addObject:string];
    }];
    
    return @{
            @"groupUV":data[@"groupUV"],
            @"validGroupUV":data[@"validGroupUV"],
            @"VISIT":data[@"visit"],
            @"newVISITRatio":newVISITRatio,
            @"newUVRatio":newUVRatio,
            @"newVaildUVRatio":newVaildUVRatio,
            @"dealMoney":data[@"dealMoney"],
            @"validDealNumber":data[@"validDealNumber"],
            @"validDealTransformRatio":data[@"validDealTransformRatio"],
            @"sourceVisitArray":sourceVisitModifiedArray,
            @"sourceValidUVArray":_sourceValidUVArray,
            @"cityNameArray":cityArray,
            @"cityValueArray":data[@"cityValueArray"],
            @"pagesNameArray":modifedPageArray,
            @"pagesValueArray":data[@"pagesValueArray"],
            @"arrayOfValues":modifedDealValues,
            @"arrayOfDates":data[@"arrayOfDates"],
            @"UV_arrayOfValues":data[@"uvArrayOfValues"],
            @"PV_arrayOfValues":data[@"pvArrayOfValues"],
            @"VISIT_arrayOfValues":data[@"visitArrayOfValues"],
            @"新UV_arrayOfValues":data[@"newUvArrayOfValues"],
            @"有效UV_arrayOfValues":data[@"validUvArrayOfValues"],
            @"付款金额_arrayOfValues":data[@"payAmntArrayOfValues"],
            @"有效订单数_arrayOfValues":data[@"validOrderArrayOfValues"],
            @"有效订单转化率_arrayOfValues":data[@"validOrderTransPerArrayOfValues"],
            @"UV_number":data[@"uvNumber"],
            @"PV_number":data[@"pvNumber"],
            @"VISIT_number":data[@"visitNumber"],
            @"新UV_number":data[@"newUvNumber"],
            @"有效UV_number":data[@"validUvNumber"],
            @"付款金额_number":data[@"payAmntNumber"],
            @"有效订单数_number":data[@"validOrderNumber"],
            @"有效订单转化率_number":data[@"validOrderTransPerNumber"]
            };
}

- (void)getNewData
{
     void (^successefullyBlock)(NSDictionary *data) = ^(NSDictionary *data) {
         @autoreleasepool{
             realTimeModel *strongSelf = _wself;
             
             _groupUV = arc4random() % 20000;
             _validUVRatio = ((arc4random() % 500) + 500) / 1000.0;
             _validGroupUV = _groupUV * _validUVRatio;
             _visit = arc4random() % 100000;
             _dealMoney = arc4random() % 20000;
             _validDealNumber = (arc4random() % 1000);
             _validDealTransformRatio = ((arc4random() % 1000)/1000.0) * 100;

             _sourceVisitArray = [[NSMutableArray alloc] initWithArray:@[@(arc4random() % 100),
                                                                          @(arc4random() % 100),
                                                                          @(arc4random() % 100),
                                                                          @(arc4random() % 100),
                                                                          @(arc4random() % 100),
                                                                          @(arc4random() % 100)
                                                                          ]];

             _sourceValidUVArray = [[NSMutableArray alloc] initWithArray:@[@(arc4random() % 20),
                                                                               @(arc4random() % 20),
                                                                               @(arc4random() % 20),
                                                                               @(arc4random() % 20),
                                                                               @(arc4random() % 20),
                                                                               @(arc4random() % 20)]];
             _cityValueArray     = [[NSMutableArray alloc] initWithArray:@[@(arc4random() % 100),
                                                                               @(arc4random() % 100),
                                                                               @(arc4random() % 100),
                                                                               @(arc4random() % 100),
                                                                               @(arc4random() % 100)]];
             
             _pagesValueArray    = [[NSMutableArray alloc] initWithArray:@[@(arc4random() % 100),
                                                                               @(arc4random() % 100),
                                                                               @(arc4random() % 100),
                                                                               @(arc4random() % 100),
                                                                               @(arc4random() % 100)]];

             
             NSMutableArray *parallelArray = [[NSMutableArray alloc] initWithCapacity:8];
             for(int i = 0; i < 8; i++){
                 [parallelArray addObject:[[NSMutableArray alloc] init]];
             }
             
             [_arrayOfValues removeAllObjects];
             for (int i = 0; i < 19; i++) {
                 [_arrayOfValues addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
             }
             
             //同步的并行处理
             dispatch_apply(8, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
    //             NSLog(@"parallel %i",index);
                 [strongSelf addNumberToArray:parallelArray[index]];
             });
             
             _sendDict = [strongSelf handleData:data];
             
//             _sendDict = @{
//                           @"VISIT":@(_visit),
//                           @"groupUV":@(_groupUV),
//                           @"validUVRatio":@(_validUVRatio),
//                           @"validGroupUV":@(_validGroupUV),
//                           @"newVISITRatio":@(((arc4random() % 400) + 600) / 1000.0 ),
//                           @"newUVRatio":@(((arc4random() % 400) + 600) / 1000.0 ),
//                           @"newVaildUVRatio":@(((arc4random() % 400) + 600) / 1000.0 ),
//                           
//                           @"sourceVisitArray":_sourceVisitArray,
//                           @"sourceValidUVArray":_sourceValidUVArray,
//                           @"cityNameArray" :_cityNameArray,
//                           @"cityValueArray":_cityValueArray,
//                           @"pagesNameArray":_pagesNameArray,
//                           @"pagesValueArray":_pagesValueArray,
//                           @"arrayOfValues":_arrayOfValues,
//                           @"dealMoney":@(_dealMoney),
//                           @"validDealNumber":@(_validDealNumber),
//                           @"validDealTransformRatio":@(_validDealTransformRatio),
//                           @"UV_arrayOfValues":parallelArray[0],
//                           @"PV_arrayOfValues":parallelArray[1],
//                           @"VISIT_arrayOfValues":parallelArray[2],
//                           @"新UV_arrayOfValues":parallelArray[3],
//                           @"有效UV_arrayOfValues":parallelArray[4],
//                           @"付款金额_arrayOfValues":parallelArray[5],
//                           @"有效订单数_arrayOfValues":parallelArray[6],
//                           @"有效订单转化率_arrayOfValues":parallelArray[7],
//                           @"UV_number":@(arc4random() % 20000),
//                           @"PV_number":@(arc4random() % 20000),
//                           @"VISIT_number":@(arc4random() % 20000),
//                           @"新UV_number":@(arc4random() % 10000),
//                           @"有效UV_number":@(arc4random() % 2000),
//                           @"付款金额_number":@(arc4random() % 20000),
//                           @"有效订单数_number":@(arc4random() % 200),
//                           @"有效订单转化率_number":@(arc4random() % 100)
//                           };
             
             NSNotification *notification = [[NSNotification alloc] initWithName:realTimeDataDidChange object:strongSelf userInfo:_sendDict];
             
             //这是同步处理通知
             //        [[NSNotificationQueue defaultQueue]
             //         enqueueNotification:notification
             //         postingStyle:NSPostNow
             //         coalesceMask:NSNotificationCoalescingOnName
             //         forModes:@[NSDefaultRunLoopMode]];
             //        NSLog(@"finished sending");
             
             // 异步处理通知
             dispatch_async(dispatch_get_main_queue(), ^{
                 [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                            postingStyle:NSPostASAP
                                                            coalesceMask:NSNotificationCoalescingOnName forModes:@[NSDefaultRunLoopMode]];
                 
                 //            NSLog(@"finished sending");
             });
         }
     };
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@/snf-mbbi-web/mbbi/getRealTimeData.htm",serverAddress];
    [[networkManager sharedInstance] sendAsynchronousRequestWithURL:url failureBlock:successefullyBlock successedBlock:successefullyBlock];
}

- (void)addNumberToArray:(NSMutableArray *)array
{
    for (int i = 0; i < 19; i++) {
        [array addObject:[NSNumber numberWithInteger:(arc4random() % 100)]];
    }
}

@end
