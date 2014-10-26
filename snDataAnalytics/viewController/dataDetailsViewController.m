//
//  dataDetailsViewController.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-9-4.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "dataDetailsViewController.h"
#import "dataOutlineViewContainer.h"
#import "BEMSimpleLineGraphView.h"
#import "defines.h"
#import "dataOutlineViewContainer.h"

#import "wkBlurPopover.h"
#import "indexSwitchController.h"
#import "THDatePickerViewController.h"

#import "Colours.h"
#import "FBShimmeringView.h"
#import "flatButton.h"
#import "changefulButton.h"

#import "networkManager.h"

#import "wkContextMenuView.h"

#import "test.h"
#import "visitorGroupDetailOutlineView.h"
#import "notificationDefine.h"
#import "FRDLivelyButton.h"
#import "calloutItemView.h"

const static CGFloat titleViewHeight = 44.0f;

@interface UIViewController (test)

- (void)test1;

@end

@implementation UIViewController (test)

- (void)test1
{
    NSLog(@"!!!!!!!test");
}
@end

@interface dataDetailsViewController ()<THDatePickerDelegate,BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate,wkContextOverlayViewDataSource, wkContextOverlayViewDelegate>

@property (strong, nonatomic) NSMutableArray *ArrayOfValues;
@property (strong, nonatomic) NSMutableArray *ArrayOfDates;
@property (nonatomic)  BEMSimpleLineGraphView *myGraph;

@end

@implementation dataDetailsViewController
{
    int previousStepperValue;
    int totalNumber;
    
    UIView *_contentView;
    UIView *_barView;
    FRDLivelyButton *_timeSwithButton;
    UIView *_itemsView;
    NSMutableArray     *_items;
    NSMutableIndexSet  *_selectedIndices;
    NSArray            *_borderColors;
    NSArray            *_images;
    BOOL               _itemsShowed;
    BOOL               _isSingleSelect;
    
    THDatePickerViewController *_datePicker;
    NSDate *_curDate;
    NSDateFormatter *_formatter;
    
    NSMutableArray *_selectedDays;
    BOOL _ifHasDetailsView;
    
    test *testInstance;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero type:outlineRealTime title:nil];
}

- (instancetype)initWithFrame:(CGRect)frame type:(viewType)viewType
{
    return [self initWithFrame:CGRectZero type:viewType title:nil];
}

- (instancetype)initWithFrame:(CGRect)frame type:(viewType)viewType title:(NSString *)title
{
    if ( (self = [super init]) ) {
        
        _dataVisualizedType = viewType;
        _viewTitleString   = title;
        self.view.frame = frame;
        _ifHasDetailsView = NO;
//        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    
   _contentView = [[UIView alloc] initWithFrame:self.view.frame];
    _contentView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    [self.view addSubview:_contentView];
    
    _curDate = [NSDate date];
    _formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"dd/MM/yyyy --- HH:mm"];

    [self addTitleView];
    [self addSettingButton];
    [self addDatePickerButton];
    [self addScrollView];
    [self addOutlineDataView];
    [self addTimeSwithButton];
    
    wkContextMenuView* overlay = [[wkContextMenuView alloc] init];
    overlay.dataSource = self;
    overlay.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleRealTimeDataDidChange:)
                                                 name:dataDidChange object:nil];
    
    UILongPressGestureRecognizer* _longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:overlay action:@selector(longPressDetected:)];
    [self.scrollView setUserInteractionEnabled:YES];
    [self.scrollView addGestureRecognizer:_longPressRecognizer];
    
//    testInstance = [[test alloc] init];
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
}

- (void)addTimeSwithButton
{
    _itemsView = [[UIView alloc] initWithFrame:CGRectMake(45, self.view.frame.size.height - 45, 300, 45)];
    [self.view addSubview:_itemsView];
    _timeSwithButton = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(0,12, 25, 25)];
    [_timeSwithButton setOptions:@{ kFRDLivelyButtonLineWidth: @(2.0f),
                           kFRDLivelyButtonHighlightedColor: [UIColor colorWithRed:0.5 green:0.8 blue:1.0 alpha:1.0],
                           kFRDLivelyButtonColor: PNTwitterColor
                           }];
    [_timeSwithButton setStyle:kFRDLivelyButtonStyleCirclePlus animated:NO];
    [_timeSwithButton addTarget:self action:@selector(showItems:) forControlEvents:UIControlEventTouchUpInside];
    _timeSwithButton.tag = 0;
    [_itemsView addSubview:_timeSwithButton];
    
    _selectedIndices = [NSMutableIndexSet indexSet];
    _items = [[NSMutableArray alloc] init];
    _borderColors = @[  [UIColor colorWithWhite:0.7 alpha:1],
                        [UIColor colorWithWhite:0.7 alpha:1],
                        [UIColor colorWithWhite:0.7 alpha:1],
                        [UIColor colorWithWhite:0.7 alpha:1]
                        ];
    _images = @[[UIImage imageNamed:@"icon_account"],
                [UIImage imageNamed:@"icon_account"],
                [UIImage imageNamed:@"icon_account"],
                ];
    
    [_images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
        calloutItemView *view = [[calloutItemView alloc] init];
        view.itemIndex = idx;
        view.clipsToBounds = YES;
        view.imageView.image = image;
        
        CGRect frame = CGRectMake(65 + idx * 60, 0 , 55, 55);
        view.frame = frame;
        view.layer.cornerRadius = frame.size.width/2.f;
        view.originalBackgroundColor = [UIColor clearColor];
        view.alpha = 0.0f;
        
        [_itemsView addSubview:view];
        
        [_items addObject:view];
        
        if (_borderColors && _selectedIndices && [_selectedIndices containsIndex:idx]) {
            UIColor *color = _borderColors[idx];
            view.layer.borderColor = color.CGColor;
        }
        else {
            view.layer.borderColor = [UIColor clearColor].CGColor;
        }
    }];
}

- (void)handleTap:(UIGestureRecognizer *)recognizer
{
    if(!_itemsShowed){
        CGPoint touchPoint = [recognizer locationInView:_contentView];
        
    }else{
        NSInteger tapIndex = [self indexOfTap:[recognizer locationInView:_itemsView]];
        
        if (tapIndex != NSNotFound) {
            [self didTapItemAtIndex:tapIndex];
        }else{
            [self dismissItems];
        }
    }
}

- (NSInteger)indexOfTap:(CGPoint)location
{
    __block NSUInteger index = NSNotFound;
    
    [_items enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if (CGRectContainsPoint(view.frame, location)) {
            index = idx;
            *stop = YES;
        }
    }];
    
    return index;
}

- (void)didTapItemAtIndex:(NSUInteger)index
{
    BOOL didEnable = ! [_selectedIndices containsIndex:index];
    
    if (_borderColors) {
        UIColor *stroke = _borderColors[index];
        UIView *view = _items[index];
        
        if (didEnable) {
            if (_isSingleSelect){
                [_selectedIndices removeAllIndexes];
                [_items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    UIView *aView = (UIView *)obj;
                    [[aView layer] setBorderColor:[[UIColor clearColor] CGColor]];
                }];
            }
            view.layer.borderColor = stroke.CGColor;
            
            CABasicAnimation *borderAnimation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
            borderAnimation.fromValue = (id)[UIColor clearColor].CGColor;
            borderAnimation.toValue = (id)stroke.CGColor;
            borderAnimation.duration = 0.5f;
            [view.layer addAnimation:borderAnimation forKey:nil];
            
            [_selectedIndices addIndex:index];
        }
        else {
            if (!_isSingleSelect){
                view.layer.borderColor = [UIColor clearColor].CGColor;
                [_selectedIndices removeIndex:index];
            }
        }
        
        CGRect pathFrame = CGRectMake(-CGRectGetMidX(view.bounds), -CGRectGetMidY(view.bounds), view.bounds.size.width, view.bounds.size.height);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:view.layer.cornerRadius];
        
        // accounts for left/right offset and contentOffset of scroll view
        CGPoint shapePosition = [_contentView convertPoint:view.center fromView:_itemsView];
        
        CAShapeLayer *circleShape = [CAShapeLayer layer];
        circleShape.path = path.CGPath;
        circleShape.position = shapePosition;
        circleShape.fillColor = [UIColor clearColor].CGColor;
        circleShape.opacity = 0;
        circleShape.strokeColor = stroke.CGColor;
        circleShape.lineWidth = 1.5;
        
        [self.view.layer addSublayer:circleShape];
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.5, 2.5, 1)];
        
        CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        alphaAnimation.fromValue = @1;
        alphaAnimation.toValue = @0;
        
        CAAnimationGroup *animation = [CAAnimationGroup animation];
        animation.animations = @[scaleAnimation, alphaAnimation];
        animation.duration = 0.5f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [circleShape addAnimation:animation forKey:nil];
    }
    
    
    //    if ([self.delegate respondsToSelector:@selector(sidebar:didTapItemAtIndex:)]) {
    //        [self.delegate sidebar:self didTapItemAtIndex:index];
    //    }
    //    if ([self.delegate respondsToSelector:@selector(sidebar:didEnable:itemAtIndex:)]) {
    //        [self.delegate sidebar:self didEnable:didEnable itemAtIndex:index];
    //    }
}
#pragma mark - Show and dismiss items
- (void)showItems:(id)sender
{
    if(_itemsShowed){
        [self dismissItems];
    }else{
        _itemsShowed = YES;
        [_timeSwithButton setStyle:kFRDLivelyButtonStyleCircleClose animated:YES];
        
        [_items enumerateObjectsUsingBlock:^(calloutItemView *view, NSUInteger idx, BOOL *stop) {
            //        view.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
            view.alpha = 0;
            CGFloat y = view.center.y;
            //        view.center =CGPointMake(view.center.x, view.center.y - 30);
            view.originalBackgroundColor = [UIColor clearColor];
            view.layer.borderWidth = 1.5f;
            
            [self showWithView:view idx:idx initDelay:0.1 centerY:y];
        }];
        
//        _lastText1Alpha = _text1.alpha;
//        _lastTextAlpha = _text.alpha;
//        _lastHeaderAlpha = _header.alpha;
//        _lastTitleAlpha = _title.alpha;
//        
        [UIView animateWithDuration:0.5 animations:^{
            _contentView.alpha  *= 0.2;
        }];
    }
}

- (void)dismissItems
{
    _itemsShowed = NO;
    [_timeSwithButton setStyle:kFRDLivelyButtonStyleCirclePlus animated:YES];
    [_items enumerateObjectsUsingBlock:^(calloutItemView *view, NSUInteger idx, BOOL *stop) {
        //        view.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
        CGFloat y = view.center.y;
        //        view.center =CGPointMake(view.center.x, view.center.y - 30);
        view.originalBackgroundColor = [UIColor clearColor];
        view.layer.borderWidth = 1.5f;
        
        [self dismissWithView:view idx:idx initDelay:0.5 centerY:y];
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        _contentView.alpha = 1.0;
    }];
    
}

#pragma mark - Set how items show and dismiss
- (void)showWithView:(calloutItemView *)view idx:(NSUInteger)idx initDelay:(CGFloat)initDelay centerY:(CGFloat)y
{
    [UIView animateWithDuration:0.7
                          delay:(initDelay + idx*0.08f)
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         //                        view.layer.transform = CATransform3DIdentity;
                         //                         view.center = CGPointMake(view.center.x,y);
                         //                         view.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1);
                         view.backgroundColor = [UIColor clearColor];
                         view.alpha = 1.0;
                     }
                     completion:nil];
}

- (void)dismissWithView:(calloutItemView *)view idx:(NSUInteger)idx initDelay:(CGFloat)initDelay centerY:(CGFloat)y
{
    [UIView animateWithDuration:0.7
                          delay:(initDelay - idx*0.08f)
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         //                        view.layer.transform = CATransform3DIdentity;
                         //                         view.center = CGPointMake(view.center.x,y);
                         //                         view.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1);
                         view.backgroundColor = [UIColor clearColor];
                         view.alpha = 0.0;
                     }
                     completion:nil];
}

#pragma mark removeObservers
- (void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:dataDidChange
                                                  object:nil];
}

#pragma mark wkContextOverlayViewDataSource
- (NSInteger) numberOfMenuItems
{
    return 3;
}

- (UIImage *)imageForItemAtIndex:(NSInteger)index
{
    NSString* imageName = nil;
//    heart camera pencil beaker puzzle glass
    switch (index) {
        case 0:
            imageName = @"heart";
            break;
        case 1:
            imageName = @"puzzle";
            break;
        case 2:
            imageName = @"pencil";
            break;
        case 3:
            imageName = @"glass";
            break;
        case 4:
            imageName = @"pinterest-white";
            break;
            
        default:
            break;
    }
    return [UIImage imageNamed:imageName];
}

#pragma mark wkContextOverlayViewDelegate

- (void)didSelectItemAtIndex:(NSInteger)selectedIndex forMenuAtPoint:(CGPoint)point
{
    NSString* msg = nil;
    switch (selectedIndex) {
        case 0:
            msg = @"1 Selected";
            [self settingButtonClicked];
            break;
        case 1:
            msg = @"2 Selected";
            [self modifyDataView:0];
            break;
        case 2:
            msg = @"3 Selected";
            [self datePickerButtonClicked];
            break;
        case 3:
            msg = @"4 Selected";
            break;
        case 4:
            msg = @"5 Selected";
            break;
            
        default:
            break;
    }
    
    
//    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alertView show];
    
}


#pragma mark add views
- (void)addTitleView
{
    _barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, titleViewHeight)];
    _barView.backgroundColor = [UIColor colorWithRed:0xbf/255.0 green:0xef/255.0 blue:0xff/255.0 alpha:1];
    [_contentView addSubview:_barView];
    
    _viewTitle = [[UILabel alloc] init];
    [_viewTitle setTextColor:[UIColor blackColor]];
    [_viewTitle setText:_viewTitleString];
    _viewTitle.textAlignment = NSTextAlignmentCenter;
    _viewTitle.font   = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    CGSize sz    = [_viewTitle.text sizeWithAttributes:@{NSFontAttributeName:_viewTitle.font}];
    _viewTitle.frame  = CGRectMake(0, 0, sz.width*2, sz.height);
    _viewTitle.center = CGPointMake(_barView.center.x,_barView.center.y);
//    [titleView addSubview:_viewTitle];

    FBShimmeringView *shimmeringLogo = [[FBShimmeringView alloc] initWithFrame:_viewTitle.frame];
    shimmeringLogo.contentView     = _viewTitle;
    shimmeringLogo.shimmeringSpeed = 180;
    shimmeringLogo.shimmering      = YES;
    shimmeringLogo.center          = CGPointMake(_barView.center.x,_barView.center.y);
    [_barView addSubview:shimmeringLogo];
    
    
}

- (void)setViewTitleString:(NSString *)titleString
{
    _viewTitleString = titleString;
    [_viewTitle setText:titleString];
}

- (void)addTimeSwitchButton
{
//    _tipButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    _tipButton.frame = CGRectMake(0, 0, 160.0, 40.0);
//    _tipButton.center = CGPointMake(self.view.center.x, self.view.center.y+150);
//    [_tipButton setTitle:@"swipe or click" forState:UIControlStateNormal];
//    [_tipButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [_contentView addSubview:_tipButton];
}

- (void)addSettingButton
{
//    changefulButton *settingButton = [changefulButton button];
//    settingButton.tintColor = [UIColor blackColor];
//    settingButton.center = CGPointMake(290.0f,22.0f);


    flatButton *settingButton = [flatButton button];
    settingButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Medium"size:18];

    settingButton.backgroundColor = [UIColor clearColor];
    settingButton.translatesAutoresizingMaskIntoConstraints = NO;
    [settingButton setTitle:@"Settings" forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(settingButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [_barView addSubview:settingButton];
    
    [_barView addConstraint:[NSLayoutConstraint constraintWithItem:settingButton
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_barView
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1.f
                                                              constant:0.0f]];
    
    
    [_barView addConstraint:[NSLayoutConstraint constraintWithItem:settingButton
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_barView
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0f
                                                              constant:0.f]];

}

- (void)addDatePickerButton
{
    flatButton *datePickerButton = [flatButton button];
    datePickerButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Medium"size:18];
    
    datePickerButton.backgroundColor = [UIColor clearColor];
    datePickerButton.textColor = PNLightGreen;
    datePickerButton.translatesAutoresizingMaskIntoConstraints = NO;
    [datePickerButton setTitle:@"Date" forState:UIControlStateNormal];
    [datePickerButton addTarget:self action:@selector(datePickerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [_barView addSubview:datePickerButton];
    
    [_barView addConstraint:[NSLayoutConstraint constraintWithItem:datePickerButton
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_barView
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.f
                                                          constant:0.0f]];
    
    
    [_barView addConstraint:[NSLayoutConstraint constraintWithItem:datePickerButton
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_barView
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0f
                                                          constant:0.f]];
}

- (void)addScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, titleViewHeight, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    [_scrollView setDelegate:self];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setContentSize:CGSizeMake(0, self.view.bounds.size.height * 3)];
    [_contentView addSubview:_scrollView];
}

- (void)addOutlineDataView
{
    float marginX = 20.0;
    float marginY = 10.0;
    float width   = wkScreenWidth - marginX * 2;
    float height  = wkScreenHeight/2 + 10;
    
    if(_dataVisualizedType == outlineRealTime){
        _dataContentView = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(marginX, marginY, width, height*2.5) dataType:outlineRealTime inControllerType:detailView];
        _dataContentView.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:_dataContentView];
        
    }else if (_dataVisualizedType == outlinePageAnalytics) {
        
        _dataContentView = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(marginX, marginY, width, height) dataType:outlinePageAnalytics inControllerType:detailView];
        _dataContentView.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:_dataContentView];
        
    }else if (_dataVisualizedType == outlineHotCity){
        //Add BarChart
        _dataContentView = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(marginX, marginY, width, height) dataType:outlineHotCity inControllerType:detailView];
        [_scrollView addSubview:_dataContentView];
        
           
    }else if (_dataVisualizedType == outlineSource){
        
        //Add CircleChart
        _dataContentView = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(marginX, marginY, width, height) dataType:outlineSource inControllerType:detailView];
        [_scrollView addSubview:_dataContentView];
        
    }else if (_dataVisualizedType == outlinevisitorGroup){
        
        //Add PieChart
        
        _dataContentView = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(marginX, marginY, width, height) dataType:outlinevisitorGroup inControllerType:detailView];
        [_scrollView addSubview:_dataContentView];
        
        visitorGroupDetailOutlineView *detailView = [[visitorGroupDetailOutlineView alloc] initWithFrame:CGRectMake(marginX , _dataContentView.frame.origin.y + _dataContentView.frame.size.height + 20, width, height - 30.0)];
        
        [_scrollView addSubview:detailView];
        _ifHasDetailsView = YES;
       
    }else if (_dataVisualizedType == outlineHotPage){
        _dataContentView = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(marginX, marginY, width, height) dataType:outlineHotPage inControllerType:detailView];
        [_scrollView addSubview:_dataContentView];
        
    }

    if(!_ifHasDetailsView){
        dataOutlineViewContainer *dataContentView1 = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(marginX , _dataContentView.frame.origin.y + _dataContentView.frame.size.height + 20, width, height) ifLoading:YES];
        dataOutlineViewContainer *dataContentView2 = [[dataOutlineViewContainer alloc ] initWithFrame:CGRectMake(marginX , dataContentView1.frame.origin.y + dataContentView1.frame.size.height + 20, width, height) ifLoading:YES];
        
        [_scrollView addSubview:dataContentView1];
        [_scrollView addSubview:dataContentView2];
    }
}


#pragma mark settingButtonClicked
- (void)settingButtonClicked
{
//    indexSwitchController *vc = [[indexSwitchController alloc] initWithFrame:CGRectMake(0, 0, 280, 160) type:demo];
//    
//    __weak typeof(self) weakSelf = self;
//    
//    vc.switchAction =^(NSInteger clickedButtonIndex){
//        typeof(weakSelf) strongSelf = weakSelf;
//
//        [strongSelf dismissViewControllerAnimated:YES completion:nil];
//        [strongSelf modifyDataView:clickedButtonIndex];
//        };
//    
//    wkBlurPopover *popover = [[wkBlurPopover alloc] initWithContentViewController:vc];
//    [self presentViewController:popover animated:YES completion:nil];
    
    indexSwitchController *vc = [[indexSwitchController alloc] initWithFrame:CGRectMake(0, 0, 280, 216) type:visitorGroup];
        __weak typeof(self) weakSelf = self;
    
        vc.switchAction =^(NSInteger index){
            typeof(weakSelf) strongSelf = weakSelf;
    
            [strongSelf dismissViewControllerAnimated:YES completion:nil];
            [strongSelf modifyDataView:index];
            };

    wkBlurPopover *popover = [[wkBlurPopover alloc] initWithContentViewController:vc];
    [self presentViewController:popover animated:YES completion:nil];
    
}

#pragma mark datePicker

- (void)datePickerButtonClicked
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        typeof(weakself) strongSelf = weakself;
        
        if(!_datePicker){
            _datePicker = [THDatePickerViewController datePicker];
        }
        _datePicker.date = _curDate;
        _datePicker.delegate = strongSelf;
        [_datePicker setAllowClearDate:NO];
        [_datePicker setAutoCloseOnSelectDate:NO];
        [_datePicker setDisableFutureSelection:NO];
        [_datePicker setSelectedBackgroundColor:[UIColor colorWithRed:125/255.0 green:208/255.0 blue:0/255.0 alpha:1.0]];
        [_datePicker setCurrentDateColor:[UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0]];

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [strongSelf presentSemiViewController:_datePicker withOptions:@{
                                                                      KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                                      KNSemiModalOptionKeys.animationDuration : @(0.6),
                                                                      KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
                                                                      }];

        });
    });
//    if(!_datePicker){
//        _datePicker = [THDatePickerViewController datePicker];
//    }
//    _datePicker.date = _curDate;
//    _datePicker.delegate = self;
//    [_datePicker setAllowClearDate:NO];
//    [_datePicker setAutoCloseOnSelectDate:NO];
//    [_datePicker setDisableFutureSelection:NO];
//    [_datePicker setSelectedBackgroundColor:[UIColor colorWithRed:125/255.0 green:208/255.0 blue:0/255.0 alpha:1.0]];
//    [_datePicker setCurrentDateColor:[UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0]];
//    
////    [_datePicker setDateHasItemsCallback:^BOOL(NSDate *date) {
////        int tmp = (arc4random() % 30)+1;
////        if(tmp % 5 == 0)
////            return YES;
////        return NO;
////    }];
//    [self presentSemiViewController:_datePicker withOptions:@{
//                                                                  KNSemiModalOptionKeys.pushParentBack    : @(NO),
//                                                                  KNSemiModalOptionKeys.animationDuration : @(0.6),
//                                                                  KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
//                                                                  }];
}

#pragma mark THDatePickerDelegate
-(void)datePickerDonePressed:(THDatePickerViewController *)datePicker selectedDays:(NSMutableArray *)selectedDays
{
    _selectedDays = selectedDays;
    [_selectedDays enumerateObjectsUsingBlock:^(THDateDay* day, NSUInteger idx, BOOL *stop) {
        NSLog(@"selected Day:%@",[_formatter stringFromDate:day.date]);
    }];
    _curDate = datePicker.date;
//    [self refreshTitle];
    [self dismissSemiModalView];
}

-(void)datePickerCancelPressed:(THDatePickerViewController *)datePicker
{
    //[_datePicker slideDownAndOut];
    _selectedDays = datePicker.selectedDaysArray;
    [_selectedDays enumerateObjectsUsingBlock:^(THDateDay* day, NSUInteger idx, BOOL *stop) {
        NSLog(@"selected Day:%@",[_formatter stringFromDate:day.date]);
    }];
    [self dismissSemiModalView];
}

-(void)refreshTitle
{
//    if(_curDate) {
//        [_tipButton setTitle:[_formatter stringFromDate:_curDate] forState:UIControlStateNormal];
//    }else {
//        [_tipButton setTitle:@"No date selected" forState:UIControlStateNormal];
//    }
}

#pragma mark handleRealTimeDataDidChange

- (void)handleRealTimeDataDidChange:(NSNotification *)notification
{
    if(_dataVisualizedType == outlineRealTime){
        [_dataContentView reloadRealTimeData:notification.userInfo];
    }
}

#pragma mark modifyDataView
- (void)modifyDataView:(NSInteger)clickedButtonIndex
{
    if(_dataVisualizedType == outlinePageAnalytics){
//        if (clickedButtonIndex == 0) {
//            [_dataContentView modifyLineChartWithDataArray1:@[@160.1, @260.1, @36.4, @162.2, @86.2, @227.2, @76.2] dataArray2:@[@260.1, @60.1, @26.4, @262.2, @186.2, @227.2, @76.2] xLabelArray:@[@"10.1",@"10.2",@"10.3",@"10.4",@"10.5",@"10.6",@"10.7"]];
//        }else if(clickedButtonIndex == 1){
//            [_dataContentView modifyLineChartWithDataArray1: @[@60.1, @160.1, @126.4, @262.2, @186.2, @127.2, @176.2] dataArray2:@[@20.1, @180.1, @26.4, @202.2, @126.2, @167.2, @276.2] xLabelArray:@[@"9.1",@"9.2",@"9.3",@"9.4",@"9.5",@"9.6",@"9.7"]];
//        }
        if (clickedButtonIndex == 0) {
            [_dataContentView modifyPieChartInView:_dataContentView.pageView type:outlinePageAnalytics WithDataArray: @[[PNPieChartDataItem dataItemWithValue:15 color:PNLightGreen],[PNPieChartDataItem dataItemWithValue:20 color:PNGreen ],[PNPieChartDataItem dataItemWithValue:20 color:PNFreshGreen ],[PNPieChartDataItem dataItemWithValue:45 color:PNDeepGreen]] groupColorArray:@[PNLightGreen,PNGreen,PNFreshGreen,PNDeepGreen] groupPercentArray:@[@15,@20,@20,@45]];
            [_dataContentView modifyLineChartInView:_dataContentView.pageView type:outlinePageAnalytics WithValueArray:nil dateArray:nil];
        }else if(clickedButtonIndex == 1){
            [_dataContentView modifyPieChartInView:_dataContentView.pageView type:outlinePageAnalytics WithDataArray:@[[PNPieChartDataItem dataItemWithValue:15 color:[UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:250.0/255.0 alpha:1]],[PNPieChartDataItem dataItemWithValue:20 color:PNTwitterColor],[PNPieChartDataItem dataItemWithValue:30 color:[UIColor colorWithRed:30.0/255.0 green:144.0/255.0 blue:255.0/255.0 alpha:1] description:@"40%"],[PNPieChartDataItem dataItemWithValue:35 color:PNBlue description:@"50%"]] groupColorArray:@[[UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:250.0/255.0 alpha:1],PNTwitterColor,[UIColor colorWithRed:30.0/255.0 green:144.0/255.0 blue:255.0/255.0 alpha:1],PNBlue] groupPercentArray:@[@15,@20,@30,@35]];
            [_dataContentView modifyLineChartInView:_dataContentView.pageView type:outlinePageAnalytics WithValueArray:nil dateArray:nil];
        }
        
    }else if(_dataVisualizedType == outlineHotCity){
        if (clickedButtonIndex == 0) {
            [_dataContentView modifyBarChartWithDataArray:@[@31,@12,@20,@8,@21] xLabelArray:@[@"杭州",@"天津",@"成都",@"重庆",@"苏州"]];
        }else if(clickedButtonIndex == 1){
            [_dataContentView modifyBarChartWithDataArray: @[@24,@12,@18,@10,@21] xLabelArray:@[@"北京",@"上海",@"广州",@"深圳",@"南京"]];
        }
        
    }else if(_dataVisualizedType == outlineSource){
        if (clickedButtonIndex == 0) {
            [_dataContentView modifyCircleChartWithData:@20];
        }else if(clickedButtonIndex == 1){
            [_dataContentView modifyCircleChartWithData:@60];
        }
        
    }else if(_dataVisualizedType == outlinevisitorGroup){
        if (clickedButtonIndex == 0) {
            [_dataContentView modifyPieChartInView:_dataContentView.visitorGroupView type:outlinevisitorGroup WithDataArray:@[[PNPieChartDataItem dataItemWithValue:10 color:PNBlue],[PNPieChartDataItem dataItemWithValue:40 color:PNLightBlue description:@"40%"],[PNPieChartDataItem dataItemWithValue:50 color:PNTwitterColor description:@"50%"]] groupColorArray:@[PNBlue,PNLightBlue,PNTwitterColor] groupPercentArray:@[@10,@40,@50]];
        }else if(clickedButtonIndex == 1){
            [_dataContentView modifyPieChartInView:_dataContentView.visitorGroupView type:outlinevisitorGroup WithDataArray: @[[PNPieChartDataItem dataItemWithValue:15 color:PNLightGreen],[PNPieChartDataItem dataItemWithValue:30 color:PNFreshGreen ],[PNPieChartDataItem dataItemWithValue:55 color:PNDeepGreen]] groupColorArray:@[PNLightGreen,PNFreshGreen,PNDeepGreen] groupPercentArray:@[@15,@30,@55]];
        }
        
    }else if(_dataVisualizedType == outlineHotPage){
        if (clickedButtonIndex == 0) {
            [_dataContentView modifyLineChartInView:nil type:0 WithValueArray:nil dateArray:nil];
        }else if(clickedButtonIndex == 1){
            [_dataContentView modifyLineChartInView:nil type:0 WithValueArray:nil dateArray:nil];
        }
    }
}

#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return (int)[self.ArrayOfValues count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[self.ArrayOfValues objectAtIndex:index] floatValue];
}

#pragma mark - SimpleLineGraph Delegate

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 1;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    NSString *label = [self.ArrayOfDates objectAtIndex:index];
    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
//    self.labelValues.text = [NSString stringWithFormat:@"%@", [self.ArrayOfValues objectAtIndex:index]];
//    self.labelDates.text = [NSString stringWithFormat:@"in %@", [self.ArrayOfDates objectAtIndex:index]];
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self.labelValues.alpha = 0.0;
//        self.labelDates.alpha = 0.0;
    } completion:^(BOOL finished) {
//        self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSum] intValue]];
//        self.labelDates.text = [NSString stringWithFormat:@"between 2000 and %@", [self.ArrayOfDates lastObject]];
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            self.labelValues.alpha = 1.0;
//            self.labelDates.alpha = 1.0;
        } completion:nil];
    }];
}

- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph {
//    self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSum] intValue]];
//    self.labelDates.text = [NSString stringWithFormat:@"between 2000 and %@", [self.ArrayOfDates lastObject]];
}

//- (void)handleTap:(id)sender
//{
//    if(self.delegate && [self.delegate respondsToSelector:@selector(dismissDetailsController)]){
//        [self.delegate dismissDetailsController];
//    }
//}

- (void)buttonClicked:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(dismissDetailsController)]){
        [self.delegate dismissDetailsController];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
