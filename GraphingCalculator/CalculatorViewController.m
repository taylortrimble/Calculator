//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Taylor Trimble on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorVariablesViewController.h"
#import "CalculatorGraphVariableChooserViewController.h"

@interface CalculatorViewController() <CalculatorVariablesViewControllerDelegate>

- (void)updateDisplay;

@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize historyDisplay = _historyDisplay;
@synthesize brain = _brain;
@synthesize userIsCurrentlyEnteringData = _userIsCurrentlyEnteringData;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setDisplay:nil];
    [self setHistoryDisplay:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateDisplay];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PresentVariablesViewController"]) {
        [(CalculatorVariablesViewController *)[segue.destinationViewController topViewController] setDelegate:self];
        [(CalculatorVariablesViewController *)[segue.destinationViewController topViewController] setVariables:self.brain.activeFunction.variables];
    } else if ([segue.identifier isEqualToString:@"PushGraphVariableChooser"]) {
        CalculatorGraphVariableChooserViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.function = self.brain.activeFunction;
    }
}

#pragma mark - Variables View Controller Delegate

- (void)defineVariables:(NSDictionary *)variables
{
    [self.brain.activeFunction defineVariables:variables];
}

- (void)selectVariable:(NSString *)variable
{
    [self.brain.activeFunction pushVariable:variable];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Button presses

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = [sender currentTitle];
    
    if (self.userIsCurrentlyEnteringData) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsCurrentlyEnteringData = YES;
    }
}

- (IBAction)enterPressed
{
    [self.brain.activeFunction pushOperand:[self.display.text doubleValue]];
    self.userIsCurrentlyEnteringData = NO;
    self.historyDisplay.text = [self.brain.activeFunction programDescription];
}

- (IBAction)decimalPressed
{
    BOOL displayIsDecimal = ([self.display.text rangeOfString:@"."].location != NSNotFound);
    
    if (!self.userIsCurrentlyEnteringData) {
        self.display.text = @"0.";
        self.userIsCurrentlyEnteringData = YES;
    } else if (!displayIsDecimal) {
        self.display.text = [self.display.text stringByAppendingString:@"."];
    } else {
        return;
    }
}

- (IBAction)negationPressed:(id)sender
{
    if (self.userIsCurrentlyEnteringData && [self.display.text length]>0) {
        if ([self.display.text characterAtIndex:0] == '-') {
            self.display.text = [self.display.text substringFromIndex:1];
        } else {
            self.display.text = [NSString stringWithFormat:@"-%@", self.display.text];
        }
    } else {
        [self operationPressed:sender];
    }
}

- (IBAction)operationPressed:(UIButton *)sender
{
    if (self.userIsCurrentlyEnteringData) {
        [self enterPressed];
    }
    
    CalculatorOperation operation;
    switch (sender.tag) {
        case 0:
            operation = CalculatorOperationAddition;
            break;
            
        case 1:
            operation = CalculatorOperationSubtraction;
            break;
            
        case 2:
            operation = CalculatorOperationMultiplication;
            break;
            
        case 3:
            operation = CalculatorOperationDivision;
            break;
            
        case 4:
            operation = CalculatorOperationNegation;
            break;
            
        case 5:
            operation = CalculatorOperationTangent;
            break;
            
        case 6:
            operation = CalculatorOperationSine;
            break;
            
        case 7:
            operation = CalculatorOperationCosine;
            break;
            
        case 8:
            operation = CalculatorOperationPi;
            break;
            
        case 9:
            operation = CalculatorOperationSquareRoot;
            break;
        
        case 10:
            operation = CalculatorOperationPower;
            break;
        
        case 11:
            operation = CalculatorOperationNaturalLog;
            break;
        
        case 12:
            operation = CalculatorOperationE;
            break;
            
        default:
            operation = CalculatorOperationNull;
            break;
    }
    
    [self.brain.activeFunction pushOperation:operation];
    [self updateDisplay];
}

- (IBAction)variablePressed:(UIButton *)sender
{
    if (self.userIsCurrentlyEnteringData) {
        [self enterPressed];
    }
    [self updateDisplay];
}

- (IBAction)clearPressed
{
    [self.brain.activeFunction clear];
    [self updateDisplay];
}

- (IBAction)undoPressed
{
    if (!self.userIsCurrentlyEnteringData) {
        [self.brain.activeFunction undo];
        [self updateDisplay];
    } else {
        if ([self.display.text length]) {
            self.display.text = [self.display.text
                                 substringToIndex:[self.display.text length]-1];
        }
    }
}

#pragma mark - Display methods

- (void)updateDisplay
{
    self.display.text = [NSString stringWithFormat:@"%g",
                         [self.brain.activeFunction runProgram]
                         ];
    if ([self.display.text isEqualToString:@""]) {
        self.display.text = @"0";
    }
    self.historyDisplay.text = [self.brain.activeFunction programDescription];
}

@end
