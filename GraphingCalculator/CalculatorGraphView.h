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

- (IBAction)handlePinchGesture:(UIPinchGestureRecognizer *)pinchGR;
- (IBAction)handlePanGesture:(UIPanGestureRecognizer *)panGR;

@end

@protocol CalculatorGraphViewDataSource <NSObject>

- (CGRect)graphingWindow;
- (double)valueForInput:(double)x;

@end
