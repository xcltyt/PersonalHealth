//
//  PHListCell.m
//  PersonalHealth
//
//  Created by 汪俊 on 16/3/5.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import "PHListCell.h"

@interface PHListCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation PHListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  得到tableview
 *
 *  @param tableView cell所属的tableView
 *
 *  @return 指定tableview的cell
 */
+ (PHListCell *)listCellWithTableView:(UITableView *)tableView {
    NSString * className = NSStringFromClass([self class]);
    UINib * nib = [UINib nibWithNibName:className bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:className];
    return [tableView dequeueReusableCellWithIdentifier:className];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupTableViewCell];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupTableViewCell];
    }
    return self;
}


/**
 *  初始化cell
 */
- (void)setupTableViewCell{
    //设置cell的背景色
    self.backgroundColor = [UIColor whiteColor];
}


- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = name;
    
}


@end
