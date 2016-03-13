//
//  YUDBManager.m
//  Test
//
//  Created by qianfeng on 16/1/9.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "YUDBManager.h"
#import "FMDatabase.h"
#import "PHBook.h"

@implementation YUDBManager

{
    FMDatabase *_myDatabase;
}


+ (YUDBManager *)sharedManager
{
    static YUDBManager *manager =nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            
            manager = [[YUDBManager alloc]init];
            
        }
        
    });
    return manager;
}

-(instancetype)init
{
    if (self = [super init])
    {
        [self createDatabase];
    }
    return self;
}
- (void)createDatabase
{
//    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/news.sqlite"];
    
    _myDatabase  = [[FMDatabase alloc]initWithPath:path];
  //  NSLog(@"%@",path);
    
    BOOL ret  = [_myDatabase open];
    
    if (ret) {
        NSString *createSql = @"create table if not exists book(ID integer primary key autoincrement,name varchar(50),author varchar(50),img varchar(50),summary varchar(50),content varchar(50),bookclass varchar(50),fromer varchar(50))";
        
        BOOL flag = [_myDatabase executeUpdate:createSql];
        
        if (flag == NO) {
            
          //  NSLog(@"%@",_myDatabase.lastErrorMessage);
        }
        
    }else
    {
      //  NSLog(@"%@",_myDatabase.lastErrorMessage);
    }
    
    
}
- (void)insertBook:(PHBook *)book;
{
    NSString *insertSql = @"insert into book (name, author, img, ID,summary,content,bookclass,fromer) values(?,?,?,?,?,?,?,?)";
    
    BOOL flag = [_myDatabase executeUpdate:insertSql,book.name,book.author,book.img,book.ID,book.summary,book.content,book.bookclass,book.fromer];
    
    if (flag)
    {
        //此处应有弹窗
        UITabBarController * tabbar =(UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"收藏成功" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [tabbar.selectedViewController presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        
    }
}

- (NSArray *)searchAllBook;
{
    NSString *selectSql = @"select * from book";
    FMResultSet *rs =[_myDatabase executeQuery:selectSql];
    NSMutableArray *arrayM = [NSMutableArray array];
    
    while ([rs next]) {
        PHBook *book = [[PHBook alloc]init];
        
      //  news.newsId = [rs intForColumn:@"newsId"];
        book.name = [rs stringForColumn:@"name"];
        book.author = [rs stringForColumn: @"author"];
        book.img = [rs stringForColumn:@"img"];
        book.ID = [rs stringForColumn:@"ID"];
        book.summary = [rs stringForColumn:@"summary"];
        book.content = [rs stringForColumn:@"content"];
        book.bookclass = [rs stringForColumn:@"bookclass"];
        book.fromer = [rs stringForColumn:@"fromer"];
        [arrayM addObject:book];
        
    }
    
    return arrayM;
}

//- (void)updateNews:(YUNews *)news withNewsId:(NSInteger)newsId
//{
//    
//    NSString *updateSql = @"update news set title=? ,time=? ,image=? ,nid=?,where newsId =?";
//    
//    BOOL flag =  [_myDatabase executeUpdate:updateSql,news.title,news.createTime,news.header_img_url,news.nid,@(newsId)];
//    if (flag == NO) {
//        
//        NSLog(@"%@",_myDatabase.lastErrorMessage);
//        
//    }
//    
//}

- (void)deleteBookWithID:(NSString *)ID
{
    NSString *delectSql = @"delete from book where ID =?";
    
    BOOL flag = [_myDatabase executeUpdate:delectSql,ID];
    if (flag) {
        
    //    NSLog(@"收藏失败%@",[_myDatabase lastErrorMessage]);
        UITabBarController * tabbar =(UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"取消收藏成功" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [tabbar.selectedViewController presentViewController:alert animated:YES completion:nil];
    }
    
}

-(void)deleteCollectWithBook:(PHBook *)book
{
    [self deleteBookWithID:book.ID];
}

@end
