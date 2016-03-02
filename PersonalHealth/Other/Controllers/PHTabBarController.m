//
//  PHTabBarController.m
//  PersonalHealth
//
//  Created by lifan on 16/3/2.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import "PHTabBarController.h"
//子视图
#import "PHInformationViewController.h"
#import "PHLibraryViewController.h"
#import "PHCheckViewController.h"
#import "PHSettingViewController.h"

@interface PHTabBarController ()

@end

@implementation PHTabBarController

+(void)initialize {
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //资讯
    PHInformationViewController *informationVC = [[PHInformationViewController alloc] init];
    [self setupViewController:informationVC title:@"资讯" image:@"information" selectedImage:@"informationS"];
    //图书
    PHLibraryViewController *libraryVC = [[PHLibraryViewController alloc] init];
    [self setupViewController:libraryVC title:@"图书" image:@"library" selectedImage:@"libraryS"];
    //查询
    PHCheckViewController *checkVC = [[PHCheckViewController alloc] init];
    [self setupViewController:checkVC title:@"查询" image:@"check" selectedImage:@"checkS"];
    //我的
    PHSettingViewController *settingVC = [[PHSettingViewController alloc] init];
    [self setupViewController:settingVC title:@"我的" image:@"setting" selectedImage:@"settingS"];
}

- (void)setupViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
    vc.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
