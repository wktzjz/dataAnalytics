//
//  lineChartDetailsViewController.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-31.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "lineChartDetailsViewController.h"
#import "ConditionInquireController.h"
#import "THDatePickerViewController.h"
#import "wkBlurPopover.h"
#import "wkContextMenuView.h"
#import "FBShimmeringView.h"
#import "BFPaperButton.h"
#import "flatButton.h"
#import "PNColor.h"
#import "Colours.h"
#import "timeView.h"

typedef NS_ENUM(NSUInteger, operationType) {
    Dimension = 0,
    Index = 1
};

const static CGFloat titleViewHeight = 44.0f;
@interface lineChartDetailsViewController () <THDatePickerDelegate,wkContextOverlayViewDataSource, wkContextOverlayViewDelegate>

@end
@implementation lineChartDetailsViewController
{
    UIView *_barView;
    UILabel *_viewTitle;
    
    NSDateFormatter *_formatter;
    NSDate *_curDate;
    THDatePickerViewController *_datePicker;

    BOOL _dimensionItemsShowed;
    BOOL _indexItemsShowed;

    UIView *_popupBackgroundView;
    NSMutableArray *_popupDimensionViews;
    NSMutableArray *_popupIndexViews;
    
    timeView *_timeView;
    UIScrollView *_scrollView;

}

#pragma mark init
- (instancetype)initWithFrame:(CGRect)frame data:(NSDictionary *)data
{
    if ( (self = [super init]) ) {
        _titleString = @"NeedData";
        _data = data;
        
        _popupDimensionViews = [[NSMutableArray alloc] initWithCapacity:8];
        _popupIndexViews = [[NSMutableArray alloc] initWithCapacity:8];
        _dimensionItemsShowed = NO;
        _indexItemsShowed = NO;
        
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"dd/MM/yyyy --- HH:mm"];
        _curDate = [NSDate date];
        
        self.view.frame = frame;
    }
    
    return self;
}

#pragma mark viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self prefersStatusBarHidden];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addTitleView];
    [self addSettingButton];
//    [self addDatePickerButton];
    
    [self addLineDetailsView];
    [self addTimeView];
    [self addScrollView];

    wkContextMenuView* overlay = [[wkContextMenuView alloc] init];
    overlay.dataSource = self;
    overlay.delegate = self;
    
    UILongPressGestureRecognizer *_longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:overlay action:@selector(longPressDetected:)];
    [self.view addGestureRecognizer:_longPressRecognizer];

}

#pragma mark addViews
- (void)addTitleView
{
    _barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, titleViewHeight)];
    _barView.backgroundColor = [UIColor colorWithRed:0xbf/255.0 green:0xef/255.0 blue:0xff/255.0 alpha:0.3];
    [self.view addSubview:_barView];
    
    _barView.frame = CGRectMake(0, 0, self.view.frame.size.width, titleViewHeight);
    [self.view addSubview:_barView];
    
    _viewTitle = [[UILabel alloc] init];
    [_viewTitle setTextColor:[UIColor blackColor]];
    [_viewTitle setText:_titleString];
    _viewTitle.textAlignment = NSTextAlignmentCenter;
    _viewTitle.font   = [UIFont fontWithName:@"OpenSans-Light" size:20];
    CGSize sz    = [_viewTitle.text sizeWithAttributes:@{NSFontAttributeName:_viewTitle.font}];
    _viewTitle.frame  = CGRectMake(0, 0, sz.width*2, sz.height);
    _viewTitle.center = CGPointMake(_barView.center.x,_barView.center.y);
    
    FBShimmeringView *shimmeringLogo = [[FBShimmeringView alloc] initWithFrame:_viewTitle.frame];
    shimmeringLogo.contentView     = _viewTitle;
    shimmeringLogo.shimmeringSpeed = 70;
    shimmeringLogo.shimmering      = YES;
    shimmeringLogo.center          = CGPointMake(_barView.center.x,_barView.center.y);
    [_barView addSubview:shimmeringLogo];
}

- (void)addSettingButton
{
    flatButton *settingButton = [flatButton button];
    settingButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light"size:18];
    
    settingButton.backgroundColor = [UIColor clearColor];
    settingButton.translatesAutoresizingMaskIntoConstraints = NO;
    settingButton.textColor = PNTwitterColor;
    [settingButton setTitle:@"查询" forState:UIControlStateNormal];
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
    datePickerButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light"size:18];
    
    datePickerButton.backgroundColor = [UIColor clearColor];
    datePickerButton.textColor = PNTwitterColor;
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

- (void)addTimeView
{
    _curDate = [NSDate date];
    _formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"dd/MM/yyyy --- HH:mm"];
    
    _timeView = [[timeView alloc] initWithFrame:CGRectMake(0, titleViewHeight ,self.view.frame.size.width, 50.0)];
    __weak typeof(self) weakSelf = self;
    _timeView.timeViewChoosedBlock = ^{
        typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf datePickerButtonClicked];
    };
    
    [self.view addSubview:_timeView];
}

- (void)addLineDetailsView
{
    CGRect r = self.view.frame;
    r.origin.y = titleViewHeight + 50.0;
    r.size.height -= titleViewHeight + 50.0;
    _chartDetailsView = [[lineChartDetailsView alloc] initWithFrame:r];
    
    __weak typeof(self) weakSelf = self;
    _chartDetailsView.detailsView.dimensionButtonClickedBlock = ^{
        typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf showItemsType:Dimension delay:0.0];
    };
    
    _chartDetailsView.detailsView.indexButtonClickedBlock = ^{
        typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf showItemsType:Index delay:0.0];
    };
    
    [self.view addSubview:_chartDetailsView];
    
//    _popupBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 350, self.view.frame.size.width, 230)];
//    _popupBackgroundView.backgroundColor = [UIColor whiteColor];
//    _popupBackgroundView.alpha = 0.0;
//    [self.view addSubview:_popupBackgroundView];
}

- (void)addScrollView
{
    float originY =  _chartDetailsView.lineView.frame.origin.y + _chartDetailsView.lineView.frame.size.height + 85;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, originY ,self.view.frame.size.width , self.view.frame.size.height - originY)];
//    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setContentSize:CGSizeMake(0, self.view.bounds.size.height * 3)];
    _scrollView.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:_scrollView];
    
    [self.view insertSubview:_scrollView belowSubview:_chartDetailsView];
}


#pragma mark set add Views With Data

- (void)addLineViewWithData:(NSDictionary *)data
{
    [_chartDetailsView addLineViewWithData:data];
}

- (void)addDetailsViewButtonWithData:(NSDictionary *)data
{
    [_chartDetailsView addDetailsViewButtonWithData:data];
}

- (void)addDetailsViewWithData:(NSDictionary *)data
{
    [_chartDetailsView addDetailsViewWithData:data];
}

- (void)reloadViewWithData:(NSDictionary *)data
{
//    [_chartDetailsView reloadViewWithData:data];
    [_chartDetailsView addLineViewWithData:data];
    [_chartDetailsView addDetailsViewWithData:data];
}


#pragma mark set titleString

- (void)setTitleString:(NSString *)string
{
    _titleString = string;
    [_viewTitle setText:_titleString];
}


#pragma mark - setDimensionArray

- (void)setDimensionArray:(NSMutableArray *)array
{
    _dimensionArray = array;
    [self addPopViewsType:Dimension];
}

- (void)setIndexArray:(NSMutableArray *)array
{
    _indexArray = array;
    [self addPopViewsType:Index];
}

#pragma mark settingButtonClicked
- (void)settingButtonClicked
{
    ConditionInquireController *vc = [[ConditionInquireController alloc] initWithFrame:CGRectMake(0, 0, 300, 360) type:inquireVisitorGroup1];
    
    vc.chooseActionBlock =^(NSDictionary *data) {
        if(_conditionChoosedBlock){
            _conditionChoosedBlock(data);
        }
    };
    
    wkBlurPopover *popover = [[wkBlurPopover alloc] initWithContentViewController:vc type:top];
    [self presentViewController:popover animated:YES completion:nil];
    
}


#pragma mark - popDimensionViews

- (void)addPopViewsType:(operationType)type
{
    NSMutableArray *array;
    NSMutableArray *views;
    
    if (type == Dimension) {
        array = _dimensionArray;
        views = _popupDimensionViews;
    }else{
        array = _indexArray;
        views = _popupIndexViews;
        [views enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
            [button removeFromSuperview];
        }];
        [views removeAllObjects];
    }
    
    if (array.count >0) {
        
        [array enumerateObjectsUsingBlock:^(NSString *dimensionString, NSUInteger idx, BOOL *stop) {
            UIButton *button = [[BFPaperButton alloc] initWithFrame:CGRectMake(25, 355 + idx * 30 , 150, 30) raised:NO];
            button.tag = idx;
            [button setTitle:dimensionString forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light"
                                                size:15];
            [button setTitleColor:PNTwitterColor forState:UIControlStateNormal];
            
            CGRect frame = CGRectMake(25, 10 + idx * 30 , 150, 30);

//            CGRect frame = CGRectMake(25, 355 + idx * 30 , 150, 30);
//            if(idx > 6){
//                frame = CGRectMake(25 + 30, 145 + idx * 30 , 150, 30);
//            }
            button.frame = frame;
            button.backgroundColor = [UIColor clearColor];
            button.alpha = 0.0f;
            
            if (type == Dimension) {
                [button addTarget:self action:@selector(handleDimensionClicked:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [button addTarget:self action:@selector(handleIndexClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [_scrollView addSubview:button];
            
            [views addObject:button];
        }];
    }
}

- (void)handleDimensionClicked:(UIButton *)button
{
    [self dismissItemsType:Dimension];
    if (_dimensionChoosedBlock) {
        _dimensionChoosedBlock(button.tag);
    }
}

- (void)handleIndexClicked:(UIButton *)button
{
    [self dismissItemsType:Index];
    if (_indexChoosedBlock) {
        _indexChoosedBlock(button.tag);
    }
}


#pragma mark - Show and dismiss items

- (void)showItemsType:(operationType)type delay:(float)delay
{
    if (_dimensionItemsShowed) {
        [self dismissItemsType:Dimension];
        if (type == Index) {
            [self showItemsType:Index delay:0.4];
        }
    }else if (_indexItemsShowed) {
        [self dismissItemsType:Index];
        if (type == Dimension) {
            [self showItemsType:Dimension delay:0.4];
        }
    }else{
        
        NSMutableArray *views;
        CGFloat centerX;
        
        if (type == Dimension) {
            views = _popupDimensionViews;
            _dimensionItemsShowed = YES;
            centerX = -105;
        }else{
            views = _popupIndexViews;
            _indexItemsShowed = YES;
            centerX = 500;
        }
        
        [self.view insertSubview:_scrollView aboveSubview:_chartDetailsView];

        [_scrollView setContentOffset:CGPointMake(0, 0)];
        [UIView animateWithDuration:0.3 animations:^{
            _scrollView.alpha = 1.0;
//            _popupBackgroundView.alpha = 1.0;
        }];
        
        [views enumerateObjectsUsingBlock:^(UIButton *view, NSUInteger idx, BOOL *stop) {
            view.alpha = 0;
            CGFloat x = self.view.center.x;
//            if(idx > 6){
//                x += 90;
//            }
            view.center = CGPointMake(centerX, view.center.y);
            
            [self showWithView:view idx:idx initDelay:0.1 + delay centerX:x];
        }];
    }
}

- (void)dismissItemsType:(operationType)type
{
    NSMutableArray *views;
    CGFloat centerX;
    
    if (type == Dimension) {
        _dimensionItemsShowed = NO;
        views = _popupDimensionViews;
        centerX = -105;
        
    }else{
        _indexItemsShowed = NO;
        views = _popupIndexViews;
        centerX = 500;
    }
    
    [views enumerateObjectsUsingBlock:^(UIButton *view, NSUInteger idx, BOOL *stop) {
//        CGFloat x = view.center.x;
//        view.center =CGPointMake(centerX, view.center.y);
        [self dismissWithView:view idx:idx initDelay:0.5 centerX:centerX];
    }];
    
    [UIView animateWithDuration:0.3
                          delay:0.7
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
//                         _popupBackgroundView.alpha = 0.0;
                         _scrollView.alpha = 0.0;

                     }
                     completion:^(BOOL finished){
                         [self.view insertSubview:_scrollView belowSubview:_chartDetailsView];
                     }];
    
}


#pragma mark - Set how items show and dismiss

- (void)showWithView:(UIView *)view idx:(NSUInteger)idx initDelay:(CGFloat)initDelay centerX:(CGFloat)x
{
    [UIView animateWithDuration:0.7
                          delay:(initDelay + idx*0.08f)
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         view.center = CGPointMake(x,view.center.y);
                         view.backgroundColor = [UIColor clearColor];
                         view.alpha = 1.0;
                     }
                     completion:nil];
}

- (void)dismissWithView:(UIView *)view idx:(NSUInteger)idx initDelay:(CGFloat)initDelay centerX:(CGFloat)x
{
    [UIView animateWithDuration:0.5
                          delay:(initDelay - idx*0.08f)
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         view.center = CGPointMake(x,view.center.y);
                         view.backgroundColor = [UIColor clearColor];
                         view.alpha = 0.0;
                     }
                     completion:nil];
}


#pragma mark wkContextOverlayViewDataSource

- (NSInteger) numberOfMenuItems
{
    return 4;
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
            imageName = @"icon_dataBar";
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
            if (_dismissBlock) {
                _dismissBlock();
            }
            break;
        case 1:
            msg = @"2 Selected";
            [self datePickerButtonClicked];
            break;
        case 2:
            msg = @"3 Selected";
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
}

#pragma mark datePicker

- (void)datePickerButtonClicked
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        typeof(weakself) strongSelf = weakself;
        
        if (!_datePicker) {
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
}


#pragma mark THDatePickerDelegate
-(void)datePickerDonePressed:(THDatePickerViewController *)datePicker selectedDays:(NSMutableDictionary *)selectedDays
{
    [self dismissSemiModalView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSArray* arr = [selectedDays allKeys];
        arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSComparisonResult result = [obj1 compare:obj2];
            return result==NSOrderedDescending;
        }];
        
        if (arr.count > 0) {
            _timeView.fromTime = ((THDateDay *)selectedDays[(NSNumber *)arr[0]]).date;
            _timeView.toTime = ((THDateDay *)selectedDays[[arr lastObject]]).date;
        }
        
        if(_dateChoosedBlock){
            _dateChoosedBlock(_timeView.fromString,_timeView.toString);
        }

    });
   
}

-(void)datePickerCancelPressed:(THDatePickerViewController *)datePicker
{
    [self dismissSemiModalView];
}

//- (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}

@end
