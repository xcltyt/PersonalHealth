//
//  PHPageViewController.h
//  PersonalHealthHelper
//
//  Created by qianfeng on 16/3/2.
//  Copyright © 2016年 PH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHBook;

@interface PHPageViewController : UIViewController
@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSArray *pageContent;
@property (nonatomic, strong) PHBook *book;
@property (nonatomic, assign) NSInteger currentIndex;

@end
