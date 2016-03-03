//
//  PHMsgTableController.h
//  PersonalHealthHelper
//
//  Created by Dylan on 3/1/16.
//  Copyright © 2016 PH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHMsgTableMod.h"
#import "PHMsgCell.h"

@class PHMsgTableView;
@protocol PHMsgTableViewDelegate <NSObject>

-(void)phMsgTableViewRowsSelectedWithMode:(PHMsgTableMod *)mod;

@end
@interface PHMsgTableView : UIView

@property (nonatomic,strong)NSNumber * tid;
@property (nonatomic,strong)NSString * keywords;

@property (nonatomic,strong)id<PHMsgTableViewDelegate> delegate;


+(instancetype)phmsgTableViewWithFrame:(CGRect)frame andtid:(NSNumber *)tid;
+(instancetype)phmsgTableViewWithFrame:(CGRect)frame andKeywords:(NSString *)keywords;

//注意，array必须由tablemod组成
+(instancetype)phmsgTableViewWithFrame:(CGRect)frame andtableModArray:(NSArray *)array;

@end
