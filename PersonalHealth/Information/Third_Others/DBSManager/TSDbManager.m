//
//  TSDbManager.m
//  搜狐
//
//  Created by qianfeng on 16/1/8.
//  Copyright (c) 2016年 TS. All rights reserved.
//

#import "TSDbManager.h"
#import "FMDatabase.h"

@implementation TSDbManager
{
    FMDatabase * _database;
}
+(TSDbManager *)sharedManager
{
    static TSDbManager * manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager==nil)
        {
            manager=[[TSDbManager alloc]init];
        }
    });
    return manager;
}
-(id)init
{
    if (self=[super init])
    {
        [self createDBS];
    }
    return self;
}
-(void)createDBS
{
    NSString * path=[NSHomeDirectory() stringByAppendingPathComponent:@"Library/phMsgTableMods.sqlite"];
    _database=[[FMDatabase alloc]initWithPath:path];
    BOOL ret=[_database open];
    if (ret)
    {
        NSLog(@"数据库 开启");
        NSString * createStr=@"create table if not exists phMsgTableMods (ID integer primary key ,author varchar(150),time varchar(150),img varchar(150),tname varchar(150),title varchar(150),tid integer,readCount varchar(150))";
        BOOL flag= [_database executeUpdate:createStr];
        if (flag)
        {
            NSLog(@"创建表格成功");
        }
        else
        {
            NSLog(@"%@",_database.lastErrorMessage);
        }
    }
    else
    {
        NSLog(@"%@",_database.lastErrorMessage);
    }
}
-(NSArray *)searchAllCollect
{
    NSString * searchAll=@"select * from phMsgTableMods";
    FMResultSet * set = [_database executeQuery:searchAll];
    NSMutableArray * array=[NSMutableArray array];
    while ([set next]) {
        PHMsgTableMod * mod=[PHMsgTableMod new];

        //查询，生成mod数组
        mod.author=[set stringForColumn:@"author"];
        mod.img=[set stringForColumn:@"img"];
        mod.time=[set stringForColumn:@"time"];
        mod.title=[set stringForColumn:@"title"];
        mod.tname=[set stringForColumn:@"tname"];
        mod.ID=[set stringForColumn:@"ID"];
        mod.tid=@([set intForColumn:@"tid"]);
        mod.readCount=[set stringForColumn:@"readCount"];
        [array addObject:mod];
        
    }
    return array;
}
-(void)insert:(PHMsgTableMod *)mod
{
    NSString * insertSql=@"insert into phMsgTableMods (author,img,time,title,tname,ID,tid,readCount) values (?,?,?,?,?,?,?,?)";
    BOOL flag=[_database executeUpdate:insertSql,mod.author,mod.img,mod.time,mod.title,mod.tname,mod.ID,mod.tid,mod.readCount];
    if (flag)
    {
        //此处应有弹窗
        UITabBarController * tabbar =(UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"收藏成功" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [tabbar.selectedViewController presentViewController:alert animated:YES completion:nil];
        
        NSLog(@"收藏成功");
    }
    else
    {
        NSLog(@"收藏失败%@",[_database lastErrorMessage]);
        UITabBarController * tabbar =(UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"您已经收藏过了" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [tabbar.selectedViewController presentViewController:alert animated:YES completion:nil];
    }
}
-(void)deleteCollectWithID:(NSString *)ID
{
    NSString * deleteStr=@"delete from phMsgTableMods where ID = ?";
    BOOL flag=[_database executeUpdate:deleteStr,ID];
    if (flag)
    {
        
        UITabBarController * tabbar =(UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"取消收藏成功" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [tabbar.selectedViewController presentViewController:alert animated:YES completion:nil];
        
        NSLog(@"删除成功");
    }
    else
    {
        NSLog(@"%@",_database.lastErrorMessage);
    }
}
-(void)deleteCollectWithMod:(PHMsgTableMod *)mod
{
    [self deleteCollectWithID:mod.ID];
}

@end
