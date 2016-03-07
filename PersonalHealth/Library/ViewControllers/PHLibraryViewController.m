//
//  PHLibraryViewController.m
//  PersonalHealthHelper
//
//  Created by lifan on 16/3/1.
//  Copyright © 2016年 PH. All rights reserved.
//

#import "PHLibraryViewController.h"
#import "NSDate+Formatter.h"
#import "PHCategory.h"
#import "PHBook.h"
#import "MJExtension.h"
#import "PHBookListCell.h"
#import "PHCategoryCell.h"
#import "MJRefresh.h"
#import "PHBookDetailViewController.h"
#import "SVProgressHUD.h"
#import "PHBookSearchViewController.h"

#define PHSelectedCategory self.categories[self.categoryTableView.indexPathForSelectedRow.row]

static NSString *categoryId = @"categoryId";
static NSString *bookListId = @"bookListId";

@interface PHLibraryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *categoryTableView;
@property (nonatomic, weak) UITableView *bookListTableView;

/** 左边的类别数据 */
@property (nonatomic, strong) NSArray *categories;
/** 右边的图书数据 */
@property (nonatomic, strong) NSMutableArray *books;
/** 当前页码 */
@property (nonatomic, assign) NSInteger page;
/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *params;

@end

@implementation PHLibraryViewController


#pragma mark - Setter & Getter


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置导航栏
    [self setupNav];
    
    // tableview的初始化
    [self setupTableView];
    
    // 加载左侧的分类数据
    [self loadCategories];
    
    // 添加刷新控件
    [self setupRefresh];
    
}

#pragma mark - Private Methods
/**
 *  设置导航栏
 */
- (void)setupNav
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"searchbar_textfield_search_icon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(searchItemClick)];
}

/**
 *  添加刷新控件
 */
- (void)setupRefresh
{
    self.bookListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewsBooks)];
    
    self.bookListTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreBooks)];
    
}

- (void)loadNewsBooks
{
    PHCategory *category = PHSelectedCategory;
    // 设置当前页码为1
    category.currentPage = 1;
    
    NSString *nowDate = [NSDate currentDateStringWithFormat:@"yyyyMM ddHHmmss"];
    NSString *usefulDate = [nowDate stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *path = @"92-92";
    NSString *secret = @"b034a3a7f7b144debe727ccebff2fd23";
    NSString *sign = [NSString stringWithFormat:@"id%@page%@showapi_appid16299showapi_timestamp%@%@",category.ID,@(category.currentPage),usefulDate,secret];
    NSString *md5Sign = [sign md532BitLower];
    
    NSDictionary *params = @{
                             @"id":category.ID,
                             @"page":@(category.currentPage),
                             @"showapi_appid":@"16299",
                             @"showapi_timestamp":usefulDate,
                             @"showapi_sign":md5Sign,
                             
                             
                             };
    
    [PHNetHelper POSTWithExtraUrl:path andParam:params andComplete:^(BOOL success, id result) {
        if (success) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            
            NSDictionary *tmpDict = dict[@"showapi_res_body"];
            
            NSArray *books = [PHBook mj_objectArrayWithKeyValuesArray:tmpDict[@"bookList"]];

            [category.books removeAllObjects];
            
            [category.books addObjectsFromArray:books];
            
            // 保存总数
            category.total = [tmpDict[@"total"] integerValue];
            
//            // 不是最后一次请求
//            if (self.params != params) return;
            
            
            [self.bookListTableView reloadData];
  
            // 结束刷新
            [self.bookListTableView.mj_header endRefreshing];
            
            // 让底部控件结束刷新
            [self checkFooterState];
            
        } else {

            // 结束刷新
            [self.bookListTableView.mj_header endRefreshing];
        }
        
    }];

}

- (void)loadMoreBooks
{
    PHCategory *category = PHSelectedCategory;
    
    NSString *nowDate = [NSDate currentDateStringWithFormat:@"yyyyMM ddHHmmss"];
    NSString *usefulDate = [nowDate stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *path = @"92-92";
    NSString *secret = @"b034a3a7f7b144debe727ccebff2fd23";
    NSString *sign = [NSString stringWithFormat:@"id%@page%@showapi_appid16299showapi_timestamp%@%@",category.ID,@(++category.currentPage),usefulDate,secret];
    NSString *md5Sign = [sign md532BitLower];
    
    NSDictionary *params = @{
                             @"id":category.ID,
                             @"page":@(category.currentPage),
                             @"showapi_appid":@"16299",
                             @"showapi_timestamp":usefulDate,
                             @"showapi_sign":md5Sign,
                             
                             
                             };
    
    [PHNetHelper POSTWithExtraUrl:path andParam:params andComplete:^(BOOL success, id result) {
        if (success) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *tmpArray = dict[@"showapi_res_body"][@"bookList"];
            
            NSArray *books = [PHBook mj_objectArrayWithKeyValuesArray:tmpArray];
            
            [category.books addObjectsFromArray:books];
            
//            // 不是最后一次请求
//            if (self.params != params) return;
            
            [self.bookListTableView reloadData];
            
            // 让底部控件结束刷新
            [self checkFooterState];
            
        } else {
            
        }
        
    }];
    
}

- (void)setupTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 左侧CategoryTableView
    UITableView *categoryTableView = [[UITableView alloc]init];
    [self.view addSubview:categoryTableView];
    self.categoryTableView = categoryTableView;
    self.categoryTableView.backgroundColor = PHGlobalBg;
    
    self.categoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [categoryTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(@0);
        make.width.equalTo(@80);
    }];
    
    
    // 左侧CategoryTableView
    UITableView *bookListTableView = [[UITableView alloc]init];
    [self.view addSubview:bookListTableView];
    self.bookListTableView = bookListTableView;
    
    self.bookListTableView.backgroundColor = self.categoryTableView.backgroundColor;
    
    [bookListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(categoryTableView.mas_right);
        make.top.right.bottom.equalTo(@0);
    }];
    
    // 设置inset
    self.categoryTableView.contentInset = UIEdgeInsetsMake(64, 0, 44, 0);
    self.bookListTableView.contentInset = self.categoryTableView.contentInset;
    
    
    // 注册cell
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([PHCategoryCell class]) bundle:nil] forCellReuseIdentifier:categoryId];
    [self.bookListTableView registerNib:[UINib nibWithNibName:NSStringFromClass([PHBookListCell class]) bundle:nil] forCellReuseIdentifier:bookListId];
    // 设置代理
    categoryTableView.delegate = self;
    categoryTableView.dataSource = self;
    bookListTableView.delegate = self;
    bookListTableView.dataSource = self;
}


- (void)loadCategories
{
    // 显示指示器
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    NSString *nowDate = [NSDate currentDateStringWithFormat:@"yyyyMM ddHHmmss"];
    NSString *usefulDate = [nowDate stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *path = @"92-93";
    NSString *secret = @"b034a3a7f7b144debe727ccebff2fd23";
    NSString *sign = [NSString stringWithFormat:@"showapi_appid16299showapi_timestamp%@%@",usefulDate,secret];
    NSString *md5Sign = [sign md532BitLower];
    
    NSDictionary *params = @{
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
           
            NSArray *tmpArray = dict[@"showapi_res_body"][@"bookClass"];
            
            self.categories = [PHCategory mj_objectArrayWithKeyValuesArray:tmpArray];
            
            [self.categoryTableView reloadData];
            
            // 默认选中首行
            [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
            
            // 让用户表格进入下拉刷新状态
            [self.bookListTableView.mj_header beginRefreshing];
        
        } else {
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }
        
    }];
    
}

/**
 * 监测footer的状态
 */
- (void)checkFooterState
{
    PHCategory *category = PHSelectedCategory;
    
    // 每次刷新右边数据时, 都控制footer显示或者隐藏
    self.bookListTableView.mj_footer.hidden = (category.books.count == 0);
    
    // 让底部控件结束刷新
    if (category.books.count == category.total) { // 已经加载完毕
        [self.bookListTableView.mj_footer endRefreshingWithNoMoreData];
    } else { // 还没有加载完毕
        [self.bookListTableView.mj_footer endRefreshing];
    }
}



#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.categoryTableView) {
        return self.categories.count;
    } else {
        
        // 监测footer的状态
        [self checkFooterState];
        PHCategory *category = PHSelectedCategory;

        return category.books.count;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.categoryTableView) {  // 左侧
    
        PHCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:categoryId];
        cell.category = self.categories[indexPath.row];
        return cell;
    }else{  // 右侧
        
        PHBookListCell *cell = [tableView dequeueReusableCellWithIdentifier:bookListId];
        
        PHCategory *category = PHSelectedCategory;
        
        cell.book = category.books[indexPath.row];
        return cell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.categoryTableView) {
    return 45;
    }
    return 135;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 结束刷新
    [self.bookListTableView.mj_header endRefreshing];
    [self.bookListTableView.mj_footer endRefreshing];
    
    
    PHCategory *category = PHSelectedCategory;
    
    if (tableView == self.categoryTableView) {
        
        if (category.books.count) {
            // 显示曾经的数据
            [self.bookListTableView reloadData];
        } else {
            // 刷新表格
            [self.bookListTableView reloadData];
            
            // 进入下拉刷新状态
            [self.bookListTableView.mj_header beginRefreshing];
        }
        
    } else {
        PHBookDetailViewController *detailVc = [[PHBookDetailViewController alloc]init];
        
        detailVc.book = category.books[indexPath.row];
        detailVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVc animated:YES];
    }
    
    
    
}




#pragma mark - Custom Delegate



#pragma mark - Event Response

- (void)searchItemClick
{
    PHBookSearchViewController *searchVc = [[PHBookSearchViewController alloc]init];
    searchVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVc animated:YES];
}






@end
