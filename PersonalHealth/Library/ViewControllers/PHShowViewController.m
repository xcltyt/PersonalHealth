//
//  PHShowViewController.m
//  PersonalHealthHelper
//
//  Created by qianfeng on 16/3/2.
//  Copyright © 2016年 PH. All rights reserved.
//

#import "PHShowViewController.h"
#import "PHBookPageDetail.h"
#import "SVProgressHUD.h"
#import "NSDate+Formatter.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "PHBookList.h"
#import "PHBook.h"



@interface PHShowViewController () <UIWebViewDelegate>
///** 存放加载已经完成的页面数据 */
//@property (nonatomic, strong) NSMutableDictionary *pages;

@end

@implementation PHShowViewController

- (void)loadView{
    
    [super loadView];
    
    self.myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
    self.myWebView.delegate = self;
    [self.view addSubview:self.myWebView];

    
//    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
//    
//    [self.myWebView loadRequest:request];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.pages objectForKey:self.pageIndex]) {
        PHBookPageDetail *pageDetail = [self.pages objectForKey:self.pageIndex];
        
        [_myWebView loadHTMLString:pageDetail.message baseURL:nil];
        
        
    } else {
    
    [self loadpageDetailDate];
        
    }
}

- (void)loadpageDetailDate
{
    // 显示指示器
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    NSString *nowDate = [NSDate currentDateStringWithFormat:@"yyyyMM ddHHmmss"];
    NSString *usefulDate = [nowDate stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *path = @"92-32";
    NSString *secret = @"b034a3a7f7b144debe727ccebff2fd23";
    NSString *sign = [NSString stringWithFormat:@"id%@showapi_appid16299showapi_timestamp%@%@",self.pageIndex,usefulDate,secret];
    NSString *md5Sign = [sign md532BitLower];
    
    NSDictionary *params = @{
                             @"id":self.pageIndex,
                             @"showapi_appid":@"16299",
                             @"showapi_timestamp":usefulDate,
                             @"showapi_sign":md5Sign,
                             };
    __weak typeof (self) weakSelf = self;
    [PHNetHelper POSTWithExtraUrl:path andParam:params andComplete:^(BOOL success, id result) {
        if (success) {
            NSError *error = nil;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:&error];
            if (error) {
                
                [SVProgressHUD showErrorWithStatus:@"解析失败"];
            }
            
            NSDictionary *tmpDict = dict[@"showapi_res_body"][@"bookDetails"];
            
            PHBookPageDetail *pageDetail = [PHBookPageDetail mj_objectWithKeyValues:tmpDict];

            // 回主线程刷新页面
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (pageDetail.message) {
                    
                    [_myWebView loadHTMLString:pageDetail.message baseURL:nil];
                    
                    NSDictionary *dict = @{
                                           _pageIndex:pageDetail,
                                           };
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:PHShowVcFinishNotification  object:nil userInfo:dict
                     ];
                    
                } else {
                    [weakSelf loadpageDetailDate];
                }
               
            });
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }
        
    }];
    
}

- (void)viewWillAppear:(BOOL)paramAnimated{
    
    [super viewWillAppear:paramAnimated];

}

#pragma mark - UIWebView代理

//开始加载网页
-(void)webViewDidStartLoad:(UIWebView *)webView
{
//     显示指示器
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
}
//加载结束
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 隐藏指示器
    [SVProgressHUD dismiss];
  
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"请求失败"];
}

@end
