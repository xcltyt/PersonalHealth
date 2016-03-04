//
//  PHSettingViewController.m
//  PersonalHealth
//
//  Created by lifan on 16/3/2.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import "PHSettingViewController.h"
//附近医院
#import "PHHospitalViewController.h"
//今日步数
#import "PHStepViewController.h"
//精华文章
#import "PHArticleViewController.h"
//好书常阅
#import "PHBookViewController.h"


@interface PHSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
//附近医院
@property (nonatomic, strong) UIViewController *hospitalVC;
//今日步数
@property (nonatomic, strong) UIViewController *stepVC;
//精华文章
@property (nonatomic, strong) UIViewController *articleVC;
//好书常阅
@property (nonatomic, strong) UIViewController *bookVC;
//主体
@property (nonatomic, strong) UITableView *tableView;
//头部
@property (nonatomic, strong) UIView *headerView;
@end

@implementation PHSettingViewController


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.tableView];
    [self.tableView.tableHeaderView addSubview:self.headerView];
    //配置子视图布局约束
    [self configSubviewsConstraints];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];

    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"附近医院";
            break;
        case 1:
            cell.textLabel.text = @"今日步数";
            break;
        case 2:
            cell.textLabel.text = @"精华文章";
            break;
        case 3:
            cell.textLabel.text = @"好书常阅";
            break;
        case 4:
            cell.textLabel.text = @"分享应用";
            break;
        case 5:
            cell.textLabel.text = @"意见反馈";
            break;
        default:
            break;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:self.hospitalVC animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:self.stepVC animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:self.articleVC animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:self.bookVC animated:YES];
            break;
        default:
            break;
    }
}

#pragma mark - Custom Delegate



#pragma mark - Event Response



#pragma mark - Private Methods

- (void)configSubviewsConstraints {
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(StatusBarH, 0, 0, 0);
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(edgeInsets);
    }];
}

#pragma mark - Setter & Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    }
    return _headerView;
}

- (UIViewController *)hospitalVC {
    if (!_hospitalVC) {
        _hospitalVC = [[PHHospitalViewController alloc] init];
    }
    return _hospitalVC;
}

- (UIViewController *)stepVC {
    if (!_stepVC) {
        _stepVC = [[PHStepViewController alloc] init];
    }
    return _stepVC;
}

- (UIViewController *)articleVC {
    if (!_articleVC) {
        _articleVC = [[PHArticleViewController alloc] init];
    }
    return _articleVC;
}

- (UIViewController *)bookVC {
    if (!_bookVC) {
        _bookVC = [[PHBookViewController alloc] init];
    }
    return _bookVC;
}

@end
