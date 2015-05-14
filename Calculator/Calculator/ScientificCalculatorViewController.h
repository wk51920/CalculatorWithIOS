//
//  scientificCalculatorViewController.h
//  Calculator
//
//  Created by wk on 15/5/14.
//  Copyright (c) 2015年 WK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScientificCalculatorPassValueDelegate <NSObject>

-(void)scienPassEquationValue:(NSString *)value;

-(void)scienPassResultValue:(NSString *)value;


@end

@interface ScientificCalculatorViewController : UIViewController

@property (assign, nonatomic) id <ScientificCalculatorPassValueDelegate> delegate;

@end
