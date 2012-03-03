//
//  CalculatorVariablesViewController.h
//  GraphingCalculator
//
//  Created by Taylor Trimble on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalculatorVariablesViewControllerDelegate;



@interface CalculatorVariablesViewController : UITableViewController

@property (nonatomic, weak) NSMutableDictionary *variables;
@property (nonatomic, weak) id <CalculatorVariablesViewControllerDelegate> delegate;

- (IBAction)cancelButtonPressed:(id)sender;

@end



@protocol CalculatorVariablesViewControllerDelegate <NSObject>

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;
- (void)defineVariables:(NSDictionary *)variables;
- (void)selectVariable:(NSString *)variable;

@end