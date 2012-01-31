//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Taylor Trimble on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _CalculatorOperation {
    CalculatorOperationNull,
    CalculatorOperationAddition,
    CalculatorOperationSubtraction,
    CalculatorOperationMultiplication,
    CalculatorOperationDivision,
    CalculatorOperationPower,
    CalculatorOperationNegation,
    CalculatorOperationTangent,
    CalculatorOperationSine,
    CalculatorOperationCosine,
    CalculatorOperationPi,
    CalculatorOperationNaturalLog,
    CalculatorOperationE,
    CalculatorOperationSquareRoot
} CalculatorOperation ;

@interface CalculatorFunction : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong, readonly) NSMutableDictionary *variables;

- (CalculatorFunction *)initWithTitle:(NSString *)title;

- (void)pushOperand:(double)operand;
- (void)pushVariable:(NSString *)variable;
- (void)pushOperation:(CalculatorOperation)operation;

- (void)undo;

- (void)defineVariables:(NSDictionary *)variables;
- (double)valueForVariable:(NSString *)variable;

- (double)runProgram;
- (NSString *)programDescription;

- (void)clear;

@end
