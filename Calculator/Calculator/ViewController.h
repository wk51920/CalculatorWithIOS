//
//  ViewController.h
//  Calculator
//
//  Created by wk on 15/4/27.
//  Copyright (c) 2015年 WK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NormalCalculatorViewController.h"
#import "ScientificCalculatorViewController.h"

@interface ViewController : UIViewController <NormalCalculatorPassValueDelegate, ScientificCalculatorPassValueDelegate>


@end

