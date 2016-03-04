//
//  PHTextField.m
//  PersonalHealth
//
//  Created by 汪俊 on 16/3/4.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import "PHTextField.h"

@interface PHTextField ()


@end

@implementation PHTextField

/**
 * 当前文本框聚焦时就会调用
 */
- (BOOL)becomeFirstResponder
{
    if ([self.showHistoryDelegate respondsToSelector:@selector(textField:isBecomeFirstResponder:)]) {
        [self.showHistoryDelegate textField:self isBecomeFirstResponder:YES];
    }
    return [super becomeFirstResponder];
}

/**
 * 当前文本框失去焦点时就会调用
 */
- (BOOL)resignFirstResponder
{
    if ([self.showHistoryDelegate respondsToSelector:@selector(textField:isBecomeFirstResponder:)]) {
        [self.showHistoryDelegate textField:self isBecomeFirstResponder:NO];
    }
    return [super resignFirstResponder];
}
@end
