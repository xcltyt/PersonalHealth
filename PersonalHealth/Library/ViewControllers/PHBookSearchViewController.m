//
//  PHBookSearchViewController.m
//  PersonalHealth
//
//  Created by qianfeng on 16/3/3.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import "PHBookSearchViewController.h"
#import "PHSearchBar.h"
#import "SVProgressHUD.h"
#import "PHBook.h"
#import "MJExtension.h"
#import "PHBookDetailViewController.h"
#import "PHBookSearchCell.h"

static NSString *searchCellId = @"searchCellId";

@interface PHBookSearchViewController () <UIScrollViewDelegate>

/** 搜索到的图书数据 */
@property (nonatomic, strong) NSArray *books;
/** 搜索框 */
@property (nonatomic, strong) UITextField *searchBar;

@end

@implementation PHBookSearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PHBookSearchCell class]) bundle:nil] forCellReuseIdentifier:searchCellId];
    
}

- (void)setupNav
{
    self.view.backgroundColor = [UIColor whiteColor];
    // 创建搜索框对象
    PHSearchBar *searchBar = [PHSearchBar searchBar];
    searchBar.width = 260;
    searchBar.height = 30;
    self.searchBar = searchBar;
    
    [searchBar becomeFirstResponder];
    
    self.navigationItem.titleView = searchBar;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchItemClick)];
    
}

- (void)searchItemClick
{
    [self.searchBar resignFirstResponder];
    
    NSString *tmpStr = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (tmpStr.length > 0) {
        
        [self loadDeailWithKeyWords:tmpStr];
        
    }
}

- (void)loadDeailWithKeyWords:(NSString *)keyWords
{
    // 显示指示器
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    NSString *nowDate = [NSDate currentDateStringWithFormat:@"yyyyMM ddHHmmss"];
    NSString *usefulDate = [nowDate stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *path = @"92-94";
    NSString *secret = @"b034a3a7f7b144debe727ccebff2fd23";
    NSString *sign = [NSString stringWithFormat:@"keyword%@showapi_appid16299showapi_timestamp%@%@",keyWords,usefulDate,secret];
    NSString *md5Sign = [sign md532BitLower];
    
    NSDictionary *params = @{
                             @"keyword":keyWords,
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
            
            NSArray *tmpArray = dict[@"showapi_res_body"][@"bookList"];
            
            self.books = [PHBook mj_objectArrayWithKeyValuesArray:tmpArray];
            
            [self.tableView reloadData];
            
            
        } else {
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }
        
    }];
    
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.books.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PHBookSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCellId];
    
    cell.book = self.books[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PHBookDetailViewController *detailVc = [[PHBookDetailViewController alloc]init];
    
    detailVc.book = self.books[indexPath.row];
    
    [self.navigationController pushViewController:detailVc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.searchBar resignFirstResponder];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

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
