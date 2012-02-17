//
//  CalculatorBrain.m
//  GraphingCalculator
//
//  Created by Taylor Trimble on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@implementation CalculatorBrain

@synthesize functions = _functions;
@synthesize activeFunction = _activeFunction;

- (NSArray *)functions
{
    if (!_functions || ![_functions count]) {
        CalculatorFunction *newFunction = [[CalculatorFunction alloc] initWithTitle:@"f1"];
        _functions = [NSArray arrayWithObject:newFunction];
    }
    
    return _functions;
}

- (CalculatorFunction *)activeFunction
{
    if (!_activeFunction) {
        NSArray *functions = self.functions;
        _activeFunction = [functions objectAtIndex:0];
    }
    
    return _activeFunction;
}

- (void)addNewFunctionWithTitle:(NSString *)title setAsActive:(BOOL)active
{
    if ([title isEqualToString:@""]) {
        title = @"new";
    }
    
    self.functions = [self.functions arrayByAddingObject:
                      [[CalculatorFunction alloc]initWithTitle:title]];
    if (active) {
        self.activeFunction = [self.functions lastObject];
    }
}

@end
