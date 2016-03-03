//
//  PHShowViewController.h
//  PersonalHealthHelper
//
//  Created by qianfeng on 16/3/2.
//  Copyright © 2016年 PH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHBookPageDetail;

@interface PHShowViewController : UIViewController

@property (nonatomic, assign) NSString *pageIndex;
@property (nonatomic, strong) UIWebView *myWebView;
//@property (nonatomic, strong) id pageDetail;
@end
