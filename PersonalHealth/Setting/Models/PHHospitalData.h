//
//  PHHospitalData.h
//  PersonalHealth
//
//  Created by lifan on 16/3/7.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const hospitalCellID;

@interface PHHospitalData : NSObject <UITableViewDataSource,UITableViewDelegate>

- (void)dataWithCityName:(NSString *)cityName tableView:(UITableView *)tableView;

@end
