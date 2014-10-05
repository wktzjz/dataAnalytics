//
//  test.m
//  wkContextMenuDemo
//
//  Created by wktzjz on 14-9-30.
//  Copyright (c) 2014年 Tapasya. All rights reserved.
//

#import "test.h"

@implementation test
{
    CADisplayLink *_displayLink;
//    UILongPressGestureRecognizer *_gesture;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:nil];
//    _gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:nil];
      
    }
    return self;
}

- (void)test1
{
    NSLog(@"test test1");
}

@end
