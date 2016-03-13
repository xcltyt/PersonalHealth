//
//  PHArcView.h
//  PersonalHealth
//
//  Created by lifan on 16/3/10.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHArcView : UIView

//步数
@property (nonatomic, assign) int num;
//步数显示
@property (nonatomic, strong) UILabel *numLabel;
//计时器
@property (nonatomic, strong) NSTimer *timer;



@end
