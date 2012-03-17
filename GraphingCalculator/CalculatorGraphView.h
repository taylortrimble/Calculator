//
//  CalculatorGraphView.h
//  GraphingCalculator
//
//  Created by Taylor Trimble on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalculatorGraphViewDataSource;

@interface CalculatorGraphView : UIView

@property (weak, nonatomic) IBOutlet id <CalculatorGraphViewDataSource> dataSource;

@end

@protocol CalculatorGraphViewDataSource <NSObject>

- (CGRect)graphingWindow;
- (double)valueForInput:(double)x;
- (void)updateScale:(CGFloat)scale;
- (void)updateOrigin:(CGPoint)translation;

@end
