//
//  PHBookPageDetail.h
//  PersonalHealthHelper
//
//  Created by qianfeng on 16/3/2.
//  Copyright © 2016年 PH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHBookPageDetail : NSObject

/** 页面ID */
@property (nonatomic, copy) NSString *id;
/** 页面标题 */
@property (nonatomic, copy) NSString *title;
/** 页面内容 */
@property (nonatomic, copy) NSString *message;
/** 图书ID */
@property (nonatomic, copy) NSString *book;

@end
