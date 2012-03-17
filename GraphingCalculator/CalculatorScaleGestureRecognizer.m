//
//  CalculatorScaleGestureRecognizer.m
//  GraphingCalculator
//
//  Created by Taylor Trimble on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorScaleGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>


@interface CalculatorScaleGestureRecognizer ()

@property CGPoint touch0StartPoint;
@property CGPoint touch1StartPoint;

@end


@implementation CalculatorScaleGestureRecognizer

#pragma mark - Touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if ([self numberOfTouches] == 2) {
        self.touch0StartPoint = [self locationOfTouch:0 inView:self.view];
        self.touch1StartPoint = [self locationOfTouch:1 inView:self.view];
        self.state = UIGestureRecognizerStateBegan;     // Send action message
    } else if ([self numberOfTouches] >= 3) {
        self.state = UIGestureRecognizerStateCancelled; // Send action message
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    if ([self numberOfTouches] == 2) {
        self.state = UIGestureRecognizerStateChanged;   // Send action message
    } else if ([self numberOfTouches] >= 3) {
        self.state = UIGestureRecognizerStateCancelled; // Send action message
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if ([self numberOfTouches] < 2 && (self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged)) {
        self.state = UIGestureRecognizerStateEnded;     // Send action message
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    self.state = UIGestureRecognizerStateCancelled;     // Send action message
}

#pragma mark - System reset

- (void)reset
{
    self.touch0StartPoint = CGPointZero;
    self.touch1StartPoint = CGPointZero;
}

#pragma mark - Private methods

- (CGFloat)xScale
{
    CGFloat xScale = ABS([self locationOfTouch:1 inView:self.view].x - [self locationOfTouch:0 inView:self.view].x) /
           ABS(self.touch1StartPoint.x - self.touch0StartPoint.x);
    return (xScale<0.01?0.01:(xScale>100.0?100.0:xScale));
}

- (CGFloat)yScale
{
    CGFloat yScale =  ABS([self locationOfTouch:1 inView:self.view].y - [self locationOfTouch:0 inView:self.view].y) /
           ABS(self.touch1StartPoint.y - self.touch0StartPoint.y);
    return (yScale<0.01?0.01:(yScale>100.0?100.0:yScale));
}

- (CGFloat)xOriginTranslation
{
    CGPoint touch0EndPoint = [self locationOfTouch:0 inView:self.view];
    CGPoint touch1EndPoint = [self locationOfTouch:1 inView:self.view];
    
    CGFloat xOriginTranslation = (self.touch0StartPoint.x*touch1EndPoint.x-self.touch1StartPoint.x*touch0EndPoint.x)/(touch1EndPoint.x-touch0EndPoint.x);
    return (xOriginTranslation<-1e6?-1e6:(xOriginTranslation>1e6?1e6:xOriginTranslation));
}

- (CGFloat)yOriginTranslation
{
    CGPoint touch0EndPoint = [self locationOfTouch:0 inView:self.view];
    CGPoint touch1EndPoint = [self locationOfTouch:1 inView:self.view];
    
    CGFloat yOriginTranslation = (self.touch0StartPoint.y*touch1EndPoint.y-self.touch1StartPoint.y*touch0EndPoint.y)/(touch1EndPoint.y-touch0EndPoint.y);
    return (yOriginTranslation<-1e6?-1e6:(yOriginTranslation>1e6?1e6:yOriginTranslation));

}

@end
