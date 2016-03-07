//
//  PHMsgDetailController.m
//  PersonalHealthHelper
//
//  Created by Dylan on 3/2/16.
//  Copyright © 2016 PH. All rights reserved.
//

#import "PHMsgDetailController.h"
#import "UIImageView+WebCache.h"
#import "TSDbManager.h"

@interface PHMsgDetailController ()

@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UIImageView * imgImageView;
@property(nonatomic,strong)UITextView * contenttextView;
@property (nonatomic,strong)UILabel * authorLabel;
@property (nonatomic,strong)UILabel * timeLabel;

@property (nonatomic,strong)UIScrollView * scrollView;
@end

@implementation PHMsgDetailController
-(void)setMod:(PHDetailMod *)mod
{
    _mod=mod;
    [self configSubViews];
}
+(instancetype)phMsgDetailControllerWithPHDetailMod:(PHDetailMod *)mod
{
    PHMsgDetailController * ctl=[PHMsgDetailController new];

   // ctl.scrollView.contentSize=CGSizeMake(SCRW, 500);
    ctl.mod=mod;
    return ctl;
}

-(void)configSubViews
{
    //标题
    self.scrollView=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    //self.scrollView.autoresizesSubviews=NO;
    UILabel * titleLabel=[[UILabel alloc]init];
    [self.scrollView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    titleLabel.numberOfLines=0;
    self.titleLabel.text=_mod.title;
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.width.equalTo(ScreenW-30);
        make.top.equalTo(5);
        make.height.equalTo(50);
    }];
    //分割线
    UIView * fengeView=[[UIView alloc]init];
    fengeView.backgroundColor=[UIColor brownColor];
    [self.scrollView addSubview:fengeView];
    [fengeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.top.equalTo(titleLabel.mas_bottom).offset(2);
        make.height.equalTo(2);
    }];
    
    //图片
    UIImageView * imageView=[UIImageView new];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_mod.img]];
    [self.scrollView addSubview:imageView];
    self.imgImageView=imageView;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(fengeView.mas_bottom).offset(10);
         make.centerX.equalTo(0);
         make.width.height.equalTo(280);
     }];

    //详细咨询
    UITextView * contenttextView=[[UITextView alloc]init];
    self.contenttextView=contenttextView;
    [self.scrollView addSubview:contenttextView];
    contenttextView.text=_mod.content;
    contenttextView.editable=NO;
    [contenttextView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(imageView.mas_bottom).offset(20);
         make.left.equalTo(15);
         make.centerX.equalTo(0);
         make.height.equalTo(80);
    }];
    
    //作者label
    UILabel * authorLable=[[UILabel alloc]init];
    self.authorLabel= authorLable;
    [self.scrollView addSubview:authorLable];
    authorLable.font=[UIFont systemFontOfSize:15];
    NSString * text=[@"来源：" stringByAppendingString:_mod.author];
    authorLable.text=text;
    [authorLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(8);
        make.top.equalTo(contenttextView.mas_bottom).offset(10);
        make.width.equalTo(120);
        make.height.equalTo(ButtonH);
    }];
    
    UILabel * timeLabe=[[UILabel alloc]init];
    self.timeLabel=timeLabe;
    [self.scrollView addSubview:timeLabe];
    timeLabe.text=_mod.time;
    timeLabe.font=[UIFont systemFontOfSize:12];
    [timeLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.top.equalTo(contenttextView.mas_bottom).offset(10);
        make.bottom.equalTo(10);
        make.width.equalTo(150);
        make.height.equalTo(ButtonH);
    }];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"收藏" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnTouch)];
    // Do any additional setup after loading the view.
}
//执行收藏操作
-(void)rightBtnTouch
{
    [[TSDbManager sharedManager]insert:self.tableMod];
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
