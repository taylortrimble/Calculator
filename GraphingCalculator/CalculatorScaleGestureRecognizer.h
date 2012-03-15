//
//  CalculatorScaleGestureRecognizer.h
//  GraphingCalculator
//
//  Created by Taylor Trimble on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorScaleGestureRecognizer : UIGestureRecognizer

@property (readonly) CGFloat xScale;
@property (readonly) CGFloat yScale;
@property (readonly) CGFloat xOriginTranslation;
@property (readonly) CGFloat yOriginTranslation;

@end
