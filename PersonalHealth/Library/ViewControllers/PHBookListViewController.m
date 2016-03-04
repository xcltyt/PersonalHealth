//
//  PHBookListViewController.m
//  PersonalHealthHelper
//
//  Created by qianfeng on 16/3/2.
//  Copyright © 2016年 PH. All rights reserved.
//

#import "PHBookListViewController.h"
#import "NSDate+Formatter.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "PHBookList.h"
#import "PHBook.h"
#import "PHPageViewController.h"
#import "SVProgressHUD.h"

@interface PHBookListViewController ()

@end

@implementation PHBookListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self loadDeailData];
    
    self.title = @"目录";
    
    self.tableView.backgroundColor = PHGlobalBg;
}

- (void)loadDeailData
{
    // 显示指示器
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    NSString *nowDate = [NSDate currentDateStringWithFormat:@"yyyyMM ddHHmmss"];
    NSString *usefulDate = [nowDate stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *path = @"92-94";
    NSString *secret = @"b034a3a7f7b144debe727ccebff2fd23";
    NSString *sign = [NSString stringWithFormat:@"keyword%@showapi_appid16299showapi_timestamp%@%@",@"男",usefulDate,secret];
    NSString *md5Sign = [sign md532BitLower];
    
    NSDictionary *params = @{
                             @"keyword":@"男",
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
            
            if (dict == nil) {
                [self loadDeailData];
                return ;
            }
            
            
            NSDictionary *tmpDict = dict[@"showapi_res_body"][@"bookDetails"];
            
            self.book = [PHBook mj_objectWithKeyValues:tmpDict];
            
          //  [self.tableView reloadData];
            
            
        } else {
           [SVProgressHUD showErrorWithStatus:@"请求失败"]; 
        }
        
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return self.book.list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Id = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    
    PHBookList *list = self.book.list[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld  %@",indexPath.row + 1,list.title];
    

    cell.backgroundColor = PHGlobalBg;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PHPageViewController *pageVc = [[PHPageViewController alloc]init];
    
    pageVc.book = self.book;
    pageVc.currentIndex = indexPath.row;
//    [self presentViewController:pageVc animated:YES completion:nil];
    
    [self.navigationController pushViewController:pageVc animated:YES];
}

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
