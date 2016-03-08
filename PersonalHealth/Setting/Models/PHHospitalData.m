//
//  PHHospitalData.m
//  PersonalHealth
//
//  Created by lifan on 16/3/7.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import "PHHospitalData.h"
#import "PHHospitalModel.h"

NSString *const hospitalCellID = @"hospital";

@interface PHHospitalData()

@property (nonatomic, strong) NSArray *cityList;

@end

@implementation PHHospitalData

- (void)dataWithCityName:(NSString *)cityName tableView:(UITableView *)tableView{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    //当前时间
    NSString *nowDate = [NSDate currentDateStringWithFormat:@"yyyyMMddHHmmss"];
    NSString *extraUrl = @"87-60";
    NSString *sign = [NSString stringWithFormat:@"cityName%@showapi_appid%@showapi_timestamp%@%@",cityName,PHID,nowDate,PHSerect];
    NSString *md5Sign = [sign md532BitLower];
    NSDictionary * param =@{
                            @"cityName":cityName,
                            @"showapi_appid":PHID,
                            @"showapi_timestamp":nowDate,
                            @"showapi_sign":md5Sign
                            };
    [PHNetHelper POSTWithExtraUrl:extraUrl andParam:param andComplete:^(BOOL success, id result) {
        if (success) {
            NSLog(@"Hospital data is succeed!");
            NSError *error;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:&error];
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"解析失败!"];
            } else {
                NSDictionary *bodyDict = dict[@"showapi_res_body"];
                PHHospitalModel *dataModel = [PHHospitalModel mj_objectWithKeyValues:bodyDict];
                self.cityList = dataModel.hospitalList;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView reloadData];
                });
                
                [SVProgressHUD dismiss];
            }
        } else {
            NSLog(@"%@",result);
            [SVProgressHUD showErrorWithStatus:@"请求失败!"];
        }
    }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cityList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hospitalCellID];
    Hospitallist *hospitallist = self.cityList[indexPath.row];
    cell.textLabel.text = hospitallist.hosName;
    NSLog(@"-------%@",cell.textLabel.text);
    return cell;
}

- (NSArray *)cityList {
    if (!_cityList) {
        _cityList = [[NSArray alloc] init];
    }
    return _cityList;
}



@end
