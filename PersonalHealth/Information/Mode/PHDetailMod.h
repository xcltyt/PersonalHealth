//
//  PHDetailMod.h
//  PersonalHealthHelper
//
//  Created by Dylan on 3/2/16.
//  Copyright © 2016 PH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHDetailMod : NSObject

@property (nonatomic,strong)NSString * author;//来源
@property (nonatomic,strong)NSString * content;//内容
@property (nonatomic,strong)NSString * img;//图片
@property (nonatomic,strong)NSString * ID;//id
@property (nonatomic,strong)NSString * time;//时间
@property (nonatomic,strong)NSString * title;//标题
@property (nonatomic,strong)NSString * tname;//分类
@property (nonatomic,strong)NSNumber * tid;//分类号

@property (nonatomic,assign)CGFloat heigth;


+(PHDetailMod *)modWithDict:(NSDictionary *)dict;

@end
