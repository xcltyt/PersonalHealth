//
//  PHHospitalCell.m
//  PersonalHealth
//
//  Created by lifan on 16/3/8.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import "PHHospitalCell.h"

@interface PHHospitalCell()




@end

@implementation PHHospitalCell

- (void)setHospital:(Hospitallist *)hospital {
    _hospital = hospital;
    self.hospitalNameLabel.text = hospital.hosName;
    self.hospitalAddressLabel.text = [NSString stringWithFormat:@"地址：%@",hospital.addr];
    self.specialOfficialLabel.text = [NSString stringWithFormat:@"特色：%@",hospital.tsks];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
