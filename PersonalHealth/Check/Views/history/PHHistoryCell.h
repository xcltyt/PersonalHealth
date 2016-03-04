//
//  PHHistoryCell.h
//  PersonalHealth
//
//  Created by 汪俊 on 16/3/4.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHHistoryCell : UITableViewCell

+ (PHHistoryCell *)historyCellWithTableView:(UITableView *)tableView;

@property (strong, nonatomic)NSString *content;

@end
