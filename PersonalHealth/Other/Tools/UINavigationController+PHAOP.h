//
//  UINavigationController+PHAOP.h
//  PersonalHealth
//
//  Created by lifan on 16/3/2.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (PHAOP)

- (void)aop_pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end
