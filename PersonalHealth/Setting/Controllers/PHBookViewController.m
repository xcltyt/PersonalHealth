//
//  PHBookViewController.m
//  PersonalHealth
//
//  Created by lifan on 16/3/4.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import "PHBookViewController.h"
#import "PHBookCell.h"

static NSString *const bookCellID = @"bookCellID";

@interface PHBookViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PHBookViewController

#pragma mark Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    //配置子视图布局
    [self configSubviewConstraints];
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bookCellID];
    return cell;
}

#pragma mark Private Method

- (void)configSubviewConstraints {
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(StatusBarH, 0, 0, 0);
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(edgeInsets);
    }];
}

#pragma mark Getter & Setter 

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PHBookCell class]) bundle:nil] forCellReuseIdentifier:bookCellID];
    }
    return _tableView;
}

@end
