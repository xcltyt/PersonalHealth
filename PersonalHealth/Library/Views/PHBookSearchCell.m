//
//  PHBookSearchCell.m
//  PersonalHealth
//
//  Created by qianfeng on 16/3/3.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import "PHBookSearchCell.h"
#import "PHBook.h"
#import "UIImageView+WebCache.h"

@interface PHBookSearchCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation PHBookSearchCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setBook:(PHBook *)book
{
    _book = book;
    
    self.authorLabel.text = book.author;
    self.nameLabel.text = book.name;
    self.contentLabel.text = book.summary? book.summary : book.content;
    
    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:book.img]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
