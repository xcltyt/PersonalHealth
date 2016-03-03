//
//  PHCategoryCell.m
//  PersonalHealthHelper
//
//  Created by qianfeng on 16/3/1.
//  Copyright © 2016年 PH. All rights reserved.
//

#import "PHCategoryCell.h"
#import "PHCategory.h"

@implementation PHCategoryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCategory:(PHCategory *)category
{
    _category = category;
    self.textLabel.font = [UIFont systemFontOfSize:11];
    self.textLabel.text = category.name;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
