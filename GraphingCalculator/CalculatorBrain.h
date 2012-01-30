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
    CalculatorOperationNegation,
    CalculatorOperationTangent,
    CalculatorOperationSine,
    CalculatorOperationCosine,
    CalculatorOperationSquareRoot,
    CalculatorOperationPi
} CalculatorOperation ;

@interface CalculatorBrain : NSObject

@property (nonatomic, strong, readonly) NSMutableDictionary *variables;

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
