//
//  XYDChatTextMessage.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/11.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatTypeMessage.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYDChatTextMessage : XYDChatTypeMessage<XYDChatTypedMessageSubclassing>

/*!
 创建文本消息。
 @param text － 消息文本.
 @param attributes － 用户附加属性
 */
+ (instancetype)messageWithText:(NSString *)text
                     attributes:(nullable NSDictionary *)attributes;

@end

NS_ASSUME_NONNULL_END
