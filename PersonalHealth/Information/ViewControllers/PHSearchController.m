//
//  PHSearchController.m
//  PersonalHealthHelper
//
//  Created by Dylan on 3/2/16.
//  Copyright © 2016 PH. All rights reserved.
//

#import "PHSearchController.h"
#import "PHMsgTableView.h"
#import "PHMsgTableMod.h"
#import "PHDetailMod.h"
#import "PHMsgDetailController.h"

@interface PHSearchController ()<PHMsgTableViewDelegate>

@property (nonatomic,strong)UITextField * searchField;
@property (nonatomic,strong)PHMsgTableView * tableView;
@end

@implementation PHSearchController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configNavigation];
    self.view.backgroundColor=[UIColor whiteColor];
}
-(void)configNavigation
{
    UITextField * searchField=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, SCRW*0.65, NAVH-12)];
    searchField.borderStyle=UITextBorderStyleRoundedRect;
    searchField.clearButtonMode=UITextFieldViewModeAlways;
    self.navigationItem.titleView =searchField;
    self.searchField=searchField;
    
    [searchField becomeFirstResponder];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(ringtBtnTouch)];
}
//搜索功能
-(void)ringtBtnTouch
{
    CGFloat phY=NAVH+20;
    CGFloat phH=SCRH-NAVH-20-TabbarH;
    CGRect frame= CGRectMake(0, phY, SCRW, phH);
    PHMsgTableView * msgTable=[PHMsgTableView phmsgTableViewWithFrame:frame andKeywords:self.searchField.text];
    msgTable.delegate=self;
    self.tableView=msgTable;
    [self.view addSubview:msgTable];
    [self.searchField endEditing:YES];
}
//根据mod，请求数据加载页面
-(void)downLoadRowsMsgWithModel:(PHMsgTableMod *)mod
{
    NSString * currentDate=[NSDate currentDateStringWithFormat:@"yyyyMM ddHHmmss"];
    NSString * usefulDate=[currentDate stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString * path=@"96-36";
    //这里通过model获取id,并且加入序列中
    NSString * sign=[NSString stringWithFormat:@"id%@showapi_appid%@showapi_timestamp%@%@",mod.ID,PHID,usefulDate,PHSerect];
    NSLog(@"%@",mod.ID);
    
    NSString * md5Sign=[sign md532BitLower];
    NSDictionary * param =@{
                            @"id":mod.ID,
                            @"showapi_appid":PHID,
                            @"showapi_timestamp":usefulDate,
                            @"showapi_sign":md5Sign
                            };
    
    [PHNetHelper POSTWithExtraUrl:path andParam:param andComplete:^(BOOL success, id result) {
        
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
                //获取名称
                //获取名称
                NSDictionary * tempDict=dict[@"showapi_res_body"];
                PHDetailMod * mod= [PHDetailMod modWithDict:tempDict[@"item"]];
                PHMsgDetailController * detailCtl=[PHMsgDetailController phMsgDetailControllerWithPHDetailMod:mod];
                [self.navigationController pushViewController:detailCtl animated:YES];

            }
        }
        else
        {
            NSLog(@"%@",result);
            NSLog(@"请求失败");
        }
    }];
}
#pragma PHMsgTableViewDelegate
-(void)phMsgTableViewRowsSelectedWithMode:(PHMsgTableMod *)mod
{
    [self downLoadRowsMsgWithModel:mod];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
