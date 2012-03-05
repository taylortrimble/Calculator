//
//  CalculatorGraphView.m
//  GraphingCalculator
//
//  Created by Taylor Trimble on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorGraphView.h"
#import "CalculatorGraphViewController.h"

@interface CalculatorGraphView ()

- (CGFloat)convertDomainValue:(double)x;
- (CGFloat)convertRangeValue:(double)y;
- (CGFloat)xAxisOffset;
- (CGFloat)yAxisOffset;

@end

@implementation CalculatorGraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *xAxis = [UIBezierPath bezierPath];
    [xAxis moveToPoint:CGPointZero];
    [xAxis addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds), 0)];
    
    UIBezierPath *yAxis = [UIBezierPath bezierPath];
    [yAxis moveToPoint:CGPointZero];
    [yAxis addLineToPoint:CGPointMake(0, CGRectGetMaxY(self.bounds))];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor lightGrayColor] setStroke];
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, [self xAxisOffset]);
    [xAxis stroke];
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, [self yAxisOffset], 0);
    [yAxis stroke];
    CGContextRestoreGState(context);
}

#pragma mark - Private methods

- (CGFloat)convertDomainValue:(double)x
{
    double maxX = CGRectGetMaxX([self.dataSource graphingWindow]);
    double minX = CGRectGetMinX([self.dataSource graphingWindow]);
    
    return (maxX-x)/(maxX-minX)*CGRectGetWidth(self.bounds);
}

- (CGFloat)convertRangeValue:(double)y
{
    double maxY = CGRectGetMaxY([self.dataSource graphingWindow]);
    double minY = CGRectGetMinY([self.dataSource graphingWindow]);
    
    return (maxY-y)/(maxY-minY)*CGRectGetHeight(self.bounds);
}

- (CGFloat)xAxisOffset
{
    CGFloat offset = [self convertRangeValue:0];
    CGFloat minAllowed = CGRectGetMinY(self.bounds);
    CGFloat maxAllowed = CGRectGetMaxY(self.bounds);
    
    return offset<minAllowed?minAllowed:(offset>maxAllowed?maxAllowed:offset);  // Offset is in valid range
}

- (CGFloat)yAxisOffset
{
    CGFloat offset = [self convertDomainValue:0];
    CGFloat minAllowed = CGRectGetMinX(self.bounds);
    CGFloat maxAllowed = CGRectGetMaxX(self.bounds);
    
    return offset<minAllowed?minAllowed:(offset>maxAllowed?maxAllowed:offset);  // Offset is in valid range
}

@end
