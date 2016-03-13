//
//  PHHospitalCell.h
//  PersonalHealth
//
//  Created by lifan on 16/3/8.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHHospitalModel.h"

@interface PHHospitalCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *hospitalNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialOfficialLabel;
//hospital
@property (nonatomic, strong) Hospitallist *hospital;

@end
