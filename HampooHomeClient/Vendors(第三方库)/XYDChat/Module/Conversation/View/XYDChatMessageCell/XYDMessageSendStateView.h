//
//  XYDMessageSendStateV.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/10.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYDChatConstant.h"

@protocol XYDChatSendImageViewDelegate <NSObject>
@required
- (void)resendMessage:(id)sender;
@end

@interface XYDMessageSendStateView : UIButton

@property (nonatomic, assign) XYDChatMessageSendState messageSendState;
@property (nonatomic, weak) id<XYDChatSendImageViewDelegate> delegate;

@end
