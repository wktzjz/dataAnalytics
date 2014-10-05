//
//  wkContextMenuView.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-29.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "wkContextMenuView.h"

#define WKShowAnimationID @"wkContextMenuViewRriseAnimationID"
#define WKDismissAnimationID @"wkContextMenuViewDismissAnimationID"

NSInteger const WKMainItemSize = 44;
NSInteger const WKMenuItemSize = 40;
NSInteger const WKBorderWidth  = 5;

CGFloat const   WKAnimationDuration = 0.2;
CGFloat const   WKAnimationDelay = WKAnimationDuration/5;


@interface WKMenuItemLocation : NSObject

@property (nonatomic) CGPoint position;
@property (nonatomic) CGFloat angle;

@end

@implementation WKMenuItemLocation

@end


@interface wkContextMenuView ()<UIGestureRecognizerDelegate>
{
    CADisplayLink *displayLink;
}

@property (nonatomic, strong) UILongPressGestureRecognizer* longPressRecognizer;

@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, assign) BOOL isPaning;

@property (nonatomic) CGPoint longPressLocation;
@property (nonatomic) CGPoint curretnLocation;

@property (nonatomic, strong) NSMutableArray* menuItems;

@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat arcAngle;
@property (nonatomic) CGFloat angleBetweenItems;
@property (nonatomic, strong) NSMutableArray* itemLocations;
@property (nonatomic) NSInteger prevIndex;

@property (nonatomic) CGColorRef itemBWKighlightedColor;
@property (nonatomic) CGColorRef itemBGColor;

@end

@implementation wkContextMenuView

- (instancetype)init
{
    self = [super initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
//        _longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDetected:)];
//        [self addGestureRecognizer:_longPressRecognizer];
        self.backgroundColor  = [UIColor clearColor];

        // Default the menuActionType to Pan (original/default)
        _menuActionType = wkContextMenuActionTypePan;
        

        //wk
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:nil];
//        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(highlightMenuItemForPoint)];
//        displayLink.paused = YES;
//        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        
        
        _menuItems = [NSMutableArray array];
        _itemLocations = [NSMutableArray array];
        _arcAngle = M_PI_2;
        _radius = 90;
        
        self.itemBGColor = [UIColor grayColor].CGColor;
        self.itemBWKighlightedColor = [UIColor redColor].CGColor;
        
    }
    return self;
}

#pragma mark -
#pragma mark Layer Touch Tracking
#pragma mark -

- (NSInteger)indexOfClosestMatchAtPoint:(CGPoint)point {
    int i = 0;
    for( CALayer *menuItemLayer in self.menuItems ) {
        if( CGRectContainsPoint( menuItemLayer.frame, point ) ) {
            NSLog( @"Touched Layer at index: %i", i);
            return i;
        }
        i++;
    }
    return -1;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    CGPoint menuAtPoint = CGPointZero;

    if ([touches count] == 1) {

        UITouch *touch = (UITouch *)[touches anyObject];
        CGPoint touchPoint = [touch locationInView:self];

        NSInteger menuItemIndex = [self indexOfClosestMatchAtPoint:touchPoint];
        if( menuItemIndex > -1 ) {
            menuAtPoint = [(CALayer *)self.menuItems[(NSUInteger)menuItemIndex] position];
        }

        if( (self.prevIndex >= 0 && self.prevIndex != menuItemIndex)) {
            [self resetPreviousSelection];
        }
        self.prevIndex = menuItemIndex;
    }

    [self dismissWithSelectedIndexForMenuAtPoint: menuAtPoint];
}


#pragma mark -
#pragma mark LongPress handler
#pragma mark -

// Split this out of the longPressDetected so that we can reuse it with touchesBegan (above)
- (void)dismissWithSelectedIndexForMenuAtPoint:(CGPoint)point
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectItemAtIndex: forMenuAtPoint:)] && self.prevIndex >= 0){
        [self.delegate didSelectItemAtIndex:self.prevIndex forMenuAtPoint:point];
        self.prevIndex = -1;
    }

    [self hideMenu];
}

- (void)longPressDetected:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.prevIndex = -1;
        
        CGPoint pointInView = [gestureRecognizer locationInView:gestureRecognizer.view];
        //wk
        
        _menuActionType = (pointInView.x <= [[UIScreen mainScreen] applicationFrame].size.width/2)?  wkContextMenuActionTypePan : wkContextMenuActionTypeTap ;
        
        if (self.dataSource != nil && [self.dataSource respondsToSelector:@selector(shouldShowMenuAtPoint:)] && ![self.dataSource shouldShowMenuAtPoint:pointInView]){
            return;
        }
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        self.longPressLocation = [gestureRecognizer locationInView:self];
        
        self.frame = [[UIScreen mainScreen] applicationFrame];
        self.layer.backgroundColor = [UIColor colorWithWhite:0.1f alpha:.8f].CGColor;
        self.isShowing = YES;
        [self animateMenu:YES];
        [self setNeedsDisplay];
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
//        NSLog(@"long pressed changed");
        if (self.isShowing && self.menuActionType == wkContextMenuActionTypePan) {
            self.isPaning = YES;
            self.curretnLocation =  [gestureRecognizer locationInView:self];
            //wk
            [self highlightMenuItemForPoint];
//            displayLink.paused = NO;
        }
    }
    
    // Only trigger if we're using the wkContextMenuActionTypePan (default)
    if( gestureRecognizer.state == UIGestureRecognizerStateEnded && self.menuActionType == wkContextMenuActionTypePan ) {
        CGPoint menuAtPoint = [self convertPoint:self.longPressLocation toView:gestureRecognizer.view];
        [self dismissWithSelectedIndexForMenuAtPoint:menuAtPoint];
    }
}

- (void)hideMenu
{
    //wk
//    displayLink.paused = YES;
    if (self.isShowing) {
        self.layer.backgroundColor = [UIColor clearColor].CGColor;
        self.isShowing = NO;
        self.isPaning = NO;
        [self animateMenu:NO];
        [self setNeedsDisplay];
        [self removeFromSuperview];
    }
}

- (CALayer *)layerWithImage:(UIImage*) image
{
    CALayer *layer = [CALayer layer];
    layer.bounds = CGRectMake(0, 0, WKMenuItemSize, WKMenuItemSize);
    layer.cornerRadius = WKMenuItemSize/2;
    layer.borderColor = [UIColor whiteColor].CGColor;
    layer.borderWidth = WKBorderWidth;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(0, -1);
    layer.backgroundColor = self.itemBGColor;
    
    CALayer* imageLayer = [CALayer layer];
    imageLayer.contents = (id)image.CGImage;
    imageLayer.bounds = CGRectMake(0, 0, WKMenuItemSize*2/3, WKMenuItemSize*2/3);
    imageLayer.position = CGPointMake(WKMenuItemSize/2, WKMenuItemSize/2);
    [layer addSublayer:imageLayer];
    
    return layer;
}

- (void)setDataSource:(id<wkContextOverlayViewDataSource>)dataSource
{
    _dataSource = dataSource;
    [self reloadData];

}

# pragma mark - menu item layout

- (void)reloadData
{
    [self.menuItems removeAllObjects];
    [self.itemLocations removeAllObjects];
    
    if (self.dataSource != nil) {
        NSInteger count = [self.dataSource numberOfMenuItems];
        for (int i = 0; i < count; i++) {
            UIImage* image = [self.dataSource imageForItemAtIndex:i];
            CALayer *layer = [self layerWithImage:image];
            [self.layer addSublayer:layer];
            [self.menuItems addObject:layer];
        }
    }
}

- (void)layoutMenuItems
{
    [self.itemLocations removeAllObjects];
    
    CGSize itemSize = CGSizeMake(WKMenuItemSize, WKMenuItemSize);
    CGFloat itemRadius = sqrt(pow(itemSize.width, 2) + pow(itemSize.height, 2)) / 2;
    self.arcAngle = ((itemRadius * self.menuItems.count) / self.radius) * 1.5;
    
    NSUInteger count = self.menuItems.count;
	BOOL isFullCircle = (self.arcAngle == M_PI*2);
	NSUInteger divisor = (isFullCircle) ? count : count - 1;

    self.angleBetweenItems = self.arcAngle/divisor;
    
    for (int i = 0; i < self.menuItems.count; i++) {
        WKMenuItemLocation *location = [self locationForItemAtIndex:i];
        [self.itemLocations addObject:location];
        
        CALayer* layer = (CALayer*) [self.menuItems objectAtIndex:i];
        layer.transform = CATransform3DIdentity;
       
        // Rotate menu items based on orientation
        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
            CGFloat angle = [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft ? M_PI_2 : -M_PI_2;
            layer.transform = CATransform3DRotate(CATransform3DIdentity, angle, 0, 0, 1);
        }
    }
}

- (WKMenuItemLocation *)locationForItemAtIndex:(NSUInteger) index
{
	CGFloat itemAngle = [self itemAngleAtIndex:index];
	
	CGPoint itemCenter = CGPointMake(self.longPressLocation.x + cosf(itemAngle) * self.radius,
									 self.longPressLocation.y + sinf(itemAngle) * self.radius);
    WKMenuItemLocation *location = [WKMenuItemLocation new];
    location.position = itemCenter;
    location.angle = itemAngle;
    
    return location;
}

- (CGFloat)itemAngleAtIndex:(NSUInteger)index
{
    float bearingRadians = [self angleBeweenStartinPoint:self.longPressLocation endingPoint:self.center];
    
    CGFloat angle =  bearingRadians - self.arcAngle/2;
    
	CGFloat itemAngle = angle + (index * self.angleBetweenItems);
    
    if (itemAngle > 2 *M_PI) {
        itemAngle -= 2*M_PI;
    }else if (itemAngle < 0){
        itemAngle += 2*M_PI;
    }

    return itemAngle;
}

# pragma mark - helper methiods

- (CGFloat)calculateRadius
{
    CGSize mainSize = CGSizeMake(WKMainItemSize, WKMainItemSize);
    CGSize itemSize = CGSizeMake(WKMenuItemSize, WKMenuItemSize);
    CGFloat mainRadius = sqrt(pow(mainSize.width, 2) + pow(mainSize.height, 2)) / 2;
    CGFloat itemRadius = sqrt(pow(itemSize.width, 2) + pow(itemSize.height, 2)) / 2;
    
    CGFloat minRadius = (CGFloat)(mainRadius + itemRadius);
    CGFloat maxRadius = ((itemRadius * self.menuItems.count) / self.arcAngle) * 1.5;
    
	CGFloat radius = MAX(minRadius, maxRadius);

    return radius;
}

- (CGFloat)angleBeweenStartinPoint:(CGPoint) startingPoint endingPoint:(CGPoint) endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y);
    float bearingRadians = atan2f(originPoint.y, originPoint.x);
    
    bearingRadians = (bearingRadians > 0.0 ? bearingRadians : (M_PI*2 + bearingRadians));

    return bearingRadians;
}

- (CGFloat)validaAngle:(CGFloat) angle
{
    if (angle > 2*M_PI) {
        angle = [self validaAngle:angle - 2*M_PI];
    }
    
    return angle;
}

# pragma mark - animation and selection

- (void)highlightMenuItemForPoint
{
//    NSLog(@"highlightMenuItemForPoint");
    if (self.isShowing && self.isPaning) {
        
        CGFloat angle = [self angleBeweenStartinPoint:self.longPressLocation endingPoint:self.curretnLocation];
        NSInteger closeToIndex = -1;
        for (int i = 0; i < self.menuItems.count; i++) {
            WKMenuItemLocation* itemLocation = [self.itemLocations objectAtIndex:i];
            if (fabs(itemLocation.angle - angle) < self.angleBetweenItems/2) {
                closeToIndex = i;
                break;
            }
        }
        
        if (closeToIndex >= 0 && closeToIndex < self.menuItems.count) {
            
            WKMenuItemLocation* itemLocation = [self.itemLocations objectAtIndex:closeToIndex];

            CGFloat distanceFromCenter = sqrt(pow(self.curretnLocation.x - self.longPressLocation.x, 2)+ pow(self.curretnLocation.y-self.longPressLocation.y, 2));
            
            CGFloat toleranceDistance = (self.radius - WKMainItemSize/(2*sqrt(2)) - WKMenuItemSize/(2*sqrt(2)) )/2;
            
            CGFloat distanceFromItem = fabsf(distanceFromCenter - self.radius) - WKMenuItemSize/(2*sqrt(2)) ;
            
            if (fabs(distanceFromItem) < toleranceDistance ) {
                CALayer *layer = [self.menuItems objectAtIndex:closeToIndex];
                layer.backgroundColor = self.itemBWKighlightedColor;
                
                CGFloat distanceFromItemBorder = fabs(distanceFromItem);
                
                CGFloat scaleFactor = 1 + 0.5 *(1-distanceFromItemBorder/toleranceDistance) ;
                
                if (scaleFactor < 1.0) {
                    scaleFactor = 1.0;
                }
                
                // Scale
                CATransform3D scaleTransForm =  CATransform3DScale(CATransform3DIdentity, scaleFactor, scaleFactor, 1.0);
                
                CGFloat xtrans = cosf(itemLocation.angle);
                CGFloat ytrans = sinf(itemLocation.angle);
                
                CATransform3D transLate = CATransform3DTranslate(scaleTransForm, 10*scaleFactor*xtrans, 10*scaleFactor*ytrans, 0);
                layer.transform = transLate;
                
                if ( ( self.prevIndex >= 0 && self.prevIndex != closeToIndex)) {
                    [self resetPreviousSelection];
                }
                
                self.prevIndex = closeToIndex;
                
            } else if(self.prevIndex >= 0) {
                [self resetPreviousSelection];
            }
        }else {
            [self resetPreviousSelection];
        }
    }
}

- (void)resetPreviousSelection
{
    if (self.prevIndex >= 0) {
        CALayer *layer = self.menuItems[self.prevIndex];
        WKMenuItemLocation* itemLocation = [self.itemLocations objectAtIndex:self.prevIndex];
        layer.position = itemLocation.position;
        layer.backgroundColor = self.itemBGColor;
        layer.transform = CATransform3DIdentity;
        self.prevIndex = -1;
    }
}

- (void)animateMenu:(BOOL) isShowing
{
//    NSLog(@"animateMenu");

    if (isShowing) {
        [self layoutMenuItems];
    }
    
    for (NSUInteger index = 0; index < self.menuItems.count; index++) {
        CALayer *layer = self.menuItems[index];
        layer.opacity = 0;
        CGPoint fromPosition = self.longPressLocation;
        
        WKMenuItemLocation* location = [self.itemLocations objectAtIndex:index];
        CGPoint toPosition = location.position;
        
        double delayInSeconds = index * WKAnimationDelay;
        
        CABasicAnimation *positionAnimation;
        
        positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:isShowing ? fromPosition : toPosition];
        positionAnimation.toValue = [NSValue valueWithCGPoint:isShowing ? toPosition : fromPosition];
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.45f :1.2f :0.75f :1.0f];
        positionAnimation.duration = WKAnimationDuration;
        positionAnimation.beginTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil] + delayInSeconds;
        [positionAnimation setValue:[NSNumber numberWithUnsignedInteger:index] forKey:isShowing ? WKShowAnimationID : WKDismissAnimationID];
        positionAnimation.delegate = self;
        
        [layer addAnimation:positionAnimation forKey:@"riseAnimation"];
    }
}

- (void)animationDidStart:(CAAnimation *)anim
{
//    NSLog(@"animationDidStart");
    if([anim valueForKey:WKShowAnimationID]) {
        NSUInteger index = [[anim valueForKey:WKShowAnimationID] unsignedIntegerValue];
        CALayer *layer = self.menuItems[index];
        
        WKMenuItemLocation* location = [self.itemLocations objectAtIndex:index];
        CGFloat toAlpha = 1.0;
        
        layer.position = location.position;
        layer.opacity = toAlpha;
        
    }
    else if([anim valueForKey:WKDismissAnimationID]) {
        NSUInteger index = [[anim valueForKey:WKDismissAnimationID] unsignedIntegerValue];
        CALayer *layer = self.menuItems[index];
        CGPoint toPosition = self.longPressLocation;
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        layer.position = toPosition;
        layer.backgroundColor = self.itemBGColor;
        layer.opacity = 0.0f;
        layer.transform = CATransform3DIdentity;
        [CATransaction commit];
    }
}

- (void)drawCircle:(CGPoint)locationOfTouch
{
    CGContextRef ctx= UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextSetLineWidth(ctx,WKBorderWidth/2);
    CGContextSetRGBStrokeColor(ctx,0.8,0.8,0.8,1.0);
    CGContextAddArc(ctx,locationOfTouch.x,locationOfTouch.y,WKMainItemSize/2,0.0,M_PI*2,YES);
    CGContextStrokePath(ctx);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if (self.isShowing) {
        [self drawCircle:self.longPressLocation];
    }
}
@end
