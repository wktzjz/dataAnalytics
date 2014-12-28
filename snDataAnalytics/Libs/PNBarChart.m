//
//  PNBarChart.m
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNBarChart.h"
#import "PNColor.h"
#import "PNChartLabel.h"


@interface PNBarChart () {
    NSMutableArray *_labels;
}

- (UIColor *)barColorAtIndex:(NSUInteger)index;
//wk
- (UIColor *)bar1ColorAtIndex:(NSUInteger)index;
@end

@implementation PNBarChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds   = YES;
        _showLabel           = YES;
        _barBackgroundColor  = PNLightGrey;
        _labelTextColor      = [UIColor grayColor];
        _labelFont           = [UIFont systemFontOfSize:11.0f];
        _labels              = [NSMutableArray array];
        _bars                = [NSMutableArray array];
        _xLabelSkip          = 1;
        _yLabelSum           = 4;
        _labelMarginTop      = 0;
        _chartMargin         = 15.0;
        _barRadius           = 2.0;
        _showChartBorder     = NO;
        _yChartLabelWidth    = 18;
        
        //wk
        _ifUseGradientColor = NO;
        _showReferenceLines = NO;
        _bars1              = [NSMutableArray array];
        _referencesLines    = [NSMutableArray array];
        _labelLineNumber     = 1;
    }

    return self;
}


- (void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    
    if (_yMaxValue) {
        _yValueMax = _yMaxValue;
    }else{
        [self getYValueMax:yValues];
    }
    

    _xLabelWidth = (self.frame.size.width - _chartMargin * 2) / [_yValues count];
}


- (void)getYValueMax:(NSArray *)yLabels
{
    int max = [[yLabels valueForKeyPath:@"@max.intValue"] intValue];
    
    _yValueMax = (int)max;
    
    if (_yValueMax == 0) {
        _yValueMax = _yMinValue;
    }
}


- (void)setYLabels:(NSArray *)yLabels
{
    
}


- (void)setXLabels:(NSArray *)xLabels
{
    _xLabels = xLabels;

    if (_showLabel) {
        _xLabelWidth = (self.frame.size.width - _chartMargin * 2) / [xLabels count];
    }
}


- (void)setStrokeColor:(UIColor *)strokeColor
{
    _strokeColor = strokeColor;
}


- (void)strokeChart
{
    [self viewCleanupForCollection:_labels];
    //Add Labels
    if (_showLabel) {
        //Add x labels
        int labelAddCount = 0;
        for (int index = 0; index < _xLabels.count; index++) {
            labelAddCount += 1;
            
            if (labelAddCount == _xLabelSkip) {
                NSString *labelText = _xLabels[index];
                PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectZero];
                if(_labelLineNumber > 1){
                    label.numberOfLines = _labelLineNumber;
                }
                label.font = _labelFont;
                label.textColor = _labelTextColor;
                [label setTextAlignment:NSTextAlignmentCenter];
                label.text = labelText;
                [label sizeToFit];
                CGFloat labelXPosition  = (index *  _xLabelWidth + _chartMargin + _xLabelWidth /2.0 );
                
                label.center = CGPointMake(labelXPosition,
                                           self.frame.size.height - xLabelHeight - _chartMargin + label.frame.size.height /2.0 + _labelMarginTop);
                labelAddCount = 0;
                
                [_labels addObject:label];
                [self addSubview:label];
            }
        }
        
        //Add y labels
        
        //wk clean refercnce lines
            if (_referencesLines.count) {
                [_referencesLines makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
                [_referencesLines removeAllObjects];
            }
        
        float yLabelSectionHeight = (self.frame.size.height - _chartMargin * 2 - xLabelHeight) / _yLabelSum;
        
        for (int index = 0; index < _yLabelSum; index++) {

            NSString *labelText = _yLabelFormatter((float)_yValueMax * ( (_yLabelSum - index) / (float)_yLabelSum ));
           
            //wk
            float originX = _showChartBorder ? -5.0 : 0.0 ;
            PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(originX,
                                                                                  yLabelSectionHeight * index + _chartMargin - yLabelHeight/2.0,
                                                                                  _yChartLabelWidth,
                                                                                  yLabelHeight)];
            label.font = _labelFont;
            label.textColor = _labelTextColor;
            [label setTextAlignment:NSTextAlignmentRight];
            label.text = labelText;

            [_labels addObject:label];
            [self addSubview:label];
            
            
            //wk add to show reference lines
            if (_showReferenceLines) {
                
                if (index == 0) continue;
                
                CAShapeLayer *referenceLine = [CAShapeLayer layer];
                referenceLine.lineCap      = kCALineCapButt;
                referenceLine.fillColor    = [[UIColor whiteColor] CGColor];
                referenceLine.lineWidth    = 1.0;
                referenceLine.strokeEnd    = 0.0;
                
                UIBezierPath *progressline = [UIBezierPath bezierPath];
                
                [progressline moveToPoint:CGPointMake(label.frame.size.width,yLabelSectionHeight * index + _chartMargin )];
                [progressline addLineToPoint:CGPointMake(self.frame.size.width - _chartMargin,  yLabelSectionHeight * index + _chartMargin )];
                
                [progressline setLineWidth:1.0];
                [progressline setLineCapStyle:kCGLineCapSquare];
                referenceLine.path = progressline.CGPath;
                
                referenceLine.strokeColor = [UIColor colorWithWhite:0.85 alpha:0.7].CGColor;
                
                
                CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
                pathAnimation.duration = 1.2;
                pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                pathAnimation.fromValue = @0.0f;
                pathAnimation.toValue = @1.0f;
                [referenceLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
                
                referenceLine.strokeEnd = 1.0;
                
//                [self animateForLayer:referenceLine isAnimatingReferenceLine:YES];
                
                [self.layer addSublayer:referenceLine];

                [_referencesLines addObject:referenceLine];
            }
        }
    }
    

    [self viewCleanupForCollection:_bars];
    //wk
    [self viewCleanupForCollection:_bars1];
    
    
    //Add bars
    CGFloat chartCavanHeight = self.frame.size.height - _chartMargin * 2 - xLabelHeight;
    NSInteger index = 0;

    for (NSNumber *valueString in _yValues) {
        float value = [valueString floatValue];

        float grade = (float)value / (float)_yValueMax;
        
        if (isnan(grade)) {
            grade = 0;
        }
        
        PNBar *bar;
        CGFloat barWidth;
        CGFloat barXPosition;
        
        if (_barWidth) {
            barWidth = _barWidth;
            barXPosition = index *  _xLabelWidth + _chartMargin + _xLabelWidth /2.0 - _barWidth /2.0;
        }else{
            barXPosition = index *  _xLabelWidth + _chartMargin + _xLabelWidth * 0.25;
            if (_showLabel) {
                barWidth = _xLabelWidth * 0.5;
                
            }
            else {
                barWidth = _xLabelWidth * 0.6;
                
            }
        }
        
        bar = [[PNBar alloc] initWithFrame:CGRectMake(barXPosition, //Bar X position
                                                      self.frame.size.height - chartCavanHeight - xLabelHeight - _chartMargin, //Bar Y position
                                                      barWidth, // Bar witdh
                                                      chartCavanHeight)]; //Bar height
        
        //Change Bar Radius
        bar.barRadius = _barRadius;
        
        //Change Bar Background color
        bar.backgroundColor = _barBackgroundColor;
        
        //Bar StrokColor First
        if (self.strokeColor) {
            bar.barColor = self.strokeColor;
        }else{
            bar.barColor = [self barColorAtIndex:index];
        }
        
        //Height Of Bar
        bar.grade = grade;
        
        //wk add a switch to improve the performance
        // Add gradient
        if (_ifUseGradientColor) {
           bar.barColorGradientStart = _barColorGradientStart;
        }

        //For Click Index
        bar.tag = index;
        
        
        [_bars addObject:bar];
        [self addSubview:bar];

        index += 1;
    }
    //wk add to draw bars1, usually is ratio barChart;
    NSInteger index1 = 0;
    for (NSNumber *valueString in _yValues1) {
        float value = [valueString floatValue];
        
        float grade = (float)value / (float)_yValueMax;
        
        if (isnan(grade)) {
            grade = 0;
        }
        
        PNBar *bar;
        CGFloat barWidth;
        CGFloat barXPosition;
        
        if (_barWidth) {
            barWidth = _barWidth;
            barXPosition = index1 *  _xLabelWidth + _chartMargin + _xLabelWidth /2.0 - _barWidth /2.0;
        }else{
            barXPosition = index1 *  _xLabelWidth + _chartMargin + _xLabelWidth * 0.25;
            if (_showLabel) {
                barWidth = _xLabelWidth * 0.5;
                
            }
            else {
                barWidth = _xLabelWidth * 0.6;
                
            }
        }
        
        bar = [[PNBar alloc] initWithFrame:CGRectMake(barXPosition, //Bar X position
                                                      self.frame.size.height - chartCavanHeight - xLabelHeight - _chartMargin, //Bar Y position
                                                      barWidth, // Bar witdh
                                                      chartCavanHeight)]; //Bar height
        
        //Change Bar Radius
        bar.barRadius = _barRadius;
        
        //Change Bar Background color
        bar.backgroundColor = [UIColor clearColor];
        
        //Bar StrokColor First
        if (self.strokeColor1) {
            bar.barColor = self.strokeColor1;
        }else{
            bar.barColor = [self barColorAtIndex:index1];
        }
        
        //Height Of Bar
        bar.grade = grade;
        
        //wk add a switch to improve the performance
        // Add gradient
//        if (_ifUseGradientColor) {
//            bar.barColorGradientStart = _barColorGradientStart;
//        }
        
        //For Click Index
        bar.tag = index;
        
        
        [_bars1 addObject:bar];
        [self addSubview:bar];
        
        index1 += 1;
    }
    
    //Add chart border lines
    
    if (_showChartBorder) {
        _chartBottomLine = [CAShapeLayer layer];
        _chartBottomLine.lineCap      = kCALineCapButt;
        _chartBottomLine.fillColor    = [[UIColor whiteColor] CGColor];
        _chartBottomLine.lineWidth    = 1.0;
        _chartBottomLine.strokeEnd    = 0.0;
        
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        
        [progressline moveToPoint:CGPointMake(_chartMargin, self.frame.size.height - xLabelHeight - _chartMargin)];
        [progressline addLineToPoint:CGPointMake(self.frame.size.width - _chartMargin,  self.frame.size.height - xLabelHeight - _chartMargin)];
        
        [progressline setLineWidth:1.0];
        [progressline setLineCapStyle:kCGLineCapSquare];
        _chartBottomLine.path = progressline.CGPath;
        
        
        _chartBottomLine.strokeColor = PNLightGrey.CGColor;
        
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 0.5;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = @0.0f;
        pathAnimation.toValue = @1.0f;
        [_chartBottomLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        _chartBottomLine.strokeEnd = 1.0;
        
        [self.layer addSublayer:_chartBottomLine];
        
        //Add left Chart Line
        
        _chartLeftLine = [CAShapeLayer layer];
        _chartLeftLine.lineCap      = kCALineCapButt;
        _chartLeftLine.fillColor    = [[UIColor whiteColor] CGColor];
        _chartLeftLine.lineWidth    = 1.0;
        _chartLeftLine.strokeEnd    = 0.0;
        
        UIBezierPath *progressLeftline = [UIBezierPath bezierPath];
        
        [progressLeftline moveToPoint:CGPointMake(_chartMargin, self.frame.size.height - xLabelHeight - _chartMargin)];
        [progressLeftline addLineToPoint:CGPointMake(_chartMargin,  _chartMargin)];
        
        [progressLeftline setLineWidth:1.0];
        [progressLeftline setLineCapStyle:kCGLineCapSquare];
        _chartLeftLine.path = progressLeftline.CGPath;
        
        
        _chartLeftLine.strokeColor = PNLightGrey.CGColor;
        
        
        CABasicAnimation *pathLeftAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathLeftAnimation.duration = 0.5;
        pathLeftAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathLeftAnimation.fromValue = @0.0f;
        pathLeftAnimation.toValue = @1.0f;
        [_chartLeftLine addAnimation:pathLeftAnimation forKey:@"strokeEndAnimation"];
        
        _chartLeftLine.strokeEnd = 1.0;
        
        [self.layer addSublayer:_chartLeftLine];
    }
    //wk
    else{
        [_chartBottomLine removeFromSuperlayer];
        [_chartLeftLine removeFromSuperlayer];
    }
}

//wk add line animation
- (void)animateForLayer:(CAShapeLayer *)shapeLayer isAnimatingReferenceLine:(BOOL)shouldHalfOpacity
{
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 1.2;
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        [shapeLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
        
        return;
}

- (void)viewCleanupForCollection:(NSMutableArray *)array
{
    if (array.count) {
        [array makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [array removeAllObjects];
    }
}

//wk
- (void)removeLabelView
{
    [self viewCleanupForCollection:_labels];
}


#pragma mark - Class extension methods

- (UIColor *)barColorAtIndex:(NSUInteger)index
{
    if ([self.strokeColors count] == [self.yValues count]) {
        return self.strokeColors[index];
    }
    else {
        return self.strokeColor;
    }
}

- (UIColor *)bar1ColorAtIndex:(NSUInteger)index
{
//    if ([self.strokeColors count] == [self.yValues count]) {
//        return self.strokeColors1[index];
//    }
//    else {
        return self.strokeColor1;
//    }
}

//#pragma mark - Touch detection

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchPoint:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}


- (void)touchPoint:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Get the point user touched
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    UIView *subview = [self hitTest:touchPoint withEvent:nil];
    
    if ([subview isKindOfClass:[PNBar class]] && [self.delegate respondsToSelector:@selector(userClickedOnBarCharIndex:)]) {
        [self.delegate userClickedOnBarCharIndex:subview.tag];
    }
}


@end
