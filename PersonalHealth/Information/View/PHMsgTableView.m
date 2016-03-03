//
//  PHMsgTableController.m
//  PersonalHealthHelper
//
//  Created by Dylan on 3/1/16.
//  Copyright © 2016 PH. All rights reserved.
//

#import "PHMsgTableView.h"
#import "MJRefresh.h"

@interface PHMsgTableView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation PHMsgTableView
+(instancetype)phmsgTableViewWithFrame:(CGRect)frame andtableModArray:(NSArray *)array
{
    PHMsgTableView * table=[[PHMsgTableView alloc]initWithFrame:frame];
    table.dataArray=(NSMutableArray *)array;
    [table.tableView reloadData];
    return table;
}
+(instancetype)phmsgTableViewWithFrame:(CGRect)frame andtid:(NSNumber *)tid
{
    PHMsgTableView * table=[[PHMsgTableView alloc]initWithFrame:frame];
    table.tid=tid;
    return table;
}
+(instancetype)phmsgTableViewWithFrame:(CGRect)frame andKeywords:(NSString *)keywords
{
    PHMsgTableView * table=[[PHMsgTableView alloc]initWithFrame:frame];
    table.keywords=keywords;
    return table;
}
-(UITableView *)tableView
{
    if (_tableView==nil)
    {
        _tableView=[[UITableView alloc]initWithFrame:self.bounds];
        [self addSubview:_tableView];
        _tableView.dataSource=self;
        _tableView.delegate=self;
    }
    return _tableView;
}

-(NSMutableArray *)dataArray
{
    if (_dataArray==nil)
    {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}
-(void)setTid:(NSNumber *)tid
{
    _tid=tid;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self downloadClassMsgWithtid:tid];
    }];
    [self downloadClassMsgWithtid:tid];
    
}
-(void)setKeywords:(NSString *)keywords
{
    _keywords=keywords;
    [self downloadMsgWithkeyWords:keywords];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
//        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -TabBarH, 0);
//        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, -TabBarH, 0);
        self.tableView.tableFooterView = [[UIView alloc] init];
    }
    return self;
}
-(void)downloadClassMsgWithtid:(NSNumber *)pid
{
    NSString * currentDate=[NSDate currentDateStringWithFormat:@"yyyyMM ddHHmmss"];
    NSString * usefulDate=[currentDate stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString * path=@"96-109";
    NSString * sign=[NSString stringWithFormat:@"showapi_appid%@showapi_timestamp%@tid%@%@",PHID,usefulDate,self.tid,PHSerect];
    
    NSString * md5Sign=[sign md532BitLower];
    NSDictionary * param =@{
                            @"tid":self.tid,
                            @"showapi_appid":PHID,
                            @"showapi_timestamp":usefulDate,
                            @"showapi_sign":md5Sign
                            };
    [PHNetHelper POSTWithExtraUrl:path andParam:param andComplete:^(BOOL success, id result)
     {
         if (success)
         {
             NSLog(@"请求成功");
             NSError * error;
             NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:&error];
             if (error)
             {
                 
                 NSLog(@"解析失败%@",error);
             }
             else
             {
                 //进行json解析
                 [self.tableView.mj_header endRefreshing];
                 NSDictionary * temp1=dict[@"showapi_res_body"];
                 NSDictionary * temp2=temp1[@"pagebean"];
                 NSArray * contentList=temp2[@"contentlist"];
                 for (NSDictionary * dict in contentList)
                 {
                     PHMsgTableMod * mod= [PHMsgTableMod modWithDict:dict];
                     [self.dataArray addObject:mod];
                 }
                 //刷新
                 [self.tableView reloadData];
             }
         }
         else
         {
             NSLog(@"%@",result);
             NSLog(@"请求失败");
         }
     }];
}
-(void)downloadMsgWithkeyWords:(NSString *)keyWords
{
    /**
     *  https://route.showapi.com/
     96-109?
     keyword=&
     page=&
     showapi_appid=16297&
     showapi_timestamp=20160301142507&
     tid=&
     showapi_sign=41b2bffeb985997cd485d8db08836fd9
     */
    NSString * currentDate=[NSDate currentDateStringWithFormat:@"yyyyMM ddHHmmss"];
    NSString * usefulDate=[currentDate stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString * path=@"96-109";
    NSString * sign=[NSString stringWithFormat:@"keyword%@showapi_appid%@showapi_timestamp%@%@",keyWords,PHID,usefulDate,PHSerect];
    NSString * md5Sign=[sign md532BitLower];
    NSDictionary * param =@{
                            @"keyword":_keywords,
                            @"showapi_appid":PHID,
                            @"showapi_timestamp":usefulDate,
                            @"showapi_sign":md5Sign
                            };
    [PHNetHelper POSTWithExtraUrl:path andParam:param andComplete:^(BOOL success, id result)
     {
         if (success)
         {
             NSLog(@"请求成功");
             NSError * error;
             NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:&error];
             if (error)
             {
                 NSLog(@"解析失败%@",error);
             }
             else
             {
                 //进行json解析
                 [self.tableView.mj_header endRefreshing];
                 NSDictionary * temp1=dict[@"showapi_res_body"];
                 NSDictionary * temp2=temp1[@"pagebean"];
                 NSArray * contentList=temp2[@"contentlist"];
                 if (contentList.count == 0 )
                 {
                     UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"抱歉，未检索到此类型消息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
                     [self addSubview:alert];
                     [alert show];
                 }
                 for (NSDictionary * dict in contentList)
                 {
                     PHMsgTableMod * mod= [PHMsgTableMod modWithDict:dict];
                     [self.dataArray addObject:mod];
                 }
                 //刷新
                 [self.tableView reloadData];
             }
         }
         else
         {
             NSLog(@"%@",result);
             NSLog(@"请求失败");
         }
     }];

}
#pragma mark - Table view data source
//条目
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PHMsgCell * cell=[PHMsgCell cellWithTableView:tableView];
    [cell configCellWithMod:self.dataArray[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PHMsgTableMod * mod= self.dataArray[indexPath.row];
    //传值
    [self.delegate phMsgTableViewRowsSelectedWithMode:mod];
}
@end
