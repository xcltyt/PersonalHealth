//
//  PHBookListCell.m
//  PersonalHealthHelper
//
//  Created by qianfeng on 16/3/1.
//  Copyright © 2016年 PH. All rights reserved.
//

#import "PHBookListCell.h"
#import "PHBook.h"
#import "UIImageView+WebCache.h"

@interface PHBookListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation PHBookListCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setBook:(PHBook *)book
{
    _book = book;
    
    self.authorLabel.text = book.author;
    self.nameLabel.text = book.name;
    self.summaryLabel.text = book.summary;
    
    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:book.img]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
