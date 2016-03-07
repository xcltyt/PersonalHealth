//
//  PHSearchBar.m
//  PersonalHealth
//
//  Created by qianfeng on 16/3/3.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import "PHSearchBar.h"

@implementation PHSearchBar

+ (id)searchBar
{
    return [[self alloc]init];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // 创建搜索框对象
        self.font = [UIFont systemFontOfSize:15];
        self.placeholder = @"请输入关键词";
        self.background = [UIImage imageNamed:@"searchbar_textfield_background"];
        
        
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
        searchIcon.width = 30;
        searchIcon.height = 30;
        searchIcon.contentMode = UIViewContentModeCenter;
        self.leftView = searchIcon;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}


@end
