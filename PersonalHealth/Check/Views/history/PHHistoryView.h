//
//  PHHistoryView.h
//  PersonalHealth
//
//  Created by 汪俊 on 16/3/4.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHHistoryView;

@protocol PHHistoryViewDelegate <NSObject>

- (void)historyView:(PHHistoryView *)historyView didSelectRow:(long)row;

@end

@interface PHHistoryView : UIView

@property (weak, nonatomic)id<PHHistoryViewDelegate> delegate;

- (void)reloadData;

@end
