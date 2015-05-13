//
//  Stack.h
//  Calculator
//
//  Created by wk on 15/5/6.
//  Copyright (c) 2015年 WK. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAXSIZE 100
typedef double  numbType;

@interface Stack : NSObject

-(void) push:(numbType) atom;

-(numbType) pop;

-(BOOL) isEmpty;

-(numbType) getTop;

-(int) stackLength;

-(void) recoverStack;

@end
