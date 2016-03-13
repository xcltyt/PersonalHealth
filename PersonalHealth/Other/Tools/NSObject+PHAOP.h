//
//  NSObject+PHAOP.h
//  PersonalHealth
//
//  Created by lifan on 16/3/2.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PHAOP)

+ (void)aop_changeMethod:(SEL)oldMethod withNewMethod:(SEL)newMethod;

@end
