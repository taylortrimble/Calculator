//
//  CalculatorGraphViewController.m
//  GraphingCalculator
//
//  Created by Taylor Trimble on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorGraphViewController.h"

@interface CalculatorGraphViewController ()

@end

@implementation CalculatorGraphViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
- (void)loadView
{
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
}
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.functionDisplay.text = [NSString stringWithFormat:@"%@ = %@", self.function.title, self.function.programDescription];
}

- (void)viewDidUnload
{
    self.functionDisplay = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Graph view data source

- (CGRect)graphingWindow
{
    return CGRectMake(-10, -5, 20, 20);
}

- (double)valueForInput:(double)x
{
    CalculatorFunction *functionCopy = [self.function copy];
    [functionCopy defineVariables:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:x] forKey:self.graphingVariable]];
    return [functionCopy runProgram];
}

@end
