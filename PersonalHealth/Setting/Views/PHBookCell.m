//
//  PHBookCell.m
//  PersonalHealth
//
//  Created by lifan on 16/3/7.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import "PHBookCell.h"

@interface PHBookCell()

@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *author;


@end

@implementation PHBookCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
