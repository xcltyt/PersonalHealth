//
//  NSObject+PHAOP.m
//  PersonalHealth
//
//  Created by lifan on 16/3/2.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import "NSObject+PHAOP.h"
#import <objc/runtime.h>

@implementation NSObject (PHAOP)

+ (void)aop_changeMethod:(SEL)oldMethod withNewMethod:(SEL)newMethod {
    Method oldM = class_getInstanceMethod([self class], oldMethod);
    Method newM = class_getInstanceMethod([self class], newMethod);
    method_exchangeImplementations(oldM, newM);
}

@end
