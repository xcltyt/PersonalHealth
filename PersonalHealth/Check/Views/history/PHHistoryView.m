//
//  PHHistoryView.m
//  PersonalHealth
//
//  Created by 汪俊 on 16/3/4.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import "PHHistoryView.h"
#import "PHHistoryCell.h"
#import "NSArray+PHArrayTool.h"

@interface PHHistoryView () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *checkHistory;
@property (weak, nonatomic)UITableView *historyTableView;
@end

@implementation PHHistoryView

- (instancetype)init {
    if (self = [super init]) {
        self.historyTableView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //从沙盒中取出上次存储的搜索纪录(取出用户上次的使用记录)
    NSArray *checkHistory = [NSArray history];
    self.checkHistory = checkHistory;
    return checkHistory.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PHHistoryCell *cell = [PHHistoryCell historyCellWithTableView:tableView];
    cell.content = self.checkHistory[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(historyView:didSelectRow:)]) {
        [self.delegate historyView:self didSelectRow:indexPath.row];
    }
}



/**
 *  懒加载
 *
 *  @return UITableView
 */
- (UITableView *)historyTableView {
    if (nil == _historyTableView) {
        UITableView *historyTableView = [[UITableView alloc]init];
        _historyTableView = historyTableView;
        historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:historyTableView];
        
        historyTableView.delegate = self;
        historyTableView.dataSource = self;
    }
    return _historyTableView;
}

- (void)constraintsHistoryTableView {
    [self.historyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self constraintsHistoryTableView];
}

- (void)reloadData {
    [self.historyTableView reloadData];
}

@end
