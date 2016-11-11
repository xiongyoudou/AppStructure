//
//  XYDChatMessage.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/9.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int8_t, XYDChatMessageIOType) {
    XYDChatMessageIOTypeIn = 1,     // 接收的消息
    XYDChatMessageIOTypeOut,        // 发送出去的消息
};

typedef NS_ENUM(int8_t, XYDChatMessageStatus) {
    XYDChatMessageStatusNone = 0,       // 无状态
    XYDChatMessageStatusSending = 1,    // 发送中
    XYDChatMessageStatusSent,           // 已发送
    XYDChatMessageStatusDelivered,      // 对方已读
    XYDChatMessageStatusFailed,         // 发送失败
};

// 数据格式的定义参照 AVOSCloudIM
@interface XYDChatMessage : NSObject<NSCopying,NSCoding>

/*!
 * 表示接收和发出的消息
 */
@property (nonatomic, assign, readonly) XYDChatMessageIOType ioType;

/*!
 * 表示消息状态
 */
@property (nonatomic, assign, readonly) XYDChatMessageStatus status;

/*!
 * 消息 id
 */
@property (nonatomic, copy, readonly, nullable) NSString *messageId;

/*!
 * 消息发送/接收方 id
 */
@property (nonatomic, copy, readonly, nullable) NSString *clientId;

/*!
 * 消息所属对话的 id
 */
@property (nonatomic, copy, readonly, nullable) NSString *conversationId;

/*!
 * 消息文本
 */
@property (nonatomic, copy, nullable) NSString *content;

/*!
 * 发送时间（精确到毫秒）
 */
@property (nonatomic, assign) int64_t sendTimestamp;

/*!
 * 接收时间（精确到毫秒）
 */
@property (nonatomic, assign) int64_t deliveredTimestamp;

- (nullable NSString *)payload;

/*!
 创建文本消息。
 @param content － 消息文本.
 */
+ (nullable instancetype)messageWithContent:(nullable NSString *)content;

@end

