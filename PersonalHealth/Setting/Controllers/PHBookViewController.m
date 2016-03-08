//
//  PHBookViewController.m
//  PersonalHealth
//
//  Created by lifan on 16/3/4.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import "PHBookViewController.h"
#import "PHBookSearchCell.h"
#import "YUDBManager.h"
#import "PHBookDetailViewController.h"

static NSString *const bookSearchCell = @"bookSearchCell";

@interface PHBookViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *collectArray;

@end

@implementation PHBookViewController

#pragma mark Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    //配置子视图布局
    [self configSubviewConstraints];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *array = [[YUDBManager sharedManager] searchAllBook];
        weakSelf.collectArray = [NSMutableArray arrayWithArray:array];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.tableView reloadData];
        });
    });
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.collectArray.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PHBookSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:bookSearchCell];
    cell.book = self.collectArray[indexPath.row];
    cell.collectImageView.hidden = NO;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PHBookDetailViewController *detailVc = [[PHBookDetailViewController alloc]init];
    
    detailVc.book = self.collectArray[indexPath.row];
    
    [self.navigationController pushViewController:detailVc animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        PHBook *book = self.collectArray[indexPath.row];
        
        [[YUDBManager sharedManager] deleteCollectWithBook:book];
        
        //NSLog(@"%lu %ld",(unsigned long)self.dataArray.count,indexPath.row);
        
        [self.collectArray removeObjectAtIndex:indexPath.row];
        
        [self.tableView reloadData];
        
    }];
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        [self.collectArray insertObject:self.collectArray[indexPath.row] atIndex:0];
        
        [self.collectArray removeObjectAtIndex:indexPath.row+1];
        
        [self.tableView reloadData];
        
        
    }];
    
    UITableViewRowAction *action3 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"更多" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        
    }];
    action2.backgroundColor = [UIColor purpleColor];
    
    return @[action1,action2,action3];
}



#pragma mark Private Method

- (void)configSubviewConstraints {
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(StatusBarH + NAVH, 0, 0, 0);
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(edgeInsets);
    }];
}

#pragma mark Getter & Setter 
- (NSMutableArray *)collectArray
{
    if (_collectArray ==nil) {
        
        _collectArray = [NSMutableArray array];
        
    }
    return _collectArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 135;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PHBookSearchCell class]) bundle:nil] forCellReuseIdentifier:bookSearchCell];
    }
    return _tableView;
}

@end
