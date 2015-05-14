//
//  normalCalculatorViewController.h
//  Calculator
//
//  Created by wk on 15/5/14.
//  Copyright (c) 2015年 WK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NormalCalculatorPassValueDelegate <NSObject>

-(void)normalPassEquationValue:(NSString *)value;

-(void)normalPassResultValue:(NSString *)value;

@end

@interface NormalCalculatorViewController : UIViewController

@property (assign, nonatomic) id <NormalCalculatorPassValueDelegate> delegate;

@end
