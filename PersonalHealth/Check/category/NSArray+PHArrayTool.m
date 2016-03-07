//
//  NSArray+PHArrayTool.m
//  PersonalHealth
//
//  Created by 汪俊 on 16/3/4.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import "NSArray+PHArrayTool.h"

//存放最多多少条历史记录📝
#define PHHistoryLength 10
// 存取的key值
#define PHHistoryKey @"checkHistory"

@implementation NSArray (PHArrayTool)

+ (void)storeHistoryString:(NSString *)str {
    NSMutableArray *historyArray = [NSMutableArray array];

    //从沙盒中取出上次存储的搜索纪录(取出用户上次的使用记录)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *checkHistory = [defaults objectForKey:PHHistoryKey];
    if (![checkHistory containsObject:str]) {
        [historyArray addObject:str];
    }else {
        [historyArray removeObject:str];
        [historyArray addObject:str];
    }
    if (checkHistory == nil || checkHistory.count == 0) {

    }else if(checkHistory.count < PHHistoryLength){
        for (NSString *historyStr in checkHistory) {
            if (![historyArray containsObject:historyStr]) {
                [historyArray addObject:historyStr];
            }
        }
    }else {
        for (int i = 0 ; i < PHHistoryLength - 1; i++) {
            NSString *historyStr = checkHistory[i];
            if (![historyArray containsObject:historyStr]) {
                [historyArray addObject:historyStr];
            }
        }
    }
    [defaults setObject:historyArray forKey:PHHistoryKey];
    [defaults synchronize];
}


+ (NSArray *)history {
    //从沙盒中取出上次存储的搜索纪录(取出用户上次的使用记录)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *checkHistory = [defaults objectForKey:PHHistoryKey];
    return checkHistory;
}

@end
