//
//  detailsSwitchView.m
//  snDataAnalytics
//
//  Created by wktzjz on 14-10-31.
//  Copyright (c) 2014年 wktzjz. All rights reserved.
//

#import "detailsSwitchView.h"
#import "flatButton.h"
#import "FBShimmeringView.h"
#import "PNColor.h"


@implementation detailsSwitchView
{
    FBShimmeringView *_loadingLogo;
    BOOL _ifLoadingLogoShowing;
    
    flatButton *_dimensionButton;
    flatButton *_indexButton;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor whiteColor];
        _dimensionName = @"维度";
        _indexName = @"指标";
        
        _dimensionOptionsArray = [[NSArray alloc] init];
        _indexOptionsArray = [[NSArray alloc] init];
        _labelStringArray = [[NSArray alloc] init];
        _valueArray = [[NSArray alloc] init];
        
        [self addButtons];
        [self addLoadingView];

    }
    
    return self;
}


- (void)addButtons
{
    _dimensionButton = [flatButton button];
    _dimensionButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light"size:20];
    
    _dimensionButton.backgroundColor = [UIColor clearColor];
    _dimensionButton.translatesAutoresizingMaskIntoConstraints = NO;
    _dimensionButton.textColor = PNTwitterColor;
    [_dimensionButton setTitle:_dimensionName forState:UIControlStateNormal];
//    [_dimensionButton addTarget:self action:@selector(settingButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_dimensionButton];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_dimensionButton
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.f
                                                          constant:20.0f]];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_dimensionButton
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0f
                                                          constant:5.f]];
    
    _indexButton = [flatButton button];
    _indexButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light"size:20];
    
    _indexButton.backgroundColor = [UIColor clearColor];
    _indexButton.translatesAutoresizingMaskIntoConstraints = NO;
    _indexButton.textColor = PNTwitterColor;
    [_indexButton setTitle:_indexName forState:UIControlStateNormal];
//    [_indexButton addTarget:self action:@selector(settingButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_indexButton];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_indexButton
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.f
                                                      constant:-20.0f]];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_indexButton
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0f
                                                      constant:5.f]];


}

- (void)addLoadingView
{
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.frame.size.width - 20, 50)];
    [text setText:@"Loading"];
    [text setTextColor:[UIColor blackColor]];
    text.font = [UIFont boldSystemFontOfSize:33];
    text.textAlignment = NSTextAlignmentCenter;
    
    _loadingLogo = [[FBShimmeringView alloc] initWithFrame:CGRectMake(20, 100, self.frame.size.width - 20, 50)];
    _loadingLogo.contentView = text;
    _loadingLogo.shimmeringSpeed = 180;
    _loadingLogo.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _loadingLogo.shimmering = YES;
    
    [self addSubview:_loadingLogo];
    _ifLoadingLogoShowing = YES;
}

- (void)addViewsWithData:(NSDictionary *)data
{
    if(_ifLoadingLogoShowing){
        [UIView animateWithDuration:0.7 animations:^{
            _loadingLogo.alpha = 0.0;
        } completion:^(BOOL finished) {
            _ifLoadingLogoShowing = NO;
            [_loadingLogo removeFromSuperview];
        }];
    }
    
    _labelStringArray = (NSArray *)((NSDictionary *)data[@"访客类型"])[@"labelStringArray"];
    [self addLabels];
    [self addValues];
}

- (void)addLabels
{
    if(_labelStringArray){
        float width = self.frame.size.width/2;
        
        [_labelStringArray enumerateObjectsUsingBlock:^(NSString *string, NSUInteger idx, BOOL *stop) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 70 + 40.0 *idx, width, 30)];
            label.text = string;
            label.textColor = PNDeepGrey;
            label.font = [UIFont fontWithName:@"OpenSans-Light" size:18.0];
            label.textAlignment = NSTextAlignmentLeft;
            
            [self addSubview:label];
 
        }];
    }
}

- (void)addValues
{
    if(_valueArray){
        float originX = self.frame.size.width/2;
        float width = self.frame.size.width/2;

        [_valueArray enumerateObjectsUsingBlock:^(NSNumber *value, NSUInteger idx, BOOL *stop) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(originX, 70 + 10.0 *idx, width, 30)];
            label.text = [NSString stringWithFormat:@"%i",value.intValue];
            label.textColor = PNDeepGrey;
            label.font = [UIFont fontWithName:@"OpenSans-Light" size:18.0];
            label.textAlignment = NSTextAlignmentLeft;
            
            [self addSubview:label];
        }];
    }
}

- (void)setDimensionName:(NSString *)dimensionName
{
    _dimensionName = dimensionName;
    [_dimensionButton setTitle:dimensionName forState:UIControlStateNormal];
}

- (void)setIndexName:(NSString *)indexName
{
    _indexName = indexName;
    [_indexButton setTitle:indexName forState:UIControlStateNormal];
}


@end
