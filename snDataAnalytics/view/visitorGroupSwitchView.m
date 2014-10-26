//
//  visitorGroupSwitchView.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-9.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "visitorGroupSwitchView.h"
#import "PNColor.h"
#import "flatButton.h"
#import <QuartzCore/QuartzCore.h>
#import "Colours.h"

#define sectionHeaderHeight 44.0
#define cellHeight          44.0
#define secondaryCellHeight 44.0

@implementation visitorGroupSwitchView
{
    UILabel *_label;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor whiteColor];
        
        [self addViews];
    }
    
    return self;
}


- (void)addViews
{
    self.mTableView = [[TQMultistageTableView alloc] initWithFrame:self.frame];
    self.mTableView.dataSource = self;
    self.mTableView.delegate   = self;
    self.mTableView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.mTableView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mTableView.bounds.size.width, 100)];
    view.backgroundColor = PNLightGrey;
    _label = [[UILabel alloc] initWithFrame:CGRectMake(30, 7 , self.frame.size.width - 40, 30)];
    _label.textColor = PNTwitterColor;
    _label.font = [UIFont fontWithName:@"OpenSans-Light" size:18.0];
    _label.textAlignment = NSTextAlignmentLeft;
    [view addSubview:_label];
    
    self.mTableView.atomView = view;

}

#pragma mark - TQTableViewDataSource

- (NSInteger)mTableView:(TQMultistageTableView *)mTableView numberOfRowsInSection:(NSInteger)section
{
    if(section != 1){
        return 0;
    }else{
        return 2;
    }
}

- (UITableViewCell *)mTableView:(TQMultistageTableView *)mTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"row:%i",indexPath.row);
    
    if(indexPath.row == 0){
        static NSString *cellIdentifier = @"tableViewCell1";
        UITableViewCell *cell = [mTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            
            UIView *view = [[UIView alloc] initWithFrame:cell.bounds] ;
            view.layer.backgroundColor  = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1].CGColor;
            view.layer.masksToBounds    = YES;
            view.layer.borderWidth      = 0.5;
            view.layer.borderColor        = [UIColor colorWithWhite:0.85 alpha:0.5].CGColor;
            
            cell.backgroundView = view;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 5 , 120, 30)];
            //    label.text =[NSString stringWithFormat:@"新UV:      %i",(arc4random() % 1000)];
            label.textColor = PNTwitterColor;
            label.font = [UIFont fontWithName:@"OpenSans-Light" size:18.0];
            label.textAlignment = NSTextAlignmentLeft;
            
            label.text = @"会员类型";
            //                NSLog(@"会员类型");
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 45, 7, 25, 25)];
            imageView.image = [UIImage imageNamed:@"icon_downArrow"];
            imageView.center = CGPointMake(imageView.center.x, sectionHeaderHeight/2);

            [cell addSubview:label];
            [cell addSubview:imageView];
        }
        return cell;
        
    }else{
        static NSString *cellIdentifier = @"tableViewCell2";
        UITableViewCell *cell = [mTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            
            UIView *view = [[UIView alloc] initWithFrame:cell.bounds] ;
            view.layer.backgroundColor  = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1].CGColor;
            view.layer.masksToBounds    = YES;
            view.layer.borderWidth      = 0.5;
            view.layer.borderColor      = [UIColor colorWithWhite:0.85 alpha:0.5].CGColor;
            
            cell.backgroundView = view;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 5 , 120, 30)];
            //    label.text =[NSString stringWithFormat:@"新UV:      %i",(arc4random() % 1000)];
            label.textColor = PNTwitterColor;
            label.font = [UIFont fontWithName:@"OpenSans-Light" size:18.0];
            label.textAlignment = NSTextAlignmentLeft;
            
            label.text = @"会员等级";
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 45, 7, 25, 25)];
            imageView.image = [UIImage imageNamed:@"icon_downArrow"];
            imageView.center = CGPointMake(imageView.center.x, sectionHeaderHeight/2);
            
            [cell addSubview:label];
            [cell addSubview:imageView];
        }
        return cell;
    }
}

- (UIView *)mTableView:(TQMultistageTableView *)mTableView viewForHeaderInSection:(NSInteger)section;
{
    UIView *header = [[UIView alloc] init];
    
    header.layer.backgroundColor    = [UIColor whiteColor].CGColor;
    header.layer.masksToBounds      = YES;
    header.layer.borderWidth        = 0.5;
    header.layer.borderColor        = [UIColor colorWithWhite:0.85 alpha:0.5].CGColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 7 , self.frame.size.width - 40, 30)];
    label.textColor = PNTwitterColor;
    label.font = [UIFont fontWithName:@"OpenSans-Light" size:18.0];
    label.textAlignment = NSTextAlignmentLeft;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 45, 7, 25, 25)];
    switch (section) {
        case 0:
            label.text =@"访客类型";
            imageView.image = [UIImage imageNamed:@"icon_rightArrow"];
            break;
        case 1:
            label.text =@"会员分析";
            imageView.image = [UIImage imageNamed:@"icon_downArrow"];
            break;
        case 2:
            label.text =@"城市分析";
            imageView.image = [UIImage imageNamed:@"icon_rightArrow"];
            break;
        case 3:
            label.text =@"终端类型";
            imageView.image = [UIImage imageNamed:@"icon_rightArrow"];
            break;
            
        default:
            break;
    }
    label.center = CGPointMake(label.center.x, sectionHeaderHeight/2);
    imageView.center = CGPointMake(imageView.center.x, sectionHeaderHeight/2);
    [header addSubview:label];
    [header addSubview:imageView];
    
    return header;
}


- (NSInteger)numberOfSectionsInTableView:(TQMultistageTableView *)mTableView
{
    return 4;
}

#pragma mark - Table view delegate

- (CGFloat)mTableView:(TQMultistageTableView *)mTableView heightForHeaderInSection:(NSInteger)section
{
    return sectionHeaderHeight;
}

- (CGFloat)mTableView:(TQMultistageTableView *)mTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

- (CGFloat)mTableView:(TQMultistageTableView *)mTableView heightForAtomAtIndexPath:(NSIndexPath *)indexPath
{
    return secondaryCellHeight;
}


#pragma mark - Row Open Or Close

//- (void)mTableView:(TQMultistageTableView *)mTableView willOpenRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"Open Row ----%d",indexPath.row);
//    if(indexPath.row == 0){
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mTableView.bounds.size.width, 100)];
//        view.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];
//        
//        self.mTableView.atomView = view;
//    }else{
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mTableView.bounds.size.width, 100)];
//        view.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];
//        
//        self.mTableView.atomView = view;
//    }
//}

//- (void)mTableView:(TQMultistageTableView *)mTableView willCloseRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"Close Row ----%d",indexPath.row);
//}
//
- (void)mTableView:(TQMultistageTableView *)mTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRow ----%d",indexPath.row);
    if(indexPath.row == 0){
        _label.text = @" 整体 新会员 老会员";
    }else{
       _label.text = @" 普通会员 银卡会员 金卡会员 白金会员";
    }
}
//
//#pragma mark - Header Open Or Close
//
- (void)mTableView:(TQMultistageTableView *)mTableView willOpenHeaderAtSection:(NSInteger)section
{
    NSLog(@"Open Header ----%d",section);
    
}

- (void)mTableView:(TQMultistageTableView *)mTableView didSelectHeaderAtSection:(NSInteger)section
{
    if(section == 0){
        if(self.switchAction){
            self.switchAction(section);
        }
    }else if (section == 2){
        if(self.switchAction){
            self.switchAction(1);
        }
    }
}


//- (void)mTableView:(TQMultistageTableView *)mTableView willCloseHeaderAtSection:(NSInteger)section
//{
//    NSLog(@"Close Header ---%d",section);
//}

@end
