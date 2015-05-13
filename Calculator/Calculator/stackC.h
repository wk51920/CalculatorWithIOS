//
//  stackC.h
//  Calculator
//
//  Created by wk on 15/5/7.
//  Copyright (c) 2015年 WK. All rights reserved.
//

#ifndef Calculator_stackC_h
#define Calculator_stackC_h

#define MAXSIZE 100

typedef struct{
    int top;
    float dataC[MAXSIZE];
}SqStack;

initStack(SqStack *s){
    s->top = -1;
}

bool StackEmpty(SqStack s){
    if(s.top == -1)
        return true;
    else
        return false;
}

int StackLength(SqStack s){
    return s.top + 1;
}

float GetTop(SqStack s){
    if(!(s.top == -1)){
        return s.dataC[top];
    }
}

push(SqStack *s, float e){
    if(s->top < MAXSIZE - 1){
        s->dataC[++s.top] = e;
    }
}

float pop(SqStack *s){
    if(s->top >= 0 ){
        return s->dataC[s->top--];
    }
}
#endif
