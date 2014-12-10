//
//  THDatePickerViewController.m
//  THCalendarDatePicker
//
//  Created by chase wasden on 2/10/13.
//  Adapted by Hannes Tribus on 31/07/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "THDatePickerViewController.h"

#ifdef DEBUG
//static int FIRST_WEEKDAY = 2;
#endif

@interface THDatePickerViewController () {
    int _weeksOnCalendar;
    int _bufferDaysBeginning;
    int _daysInMonth;
    NSDate * _dateNoTime;
    NSCalendar * _calendar;
    BOOL _allowClearDate;
    BOOL _autoCloseOnSelectDate;
    BOOL _disableFutureSelection;
    BOOL (^_dateHasItemsCallback)(NSDate *);
    NSDateComponents *_comps;
    
    //wk
    NSMutableArray *_shownDays;
    NSMutableArray *_shownDaysWithRepetition;
    NSMutableArray *_shownDaysTag;
    
    NSMutableArray *_selectedDaysTag;

    THDateDay *_lastSelectedDay;
}
@property (nonatomic, strong) NSDate * firstOfCurrentMonth;
@property (nonatomic, strong) THDateDay * currentDay;
@property (nonatomic, strong) NSDate * internalDate;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *prevBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (strong, nonatomic) IBOutlet UIView *calendarDaysView;
@property (weak, nonatomic) IBOutlet UIView *weekdaysView;

- (IBAction)nextMonthPressed:(id)sender;
- (IBAction)prevMonthPressed:(id)sender;
- (IBAction)okPressed:(id)sender;
- (IBAction)clearPressed:(id)sender;
- (IBAction)closePressed:(id)sender;

- (void)redraw;

@end

@implementation THDatePickerViewController
@synthesize date = _date;
@synthesize selectedBackgroundColor = _selectedBackgroundColor;
@synthesize currentDateColor = _currentDateColor;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        _allowClearDate = NO;
        _disableFutureSelection = NO;
        //wk
        _selectedDaysArray = [[NSMutableDictionary alloc] init];
        _shownDays         = [[NSMutableArray alloc] initWithCapacity:10];
        _shownDaysWithRepetition = [[NSMutableArray alloc] initWithCapacity:10];

        _shownDaysTag      = [[NSMutableArray alloc] initWithCapacity:10];
        _selectedDaysTag   = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

+(THDatePickerViewController *)datePicker{
    return [[THDatePickerViewController alloc] initWithNibName:@"THDatePickerViewController" bundle:nil];
}

- (void)setAllowClearDate:(BOOL)allow
{
    _allowClearDate = allow;
}

- (void)setAutoCloseOnSelectDate:(BOOL)autoClose
{
    [self setAllowClearDate:!autoClose];
    _autoCloseOnSelectDate = autoClose;
}

- (void)setDisableFutureSelection:(BOOL)disableFutureSelection
{
    _disableFutureSelection = disableFutureSelection;
}

#pragma mark - View Management

- (void)viewDidLoad
{
    [self configureButtonAppearances];
    if (_allowClearDate) [self showClearButton];
    else [self hideClearButton];
    [self addSwipeGestures];
 //   wk
    self.okBtn.enabled = YES;

//    self.okBtn.enabled = [self shouldOkBeEnabled];
    [self.okBtn setImage:[UIImage imageNamed:(_autoCloseOnSelectDate ? @"dialog_clear.png" : @"dialog_ok.png")] forState:UIControlStateNormal];
    [self redraw];
}

- (void)addSwipeGestures{
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self.calendarDaysView addGestureRecognizer:swipeGesture];
    
    UISwipeGestureRecognizer *swipeGesture2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeGesture2.direction = UISwipeGestureRecognizerDirectionDown;
    [self.calendarDaysView addGestureRecognizer:swipeGesture2];
}

- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)sender{
    //Gesture detect - swipe up/down , can be recognized direction
    if (sender.direction == UISwipeGestureRecognizerDirectionUp) {
        [self incrementMonth:1];
        [self slideTransitionViewInDirection:1];
    }
    else if (sender.direction == UISwipeGestureRecognizerDirectionDown) {
        [self incrementMonth:-1];
        [self slideTransitionViewInDirection:-1];
    }
}

- (void)configureButtonAppearances {
    [super viewDidLoad];
    [[self.nextBtn imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [[self.prevBtn imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [[self.clearBtn imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [[self.closeBtn imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [[self.okBtn imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    UIImage * img = [self imageOfColor:[UIColor colorWithWhite:.8 alpha:1]];
    [self.clearBtn setBackgroundImage:img forState:UIControlStateHighlighted];
    [self.closeBtn setBackgroundImage:img forState:UIControlStateHighlighted];
    [self.okBtn setBackgroundImage:img forState:UIControlStateHighlighted];
    
    img = [self imageOfColor:[UIColor colorWithWhite:.94 alpha:1]];
    [self.nextBtn setBackgroundImage:img forState:UIControlStateHighlighted];
    [self.prevBtn setBackgroundImage:img forState:UIControlStateHighlighted];
}

- (UIImage *) imageOfColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)setDateHasItemsCallback:(BOOL (^)(NSDate * date))callback {
    _dateHasItemsCallback = callback;
}

#pragma mark - Redraw Dates

- (void)redraw{
//    if (!self.firstOfCurrentMonth) {
//       [self setDisplayedMonthFromDate:[NSDate date]];
//    }
    for(UIView * view in self.calendarDaysView.subviews) { // clean view
        [view removeFromSuperview];
    }
    [self redrawDays];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM yyyy"];
    NSString *monthName = [formatter stringFromDate:self.firstOfCurrentMonth];
    self.monthLabel.text = monthName;
}

- (void)redrawDays {
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:-_bufferDaysBeginning];
    NSDate * date = [_calendar dateByAddingComponents:offsetComponents toDate:self.firstOfCurrentMonth options:0];
    [offsetComponents setDay:1];
    UIView * container = self.calendarDaysView;
    CGRect containerFrame = container.frame;
    int areaWidth = containerFrame.size.width;
    int areaHeight = containerFrame.size.height;
    int cellWidth = areaWidth/7;
    int cellHeight = areaHeight/_weeksOnCalendar;
    int days = _weeksOnCalendar*7;
    int curY = (areaHeight - cellHeight*_weeksOnCalendar)/2;
    int origX = (areaWidth - cellWidth*7)/2;
    int curX = origX;
    [self redrawWeekdays:cellWidth];
    //wk
//    [_shownDays removeAllObjects];
    
    for(int i = 0; i < days; i++) {
        // @beginning
        if (i && !(i%7)) {
            curX = origX;
            curY += cellHeight;
        }
        
        THDateDay * day = [[[NSBundle mainBundle] loadNibNamed:@"THDateDay" owner:self options:nil] objectAtIndex:0];
        if (self.currentDateColor)
            [day setCurrentDateColor:self.currentDateColor];
        if (self.selectedBackgroundColor)
            [day setSelectedBackgroundColor:self.selectedBackgroundColor];
        [day setLightText:![self dateInCurrentMonth:date]];
        [day setEnabled:![self dateInFutureAndShouldBeDisabled:date]];
        day.frame = CGRectMake(curX, curY, cellWidth, cellHeight);
        day.delegate = self;
        day.date = [date dateByAddingTimeInterval:0];
        [day indicateDayHasItems:(_dateHasItemsCallback && _dateHasItemsCallback(date))];
        
        if (_internalDate && ![date timeIntervalSinceDate:_internalDate]) {
            //wk
//            [day setSelected:YES];
            [day.dateButton setTitleColor:self.currentDateColor forState:/*selected ? UIControlStateSelected :*/ UIControlStateNormal];
            self.currentDay = day;
        }
        
        _comps =[_calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit)
                             fromDate:day.date];
        NSInteger month = [_comps month];
        NSInteger day1 = [_comps day];
        day.dayTag = month*100 + day1;
        
        //wk 遍历新生成的days，如果day的dayTag在_selectedDaysArray中有，表明这个day被选中，删除旧的day，添加新的day
//        [_selectedDaysArray enumerateObjectsUsingBlock:^(THDateDay *storedDay, NSUInteger idx, BOOL *stop) {
//            if (storedDay.dayTag == day.dayTag) {
//                [day setSelected:YES];
//                [_selectedDaysArray removeObject:storedDay];
//                [_selectedDaysArray addObject:day];
//            }
//        }];
        if (_selectedDaysArray[@(day.dayTag)]) {
            [day setSelected:YES];
            _selectedDaysArray[@(day.dayTag)] = day;
        }
        
        NSDateComponents *comps = [_calendar components:NSDayCalendarUnit fromDate:date];
        [day.dateButton setTitle:[NSString stringWithFormat:@"%ld",(long)[comps day]]
                        forState:UIControlStateNormal];
        [self.calendarDaysView addSubview:day];
        
        //wk
//        day.orderTag = i;
//        if (![_shownDaysTag containsObject:@(day.dayTag)]) {
            [_shownDays addObject:day];
//            [_shownDaysTag addObject:@(day.dayTag)];
//        }
        [_shownDaysWithRepetition addObject:day];
        
        // @end
        date = [_calendar dateByAddingComponents:offsetComponents toDate:date options:0];
        curX += cellWidth;
    }
}

- (void)redrawWeekdays:(int)dayWidth{
    if (!self.weekdaysView.subviews.count) {
        CGSize fullSize = self.weekdaysView.frame.size;
        int curX = (fullSize.width - 7*dayWidth)/2;
        NSDateComponents * comps = [_calendar components:NSDayCalendarUnit fromDate:[NSDate date]];
        NSCalendar *c = [NSCalendar currentCalendar];
#ifdef DEBUG
        //[c setFirstWeekday:FIRST_WEEKDAY];
#endif
        [comps setDay:[c firstWeekday]-1];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        [offsetComponents setDay:1];
        [df setDateFormat:@"EE"];
        NSDate * date = [_calendar dateFromComponents:comps];
        for(int i = 0; i < 7; i++) {
            UILabel * dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(curX, 0, dayWidth, fullSize.height)];
            dayLabel.textAlignment = NSTextAlignmentCenter;
            dayLabel.font = [UIFont systemFontOfSize:12];
            [self.weekdaysView addSubview:dayLabel];
            dayLabel.text = [df stringFromDate:date];
            dayLabel.textColor = [UIColor grayColor];
            date = [_calendar dateByAddingComponents:offsetComponents toDate:date options:0];
            curX+=dayWidth;
        }
    }
}

#pragma mark - Date Set, etc.

- (void)setDate:(NSDate *)date{
    _date = date;
    _dateNoTime = !date ? nil : [self dateWithOutTime:date];
    self.internalDate = [_dateNoTime dateByAddingTimeInterval:0];
}

- (NSDate *)date{
    if (!self.internalDate) return nil;
    else if (!_date) return self.internalDate;
    else {
        int ymd = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
        NSDateComponents* internalComps = [_calendar components:ymd fromDate:self.internalDate];
        int time = NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSTimeZoneCalendarUnit;
        NSDateComponents* origComps = [_calendar components:time fromDate:_date];
        [origComps setDay:[internalComps day]];
        [origComps setMonth:[internalComps month]];
        [origComps setYear:[internalComps year]];
        return [_calendar dateFromComponents:origComps];
    }
}

- (BOOL)shouldOkBeEnabled
{
    if (_autoCloseOnSelectDate)
        return YES;
    float diff = [self.internalDate timeIntervalSinceDate:_dateNoTime];
    return (self.internalDate && _dateNoTime && diff != 0)
    || (self.internalDate && !_dateNoTime)
    || (!self.internalDate && _dateNoTime);
}

- (void)setInternalDate:(NSDate *)internalDate{
    _internalDate = internalDate;
    self.clearBtn.enabled = !!internalDate;
//    self.okBtn.enabled = [self shouldOkBeEnabled];
    self.okBtn.enabled = YES;
    if (internalDate) {
        [self setDisplayedMonthFromDate:internalDate];
    }
    else {
        [self.currentDay setSelected:NO];
        self.currentDay =  nil;
    }
}

- (void)setDisplayedMonth:(int)month year:(int)year{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM"];
    self.firstOfCurrentMonth = [df dateFromString: [NSString stringWithFormat:@"%d-%@%d", year, (month<10?@"0":@""), month]];
    [self storeDateInformation];
}

- (void)setDisplayedMonthFromDate:(NSDate *)date{
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:date];
    [self setDisplayedMonth:(int)[comps month] year:(int)[comps year]];
}

- (void)storeDateInformation{
    NSDateComponents *comps = [_calendar components:NSWeekdayCalendarUnit | NSDayCalendarUnit fromDate:self.firstOfCurrentMonth];
    NSCalendar *c = [NSCalendar currentCalendar];
#ifdef DEBUG
    //[c setFirstWeekday:FIRST_WEEKDAY];
#endif
    NSRange days = [c rangeOfUnit:NSDayCalendarUnit
                           inUnit:NSMonthCalendarUnit
                          forDate:self.firstOfCurrentMonth];
    
    int bufferDaysBeginning = (int)([comps weekday]-[c firstWeekday]);
    // % 7 is not working for negative numbers
    // http://stackoverflow.com/questions/989943/weird-objective-c-mod-behavior-for-negative-numbers
    if (bufferDaysBeginning < 0)
        bufferDaysBeginning += 7;
    int daysInMonthWithBuffer = (int)(days.length + bufferDaysBeginning);
    int numberOfWeeks = daysInMonthWithBuffer / 7;
    if (daysInMonthWithBuffer % 7) numberOfWeeks++;
    
    _weeksOnCalendar = 6;
    _bufferDaysBeginning = bufferDaysBeginning;
    _daysInMonth = (int)days.length;
}

- (void)incrementMonth:(int)incrValue{
//    NSLog(@"incrValue:%i",incrValue);
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:incrValue];
    NSDate * incrementedMonth = [_calendar dateByAddingComponents:offsetComponents toDate:self.firstOfCurrentMonth options:0];
    [self setDisplayedMonthFromDate:incrementedMonth];
}

#pragma mark - User Events

- (void)dateDayTapped:(THDateDay *)dateDay{
    //wk
//    if ([_selectedDaysArray containsObject:dateDay]) {
    if (_selectedDaysArray[@(dateDay.dayTag)]) {
//        [dateDay setSelected:NO];
//        [_selectedDaysArray removeObject:dateDay];
        
    }else{
        _comps =[_calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit)
                           fromDate:dateDay.date];
        NSInteger month = [_comps month];
        NSInteger day = [_comps day];
        dateDay.dayTag = month * 100 + day;
        
        if (!_lastSelectedDay) {
            _lastSelectedDay = dateDay;
        }
//        [_selectedDaysArray addObject:dateDay];
        [_selectedDaysArray setObject:dateDay forKey:@(dateDay.dayTag)];
        [dateDay setSelected:YES];
//        if (![self dateInCurrentMonth:dateDay.date]) {
//            double direction = [dateDay.date timeIntervalSinceDate:self.firstOfCurrentMonth];
//            self.internalDate = dateDay.date;
//            [self slideTransitionViewInDirection:direction];
//        }
//        else
//            if (!_internalDate || [_internalDate timeIntervalSinceDate:dateDay.date]) { // new date selected
//            [self.currentDay setSelected:NO];
        
        for (THDateDay *day in _shownDays) {
            
            if ((day.dayTag < _lastSelectedDay.dayTag && day.dayTag > dateDay.dayTag) || (day.dayTag > _lastSelectedDay.dayTag && day.dayTag < dateDay.dayTag)) {
                
                [day setSelected:YES];
                [_selectedDaysArray setObject:day forKey:@(day.dayTag)];
            }
        }
        
//        NSLog(@"before _selectedDaysArray count:%i",(int)_selectedDaysArray.count);
//        __block THDateDay *lastDay;
//        [_selectedDaysArray enumerateObjectsUsingBlock:^(THDateDay *day, NSUInteger idx, BOOL *stop) {
//            if (idx == 0) {
//                lastDay = day;
//            }else{
//                lastDay = _selectedDaysArray[idx - 1];
//                if (lastDay.dayTag == day.dayTag) {
//                    [_selectedDaysArray removeObject:lastDay];
//                }
//            }
//        }];
//         NSLog(@"after _selectedDaysArray count:%i",(int)_selectedDaysArray.count);
//        for(THDateDay *storedDay in _selectedDaysArray) {
////            NSLog(@"_selectedDaysArrayday.dayTag:%i",(int)day.dayTag);
//            for (THDateDay *day in _shownDaysWithRepetition) {
//                if (storedDay.dayTag == day.dayTag) {
//                        [day setSelected:YES];
//                    
//                }
//            }
//        }
//             [dateDay setSelected:YES];
//            self.internalDate = dateDay.date;
            self.currentDay = dateDay;
            if (_autoCloseOnSelectDate) {
                [self.delegate datePickerDonePressed:self];
            }
//        }
    }
}

- (void)slideTransitionViewInDirection:(int)dir
{
    dir = dir < 1 ? -1 : 1;
    CGRect origFrame = self.calendarDaysView.frame;
    CGRect outDestFrame = origFrame;
    outDestFrame.origin.y -= 20*dir;
    CGRect inStartFrame = origFrame;
    inStartFrame.origin.y += 20*dir;
    UIView *oldView = self.calendarDaysView;
    UIView *newView = self.calendarDaysView = [[UIView alloc] initWithFrame:inStartFrame];
    [oldView.superview addSubview:newView];
    [self addSwipeGestures];
    newView.alpha = 0;
    [self redraw];
    [UIView animateWithDuration:.2 animations:^{
        newView.frame = origFrame;
        newView.alpha = 1;
        oldView.frame = outDestFrame;
        oldView.alpha = 0;
    } completion:^(BOOL finished) {
        [oldView removeFromSuperview];
    }];
    
    //wk
//    if (dir == -1) {
//        for (THDateDay *day in _selectedDaysArray) {
//            NSLog(@"day.date:%@",day.date);
//            [day setSelected:YES];
//        }
//    }
}

- (IBAction)nextMonthPressed:(id)sender
{
    [self incrementMonth:1];
    [self slideTransitionViewInDirection:1];
}

- (IBAction)prevMonthPressed:(id)sender
{
    [self incrementMonth:-1];
    [self slideTransitionViewInDirection:-1];
}

- (IBAction)okPressed:(id)sender {
//    if (self.okBtn.enabled) {
        if (_autoCloseOnSelectDate) {
            [self setDate:[NSDate date]];
            [self redraw];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.delegate datePickerDonePressed:self selectedDays:_selectedDaysArray];
            });
        } else {
            [self.delegate datePickerDonePressed:self selectedDays:_selectedDaysArray];
        }
//    }
}

- (IBAction)clearPressed:(id)sender {
    if (self.clearBtn.enabled) {
//        for (THDateDay *day in _shownDays) {
//            [day setSelected:NO];
//        }
        [_selectedDaysArray enumerateKeysAndObjectsUsingBlock:^(NSNumber *tag, THDateDay *day, BOOL *stop) {
            [day setSelected:NO];
        }];
        [_selectedDaysArray removeAllObjects];
//        [_selectedDaysTag removeAllObjects];
        
        _lastSelectedDay = nil;
//        self.internalDate = nil;
//        [self.currentDay setSelected:NO];
//        self.currentDay = nil;
    }
}

- (IBAction)closePressed:(id)sender {
    [_selectedDaysArray enumerateKeysAndObjectsUsingBlock:^(NSNumber *tag, THDateDay *day, BOOL *stop) {
        [day setSelected:NO];
    }];
    [_selectedDaysArray removeAllObjects];
    _lastSelectedDay = nil;
    
    [self.delegate datePickerCancelPressed:self];
//    //wk
//    [_selectedDaysArray enumerateObjectsUsingBlock:^(THDateDay *selectedDay, NSUInteger idx, BOOL *stop) {
//        [selectedDay setSelected:NO];
//    }];
//    [_selectedDaysArray removeAllObjects];
}

#pragma mark - Hide/Show Clear Button

- (void) showClearButton {
    int width = self.view.frame.size.width;
    int buttonHeight = 37;
    int buttonWidth = (width-20)/3;
    int curX = (width - buttonWidth*3 - 10)/2;
    self.closeBtn.frame = CGRectMake(curX, 5, buttonWidth, buttonHeight);
    curX+=buttonWidth+5;
    self.clearBtn.frame = CGRectMake(curX, 5, buttonWidth, buttonHeight);
    curX+=buttonWidth+5;
    self.okBtn.frame = CGRectMake(curX, 5, buttonWidth, buttonHeight);
}

- (void) hideClearButton {
    int width = self.view.frame.size.width;
    int buttonHeight = 37;
    self.clearBtn.hidden = YES;
    int buttonWidth = (width-15)/2;
    int curX = (width - buttonWidth*2 - 5)/2;
    self.closeBtn.frame = CGRectMake(curX, 5, buttonWidth, buttonHeight);
    curX+=buttonWidth+5;
    self.okBtn.frame = CGRectMake(curX, 5, buttonWidth, buttonHeight);
}

#pragma mark - Date Utils

- (BOOL)dateInFutureAndShouldBeDisabled:(NSDate *)dateToCompare
{
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
    currentDate = [calendar dateFromComponents:[calendar components:comps fromDate:currentDate]];
    dateToCompare = [calendar dateFromComponents:[calendar components:comps fromDate:dateToCompare]];
    return ([currentDate compare:dateToCompare] == NSOrderedAscending && _disableFutureSelection);
}

- (BOOL)dateInCurrentMonth:(NSDate *)date{
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [_calendar components:unitFlags fromDate:self.firstOfCurrentMonth];
    NSDateComponents* comp2 = [_calendar components:unitFlags fromDate:date];
    return [comp1 year]  == [comp2 year] && [comp1 month] == [comp2 month];
}

- (NSDate *)dateWithOutTime:(NSDate *)datDate {
    if ( datDate == nil ) {
        datDate = [NSDate date];
    }
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:datDate];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

#pragma mark - Cleanup

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
