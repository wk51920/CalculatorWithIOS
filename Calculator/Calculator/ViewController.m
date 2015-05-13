//
//  ViewController.m
//  Calculator
//
//  Created by wk on 15/4/27.
//  Copyright (c) 2015年 WK. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Stack.h"

typedef double numbType;

@interface ViewController ()


@property (weak, nonatomic) IBOutlet UILabel *equationLabel;

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *calculationType;

@property (weak, nonatomic) IBOutlet UIView *scientificCalculatorView;

@property (weak, nonatomic) IBOutlet UIView *normalCalculatorView;


@property (strong, nonatomic) NSMutableString *equation;

@property (strong, nonatomic) NSMutableString *result;

@end

@implementation ViewController{
    numbType number; //用于将结果存储为一个真实的值
    Stack *stack;    //用于计算的栈
    char operation;  //用于记录上一个运算符是什么
    BOOL singlePush; //在一元计算中标示压入一个输入值（YES）还是压入一个默认值0（NO）
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    stack = [[Stack alloc] init];
    
    singlePush = NO;
    
    operation = 'n';  //'n'表示一个真正空的运算符
    
    self.equation = [NSMutableString stringWithCapacity:40];
    
    self.result = [NSMutableString stringWithCapacity:40];
    
    //为结果标签设置圆角形式
    self.resultLabel.layer.cornerRadius = 20;
    self.resultLabel.layer.borderColor = [UIColor grayColor].CGColor;
    self.resultLabel.layer.borderWidth = 3;
    
    //必须将下一句设为YES否则，圆角边界还有原来残余的部分
    self.resultLabel.layer.masksToBounds = YES;
    /********************************************/
    self.normalCalculatorView.layer.cornerRadius = 20;
    self.normalCalculatorView.layer.borderColor = [UIColor grayColor].CGColor;
    self.normalCalculatorView.layer.borderWidth = 3;
    /******************************************/
    self.equationLabel.layer.cornerRadius = 20;
    self.equationLabel.layer.borderColor = [UIColor grayColor].CGColor;
    self.equationLabel.layer.borderWidth = 3;
    
    //必须将下一句设为YES否则，圆角边界还有原来残余的部分
    self.equationLabel.layer.masksToBounds = YES;
    /********************************************/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
- (IBAction)switchCaclutor:(UISegmentedControl *)sender {
    if(sender.selectedSegmentIndex == 1){
        [self.normalCalculatorView setHidden:YES];
    }else{
        [self.normalCalculatorView setHidden:NO];
    }
}

/********************数字区按键功能************************/

- (IBAction)numTouch:(UIButton *)sender {
    singlePush = YES;
    switch (sender.tag) {
        case 1001:
            [self.equation appendString:@"1"];
            self.equationLabel.text = self.equation;
            break;
        case 1002:
            [self.equation appendString:@"2"];
            self.equationLabel.text = self.equation;
            break;
        case 1003:
            [self.equation appendString:@"3"];
            self.equationLabel.text = self.equation;
            break;
        case 1004:
            [self.equation appendString:@"4"];
            self.equationLabel.text = self.equation;
            break;
        case 1005:
            [self.equation appendString:@"5"];
            self.equationLabel.text = self.equation;
            break;
        case 1006:
            [self.equation appendString:@"6"];
            self.equationLabel.text = self.equation;
            break;
        case 1007:
            [self.equation appendString:@"7"];
            self.equationLabel.text = self.equation;
            break;
        case 1008:
            [self.equation appendString:@"8"];
            self.equationLabel.text = self.equation;
            break;
        case 1009:
            [self.equation appendString:@"9"];
            self.equationLabel.text = self.equation;
            break;
        default:
            break;
    }
    
}

- (IBAction)zeroTouch:(UIButton *)sender {
    if([self.equation length] != 0){
        [self.equation appendString:@"0"];
        self.equationLabel.text = self.equation;
    }
}

- (IBAction)dotTouch:(UIButton *)sender {
    if([self.equation length] == 0){
        [self.equation appendString:@"0"];
        [self.equation appendString:@"."];
        self.equationLabel.text = self.equation;
    }else{
        [self.equation appendString:@"."];
        self.equationLabel.text = self.equation;
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
                if(operation == 'n')
                    operation = 'r';
                temp = [stack pop];
                temp = [self operation:operation num:temp];
                self.resultLabel.text = [NSString stringWithFormat:@"%f", temp];
                [stack push:temp];
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
                if(operation == 'n')
                    operation = 'd';
                temp = [stack pop];
                temp = [self operation:operation num:temp];
                self.resultLabel.text = [NSString stringWithFormat:@"%f", temp];
                [stack push:temp];
            }
            break;
            
        case 1015: // /
            if([stack isEmpty]){
                [stack push:number];
                operation = '/';
            }else{
                if(operation == 'n'){
                    operation = '/';
                    number = 1;  //同理乘法运算
                }
                temp = [stack pop];
                temp = [self opeartion:operation firstNum:temp secondNum:number];
                self.resultLabel.text = [NSString stringWithFormat:@"%f", temp];
                [stack push:temp];
            }

            break;
            
        case 1016: // %
            if([stack isEmpty]){
                [stack push:number];
                operation = '%';
            }else{
                if(operation == 'n')
                    operation = '%';
                temp = [stack pop];
                temp = [self opeartion:operation firstNum:temp secondNum:number];
                self.resultLabel.text = [NSString stringWithFormat:@"%f", temp];
                [stack push:temp];
            }

            break;
            
        case 1017: // *
            if([stack isEmpty]){
                [stack push:number];
                operation = '*';
            }else{
                if(operation == 'n'){
                    operation = '*';
                    number = 1;  //由于在乘法运算中如果使用默认值0，则会使得相乘的值变为0，因此不同于加减法运算
                }
                temp = [stack pop];
                temp = [self opeartion:operation firstNum:temp secondNum:number];
                self.resultLabel.text = [NSString stringWithFormat:@"%f", temp];
                [stack push:temp];
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
                if(operation == 'n')
                    operation = 'g';
                temp = [stack pop];
                temp = [self operation:operation num:temp];
                self.resultLabel.text = [NSString stringWithFormat:@"%f", temp];
                [stack push:temp];
            }
            
            break;
            
        case 1019: // -
            if([stack isEmpty]){
                [stack push:number];
                operation = '-';
            }else{
                if(operation == 'n')
                    operation = '-';
                
                temp = [stack pop];
                temp = [self opeartion:operation firstNum:temp secondNum:number];
                self.resultLabel.text = [NSString stringWithFormat:@"%f", temp];
                [stack push:temp];
            }
            
            break;
            
        case 1020: // +
            if([stack isEmpty]){
                [stack push:number]; //第一次压栈只压栈不计算
                operation = '+';     //记录第一次运算的运算符
            }else{
                if(operation == 'n')
                    operation = '+';
                temp = [stack pop];
                temp = [self opeartion:operation firstNum:temp secondNum:number];
                self.resultLabel.text = [NSString stringWithFormat:@"%f", temp];
                [stack push:temp];
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
                self.resultLabel.text = [NSString stringWithFormat:@"%f", temp];
                operation = 'n';
            }
            break;
        default:
            break;
    }
    self.equationLabel.text = @"0";
    
}

- (IBAction)delTouch:(UIButton *)sender {
    if(self.equation.length > 0){
        [self.equation deleteCharactersInRange:NSMakeRange(self.equation.length - 1, 1)];
        if(self.equation.length > 0)
            self.equationLabel.text = self.equation;
        else
            self.equationLabel.text = @"0";
    }
}

- (IBAction)ACTouch:(UIButton *)sender {  //只清除本次输入
    [self.equation deleteCharactersInRange:NSMakeRange(0, self.equation.length)];
    self.equationLabel.text = @"0";
}

- (IBAction)MCTouch:(UIButton *)sender { //重新开始计算
    [stack recoverStack];   //重置栈
    operation = 'n';        //重置运算符记录变量
    self.resultLabel.text = [NSString stringWithFormat:@"%d", 0];
    [self.equation deleteCharactersInRange:NSMakeRange(0, self.equation.length)];
    self.equationLabel.text = @"0";
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