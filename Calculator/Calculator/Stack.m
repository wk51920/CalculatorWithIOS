//
//  Stack.m
//  Calculator
//
//  Created by wk on 15/5/6.
//  Copyright (c) 2015年 WK. All rights reserved.
//

#import "Stack.h"

@implementation Stack{
    float stack[MAXSIZE];
    int top ;
}

-(id) init{
    if(self = [super init]){
        top = -1;
    }
    return self;
}


- (void) push: (numbType) atom{
    if(top < MAXSIZE - 1){
        stack[++top] = atom;
    }
}

-(numbType) pop{
    if(top >= 0){
        return stack[top--];
    }else
        return -1024;
}

-(BOOL)isEmpty{
    if(top == -1)
        return YES;
    else
        return NO;
}

-(numbType)getTop{
    if(top > -1){
        return stack[top];
    }else
        return -1024;
}

-(int)stackLength{
    return top + 1;
}

-(void)recoverStack{
    top = -1;
}

@end
