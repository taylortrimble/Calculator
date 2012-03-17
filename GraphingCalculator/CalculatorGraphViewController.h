//
//  CalculatorGraphViewController.h
//  GraphingCalculator
//
//  Created by Taylor Trimble on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorFunction.h"
#import "CalculatorGraphView.h"

@interface CalculatorGraphViewController : UIViewController <CalculatorGraphViewDataSource>

@property (weak, nonatomic) CalculatorFunction *function;
@property (weak, nonatomic) NSString *graphingVariable;

@property CGRect graphingWindow;

@property (weak, nonatomic) IBOutlet UILabel *functionDisplay;

@end
