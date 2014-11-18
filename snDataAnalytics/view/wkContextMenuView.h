//
//  wkContextMenuView.h
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-29.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, wkContextMenuActionType) {
    // Default
    wkContextMenuActionTypePan,
    // Allows tap action in order to trigger an action
    wkContextMenuActionTypeTap
};

@protocol wkContextOverlayViewDataSource;
@protocol wkContextOverlayViewDelegate;

@interface wkContextMenuView : UIView

@property (nonatomic, assign) id<wkContextOverlayViewDataSource> dataSource;
@property (nonatomic, assign) id<wkContextOverlayViewDelegate> delegate;

@property (nonatomic, assign) wkContextMenuActionType menuActionType;

- (void) longPressDetected:(UIGestureRecognizer*) gestureRecognizer;

@end

@protocol wkContextOverlayViewDataSource <NSObject>

@required
- (NSInteger) numberOfMenuItems;
- (UIImage*) imageForItemAtIndex:(NSInteger) index;

@optional
-(BOOL) shouldShowMenuAtPoint:(CGPoint) point;

@end

@protocol wkContextOverlayViewDelegate <NSObject>

- (void) didSelectItemAtIndex:(NSInteger) selectedIndex forMenuAtPoint:(CGPoint) point;

@end
