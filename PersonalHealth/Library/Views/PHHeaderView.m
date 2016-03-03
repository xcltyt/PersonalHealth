//
//  PHHeaderView.m
//  PersonalHealthHelper
//
//  Created by qianfeng on 16/3/2.
//  Copyright © 2016年 PH. All rights reserved.
//

#import "PHHeaderView.h"
#import "PHBook.h"
#import "UIImageView+WebCache.h"

@interface PHHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookCategoryIdLabell;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

@end

@implementation PHHeaderView

+ (instancetype)headerView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

- (void)setBook:(PHBook *)book
{
    _book = book;
    
    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:book.img]];
    
    self.nameLabel.text = book.name;
    self.authorLabel.text = book.author;
    self.bookIdLabel.text = book.ID;
    self.bookCategoryIdLabell.text = book.bookclass;
    self.fromLabel.text = book.from;
    
    self.summaryLabel.text = book.summary;  // [NSString stringWithFormat:@"%@",book.summary];
    
}

- (void)setFrame:(CGRect)frame
{
    
    
    frame.size.height = self.book.headerViewHeight;
    
    [super setFrame:frame];
    
}


@end
