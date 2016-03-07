//
//  PHCategory.h
//  PersonalHealthHelper
//
//  Created by qianfeng on 16/3/1.
//  Copyright © 2016年 PH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHCategory : NSObject

/** 分类ID */
@property (nonatomic,copy) NSString *ID;
/** 分类名称 */
@property (nonatomic,copy) NSString *name;

/** 这个类别对应的图书数据 */
@property (nonatomic, strong) NSMutableArray *books;
/** 总数 */
@property (nonatomic, assign) NSInteger total;
/** 当前页码 */
@property (nonatomic, assign) NSInteger currentPage;

@end
