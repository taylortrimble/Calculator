//
//  CalculatorVariablesDetailViewController.h
//  GraphingCalculator
//
//  Created by Taylor Trimble on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalculatorVariablesDetailViewControllerDelegate;


@interface CalculatorVariablesDetailViewController : UITableViewController

@property (strong, nonatomic) NSString *variableName;
@property (strong, nonatomic) NSNumber *variableValue;

@property (weak, nonatomic) IBOutlet UITableViewCell *nameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *valueCell;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (nonatomic, weak) id <CalculatorVariablesDetailViewControllerDelegate> delegate;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;

@end


@protocol CalculatorVariablesDetailViewControllerDelegate <NSObject>

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;
- (void)defineVariables:(NSDictionary *)variables;

@end
