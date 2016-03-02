//
//  PHDetailMod.m
//  PersonalHealthHelper
//
//  Created by Dylan on 3/2/16.
//  Copyright © 2016 PH. All rights reserved.
//

#import "PHDetailMod.h"

@implementation PHDetailMod

+(PHDetailMod *)modWithDict:(NSDictionary *)dict
{
    PHDetailMod * mod=[PHDetailMod new];
    mod.author=dict[@"author"];
    mod.content=dict[@"content"];
    mod.img=dict[@"img"];
    mod.ID=dict[@"id"];
    mod.time=dict[@"time"];
    mod.title=dict[@"title"];
    mod.tname=dict[@"tname"];
    mod.tid=dict[@"tid"];
    
   // CGFloat height =
    return mod;
}

@end
