//
//  CalculatorGraphVariableChooserViewController.h
//  GraphingCalculator
//
//  Created by Taylor Trimble on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorFunction.h"

@interface CalculatorGraphVariableChooserViewController : UITableViewController

@property (weak, nonatomic) CalculatorFunction *function;

@end
