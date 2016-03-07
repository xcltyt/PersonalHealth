//
//  PHListViewController.m
//  PersonalHealth
//
//  Created by 汪俊 on 16/3/5.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import "PHListViewController.h"
#import "PHSickList.h"
#import "PHListCell.h"
#import "PHShowcarefulController.h"

#define secret @"b034a3a7f7b144debe727ccebff2fd23"

@interface PHListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)NSArray *listArray;
@end

@implementation PHListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


- (void)loadData {
    
    NSString *ID = self.typeId;
    
    NSString *dataString = [NSDate currentDateStringWithFormat:@"yyyyMMdd HHmmss"];
    dataString = [dataString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *sign = [NSString stringWithFormat:@"showapi_appid%@showapi_timestamp%@subTypeId%@%@", @"16299",dataString,ID,secret];
    sign = [sign md532BitLower];
    NSDictionary *param = @{
                            @"subTypeId" : ID,
                            @"showapi_appid" : @"16299",
                            @"showapi_sign" : sign,
                            @"showapi_timestamp": dataString,
                            };
    // 显示指示器
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
#pragma mark －请求－
    [PHNetHelper POSTWithExtraUrl:@"546-2" andParam:param andComplete:^(BOOL success, id result) {
        if (success) {
            [SVProgressHUD dismiss];
            NSError *error;
            NSDictionary *dictjson = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:&error];
            NSDictionary *dict = dictjson[@"showapi_res_body"];
            NSDictionary *item = dict[@"pagebean"];
            if ([dict[@"ret_code"]integerValue] == 0) {
                NSArray *array = item[@"contentlist"];
                self.listArray = array;
                if (array.count == 0) {
                    self.title = @"没有相关列表";
                }else {
                    self.title = @"列表如下";
                }
                [self.tableView reloadData];
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PHListCell *cell = [PHListCell listCellWithTableView:tableView];
    cell.name = self.listArray[indexPath.row][@"name"];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PHShowcarefulController *carefulController = [[PHShowcarefulController alloc]init];
    carefulController.ID = self.listArray[indexPath.row][@"id"];
    [self.navigationController pushViewController:carefulController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

@end
