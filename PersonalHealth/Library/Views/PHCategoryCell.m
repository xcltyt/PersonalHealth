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
    self.textLabel.font = [UIFont systemFontOfSize:15];
    self.textLabel.text = [category.name substringToIndex:4];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.x = 10;
    
    self.textLabel.width = 60;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    self.selectedSlider.hidden = !selected;
    self.backgroundColor = !selected ? [UIColor colorWithWhite:0.800 alpha:1.000] : [UIColor colorWithRed:1.000 green:0.944 blue:0.826 alpha:1.000];
    
    
}

@end
