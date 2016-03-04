//
//  PHCheckHomeView.m
//  PersonalHealthHelper
//
//  Created by 汪俊 on 16/3/1.
//  Copyright © 2016年 PH. All rights reserved.
//

#import "PHCheckHomeView.h"
#import "Masonry.h"
#import "PHTextField.h"

#define PHBtnNormalTitle @"疾病查询"
#define PHBtnHeightTitle @"停止查询"
#define PHRectHeight 200
#define PHScreenW [UIScreen mainScreen].bounds.size.width
#define PHScreenH [UIScreen mainScreen].bounds.size.height

@interface PHCheckHomeView () <UITextFieldDelegate, PHTextFieldDelegate>

@property (weak, nonatomic) UIWebView *textView ;
@property (weak, nonatomic) UIView *rectView;
@property (weak, nonatomic) UILabel *label;

/**
 *  按钮
 */
@property (weak, nonatomic) UIButton *moreButton;
/**
 *  分割线
 */
@property (weak, nonatomic) UIView *speratorView;
@property (strong, nonatomic) NSTimer *timer;
/**
 *  计时
 */
@property (assign, nonatomic) NSTimeInterval timeInterval;

@end

@implementation PHCheckHomeView
+ (instancetype)homeView{
    return [[self alloc]initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        //4 添加button
        UIButton *moreButton = [[UIButton alloc]init];
        self.moreButton = moreButton;
        [self addSubview:moreButton];
        [moreButton setTitle:PHBtnNormalTitle forState:UIControlStateNormal];
        [moreButton addTarget:self action:@selector(checkHealthy) forControlEvents:UIControlEventTouchUpInside];
        [self constraintMoreButton];
        moreButton.backgroundColor = [UIColor greenColor];
        self.speratorView.hidden = YES;
        
        //1 添加label
        UILabel *label = [[UILabel alloc]init];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        NSString *string =  @"搜寻疾病,健康出行！！！\n身体倍好！～哦，耶～～～～";
        label.text = string;
        self.label = label;
        [self addSubview:label];
        [self constraintLabel];
        
        // 3 添加搜索框
        UITextField *textField = [[UITextField alloc]init];
        [self addSubview:textField];
        self.textField = textField;
        textField.placeholder = @"输入要搜索的疾病哦";
        textField.backgroundColor = [UIColor greenColor];
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
//        textField.showHistoryDelegate = self;
        [self constraintTextField];
        
        //2 添加rectview
        UIView *rectView = [[UIView alloc]init];
        self.rectView = rectView;
        [self addSubview:rectView];
        rectView.backgroundColor = [UIColor colorWithRed:0.1962 green:1.0 blue:0.1257 alpha:0.127074353448276];
        [self constraintRectView];
        
        // 显示文字的框
        UIWebView *textView = [[UIWebView alloc]init];
        self.textView = textView;
        textView.backgroundColor = [UIColor clearColor];
        textView.hidden = YES;
        [self.rectView addSubview:textView];
        [self constraintTextView];
        

        
        // 4 添加详情按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn = btn;
        [self.rectView addSubview:btn];
        [btn setTitle:@"🔍" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickSearchBtn) forControlEvents:UIControlEventTouchUpInside];
        [self constraintBtn];
        
        //3 添加扫描线
        UIView *speratorView = [[UIView alloc]init];
        [rectView addSubview:speratorView];
        self.speratorView = speratorView;
        [self constraintSperatorView];
        speratorView.backgroundColor = [UIColor greenColor];
        

    }
    return self;
}

- (void)constraintMoreButton {
    __weak typeof(self)weakSelf = self;
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf).offset(-52);
        make.centerX.equalTo(weakSelf);
        make.height.equalTo(@40);
        make.width.equalTo(@200);
    }];
}

- (void)checkHealthy {
    if ((self.moreButton.selected = !self.moreButton.selected)) {
        [self.moreButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        self.moreButton.backgroundColor = [UIColor colorWithRed:0.2496 green:1.0 blue:0.174 alpha:0.357866379310345];
        [self.moreButton setTitle:PHBtnHeightTitle forState:UIControlStateNormal];
        [self startCheck];
    } else {
        [self.moreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.moreButton.backgroundColor = [UIColor greenColor];
        [self.moreButton setTitle:PHBtnNormalTitle forState:UIControlStateNormal];
        [self endCheck];
    }
}
/**
 *  开启扫描
 */
- (void)startCheck {
    self.textView.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(homeView:didClickSearchButton:)]) {
        [self.delegate homeView:self didClickSearchButton:self.moreButton];
    }
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(healthCheck) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
    self.timeInterval = 0;
}

/**
 *  结束扫描
 */
- (void)endCheck {
    [self.timer invalidate];
    self.speratorView.hidden = YES;
    self.timeInterval = 0;
}

- (void)showEnd {
    [self checkHealthy];
}

- (void)healthCheck {
    if (self.timeInterval > 10) {
        [self endCheck];
        return;
    }
    self.speratorView.hidden = NO;
    self.timeInterval++;
    CGFloat height = PHScreenH - 64 - 49 - 2 - 40 - 35 - 60;
    [UIView animateWithDuration:0.75 animations:^{
        [self updateSperatorViewConstraintsWithY:0];
    } completion:^(BOOL finished) {
        [self updateSperatorViewConstraintsWithY:height];
    }];
}

/**
 *   更新约束
 */
- (void)updateSperatorViewConstraintsWithY:(CGFloat)y{
    __weak typeof(self) weakSelf = self;
    //添加动画
    [self.speratorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.rectView);
        make.height.equalTo(@1);
        make.bottom.equalTo(weakSelf.rectView.mas_top).offset(y);
        make.centerX.equalTo(weakSelf.rectView);
    }];
    //必须调用此方法，才能出动画效果
    [self layoutIfNeeded];
}

/**
 *  约束imageview
 */
- (void)constraintRectView {
    __weak typeof(self)weakSelf = self;
    [self.rectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.label.mas_top).offset(-2);
        make.left.equalTo(@(30));
        make.top.equalTo(weakSelf.textField.mas_bottom).offset(@5);
        make.centerX.equalTo(weakSelf);
    }];
}

- (void)constraintLabel {
    __weak typeof(self)weakSelf = self;
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@300);
        make.centerX.equalTo(@0);
        make.bottom.equalTo(weakSelf.moreButton.top).offset(@(-3));
    }];
}

- (void)constraintSperatorView {
    __weak typeof(self)weakSelf = self;
    [self.speratorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.rectView);
        make.height.equalTo(@1);
        make.bottom.equalTo(weakSelf.rectView.mas_top).offset(PHRectHeight);
        make.centerX.equalTo(weakSelf.rectView);
    }];
}

- (void)constraintTextField {
    __weak typeof(self)weakSelf = self;
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.height.equalTo(@35);
        make.top.equalTo(weakSelf).offset(66);
        make.centerX.equalTo(weakSelf);
    }];
}

- (void)constraintTextView {
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@2);
        make.bottom.right.equalTo(@-2);
    }];
}

- (void)constraintBtn {
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@50);
        make.bottom.right.equalTo(@0);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textField endEditing:YES];
}

- (void)showText:(NSString *)text {
    [self.textView loadHTMLString:text baseURL:nil];
    self.textView.hidden = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    return YES;
}

- (void)clickSearchBtn {
    if ([self.delegate respondsToSelector:@selector(homeView:didClickShowAllButton:)]) {
        [self.delegate homeView:self didClickShowAllButton:self.btn];
    }
}

- (void)textField:(PHTextField *)textField isBecomeFirstResponder:(BOOL)flag {
    
}

@end
