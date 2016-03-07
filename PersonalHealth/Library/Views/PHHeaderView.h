//
//  PHHeaderView.h
//  PersonalHealthHelper
//
//  Created by qianfeng on 16/3/2.
//  Copyright © 2016年 PH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHBook;

@interface PHHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) PHBook *book;

+ (instancetype)headerView;

@end
