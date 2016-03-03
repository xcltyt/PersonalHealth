//
//  PHCategory.m
//  PersonalHealthHelper
//
//  Created by qianfeng on 16/3/1.
//  Copyright © 2016年 PH. All rights reserved.
//

#import "PHCategory.h"

@implementation PHCategory

- (NSMutableArray *)books
{
    
    if (!_books) {
        _books = [NSMutableArray array];
    }
    return _books;
}

@end
