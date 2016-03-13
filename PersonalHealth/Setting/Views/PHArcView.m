//
//  PHArcView.m
//  PersonalHealth
//
//  Created by lifan on 16/3/10.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import "PHArcView.h"

@implementation PHArcView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    [self drawArcInBg];
    [self drawArcIn];
    [self drawArcOut];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        
        
        UILabel *la2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 120, 30)];
        la2.text =@"单位：步（step）";
        la2.font = [UIFont systemFontOfSize:13];
        
        
        UILabel *la1 = [[UILabel alloc]initWithFrame:CGRectMake((SCRW - 120)/2, (SCRW - 80)/2, 120, 30)];
        la1.text = @"步数";
        la1.textAlignment = NSTextAlignmentCenter;
        
        
        
        
        _numLabel=[[UILabel alloc]initWithFrame:CGRectMake((SCRW - 120)/2, (SCRW - 80)/2 + 30, 120, 30)];
        _numLabel.textAlignment =NSTextAlignmentCenter;
        _numLabel.textColor=[UIColor blackColor];
        _numLabel.text = @"0步";
        _numLabel.font=[UIFont systemFontOfSize:18];
        if (!_timer) {
            _timer=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(change) userInfo:nil repeats:YES];
            
        }
    
        UILabel *la3 = [[UILabel alloc]initWithFrame:CGRectMake((SCRW - 120)/2, (SCRW - 80)/2 + 60, 120, 30)];
        la3.text = @"每日目标5000步";
        la3.textAlignment = NSTextAlignmentCenter;
        la3.font=[UIFont systemFontOfSize:12];
        
        
        [self addSubview:la2];
        [self addSubview:self.numLabel];
        [self addSubview:la1];
        [self addSubview:la3];
    }
    return self;
}

#pragma mark - Private Methods

- (void)drawArcOut {
    // 1 获取上下文
    CGContextRef ctx =UIGraphicsGetCurrentContext();
    
    // 1.1 设置线条的宽度
    CGContextSetLineWidth(ctx, 2);
    // 1.2 设置线条的起始点样式
    CGContextSetLineCap(ctx,kCGLineCapRound);
    
    // 1.4 设置颜色
    [[[UIColor alloc]initWithRed:0.0/255.0 green:201.0/255.0 blue:87.0/255.0 alpha:1] set];
    
    // 2 设置路径
    CGContextAddArc(ctx, SCRW / 2, SCRW / 2, 120, -M_PI, M_PI, 0);
    
    // 3 绘制
    CGContextStrokePath(ctx);
}

- (void)drawArcIn {
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //设置线条宽度
    CGContextSetLineWidth(ctx, 20);
    //设置线条的起始点样式
    CGContextSetLineCap(ctx, kCGLineCapButt);
    //虚线
    CGFloat length[] = {3,3};
    CGContextSetLineDash(ctx, 0, length, 2);
    //设置颜色
    [[[UIColor alloc] initWithRed:0.0/255.0 green:201.0/255.0 blue:87.0/255.0 alpha:1] set];
    
    //设置路径
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(numberChange:) name:@"number" object:nil];
    
    CGFloat end = 1.5 * M_PI + (2 * M_PI * self.num / 10000);
    
    CGContextAddArc(ctx, SCRW / 2, SCRW / 2, 80, 1.5 * M_PI, end, 0);
    
    CGContextStrokePath(ctx);
    
}

- (void)drawArcInBg {
    //1.获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //1.1 设置线条的宽度
    CGContextSetLineWidth(ctx, 20);
    //1.2 设置线条的起始点样式
    CGContextSetLineCap(ctx,kCGLineCapButt);
    //1.3  虚实切换
    CGFloat length[] = {3,3};
    CGContextSetLineDash(ctx, 0, length, 2);
    //1.4 设置颜色
    [[[UIColor alloc]initWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1] set];
    
    CGContextAddArc(ctx, SCRW / 2, SCRW / 2, 80, 1.5 * M_PI , 3.5  *M_PI, 0);
    
    //3.绘制
    CGContextStrokePath(ctx);
}

#pragma mark - Response

- (void)numberChange:(NSNotification *)text {
    self.num = [text.userInfo[@"num"] intValue];
    [self setNeedsDisplay];
}


- (void)change {
    self.numLabel.text = [NSString stringWithFormat:@"%d步",self.num];
    NSDictionary *dict = @{@"num":self.numLabel.text};
    //创建通知
    NSNotification *noti = [NSNotification notificationWithName:@"number" object:nil userInfo:dict];
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotification:noti];
}


#pragma mark - Getter & Setter

- (void)setNum:(int)num {
    _num = num;
}



@end
