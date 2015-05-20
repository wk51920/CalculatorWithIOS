//
//  normalCalculatorViewController.m
//  Calculator
//
//  Created by wk on 15/5/14.
//  Copyright (c) 2015年 WK. All rights reserved.
//

#import "NormalCalculatorViewController.h"
#import "Stack.h"

@interface NormalCalculatorViewController()

@property (strong, nonatomic) NSMutableString *equation;
@property (strong, nonatomic) NSMutableString *result;

@end

@implementation NormalCalculatorViewController
{
    numbType number; //用于将结果存储为一个真实的值
    Stack *stack;    //用于计算的栈
    char operation;  //用于记录上一个运算符是什么
    BOOL singlePush; //用于判断是否在等于号之后又重新输入了数字
}

-(void)viewDidLoad{
    
    singlePush = NO;
    operation = 'n';  //'n'表示一个真正空的运算符
    
    stack = [[Stack alloc] init];
    
    self.equation = [NSMutableString stringWithCapacity:40];
    self.result = [NSMutableString stringWithCapacity:40];
}

/********************数字区按键功能************************/

- (IBAction)numTouch:(UIButton *)sender {
    singlePush = YES;
    switch (sender.tag) {
        case 1001:
            [self.equation appendString:@"1"];
            [self.delegate normalPassEquationValue:self.equation]; //通过此代理方法，将值传递给父viewController
            break;
        case 1002:
            [self.equation appendString:@"2"];
            [self.delegate normalPassEquationValue:self.equation];
            break;
        case 1003:
            [self.equation appendString:@"3"];
            [self.delegate normalPassEquationValue:self.equation];
            break;
        case 1004:
            [self.equation appendString:@"4"];
            [self.delegate normalPassEquationValue:self.equation];
            break;
        case 1005:
            [self.equation appendString:@"5"];
            [self.delegate normalPassEquationValue:self.equation];
            break;
        case 1006:
            [self.equation appendString:@"6"];
            [self.delegate normalPassEquationValue:self.equation];
            break;
        case 1007:
            [self.equation appendString:@"7"];
            [self.delegate normalPassEquationValue:self.equation];
            break;
        case 1008:
            [self.equation appendString:@"8"];
            [self.delegate normalPassEquationValue:self.equation];
            break;
        case 1009:
            [self.equation appendString:@"9"];
            [self.delegate normalPassEquationValue:self.equation];
            break;
        default:
            break;
    }
    
}

- (IBAction)zeroTouch:(UIButton *)sender {
    if([self.equation length] != 0){
        [self.equation appendString:@"0"];
        [self.delegate normalPassEquationValue:self.equation];
    }
}

- (IBAction)dotTouch:(UIButton *)sender {
    if([self.equation length] == 0){
        [self.equation appendString:@"0"];
        [self.equation appendString:@"."];
        [self.delegate normalPassEquationValue:self.equation];
    }else{
        [self.equation appendString:@"."];
        [self.delegate normalPassEquationValue:self.equation];
    }
}

/******************运算符功能区********************************/
//所有运算符按钮触发这一个事件，不同按钮通过tag标记来区分
- (IBAction)operatorTouch:(UIButton *)sender {
    number = [self.equation doubleValue];   //将其转化为一个数
    [self.equation deleteCharactersInRange:NSMakeRange(0, [self.equation length])];
    
    //用于实现二元运算,从栈中取结果
    double temp = 0.0;
    
    switch (sender.tag) {
        case 1013: // +/-
            if([stack isEmpty]){
                if(singlePush)
                    [stack push:number];
                else
                    [stack push:0];
                operation = 'r';
            }else{
                if(operation !='n')
                {
                    temp = [stack pop];
                    temp = [self operation:operation num:temp];
                    [self.delegate normalPassResultValue:[NSString stringWithFormat:@"%f", temp]];
                }else if(operation == 'n')
                {
                    operation = 'r';
                    if(singlePush)
                    {
                        temp = [self operation:operation num:number];
                    }else{
                        temp = [stack pop];
                        temp = [self operation:operation num:temp];
                        
                    }
                    [self.delegate normalPassResultValue:[NSString stringWithFormat:@"%f", temp]];
                }
                
                [stack push:temp];
                 operation = 'n';
            }
            break;
            
        case 1014: // 1/x
            if([stack isEmpty]){
                if(singlePush)
                    [stack push:number];
                else
                    break; //非法，0不能做分母
                operation = 'd';
            }else{
                if(operation != 'n'){
                    temp = [stack pop];
                    temp = [self operation:operation num:temp];
                    [self.delegate normalPassResultValue:[NSString stringWithFormat:@"%f", temp]];
                }else if(operation == 'n'){
                    operation = 'd';
                    if(singlePush){
                        temp = [self operation:operation num:number];
                    }else{
                        temp  = [stack pop];
                        temp = [self operation:operation num:temp];
                    }
                    [self.delegate normalPassResultValue:[NSString stringWithFormat:@"%f", temp]];
                }
                
                [stack push:temp];
                operation = 'n';
            }
            
            break;
            
        case 1015: // /
            if([stack isEmpty]){
                [stack push:number];
                operation = '/';
            }else{
                if(operation != 'n'){
                    temp = [stack pop];
                    temp = [self opeartion:operation firstNum:temp secondNum:number];
                    [self.delegate normalPassResultValue:[NSString stringWithFormat:@"%f", temp]];
                    [stack push: temp];
                }else if(operation == 'n'){
                    if(!singlePush){  //按等号后，用到上次结果
                        temp = [stack pop];
                        operation = '/';
                        number = 1;
                        temp = [self opeartion:operation firstNum:temp secondNum:number];
                        [stack push:temp];
                        [self.delegate normalPassResultValue:[NSString stringWithFormat:@"%f", temp]];
                    }else { //按了等号后重新计算
                        [stack push:number];
                        operation = '/';
                    }
                }
            }
            
            break;
            
        case 1016: // %
            if([stack isEmpty]){
                [stack push:number];
                operation = '%';
            }else{
                if(operation != 'n'){
                    temp = [stack pop];
                    temp = [self opeartion:operation firstNum:temp secondNum:number];
                    [self.delegate normalPassResultValue:[NSString stringWithFormat:@"%f", temp]];
                    [stack push:temp];
                }else if(operation == 'n'){
                    if(!singlePush){
                        temp = [stack pop];
                        operation = '%';
                        number = 0;
                        temp = [self opeartion:operation firstNum:temp secondNum:number];
                        [stack push:temp];
                        [self.delegate normalPassResultValue:[NSString stringWithFormat:@"%f", temp]];
                    }else{
                        [stack push:number];
                        operation = '%';
                    }
                }
            }
            break;
            
        case 1017: // *
            if([stack isEmpty]){
                [stack push:number];
                operation = '*';
            }else{
                if(operation != 'n'){
                        temp = [stack pop];
                        temp = [self opeartion:operation firstNum:temp secondNum:number];
                        [self.delegate normalPassResultValue:[NSString stringWithFormat:@"%f", temp]];
                        [stack push:temp];
                }else if(operation == 'n'){
                    if(!singlePush){
                        temp = [stack pop];
                        operation = '*';
                        number = 1;
                        temp = [self opeartion:operation firstNum:temp secondNum:number];
                        [stack push:temp];
                        [self.delegate normalPassResultValue:[NSString stringWithFormat:@"%f", temp]];
                    }else{
                        [stack push:number];
                        operation = '*';
                    }
                }
            }
            break;
                
        case 1018: // 根号
            if([stack isEmpty]){
                if(singlePush)
                    [stack push:number];
                else
                    [stack push:0];
                operation = 'g';
            }else{
                if(operation != 'n'){
                    temp = [stack pop];
                    temp = [self operation:operation num:temp];
                    [self.delegate normalPassResultValue:[NSString stringWithFormat:@"%f", temp]];
                }else if(operation == 'n'){
                    operation = 'g';
                    if(singlePush){
                        temp = [self operation:operation num:number];
                    }else{
                        temp  = [stack pop];
                        temp = [self operation:operation num:temp];
                    }
                    [self.delegate normalPassResultValue:[NSString stringWithFormat:@"%f", temp]];
                }
                [stack push:temp];
                operation = 'n';
            }
            break;
            
        case 1019: // -
            if([stack isEmpty]){
                [stack push:number];
                operation = '-';
            }else{
                if(operation != 'n'){
                    temp = [stack pop];
                    temp = [self opeartion:operation firstNum:temp secondNum:number];
                    [self.delegate normalPassResultValue:[NSString stringWithFormat:@"%f", temp]];
                    [stack push:temp];
                }else if(operation == 'n'){
                    if(!singlePush){
                        temp = [stack pop];
                        operation = '-';
                        number = 0;
                        temp = [self opeartion:operation firstNum:temp secondNum:number];
                        [stack push:temp];
                        [self.delegate normalPassResultValue:[NSString stringWithFormat:@"%f", temp]];
                    }else{
                        [stack push:number];
                        operation = '-';
                    }
                }
            }
            
            break;
            
        case 1020: // +
            if([stack isEmpty]){
                [stack push:number]; //第一次压栈只压栈不计算
                operation = '+';     //记录第一次运算的运算符
            }else{
                if(operation != 'n'){
                    temp = [stack pop];
                    temp = [self opeartion:operation firstNum:temp secondNum:number];
                    [self.delegate normalPassResultValue:[NSString stringWithFormat:@"%f", temp]];
                    [stack push:temp];
                }else if(operation == 'n'){
                    if(!singlePush){
                        temp = [stack pop];
                        operation = '+';
                        number = 0;
                        temp = [self opeartion:operation firstNum:temp secondNum:number];
                        [stack push:temp];
                        [self.delegate normalPassResultValue:[NSString stringWithFormat:@"%f", temp]];
                    }else{
                        [stack push:number];
                        operation = '+';
                    }
                }
            }
            break;
            
        case 1021: // =
            if(operation != 'n'){  //在此处做最后的运算
                temp = [stack pop];
                
                if(operation == 'g' || operation == 'r' || operation == 'd')
                    temp = [self operation:operation num:temp];
                else if(operation == '+' || operation == '-' || operation == '*' || operation == '/' || operation == '%')
                    temp = [self opeartion:operation firstNum:temp secondNum:number];
                
                [stack push:temp];  //使得暂时得到的结果可以继续进行后续操作，直到按下MC键结束一个系列的计算
                [self.delegate normalPassResultValue:[NSString stringWithFormat:@"%f", temp]];
                operation = 'n';
            }
            break;
        default:
            break;
    }
    singlePush = NO;
    [self.delegate normalPassEquationValue:@"0"];
    
}

- (IBAction)delTouch:(UIButton *)sender {
    if(self.equation.length > 0){
        [self.equation deleteCharactersInRange:NSMakeRange(self.equation.length - 1, 1)];
        if(self.equation.length > 0)
            [self.delegate normalPassEquationValue:self.equation];
        else
            [self.delegate normalPassEquationValue:self.equation];
    }
}

- (IBAction)ACTouch:(UIButton *)sender {  //只清除本次输入
    [self.equation deleteCharactersInRange:NSMakeRange(0, self.equation.length)];
    [self.delegate normalPassEquationValue:@"0"];
}

- (IBAction)MCTouch:(UIButton *)sender { //重新开始计算
    [stack recoverStack];   //重置栈
    operation = 'n';        //重置运算符记录变量
    [self.delegate normalPassResultValue:@"0"];
    [self.equation deleteCharactersInRange:NSMakeRange(0, self.equation.length)];
    [self.delegate normalPassEquationValue:@"0"];
}


//根据符号进行计算，返回计算结果

//二元运算
-(double)opeartion:(char)op firstNum:(double)fn secondNum:(double)dn{
    switch (op) {
        case '+':
            return fn + dn;
        case '-':
            return fn - dn;
        case '*':
            return fn * dn;
        case '/':
            return fn / dn;
        case '%':
            return (long)fn % (long)dn;
        default:
            return -1024;
    }
}

//一元运算
-(double)operation:(char)op num:(double)n {
    switch (op) {
        case 'g':   //根号
            return sqrt(n);
        case 'r':   //取反
            return 0 - n;
        case 'd':   //倒数
            return 1 / n;
        default:
            return -1024;
    }
}


@end
