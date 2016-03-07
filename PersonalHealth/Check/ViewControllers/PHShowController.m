//
//  PHShowController.m
//  PersonalHealthHelper
//
//  Created by 汪俊 on 16/3/2.
//  Copyright © 2016年 PH. All rights reserved.
//

#import "PHShowController.h"
#import "NSDate+Formatter.h"
#import "PHMoreLeftView.h"
#import "PHMoreRightView.h"
#import "PHCheckList.h"
#import "MJExtension.h"
#import "SVProgressHUD.h"
#import "PHListViewController.h"
#import "PHDescription.h"



#define secret @"b034a3a7f7b144debe727ccebff2fd23"

@interface PHShowController () <PHMoreLeftViewDelegate, PHMoreRightViewDelegate>

@property (weak, nonatomic) PHMoreLeftView *leftView;
@property (weak, nonatomic) PHMoreRightView *rightView;

@property (strong, nonatomic)NSArray *listArray;

@property (assign, nonatomic)NSInteger leftIndex;

@end

@implementation PHShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    PHMoreLeftView *leftView = [[PHMoreLeftView alloc]init];
    leftView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.leftView = leftView;
    
    leftView.delegate = self;
    
    leftView.frame = CGRectMake(0, 0, 100, ScreenH);
    
    [self.view addSubview:leftView];
    
    PHMoreRightView *rightView = [[PHMoreRightView alloc]init];
    
    rightView.frame = CGRectMake(100, 0, ScreenW - 100, ScreenH);
    rightView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rightView = rightView;
    rightView.delegate = self;
    [self.view addSubview:rightView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self loadData];
}

- (void)loadData {
    NSString *dataString = [NSDate currentDateStringWithFormat:@"yyyyMMdd HHmmss"];
    dataString = [dataString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *sign = [NSString stringWithFormat:@"showapi_appid%@showapi_timestamp%@%@",@"16299",dataString,secret];
    sign = [sign md532BitLower];
    NSDictionary *param = @{
                            @"showapi_appid" : @"16299",
                            @"showapi_sign" : sign,
                            @"showapi_timestamp": dataString,
                            };
    // 显示指示器
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
#pragma mark －请求－
    [PHNetHelper POSTWithExtraUrl:@"546-1" andParam:param andComplete:^(BOOL success, id result) {
        if (success) {
            NSError *error;
            NSDictionary *dictjson = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:&error];
            NSDictionary *dict = dictjson[@"showapi_res_body"];
            if ([dict[@"ret_code"]integerValue] == 0) {
                ;
                [SVProgressHUD dismiss];
                self.listArray = [PHCheckList mj_objectArrayWithKeyValuesArray:dict[@"list"]];
                self.leftView.categories = self.listArray;
                // 默认选中首行
                [self.leftView.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
                [self friendsLeftView:self.leftView didClickIndex:0];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"加载分类信息失败!"];
        }
    }];
}

- (void)friendsLeftView:(PHMoreLeftView *)leftView didClickIndex:(NSInteger)index {
    PHCheckList *description = self.listArray[index];
    [self.rightView.users removeAllObjects];
    [self.rightView.users addObjectsFromArray:description.subList];
    [self.rightView.tableView reloadData];
    self.leftIndex = index;
    
}

- (void)moreRightView:(PHMoreRightView *)rightView didSelectRow:(NSInteger)row {
    
    PHListViewController *phlistVC = [[PHListViewController alloc]init];
    PHCheckList *checkList = self.listArray[self.leftIndex];
    PHDescription *desc = checkList.subList[row];
    phlistVC.typeId = desc.subId;
    [self.navigationController pushViewController:phlistVC animated:YES];
}


@end
