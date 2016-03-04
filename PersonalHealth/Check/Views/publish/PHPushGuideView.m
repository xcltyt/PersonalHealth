//
//  PHPushGuideView.m
//  百思不得姐
//
//  Created by 汪俊 on 16/2/24.
//  Copyright © 2016年 汪俊. All rights reserved.
//

#import "PHPushGuideView.h"

@interface PHPushGuideView ()

@end


@implementation PHPushGuideView
/**
 *  关闭引导页
 *
 *  @param sender id<UIButton>
 */
- (IBAction)closeGuideView:(id)sender {
    [self removeFromSuperview];
}

+ (void)show
{
    NSString *key = @"CFBundleShortVersionString";
    
    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    // 获得沙盒中存储的版本号
    NSString *sanboxVersion = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    
    if (![currentVersion isEqualToString:sanboxVersion]) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        PHPushGuideView *guideView = [PHPushGuideView guideView];
        guideView.frame = window.bounds;
        [window addSubview:guideView];
        
        // 存储版本号
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (instancetype)guideView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}



@end
