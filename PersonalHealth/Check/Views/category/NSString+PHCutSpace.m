//
//  NSString+PHCutSpace.m
//  PersonalHealth
//
//  Created by 汪俊 on 16/3/4.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import "NSString+PHCutSpace.h"

@implementation NSString (PHCutSpace)


+ (NSString *)cutSpace:(NSString *)str {
    
    for (int i = 0 ; i < str.length - 1; i++) {
        if ([str characterAtIndex:i] != ' ') {
            str = [str substringFromIndex:i];
            break;
        }
    }
    
    for (long i = str.length - 1 ; i > 0; i--) {
        if ([str characterAtIndex:i] != ' ') {
            str = [str substringToIndex:i+1];
            break;
        }
    }
    return str;
}

@end
