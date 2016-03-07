//
//  PHListCell.h
//  PersonalHealth
//
//  Created by 汪俊 on 16/3/5.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHListCell : UITableViewCell

+ (PHListCell *)listCellWithTableView:(UITableView *)tableView;


@property (strong, nonatomic)NSString *name;

@end
