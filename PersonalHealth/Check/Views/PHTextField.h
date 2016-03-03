//
//  PHTextField.h
//  PersonalHealth
//
//  Created by 汪俊 on 16/3/4.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHTextField;

@protocol PHTextFieldDelegate <NSObject>

- (void)textField:(PHTextField *)textField isBecomeFirstResponder:(BOOL)flag;

@end

@interface PHTextField : UITextField

@property (weak, nonatomic)id<PHTextFieldDelegate> showHistoryDelegate;

@end
