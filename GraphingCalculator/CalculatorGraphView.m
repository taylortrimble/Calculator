//
//  CalculatorGraphView.m
//  GraphingCalculator
//
//  Created by Taylor Trimble on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorGraphView.h"
#import "CalculatorGraphViewController.h"
#import "CalculatorScaleGestureRecognizer.h"


#define NUMBER_OF_X_TICKS 4
#define NUMBER_OF_Y_TICKS 4
#define TICK_HEIGHT 10.0

@interface CalculatorGraphView () <UIGestureRecognizerDelegate>

- (void)handleScaleGesture:(CalculatorScaleGestureRecognizer *)sender;
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)sender;
- (void)handlePanGesture:(UIPanGestureRecognizer *)sender;

- (CGFloat)convertDomainValue:(double)x;
- (CGFloat)convertRangeValue:(double)y;
- (CGFloat)xAxisOffset;
- (CGFloat)yAxisOffset;

- (NSArray *)xTicks;
- (NSArray *)yTicks;

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

- (void)awakeFromNib
{
//    CalculatorScaleGestureRecognizer *scaleGestureRecognizer = [[CalculatorScaleGestureRecognizer alloc] init];
//    [scaleGestureRecognizer addTarget:self action:@selector(handleScaleGesture:)];
//    [self addGestureRecognizer:scaleGestureRecognizer];
    
    [self addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)]];
    [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)]];
    
    for (UIGestureRecognizer *gestureRecognizer in self.gestureRecognizers) {
        gestureRecognizer.delegate = self;
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Bezier paths
    UIBezierPath *xAxis = [UIBezierPath bezierPath];
    [xAxis moveToPoint:CGPointZero];
    [xAxis addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds), 0.0)];
    
    UIBezierPath *yAxis = [UIBezierPath bezierPath];
    [yAxis moveToPoint:CGPointZero];
    [yAxis addLineToPoint:CGPointMake(0.0, CGRectGetMaxY(self.bounds))];
    
    UIBezierPath *tick = [UIBezierPath bezierPath];
    [tick moveToPoint:CGPointMake(0.0, 0.0)];
    [tick addLineToPoint:CGPointMake(0.0, TICK_HEIGHT)];
    
    // Function
    double minX = CGRectGetMinX([self.dataSource graphingWindow]);
    UIBezierPath *function = [UIBezierPath bezierPath];
    [function moveToPoint:CGPointMake([self convertDomainValue:minX],
                                      [self convertRangeValue:[self.dataSource valueForInput:minX]])];
    double widthInPixels = CGRectGetWidth(self.bounds)*self.contentScaleFactor;
    double xDiv = CGRectGetWidth([self.dataSource graphingWindow]) / widthInPixels;
    for (NSUInteger index = 1; index <= widthInPixels; index++) {
        CGPoint point = CGPointMake([self convertDomainValue:minX+index*xDiv],
                                    [self convertRangeValue:[self.dataSource valueForInput:minX+index*xDiv]]);
        
        [function addLineToPoint:point];
    }
    
    // Context
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor lightGrayColor] setStroke];
    
    // Draw axes
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0.0, [self convertRangeValue:0.0]);
    [xAxis stroke];
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, [self convertDomainValue:0.0], 0.0);
    [yAxis stroke];
    CGContextRestoreGState(context);
    
    // Draw ticks
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0.0, [self xAxisOffset]-TICK_HEIGHT/2);
    for (NSNumber *tickOffset in [self xTicks]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, [tickOffset doubleValue], 0.0);
        [tick stroke];
        CGContextRestoreGState(context);
    }
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextRotateCTM(context, M_PI_2/1.0);
    CGContextTranslateCTM(context, 0, -[self yAxisOffset]-TICK_HEIGHT/2);
    for (NSNumber *tickOffset in [self yTicks]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, [tickOffset doubleValue], 0.0);
        [tick stroke];
        CGContextRestoreGState(context);
    }
    CGContextRestoreGState(context);
    
    // Draw function
    [[UIColor blueColor] setStroke];
    [function stroke];
}

#pragma mark - Gesture handlers

- (void)handleScaleGesture:(CalculatorScaleGestureRecognizer *)sender
{
    NSLog(@"xS=%#.3g, yS=%#.3g, xT=%#.3g, yT=%#.3g", sender.xScale, sender.yScale, sender.xOriginTranslation, sender.yOriginTranslation);
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)sender
{
    
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender
{
    
}

#pragma mark Gesture recognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

#pragma mark - Private methods

- (CGFloat)convertDomainValue:(double)x
{
    double maxX = CGRectGetMaxX([self.dataSource graphingWindow]);
    double minX = CGRectGetMinX([self.dataSource graphingWindow]);
    
    return (minX-x)/(minX-maxX)*CGRectGetWidth(self.bounds);
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

- (NSArray *)xTicks
{
    NSMutableArray *xTicks = [NSMutableArray array];
    
    CGFloat xDiv = CGRectGetWidth([self.dataSource graphingWindow])/NUMBER_OF_X_TICKS;
    NSInteger power;
    if (xDiv >= 1.0) {
        for (power = -1; xDiv > 1.0; power++) {
            xDiv = xDiv/10.0;
        }
    } else {
        for (power = 0; xDiv < 1.0; power--) {
            xDiv = xDiv*10.0;
        }
    }
    
    // Need to use lookup table instead of switch case
    xDiv = pow(10.0, power);
    double multiplier = 1.0;
    for (NSUInteger index = 0; index <= 3; index++) {
        double xDistance = xDiv;
        switch (index) {
            case 0:
                if (ABS(1.0*xDiv-CGRectGetWidth([self.dataSource graphingWindow])/NUMBER_OF_X_TICKS) < xDistance) {
                    multiplier = 1.0;
                    xDistance = ABS(1.0*xDiv-CGRectGetWidth([self.dataSource graphingWindow])/NUMBER_OF_X_TICKS);
                }
                
                break;
                
            case 1:
                if (ABS(2.0*xDiv-CGRectGetWidth([self.dataSource graphingWindow])/NUMBER_OF_X_TICKS) < xDistance) {
                    multiplier = 2.0;
                    xDistance = ABS(2.0*xDiv-CGRectGetWidth([self.dataSource graphingWindow])/NUMBER_OF_X_TICKS);
                }
                
                break;
                
            case 2:
                if (ABS(5.0*xDiv-CGRectGetWidth([self.dataSource graphingWindow])/NUMBER_OF_X_TICKS) < xDistance) {
                    multiplier = 5.0;
                    xDistance = ABS(5.0*xDiv-CGRectGetWidth([self.dataSource graphingWindow])/NUMBER_OF_X_TICKS);
                }

                break;
                
            case 3:
                if (ABS(10.0*xDiv-CGRectGetWidth([self.dataSource graphingWindow])/NUMBER_OF_X_TICKS) < xDistance) {
                    multiplier = 10.0;
                    xDistance = ABS(10.0*xDiv-CGRectGetWidth([self.dataSource graphingWindow])/NUMBER_OF_X_TICKS);
                }

                break;
                
            default:
                multiplier = 1.0;
                break;
        }
    }
    xDiv = xDiv * multiplier;
    
    double firstTick = CGRectGetMinX([self.dataSource graphingWindow]) - fmod(CGRectGetMinX([self.dataSource graphingWindow]), xDiv);
    if (firstTick != 0) {
        [xTicks addObject:[NSNumber numberWithDouble:[self convertDomainValue:firstTick]]];
    }
    
    for (double tick = firstTick+xDiv;
         tick <= CGRectGetMaxX([self.dataSource graphingWindow]);
         tick = tick + xDiv) {
        if (tick != 0.0) {
            [xTicks addObject:[NSNumber numberWithDouble:[self convertDomainValue:tick]]];
        }
    }    
    return [xTicks copy];
}

- (NSArray *)yTicks
{
    NSMutableArray *yTicks = [NSMutableArray array];
    
    CGFloat yDiv = CGRectGetHeight([self.dataSource graphingWindow])/NUMBER_OF_Y_TICKS;
    NSInteger power;
    if (yDiv >= 1.0) {
        for (power = -1; yDiv > 1.0; power++) {
            yDiv = yDiv/10.0;
        }
    } else {
        for (power = 0; yDiv < 1.0; power--) {
            yDiv = yDiv*10.0;
        }
    }
    
    // Need to use lookup table instead of switch case
    yDiv = pow(10.0, power);
    double multiplier = 1.0;
    for (NSUInteger index = 0; index <= 3; index++) {
        double yDistance = yDiv;
        switch (index) {
            case 0:
                if (ABS(1.0*yDiv-CGRectGetHeight([self.dataSource graphingWindow])/NUMBER_OF_Y_TICKS) < yDistance) {
                    multiplier = 1.0;
                    yDistance = ABS(1.0*yDiv-CGRectGetHeight([self.dataSource graphingWindow])/NUMBER_OF_Y_TICKS);
                }
                
                break;
                
            case 1:
                if (ABS(2.0*yDiv-CGRectGetHeight([self.dataSource graphingWindow])/NUMBER_OF_Y_TICKS) < yDistance) {
                    multiplier = 2.0;
                    yDistance = ABS(2.0*yDiv-CGRectGetHeight([self.dataSource graphingWindow])/NUMBER_OF_Y_TICKS);
                }
                
                break;
                
            case 2:
                if (ABS(5.0*yDiv-CGRectGetHeight([self.dataSource graphingWindow])/NUMBER_OF_Y_TICKS) < yDistance) {
                    multiplier = 5.0;
                    yDistance = ABS(5.0*yDiv-CGRectGetHeight([self.dataSource graphingWindow])/NUMBER_OF_Y_TICKS);
                }
                
                break;
                
            case 3:
                if (ABS(10.0*yDiv-CGRectGetHeight([self.dataSource graphingWindow])/NUMBER_OF_Y_TICKS) < yDistance) {
                    multiplier = 10.0;
                    yDistance = ABS(10.0*yDiv-CGRectGetHeight([self.dataSource graphingWindow])/NUMBER_OF_Y_TICKS);
                }
                
                break;
                
            default:
                multiplier = 1.0;
                break;
        }
    }
    yDiv = yDiv * multiplier;
    
    double firstTick = CGRectGetMaxY([self.dataSource graphingWindow]) - fmod(CGRectGetMaxY([self.dataSource graphingWindow]), yDiv);
    if (firstTick != 0) {
        [yTicks addObject:[NSNumber numberWithDouble:[self convertRangeValue:firstTick]]];
    }
    
    for (double tick = firstTick-yDiv;
         tick >= CGRectGetMinY([self.dataSource graphingWindow]);
         tick = tick - yDiv) {
        if (tick != 0.0) {
            [yTicks addObject:[NSNumber numberWithDouble:[self convertRangeValue:tick]]];
        }
    }    
    return [yTicks copy];
}

@end
