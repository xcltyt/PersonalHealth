//
//  PHBookDetailViewController.m
//  PersonalHealthHelper
//
//  Created by qianfeng on 16/3/2.
//  Copyright © 2016年 PH. All rights reserved.
//

#import "PHBookDetailViewController.h"
#import "NSDate+Formatter.h"
#import "PHBook.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "PHHeaderView.h"
#import "PHBookList.h"
#import "PHBookListViewController.h"
#import "SVProgressHUD.h"
#import "PHPageViewController.h"

@interface PHBookDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) PHHeaderView *headerView;

@property (nonatomic, strong) NSArray *lists;

@end

@implementation PHBookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBasic];
    
    [self loadDeailData];
}

- (void)setupBasic
{
    self.title = @"图书详情";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置tableview
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置inset
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    // 添加headerView
    PHHeaderView *headerView = [PHHeaderView headerView];
    self.headerView = headerView;
    headerView.book = self.book;
    
    CGRect frame = headerView.frame;
    frame.size.height = self.book.headerViewHeight;
    headerView.frame = frame;
    
    self.tableView.tableHeaderView = headerView;
    tableView.rowHeight = 40;
    
}


- (void)loadDeailData
{
    // 显示指示器
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    NSString *nowDate = [NSDate currentDateStringWithFormat:@"yyyyMM ddHHmmss"];
    NSString *usefulDate = [nowDate stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *path = @"92-91";
    NSString *secret = @"b034a3a7f7b144debe727ccebff2fd23";
    NSString *sign = [NSString stringWithFormat:@"id%@showapi_appid16299showapi_timestamp%@%@",self.book.ID,usefulDate,secret];
    NSString *md5Sign = [sign md532BitLower];
    
    NSDictionary *params = @{
                             @"id":self.book.ID,
                             @"showapi_appid":@"16299",
                             @"showapi_timestamp":usefulDate,
                             @"showapi_sign":md5Sign,
                             };
    
    [PHNetHelper POSTWithExtraUrl:path andParam:params andComplete:^(BOOL success, id result) {
        if (success) {
            // 隐藏指示器
            [SVProgressHUD dismiss];
            
            NSError *error = nil;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:&error];
            if (error) {
                
                [SVProgressHUD showErrorWithStatus:@"解析失败"];
            }
            
            NSDictionary *tmpDict = dict[@"showapi_res_body"][@"bookDetails"];
            
            if (tmpDict == nil) {
                
                [self loadDeailData];
                return;
            }
            
            self.book = [PHBook mj_objectWithKeyValues:tmpDict];
            
            self.lists = self.book.list;
            
            [self.tableView reloadData];
            
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }
        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0) {
        
        cell = [[UITableViewCell alloc]init];
        
        cell.textLabel.text = @"    开始阅读";
        cell.textLabel.textColor = [UIColor colorWithRed:1.000 green:0.496 blue:0.573 alpha:1.000];
        
    } else
    {
        cell = [[UITableViewCell alloc]init];
        
        cell.textLabel.text = @"    点击查看目录";
        cell.textLabel.textColor = [UIColor colorWithRed:1.000 green:0.656 blue:0.591 alpha:1.000];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    if (indexPath.row == 0) {
        PHPageViewController *pageVc = [[PHPageViewController alloc]init];
        
        pageVc.book = self.book;
        pageVc.currentIndex = 0;
        //    [self presentViewController:pageVc animated:YES completion:nil];
        
        [self.navigationController pushViewController:pageVc animated:YES];
        
        
    } else {
        
        PHBookListViewController *listVc = [[PHBookListViewController alloc]init];
        
        listVc.book = self.book;
        
        [self.navigationController pushViewController:listVc animated:YES];
    }
}


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    PHBook *book = self.book;
//    
//    return book.headerViewHeight;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
