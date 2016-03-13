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

#import <MessageUI/MFMailComposeViewController.h>
#import "SDImageCache.h"


@interface PHSettingViewController ()<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate>
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
//头部图片
@property (nonatomic, strong) UIImageView *headerImageView;


@end

@implementation PHSettingViewController


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.tableView];
    [self.tableView.tableHeaderView addSubview:self.headerView];
    [self.headerView addSubview:self.headerImageView];
    //配置子视图布局约束
    [self configSubviewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:20 weight:2];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
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
        {
            CGFloat size = [SDImageCache sharedImageCache].getSize / 1000.0 / 1000;
            cell.textLabel.text = [NSString stringWithFormat:@"清除缓存（%.2fMB）", size];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
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
    return 200;
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
        case 4:
            // 清除缓存
            [self clearCache];
            break;
        case 5:
            [self sendMail];
            break;
        default:
            break;
    }
}
/**
 *  发送邮件
 */
-(void)sendMail
{
    if (![MFMailComposeViewController canSendMail])
    {
        NSLog(@"设备还没有设置邮箱");
        return;
    }
    
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];

    controller.mailComposeDelegate = self;
    [controller setToRecipients:@[@"dylan@dylancc.com"]];
    [controller setSubject:@"随行健康助手"];
    [controller setMessageBody:@"Hello there." isHTML:NO];
    [self presentViewController:controller animated:YES completion:nil];

}
/**
 *  清除缓存
 */
- (void)clearCache
{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"清理缓存 ？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        return;
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[SDImageCache sharedImageCache] clearDisk];

        [SVProgressHUD showSuccessWithStatus:@"清理成功"];
        // 刷新表格
        [self.tableView reloadData];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Private Methods

- (void)configSubviewsConstraints {
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(StatusBarH, 0, 0, 0);
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(edgeInsets);
    }];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.headerView);
    }];
}

#pragma mark - Setter & Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentMode = UIViewContentModeScaleToFill;
        _tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BG"]];
        _tableView.bounces = NO;
        _tableView.rowHeight = 55;
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

- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.image = [UIImage imageNamed:@"Snip20160309_1"];
    }
    return _headerImageView;
}
#pragma mark MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent)
    {
        NSLog(@"It's away!");
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}
@end
