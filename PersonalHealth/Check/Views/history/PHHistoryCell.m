//
//  PHHistoryCell.m
//  PersonalHealth
//
//  Created by 汪俊 on 16/3/4.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import "PHHistoryCell.h"

@interface PHHistoryCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation PHHistoryCell

/**
 *  得到tableview
 *
 *  @param tableView cell所属的tableView
 *
 *  @return 指定tableview的cell
 */
+ (PHHistoryCell *)historyCellWithTableView:(UITableView *)tableView{
    NSString * className = NSStringFromClass([self class]);
    UINib * nib = [UINib nibWithNibName:className bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:className];
    return [tableView dequeueReusableCellWithIdentifier:className];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContent:(NSString *)content {
    _content = [content copy];
    self.contentLabel.text = content;
}

@end
