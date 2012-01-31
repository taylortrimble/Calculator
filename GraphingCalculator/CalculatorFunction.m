//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Taylor Trimble on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorFunction.h"

typedef enum _CalculatorOperationPriority {
    CalculatorOperationPriorityNull,
    CalculatorOperationPriorityParentheses,
    CalculatorOperationPriorityExponential,
    CalculatorOperationPriorityMultiplicationAndDivision,
    CalculatorOperationPriorityAdditionAndSubtraction, 
    CalculatorOperationPriorityFunction,
} CalculatorOperationPriority;

@interface CalculatorFunction()

@property (nonatomic, strong) NSMutableArray *program;
@property (nonatomic, strong) NSMutableIndexSet *operationIndexes;

- (double)evaluateLastProgramItem;
- (NSString *)stringForProgramItemWithPreviousOperationPriority:(CalculatorOperationPriority)previousOperationPriority;
- (NSComparisonResult)compareOperationPriority:(CalculatorOperationPriority)firstOperationPriority
                         withOperationPriority:(CalculatorOperationPriority)secondOperationPriority;

@end

@implementation CalculatorFunction

- (CalculatorFunction *)initWithTitle:(NSString *)title
{
    if (!self) {
        self = [super init];
    }
    
    self.title = title;
    return self;
}

@synthesize program = _program;
@synthesize operationIndexes = _operationIndexes;
@synthesize title = _title;
@synthesize variables = _variables;

- (NSMutableArray *)program
{
    if (!_program) {
        _program = [[NSMutableArray alloc] init];
    }
    
    return _program;
}

- (NSMutableIndexSet *)operationIndexes
{
    if (!_operationIndexes) {
        _operationIndexes = [[NSMutableIndexSet alloc] init];
    }
    
    return _operationIndexes;
}

- (NSString *)title
{
    if (!_title) {
        _title = @"f1";
    }
    
    return _title;
}

- (NSMutableDictionary *)variables
{
    if (!_variables) {
        _variables = [[NSMutableDictionary alloc] init];
    }
    
    return _variables;
}

#pragma mark - Program evaluation

- (double)runProgram
{
    NSMutableArray *programCopy = [self.program mutableCopy];
    double programEvaluation = [self evaluateLastProgramItem];
    self.program = programCopy;
    return programEvaluation;
}

- (double)evaluateLastProgramItem;
{
    CalculatorOperation operation = CalculatorOperationNull;
    id lastItemInProgram = [self.program lastObject];
    [self.program removeLastObject];
    
    if (![self.operationIndexes containsIndex:[self.program count]] &&
        [lastItemInProgram isKindOfClass:[NSNumber class]]) {
        return [lastItemInProgram doubleValue];
    } else if (![self.operationIndexes containsIndex:[self.program count]] &&
               [lastItemInProgram isKindOfClass:[NSString class]]) {
        return [self valueForVariable:lastItemInProgram];
    } else if ([self.operationIndexes containsIndex:[self.program count]] &&
               [lastItemInProgram respondsToSelector:@selector(longValue)]) {
        operation = [lastItemInProgram longValue];
        double firstOperand = 0.0;
        double secondOperand = 0.0;
        
        switch (operation) {
            case CalculatorOperationNull:
                NSLog(@"Received CalculatorOperationNull during program evaluation");
                return 0.0;
                
            case CalculatorOperationAddition:
                secondOperand = [self evaluateLastProgramItem];
                firstOperand = [self evaluateLastProgramItem];
                return firstOperand + secondOperand;
                
            case CalculatorOperationSubtraction:
                secondOperand = [self evaluateLastProgramItem];
                firstOperand = [self evaluateLastProgramItem];
                return firstOperand - secondOperand;
                
            case CalculatorOperationMultiplication:
                secondOperand = [self evaluateLastProgramItem];
                firstOperand = [self evaluateLastProgramItem];
                return firstOperand * secondOperand;    
                
            case CalculatorOperationDivision:
                secondOperand = [self evaluateLastProgramItem];
                firstOperand = [self evaluateLastProgramItem];
                
                if (secondOperand != 0.0) {
                    return firstOperand / secondOperand;
                } else {
                    return INFINITY;
                }
                
            case CalculatorOperationNegation:
                return -[self evaluateLastProgramItem];
                
            case CalculatorOperationTangent:
                return tan([self evaluateLastProgramItem]);
                
            case CalculatorOperationSine:
                return sin([self evaluateLastProgramItem]);
                
            case CalculatorOperationCosine:
                return cos([self evaluateLastProgramItem]);
                
            case CalculatorOperationSquareRoot:
                firstOperand = [self evaluateLastProgramItem];
                
                if (firstOperand >= 0.0) {
                    return sqrt(firstOperand);
                } else {
                    return NAN;
                }
                
            case CalculatorOperationPi:
                return M_PI;
            
            case CalculatorOperationE:
                return M_E;
            
            case CalculatorOperationNaturalLog:
                return log([self evaluateLastProgramItem]);
                
            case CalculatorOperationPower:
                secondOperand = [self evaluateLastProgramItem];
                firstOperand = [self evaluateLastProgramItem];
                return pow(firstOperand, secondOperand);
                
            default:
                NSLog(@"Received invalid CalculatorOperation during program evaluation: %u", operation);
                return 0.0;
        }

    } else {
        if ([self.program count] != 0) {
            NSLog(@"Received invalid program object during program evaluation: %@",
                  lastItemInProgram);
        }
        
        return 0.0;
    }
}

#pragma mark - Stack control

- (void)pushOperand:(double)operand
{
    [self.program addObject:[NSNumber numberWithDouble:operand]];
}

- (void)pushVariable:(NSString *)variable
{
    [self.program addObject:variable];
}

- (void)pushOperation:(CalculatorOperation)operation
{
    [self.program addObject:[NSNumber numberWithLong:operation]];
    [self.operationIndexes addIndex:[self.program count]-1];
}

#pragma mark Undo

- (void)undo
{
    [self.program removeLastObject];
    [self.operationIndexes removeIndex:[self.program count]];
}

#pragma mark - Variables

- (void)defineVariables:(NSDictionary *)variables
{
    [self.variables addEntriesFromDictionary:variables];
}

- (double)valueForVariable:(NSString *)variable
{
    if ([[self.variables valueForKey:variable] respondsToSelector:@selector(doubleValue)]) {
        return [[self.variables valueForKey:variable] doubleValue];
    } else {
        return 0.0;
    }
}

#pragma mark - Program Description

- (NSString *)programDescription
{
    NSMutableArray *programCopy = [self.program mutableCopy];
    NSString *programDescription = [self stringForProgramItemWithPreviousOperationPriority:CalculatorOperationPriorityFunction];
    while ([self.program count]) {
        programDescription = [NSString stringWithFormat:@"%@, %@",
                              [self stringForProgramItemWithPreviousOperationPriority:CalculatorOperationPriorityFunction],
                              programDescription
                              ];
    }
    self.program = programCopy;
    return programDescription;
}

- (NSString *)stringForProgramItemWithPreviousOperationPriority:(CalculatorOperationPriority)previousOperationPriority
{
    CalculatorOperation operation = CalculatorOperationNull;
    id lastItemInProgram = [self.program lastObject];
    [self.program removeLastObject];
    
    if (![self.operationIndexes containsIndex:[self.program count]] &&
        [lastItemInProgram respondsToSelector:@selector(stringValue)]) {
        return [lastItemInProgram stringValue];
    } else if (![self.operationIndexes containsIndex:[self.program count]] &&
               [lastItemInProgram isKindOfClass:[NSString class]]) {
        return lastItemInProgram;
    } else if ([self.operationIndexes containsIndex:[self.program count]] &&
               [lastItemInProgram respondsToSelector:@selector(longValue)]) {
        operation = [lastItemInProgram longValue];
        NSString *firstOperand = @"";
        NSString *secondOperand = @"";
        NSString *concatenation = @"";
        
        switch (operation) {
            case CalculatorOperationNull:
                NSLog(@"Received CalculatorOperationNull during program transcription");
                return @"";
                
            case CalculatorOperationAddition:
                secondOperand = [self stringForProgramItemWithPreviousOperationPriority:CalculatorOperationPriorityAdditionAndSubtraction];
                firstOperand = [self stringForProgramItemWithPreviousOperationPriority:CalculatorOperationPriorityAdditionAndSubtraction];
                concatenation = [NSString stringWithFormat:@"%@+%@",
                                           firstOperand,
                                           secondOperand
                                           ];
                if ([self compareOperationPriority:CalculatorOperationPriorityAdditionAndSubtraction
                             withOperationPriority:previousOperationPriority] == NSOrderedAscending) {
                    concatenation = [NSString stringWithFormat:@"(%@)", concatenation];
                }
                
                return concatenation;
                
            case CalculatorOperationSubtraction:
                secondOperand = [self stringForProgramItemWithPreviousOperationPriority:CalculatorOperationPriorityAdditionAndSubtraction];
                firstOperand = [self stringForProgramItemWithPreviousOperationPriority:CalculatorOperationPriorityAdditionAndSubtraction];
                concatenation = [NSString stringWithFormat:@"%@-%@",
                                           firstOperand,
                                           secondOperand
                                           ];
                if ([self compareOperationPriority:CalculatorOperationPriorityAdditionAndSubtraction
                             withOperationPriority:previousOperationPriority] == NSOrderedAscending) {
                    concatenation = [NSString stringWithFormat:@"(%@)", concatenation];
                }
                
                return concatenation;
                
            case CalculatorOperationMultiplication:
                secondOperand = [self stringForProgramItemWithPreviousOperationPriority:CalculatorOperationPriorityMultiplicationAndDivision];
                firstOperand = [self stringForProgramItemWithPreviousOperationPriority:CalculatorOperationPriorityMultiplicationAndDivision];
                concatenation = [NSString stringWithFormat:@"%@*%@",
                                           firstOperand,
                                           secondOperand
                                           ];
                if ([self compareOperationPriority:CalculatorOperationPriorityMultiplicationAndDivision
                             withOperationPriority:previousOperationPriority] == NSOrderedAscending) {
                    concatenation = [NSString stringWithFormat:@"(%@)", concatenation];
                }
                
                return concatenation;
    
                
            case CalculatorOperationDivision:
                secondOperand = [self stringForProgramItemWithPreviousOperationPriority:CalculatorOperationPriorityParentheses];
                firstOperand = [self stringForProgramItemWithPreviousOperationPriority:CalculatorOperationPriorityMultiplicationAndDivision];
                concatenation = [NSString stringWithFormat:@"%@/%@",
                                           firstOperand,
                                           secondOperand
                                           ];
                if ([self compareOperationPriority:CalculatorOperationPriorityMultiplicationAndDivision
                             withOperationPriority:previousOperationPriority] == NSOrderedAscending) {
                    concatenation = [NSString stringWithFormat:@"(%@)", concatenation];
                }
                
                return concatenation;
                
            case CalculatorOperationNegation:
                return [NSString stringWithFormat:@"-(%@)",
                        [self stringForProgramItemWithPreviousOperationPriority:CalculatorOperationPriorityFunction]
                        ];
                
            case CalculatorOperationTangent:
                return [NSString stringWithFormat:@"tan(%@)",
                        [self stringForProgramItemWithPreviousOperationPriority:CalculatorOperationPriorityFunction]
                        ];
                
            case CalculatorOperationSine:
                return [NSString stringWithFormat:@"sin(%@)",
                        [self stringForProgramItemWithPreviousOperationPriority:CalculatorOperationPriorityFunction]
                        ];
                
            case CalculatorOperationCosine:
                return [NSString stringWithFormat:@"cos(%@)",
                        [self stringForProgramItemWithPreviousOperationPriority:CalculatorOperationPriorityFunction]
                        ];
                
            case CalculatorOperationSquareRoot:
                return [NSString stringWithFormat:@"√(%@)",
                        [self stringForProgramItemWithPreviousOperationPriority:CalculatorOperationPriorityFunction]
                        ];
                
            case CalculatorOperationPi:
                return @"π";
                
            case CalculatorOperationE:
                return @"e";
            
            case CalculatorOperationNaturalLog:
                return [NSString stringWithFormat:@"ln(%@)",
                        [self stringForProgramItemWithPreviousOperationPriority:CalculatorOperationPriorityFunction]
                        ];
            
            case CalculatorOperationPower:
                secondOperand = [self stringForProgramItemWithPreviousOperationPriority:CalculatorOperationPriorityExponential];
                firstOperand = [self stringForProgramItemWithPreviousOperationPriority:CalculatorOperationPriorityExponential];
                concatenation = [NSString stringWithFormat:@"%@^%@",
                                 firstOperand,
                                 secondOperand
                                 ];
                if ([self compareOperationPriority:CalculatorOperationPriorityExponential
                             withOperationPriority:previousOperationPriority] == NSOrderedAscending) {
                    concatenation = [NSString stringWithFormat:@"(%@)", concatenation];
                }
                
                return concatenation;
            
            default:
                NSLog(@"Received invalid CalculatorOperation during program transcription: %u", operation);
                return @"";
        }
        
    } else {
        if ([self.program count] != 0) {
            NSLog(@"Received invalid program object during program evaluation: %@",
                  lastItemInProgram);
        }
        
        return @"";
    }
}

#pragma mark Function description

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ = %@", self.title, [self programDescription]];
}

#pragma mark - Operation priority

- (NSComparisonResult)compareOperationPriority:(CalculatorOperationPriority)firstOperationPriority
                         withOperationPriority:(CalculatorOperationPriority)secondOperationPriority
{
    return (firstOperationPriority==secondOperationPriority)?NSOrderedSame:
    ((firstOperationPriority>secondOperationPriority)?NSOrderedAscending:NSOrderedDescending);      // Remember lower priority value
                                                                                                    // means higher priority.
}

- (void)clear
{
    self.program = nil;
    self.operationIndexes = nil;
}

@end
