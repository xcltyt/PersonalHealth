//
//  YUDBManager.h
//  Test
//
//  Created by qianfeng on 16/1/9.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PHBook;

@interface YUDBManager : NSObject

+ (YUDBManager *)sharedManager;

- (void)createDatabase;

- (void)insertBook:(PHBook *)book;

- (NSArray *)searchAllBook;

- (void)deleteBookWithID:(NSString *)ID;

- (void)deleteCollectWithBook:(PHBook *)book;

@end
