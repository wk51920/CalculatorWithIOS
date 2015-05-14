//
//  ViewController.m
//  Calculator
//
//  Created by wk on 15/4/27.
//  Copyright (c) 2015年 WK. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

typedef double numbType;

@interface ViewController ()


@property (weak, nonatomic) IBOutlet UILabel *equationLabel;

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *calculationType;

@property (weak, nonatomic) IBOutlet UIView *scientificCalculatorView;

@property (weak, nonatomic) IBOutlet UIView *normalCalculatorView;

@property (strong, nonatomic) NormalCalculatorViewController * normalCal;
@property (strong, nonatomic)ScientificCalculatorViewController *scienCal;

@property (strong, nonatomic) NSMutableString *equation;

@property (strong, nonatomic) NSMutableString *result;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
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
    self.normalCalculatorView.layer.masksToBounds = YES;
    
    /******************************************/
    self.scientificCalculatorView.layer.cornerRadius = 20;
    self.scientificCalculatorView.layer.borderColor = [UIColor grayColor].CGColor;
    self.scientificCalculatorView.layer.borderWidth = 3;
    self.scientificCalculatorView.layer.masksToBounds = YES;
    
    //由于使用属性与storyboard关联后，相当于已经创建了此对象，则此时在未切换到此视图控制器时，将此视图删除，以节约内存
    [self.scientificCalculatorView setHidden:YES];
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

//通过segment控件切换视图
- (IBAction)switchCaclutor:(UISegmentedControl *)sender {
    if(sender.selectedSegmentIndex == 0){
        [self.scientificCalculatorView setHidden:YES];
        [self.normalCalculatorView setHidden:NO];
    }else if(sender.selectedSegmentIndex == 1){
        [self.scientificCalculatorView setHidden:YES];
        [self.scientificCalculatorView setHidden:NO];
    }
}

//此函数由viewController来侦听，如果在此viewController的view中有转场事件发生，则调用此函数
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"normalViewSegue"]){
        self.normalCal = segue.destinationViewController;
        self.normalCal.delegate = self;
    }else if([segue.identifier isEqualToString:@"scienViewSegue"]){
        self.scienCal = segue.destinationViewController;
        self.scienCal.delegate = self;
    }
}

#pragma mark - NormalCalculator Delegate Methods

-(void)normalPassEquationValue:(NSString *)value{
    NSLog(@"%@",value);
    self.equationLabel.text  = value;
}

-(void)normalPassResultValue:(NSString *)value{
    self.resultLabel.text = value;
}

@end
