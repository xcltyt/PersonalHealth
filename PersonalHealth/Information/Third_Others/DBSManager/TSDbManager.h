//
//  TSDbManager.h
//  搜狐
//
//  Created by qianfeng on 16/1/8.
//  Copyright (c) 2016年 TS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHMsgTableMod.h"

@interface TSDbManager : NSObject

+(TSDbManager *)sharedManager;

//查询所有
-(NSArray *)searchAllCollect;

//插入
-(void)insert:(PHMsgTableMod *)mod;

//删除
-(void)deleteCollectWithID:(NSString *)ID;

-(void)deleteCollectWithMod:(PHMsgTableMod *)mod;

@end
