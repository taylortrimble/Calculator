//
//  CalculatorBrain.h
//  GraphingCalculator
//
//  Created by Taylor Trimble on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalculatorFunction.h"

@interface CalculatorBrain : NSObject

@property (nonatomic, strong) NSArray *functions;
@property (nonatomic, weak) CalculatorFunction *activeFunction;

- (void)addNewFunctionWithTitle:(NSString *)title setAsActive:(BOOL)active;

@end
