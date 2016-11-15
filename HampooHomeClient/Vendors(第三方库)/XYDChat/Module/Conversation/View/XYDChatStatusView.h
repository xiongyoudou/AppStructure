//
//  XYDChatStatusView.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/15.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XYDChatStatusViewDelegate <NSObject>

@optional
- (void)statusViewClicked:(id)sender;
@end

static CGFloat XYDChatStatusViewHight = 44;

@interface XYDChatStatusView : UIView

@property (nonatomic, weak) id<XYDChatStatusViewDelegate> delegate;

@end
