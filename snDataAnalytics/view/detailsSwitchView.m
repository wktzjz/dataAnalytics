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
#import "Colours.h"
#import "BFPaperButton.h"

@implementation detailsSwitchView
{
    FBShimmeringView *_loadingLogo;
    BOOL _ifLoadingLogoShowing;
    
//    flatButton *_dimensionButton;
//    flatButton *_indexButton;
    BFPaperButton *_dimensionButton;
    BFPaperButton *_indexButton;
    
    NSMutableArray *_valueLabelArray;
    NSMutableArray *_labelArray;
}

- (instancetype)initWithFrame:(CGRect)frame
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
        
        _labelArray = [[NSMutableArray alloc] initWithCapacity:10];
        _valueLabelArray = [[NSMutableArray alloc] initWithCapacity:10];

        [self addButtons];
        [self addLoadingView];

    }
    
    return self;
}


- (void)addButtons
{
//    _dimensionButton = [flatButton button];
//    _dimensionButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light"size:20];
//    
//    _dimensionButton.backgroundColor = [UIColor clearColor];
//    _dimensionButton.translatesAutoresizingMaskIntoConstraints = NO;
//    _dimensionButton.textColor = PNTwitterColor;
//    [_dimensionButton setTitle:_dimensionName forState:UIControlStateNormal];
//    [_dimensionButton addTarget:self action:@selector(dimensionButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    [self addSubview:_dimensionButton];
//    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:_dimensionButton
//                                                         attribute:NSLayoutAttributeLeft
//                                                         relatedBy:NSLayoutRelationEqual
//                                                            toItem:self
//                                                         attribute:NSLayoutAttributeLeft
//                                                        multiplier:1.f
//                                                          constant:15.0f]];
//    
//    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:_dimensionButton
//                                                         attribute:NSLayoutAttributeTop
//                                                         relatedBy:NSLayoutRelationEqual
//                                                            toItem:self
//                                                         attribute:NSLayoutAttributeTop
//                                                        multiplier:1.0f
//                                                          constant:-10.f]];
    
    _dimensionButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(0.0, -10.0, self.frame.size.width/2 - 10.0, 40) raised:NO];
    [_dimensionButton setTitle:_dimensionName forState:UIControlStateNormal];
//    [_dimensionButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_dimensionButton setTitleColor:PNTwitterColor forState:UIControlStateNormal];
    [_dimensionButton addTarget:self action:@selector(dimensionButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_dimensionButton];
    
    
    _indexButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2 + 10.0, -10.0, self.frame.size.width/2 - 10.0, 40) raised:NO];
    [_indexButton setTitle:_indexName forState:UIControlStateNormal];
//    [_indexButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [_indexButton setTitleColor:PNTwitterColor forState:UIControlStateNormal];
    [_indexButton addTarget:self action:@selector(indexButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_indexButton];


}

- (void)dimensionButtonClicked
{
    if(_dimensionButtonClickedBlock){
        _dimensionButtonClickedBlock();
    }
}

- (void)indexButtonClicked
{
    if(_indexButtonClickedBlock){
        _indexButtonClickedBlock();
    }
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

- (void)addLabelsWithData:(NSDictionary *)data
{
    assert(_dimensionName);
    _labelStringArray = (NSArray *)(((NSDictionary *)data[_dimensionName])[@"labelStringArray"]);
    [self addLabels];
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
    
    _valueArray = (NSArray *)((NSDictionary *)data[@"labelValues"]);
    [self addValues];
}



#pragma mark add Views

- (void)addLabels
{
    if(_labelStringArray){
        float width = self.frame.size.width/2;
        float centerX = _dimensionButton.center.x;
        
        [_labelStringArray enumerateObjectsUsingBlock:^(NSString *string, NSUInteger idx, BOOL *stop) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35.0, 50 + 40.0 *idx, width, 30)];
            label.text = string;
            label.textColor = PNDeepGrey;
            label.font = [UIFont fontWithName:@"OpenSans-Light" size:18.0];
            label.textAlignment = NSTextAlignmentCenter;
            label.center = CGPointMake(centerX, label.center.y);
            [_labelArray addObject:label];
            [self addSubview:label];
        }];
    }
}

- (void)addValues
{
    if(_valueArray){
        float originX = self.frame.size.width/2 + 10;
        float width = self.frame.size.width/3;
        float centerX = _indexButton.center.x;

        [_valueArray enumerateObjectsUsingBlock:^(NSNumber *value, NSUInteger idx, BOOL *stop) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(originX, 50 + 40.0 *idx, width, 30)];
            label.text = [NSString stringWithFormat:@"%i",value.intValue];
            label.textColor = [UIColor fadedBlueColor];
            label.font = [UIFont fontWithName:@"OpenSans-Light" size:18.0];
            label.textAlignment = NSTextAlignmentCenter;
            label.center = CGPointMake(centerX, label.center.y);

            [_valueLabelArray addObject:label];
            [self addSubview:label];
        }];
    }
}

#pragma mark reload views

- (void)reloadLabelsWithData:(NSDictionary *)data
{
    [_labelArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        [label removeFromSuperview];
    }];
    [_labelArray removeAllObjects];
    
    _labelStringArray = (NSArray *)(((NSDictionary *)data[_dimensionName])[@"labelStringArray"]);
    [self addLabels];
}

- (void)reloadValuesWithData:(NSDictionary *)data
{
    [_valueLabelArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        [label removeFromSuperview];
    }];
    [_valueLabelArray removeAllObjects];
    
    _valueArray = (NSArray *)((NSDictionary *)data[@"labelValues"]);
    [self addValues];
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
