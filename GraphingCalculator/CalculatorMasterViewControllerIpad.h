//
//  CalculatorMasterViewController.h
//  GraphingCalculator
//
//  Created by Taylor Trimble on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalculatorDetailViewController;

@interface CalculatorMasterViewControllerIpad : UITableViewController

@property (strong, nonatomic) CalculatorDetailViewController *detailViewController;

@end
