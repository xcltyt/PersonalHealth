//
//  UINavigationController+PHAOP.m
//  PersonalHealth
//
//  Created by lifan on 16/3/2.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import "UINavigationController+PHAOP.h"
#import "NSObject+PHAOP.h"

@implementation UINavigationController (PHAOP)

+ (void)load {
    [UINavigationController aop_changeMethod:@selector(pushViewController:animated:) withNewMethod:@selector(aop_pushViewController:animated:)];
    NSLog(@"load");
}

- (void)aop_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //before pushing
    if (self.childViewControllers.count > 0) {
        //设置左上角的返回按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.343 green:0.827 blue:0.771 alpha:1.000] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.size = CGSizeMake(70, 30);
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    //调用原push方法
    [self aop_pushViewController:viewController animated:animated];
    //after pushing
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

@end
