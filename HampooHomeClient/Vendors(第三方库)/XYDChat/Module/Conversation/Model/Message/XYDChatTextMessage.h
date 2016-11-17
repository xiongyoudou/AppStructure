//
//  XYDChatTextMessage.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/11.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatMessage.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYDChatTextMessage : XYDChatMessage<XYDChatMessageSubclassing>

@property (nonatomic,copy,nullable,readonly) NSString *text;    // 消息文本
- (void)setText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
