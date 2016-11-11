//
//  XYDChatMsgDelegate.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/9.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYDChatConstant.h"

@protocol XYDUserDelegate;

@protocol XYDChatMsgDelegate <NSObject>

/*!
 *  消息Id
 */
@property (nonatomic, copy, readonly) NSString *messageId;

/**
 * 发送者
 */
@property (nonatomic, strong) id<XYDUserDelegate> sender;

/*!
 * 与 sender 属性中 clientId 的意义相同，但 senderId 本属性永远不为空，但sender属性可能为nil。
 */
@property (nonatomic, copy) NSString *senderId;

/*!
 * 消息发送状态
 */
@property (nonatomic, assign) XYDChatMessageSendState sendStatus;

/*!
 * 所属会话
 */
@property (nonatomic, copy) NSString *conversationId;

/*!
 * 精确到毫秒，比如：1469413969460.018
 */
@property (nonatomic, assign, readonly) NSTimeInterval timestamp;

/*!
 * 用来判断消息是否是对外发送
 */
@property (nonatomic, assign) XYDChatMessageOwnerType ownerType;

/*!
 * 消息自己是否已读，可用在多媒体消息，语音视频消息
 */
@property (nonatomic, assign, readonly, getter=hasRead) BOOL read;

@optional

/*!
 * 消息接收者是否已读
 */
@property (nonatomic, assign, readonly) BOOL receiverHasReaded;

/*!
 * 消息内容来源
 */
@property (nonatomic, strong, readonly) NSString *ownerName;


@end
