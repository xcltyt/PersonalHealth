//
//  PHHospitalModel.m
//  PersonalHealth
//
//  Created by lifan on 16/3/8.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import "PHHospitalModel.h"

@implementation PHHospitalModel


+ (NSDictionary *)objectClassInArray{
    return @{@"hospitalList" : [Hospitallist class]};
}
@end
@implementation Hospitallist

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

@end


