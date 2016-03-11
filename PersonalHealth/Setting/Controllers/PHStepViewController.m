//
//  PHStepViewController.m
//  PersonalHealth
//
//  Created by lifan on 16/3/4.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import "PHStepViewController.h"
#import "PHArcView.h"
#import <CoreMotion/CoreMotion.h>

static NSString *const setpID = @"setpID";

@interface PHStepViewController ()<UIScrollViewDelegate>

//圆形计步表
@property (nonatomic, strong) PHArcView *arcView;
//开始计步
@property (nonatomic, strong) UIButton *startButton;
//暂停计步
@property (nonatomic, strong) UIButton *purseButton;

@property (nonatomic, strong) UIView *buttonView;

@property(nonatomic, strong) UIView *distanceView;
//步行总里程
@property(nonatomic, strong) UILabel *distanceLabel;

@property (nonatomic, strong) CMPedometer *pedometer;

@property (nonatomic, strong) NSLengthFormatter *lengthFormatter;

@end

@implementation PHStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.arcView];
    [self.view addSubview:self.buttonView];
    [self.view addSubview:self.distanceView];
    [self.buttonView addSubview:self.startButton];
    [self.buttonView addSubview:self.purseButton];
    [self.distanceView addSubview:self.distanceLabel];
    
    [self configSubviewConstraints];
    
    
}

#pragma mark - Response Events

- (void)start {
    if (self.startButton.selected == YES) {
        if (![CMPedometer isStepCountingAvailable]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的设备不支持计步功能！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:alertAction];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
        
        __weak typeof(self) weakSelf = self;
        
        NSDate *date = [NSDate date];
        NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
        NSInteger interval = [timeZone secondsFromGMTForDate:date];
        NSDate *localDate = [date dateByAddingTimeInterval:interval];
        [self.pedometer startPedometerUpdatesFromDate:[NSDate dateWithTimeInterval:-24*60*60 sinceDate:localDate] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@",error.localizedDescription);
                return;
            } else {
                NSLog(@"%@",pedometerData);
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.distanceLabel.text = [NSString stringWithFormat:@"这段时间内走过的距离为%@\n这段时间内走过的步数为%@\n这段时间内上楼的近似台阶数为%@\n这段时间内下楼的近似台阶数为%@",pedometerData.distance,pedometerData.numberOfSteps,pedometerData.floorsAscended,pedometerData.floorsDescended];
                });
                
                
            }
        }];
    }
}

- (void)purse {
    self.startButton.selected = NO;
    [self.pedometer stopPedometerUpdates];
}


#pragma mark - Private Method

- (void)configSubviewConstraints {
    UIEdgeInsets arcEdgeInsets = UIEdgeInsetsMake(StatusBarH + NAVH, 0, 0, 0);
    
    [self.arcView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(SCRW);
        make.height.equalTo(SCRW);
        make.top.equalTo(self.view.mas_top).with.offset(arcEdgeInsets.top);
        make.left.equalTo(self.view.mas_left).with.offset(arcEdgeInsets.left);
    }];
    
    [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.arcView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@80);
    }];
    
    UIEdgeInsets btnEdgeInsets = UIEdgeInsetsMake(20, 40, 20, 40);
    
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buttonView.mas_top).with.offset(btnEdgeInsets.top);
        make.left.equalTo(self.buttonView.mas_left).with.offset(btnEdgeInsets.left);
        make.width.equalTo(@80);
        make.height.equalTo(@40);
    }];
    
    [self.purseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buttonView.mas_top).with.offset(btnEdgeInsets.top);
        make.right.equalTo(self.buttonView.mas_right).with.offset(-btnEdgeInsets.right);
        make.width.equalTo(@80);
        make.height.equalTo(@40);
    }];
    
    [self.distanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buttonView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.distanceView.center);
        make.width.equalTo(@200);
        make.height.equalTo(@50);
    }];
}



#pragma mark - Getter & Setter 


- (PHArcView *)arcView {
    if (!_arcView) {
        _arcView = [[PHArcView alloc] init];
        _arcView.backgroundColor = [UIColor colorWithRed:0.797 green:1.000 blue:0.915 alpha:1.000];
    }
    return _arcView;
}

- (UIButton *)startButton {
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.backgroundColor = [UIColor colorWithRed:1.000 green:0.836 blue:0.103 alpha:1.000];
        _startButton.layer.cornerRadius = 15;
        _startButton.layer.masksToBounds = YES;
        _startButton.selected = YES;
        [_startButton setTitle:@"开始" forState:UIControlStateNormal];
        [_startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}

- (UIButton *)purseButton {
    if (!_purseButton) {
        _purseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _purseButton.backgroundColor = [UIColor colorWithRed:0.471 green:0.922 blue:0.690 alpha:1.000];
        _purseButton.layer.cornerRadius = 15;
        _purseButton.layer.masksToBounds = YES;
        [_purseButton setTitle:@"暂停" forState:UIControlStateNormal];
        [_purseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_purseButton addTarget:self action:@selector(purse) forControlEvents:UIControlEventTouchUpInside];
    }
    return _purseButton;
}

- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] init];
//        _distanceLabel.text = [NSString stringWithFormat:@"今日总里程：\n总里程："];
        _distanceLabel.numberOfLines = 0;
    }
    return _distanceLabel;
}

- (UIView *)distanceView {
    if (!_distanceView) {
        _distanceView = [[UIView alloc] init];
        _distanceView.backgroundColor = [UIColor colorWithRed:0.873 green:0.837 blue:1.000 alpha:1.000];
    }
    return _distanceView;
}

- (UIView *)buttonView {
    if (!_buttonView) {
        _buttonView = [[UIView alloc] init];
        _buttonView.backgroundColor = [UIColor colorWithRed:0.906 green:1.000 blue:0.895 alpha:1.000];
        
    }
    return _buttonView;
}

- (CMPedometer *)pedometer {
    if (!_pedometer) {
        _pedometer = [[CMPedometer alloc] init];
    }
    return _pedometer;
}

@end
