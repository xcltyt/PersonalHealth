//
//  PHShowcarefulController.m
//  PersonalHealth
//
//  Created by 汪俊 on 16/3/5.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import "PHShowcarefulController.h"
#define secret @"b034a3a7f7b144debe727ccebff2fd23"

@interface PHShowcarefulController ()
@property (weak, nonatomic) IBOutlet UIWebView *contentText;

@end

@implementation PHShowcarefulController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadData {
    
    NSString *ID = self.ID;
    
    NSString *dataString = [NSDate currentDateStringWithFormat:@"yyyyMMdd HHmmss"];
    dataString = [dataString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *sign = [NSString stringWithFormat:@"id%@showapi_appid%@showapi_timestamp%@%@", ID,@"16299",dataString,secret];
    sign = [sign md532BitLower];
    NSDictionary *param = @{
                            @"showapi_appid" : @"16299",
                            @"showapi_sign" : sign,
                            @"showapi_timestamp": dataString,
                            @"id" : ID
                            };
    // 显示指示器
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
#pragma mark －请求－
    [PHNetHelper POSTWithExtraUrl:@"546-3" andParam:param andComplete:^(BOOL success, id result) {
        if (success) {
            [SVProgressHUD dismiss];
            NSError *error;
            NSDictionary *dictjson = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:&error];
            NSDictionary *dict = dictjson[@"showapi_res_body"];
            NSDictionary *item = dict[@"item"];
            NSMutableString *finallyString = [NSMutableString string];
            NSString *content = [NSString stringWithFormat:@"%@",item[@"summary"]];
            [finallyString appendString:content];
            if ([dict[@"ret_code"]integerValue] == 0) {
                NSArray *array = item[@"tagList"];
                for (int i = 0; i < array.count; i ++) {
                    NSDictionary *listDict = array[i];
                    content = [NSString stringWithFormat:@"%@",listDict[@"content"]];
                    [finallyString appendString:content];
                }
                [self.contentText loadHTMLString:finallyString baseURL:nil];
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
        }
    }];
}

@end
