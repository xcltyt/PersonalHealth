//
//  PHMsgTableMod.m
//  PersonalHealthHelper
//
//  Created by Dylan on 3/1/16.
//  Copyright © 2016 PH. All rights reserved.
//

#import "PHMsgTableMod.h"

@implementation PHMsgTableMod

+(PHMsgTableMod *)modWithDict:(NSDictionary * )dict
{
    PHMsgTableMod * mod=[PHMsgTableMod new];
    mod.author=dict[@"author"];
    mod.time=dict[@"time"];
    mod.img=dict[@"img"];
    mod.ID=dict[@"id"];
    mod.tname=dict[@"tname"];
    mod.title=dict[@"title"];
    mod.tid=dict[@"tid"];
    
    mod.readCount=[NSString stringWithFormat:@"%d人阅读过",arc4random_uniform(10000)+100];
    return mod;
}
@end
