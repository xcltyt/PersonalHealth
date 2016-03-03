//
//  PHBook.h
//  PersonalHealthHelper
//
//  Created by qianfeng on 16/3/1.
//  Copyright © 2016年 PH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHBook : NSObject

@property (nonatomic,copy) NSString *id;
/** 标题 */
@property (nonatomic,copy) NSString *name;
/** 浏览次数 */
@property (nonatomic,copy) NSString *count;
/** 图书配图 */
@property (nonatomic,copy) NSString *img;
/** 图书分类的id */
@property (nonatomic,copy) NSString *bookclass;
/** 图书简介 */
@property (nonatomic,copy) NSString *summary;
/** 出版社/来源 */
@property (nonatomic,copy) NSString *from;
/** 作者 */
@property (nonatomic,copy) NSString *author;


/** 这个类别对应的图书目录数据 */
@property (nonatomic, strong) NSArray *list;



/** cell的高度 */
@property (nonatomic, assign) CGFloat headerViewHeight;


@end
