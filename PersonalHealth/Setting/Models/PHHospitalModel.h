//
//  PHHospitalModel.h
//  PersonalHealth
//
//  Created by lifan on 16/3/8.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Hospitallist;
@interface PHHospitalModel : NSObject

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, strong) NSArray<Hospitallist *> *hospitalList;

@property (nonatomic, assign) BOOL flag;

@property (nonatomic, assign) NSInteger limit;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, copy) NSString *ret_code;

@end
@interface Hospitallist : NSObject

@property (nonatomic, copy) NSString *provinceName;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *bus;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *hosName;

@property (nonatomic, copy) NSString *tsks;

@property (nonatomic, copy) NSString *addr;

@property (nonatomic, copy) NSString *zzjb;

@property (nonatomic, copy) NSString *keshi;

@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, copy) NSString *info;

@end

