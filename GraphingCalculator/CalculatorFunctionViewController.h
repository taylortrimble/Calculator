//
//  CalculatorFunctionViewController.h
//  GraphingCalculator
//
//  Created by Taylor Trimble on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"

@protocol CalculatorFunctionViewControllerDelegate;

@interface CalculatorFunctionViewController : UITableViewController

@property (nonatomic, weak) id <CalculatorFunctionViewControllerDelegate> delegate;
@property (nonatomic, weak) CalculatorBrain *calculatorBrain;

- (IBAction)cancelPressed:(UIBarButtonItem *)sender;


@end


@protocol CalculatorFunctionViewControllerDelegate <NSObject>


@end
