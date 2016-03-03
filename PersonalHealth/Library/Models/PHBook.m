//
//  PHBook.m
//  PersonalHealthHelper
//
//  Created by qianfeng on 16/3/1.
//  Copyright © 2016年 PH. All rights reserved.
//

#import "PHBook.h"
#import "PHBookList.h"

@implementation PHBook

+ (NSDictionary *)objectClassInArray
{
    return @{@"list":[PHBookList class]};
}

- (CGFloat)headerViewHeight
{
    
    // 固定高度
    CGFloat fixedHeight = 250;
    
    // 文字高度
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGFloat textH = [self.summary boundingRectWithSize:CGSizeMake(305, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height;
    
    return fixedHeight + textH;
}


@end
