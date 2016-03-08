//
//  PHHospitalViewController.m
//  PersonalHealth
//
//  Created by lifan on 16/3/4.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import "PHHospitalViewController.h"
#import "TLCityPickerController.h"
#import "PHHospitalData.h"

static NSString *const hospitalCellID = @"hospital";

@interface PHHospitalViewController ()<UITableViewDataSource,UITableViewDelegate,TLCityPickerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PHHospitalViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    [self configNavigitionItem];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hospitalCellID];
    return cell;
}

#pragma mark - TLCityPickerDelegate

- (void)cityPickerController:(TLCityPickerController *)cityPickerViewController didSelectCity:(TLCity *)city
{
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
        //根据城市名获取该城市的医院数据
        [PHHospitalData dataWithCityName:city.cityName];
        //重载列表
        [self.tableView reloadData];
    }];
}

- (void)cityPickerControllerDidCancel:(TLCityPickerController *)cityPickerViewController
{
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Private Method

- (void)configNavigitionItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择城市" style:UIBarButtonItemStylePlain target:self action:@selector(cityPicker)];
}

- (void)cityPicker {
    TLCityPickerController *cityPickerVC = [[TLCityPickerController alloc] init];
    [cityPickerVC setDelegate:self];
    
    cityPickerVC.locationCityID = @"1400010000";
    cityPickerVC.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:^{
        
    }];
}

#pragma mark - Setter & Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:hospitalCellID];
    }
    return _tableView;
}

@end
