//
//  PHArticleCell.m
//  PersonalHealth
//
//  Created by lifan on 16/3/7.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import "PHArticleCell.h"
#import "PHMsgTableMod.h"

@interface PHArticleCell()

@property (nonatomic, strong) PHMsgTableMod *mod;

@end

@implementation PHArticleCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (PHMsgTableMod *)mod {
    if (!_mod) {
        _mod = [[PHMsgTableMod alloc] init];
    }
    return _mod;
}

@end
