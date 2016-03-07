//
//  PHArticleViewController.m
//  PersonalHealth
//
//  Created by lifan on 16/3/4.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import "PHArticleViewController.h"
#import "PHArticleCell.h"
#import "TSDbManager.h"
#import "PHMsgTableView.h"

static NSString *const cellID = @"cellID";

@interface PHArticleViewController ()

@property (nonatomic, strong) UIView *subView;
@property (nonatomic, strong) NSArray *articles;

@end

@implementation PHArticleViewController


#pragma mark Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.subView];
    
    [self configSubviewConstraints];
}

//#pragma mark UITableViewDelegate
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.articles.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    PHArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    return cell;
//}

#pragma mark Private Method

- (void)configSubviewConstraints {
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(StatusBarH, 0, 0, 0);
    
    [self.subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(edgeInsets);
    }];
}

#pragma setting & getting

- (UIView *)subView {
    if (!_subView) {
        _subView = [PHMsgTableView phmsgTableViewWithFrame:CGRectMake(0, 64, SCRW, SCRH - 64) andtableModArray:_articles];
//        [_subView registerNib:[UINib nibWithNibName:NSStringFromClass([PHArticleCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    }
    return _subView;
}

- (NSArray *)articles {
    if (!_articles) {
        _articles = [[TSDbManager sharedManager] searchAllCollect];
    }
    return _articles;
}

@end
