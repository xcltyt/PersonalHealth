//
//  PHMsgDetailController.h
//  PersonalHealthHelper
//
//  Created by Dylan on 3/2/16.
//  Copyright © 2016 PH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHDetailMod.h"
#import "PHMsgTableMod.h"
@interface PHMsgDetailController : UIViewController

@property (nonatomic,strong)PHMsgTableMod * tableMod;
@property (nonatomic,strong)PHDetailMod * mod;

+(instancetype)phMsgDetailControllerWithPHDetailMod:(PHDetailMod *)mod;

@end
