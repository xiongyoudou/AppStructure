//
//  XYDConversation.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/11.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYDChatConstant.h"
#import "XYDChatMessageOption.h"

@class XYDChatMessage;
@class XYDArchivedConversation;
@class XYDChatClient;

// 处理消息的发送，消息的拉取
NS_ASSUME_NONNULL_BEGIN
@interface XYDConversation : NSObject

/**
 *  The ID of the client which the conversation belongs to.
 */
@property (nonatomic, copy, readonly, nullable) NSString       *clientId;

/**
 *  The ID of the conversation.
 */
@property (nonatomic, copy, readonly, nullable) NSString       *conversationId;

/**
 *  The clientId of the conversation creator.
 */
@property (nonatomic, copy, readonly, nullable) NSString       *creator;

/**
 *  The creation time of the conversation.
 */
@property (nonatomic, strong, readonly, nullable) NSDate       *createAt;

/**
 *  The last updating time of the conversation. When fields like name, members changes, this time will changes.
 */
@property (nonatomic, strong, readonly, nullable) NSDate       *updateAt;

/**
 *  The send timestamp of the last message in this conversation.
 */
@property (nonatomic, strong, readonly, nullable) NSDate       *lastMessageAt;

/**
 *  The name of this conversation. Can be changed by update:callback: .
 */
@property (nonatomic, copy, readonly, nullable) NSString     *name;

/**
 *  The ids of the clients who join the conversation. Can be changed by addMembersWithClientIds:callback: or removeMembersWithClientIds:callback: .
 */
@property (nonatomic, strong, readonly, nullable) NSArray      *members;

/**
 *  The attributes of the conversation. Intend to save any extra data of the conversation.
 *  Can be set when creating the conversation or can be updated by update:callback: .
 */
@property (nonatomic, strong, readonly, nullable) NSDictionary *attributes;

/**
 *  Indicate whether it is a transient conversation.
 *  @see XYDChatConversationOptionTransient
 */
@property (nonatomic, assign, readonly) BOOL transient;

/**
 *  Muting status. If muted, when you have offline messages, will not receive Apple APNS notification.
 *  Can be changed by muteWithCallback: or unmuteWithCallback:.
 */
@property (nonatomic, assign, readonly) BOOL muted;

/**
 *  The XYDChatClient object which this conversation belongs to.
 */
@property (nonatomic, weak, readonly, nullable)   XYDChatClient   *imClient;

/*!
 生成一个新的 XYDChatConversationUpdateBuilder 实例。用于更新对话。
 @return 新的 XYDChatConversationUpdateBuilder 实例.
 */
//- (XYDChatConversationUpdateBuilder *)newUpdateBuilder;

/*!
 创建一个 XYDChatKeyedConversation 对象。用于序列化，方便保存在本地。
 @return XYDChatKeyedConversation 对象。
 */
- (XYDArchivedConversation *)keyedConversation;

/*!
 拉取服务器最新数据。
 @param callback － 结果回调
 */
- (void)fetchWithCallback:(XYDChatBooleanResultBlock)callback;

/*!
 发送更新。
 @param updateDict － 需要更新的数据，可通过 XYDChatConversationUpdateBuilder 生成
 @param callback － 结果回调
 */
- (void)update:(NSDictionary *)updateDict
      callback:(XYDChatBooleanResultBlock)callback;

/*!
 加入对话。
 @param callback － 结果回调
 */
- (void)joinWithCallback:(XYDChatBooleanResultBlock)callback;

/*!
 离开对话。
 @param callback － 结果回调
 */
- (void)quitWithCallback:(XYDChatBooleanResultBlock)callback;

/*!
 静音，不再接收此对话的离线推送。
 @param callback － 结果回调
 */
- (void)muteWithCallback:(XYDChatBooleanResultBlock)callback;

/*!
 取消静音，开始接收此对话的离线推送。
 @param callback － 结果回调
 */
- (void)unmuteWithCallback:(XYDChatBooleanResultBlock)callback;

/*!
 标记该会话已读。
 将服务端该会话的未读消息数置零。
 */
- (void)markAsReadInBackground;

/*!
 邀请新成员加入对话。
 @param clientIds － 成员列表
 @param callback － 结果回调
 */
- (void)addMembersWithClientIds:(NSArray *)clientIds
                       callback:(XYDChatBooleanResultBlock)callback;

/*!
 从对话踢出部分成员。
 @param clientIds － 成员列表
 @param callback － 结果回调
 */
- (void)removeMembersWithClientIds:(NSArray *)clientIds
                          callback:(XYDChatBooleanResultBlock)callback;

/*!
 查询成员人数（开放群组即为在线人数）。
 @param callback － 结果回调
 */
- (void)countMembersWithCallback:(XYDChatIntegerResultBlock)callback;

/*!
 往对话中发送消息。
 @param message － 消息对象
 @param callback － 结果回调
 */
- (void)sendMessage:(XYDChatMessage *)message
           callback:(XYDChatBooleanResultBlock)callback;

/*!
 往对话中发送消息。
 @param message － 消息对象
 @param option － 消息发送选项
 @param callback － 结果回调
 */
- (void)sendMessage:(XYDChatMessage *)message
             option:(nullable XYDChatMessageOption *)option
           callback:(XYDChatBooleanResultBlock)callback;

/*!
 往对话中发送消息。
 @param message － 消息对象
 @param progressBlock - 发送进度回调。仅对文件上传有效，发送文本消息时不进行回调。
 @param callback － 结果回调
 */
- (void)sendMessage:(XYDChatMessage *)message
      progressBlock:(nullable XYDChatProgressBlock)progressBlock
           callback:(XYDChatBooleanResultBlock)callback;

- (void)sendMessage:(XYDChatMessage *)message
            options:(XYDChatMessageOption *)options
      progressBlock:(XYDChatProgressBlock)progressBlock
           callback:(XYDChatBooleanResultBlock)callback;

/*!
 往对话中发送消息。
 @param message － 消息对象
 @param option － 消息发送选项
 @param progressBlock - 发送进度回调。仅对文件上传有效，发送文本消息时不进行回调。
 @param callback － 结果回调
 */
- (void)sendMessage:(XYDChatMessage *)message
             option:(nullable XYDChatMessageOption *)option
      progressBlock:(nullable XYDChatProgressBlock)progressBlock
           callback:(XYDChatBooleanResultBlock)callback;

/*!
 从服务端拉取该会话的最近 limit 条消息。
 @param limit 返回结果的数量，默认 20 条，最多 1000 条。
 @param callback 查询结果回调。
 */
- (void)queryMessagesFromServerWithLimit:(NSUInteger)limit
                                callback:(XYDChatArrayResultBlock)callback;

/*!
 从缓存中查询该会话的最近 limit 条消息。
 @param limit 返回结果的数量，默认 20 条，最多 1000 条。
 @return 消息数组。
 */
- (NSArray *)queryMessagesFromCacheWithLimit:(NSUInteger)limit;

/*!
 获取该会话的最近 limit 条消息。
 @param limit 返回结果的数量，默认 20 条，最多 1000 条。
 @param callback 查询结果回调。
 */
- (void)queryMessagesWithLimit:(NSUInteger)limit
                      callback:(XYDChatArrayResultBlock)callback;

/*!
 查询历史消息，获取某条消息或指定时间戳之前的 limit 条消息。
 @param messageId 此消息以前的消息。
 @param timestamp 此时间以前的消息。
 @param limit 返回结果的数量，默认 20 条，最多 1000 条。
 @param callback 查询结果回调。
 */
- (void)queryMessagesBeforeId:(nullable NSString *)messageId
                    timestamp:(int64_t)timestamp
                        limit:(NSUInteger)limit
                     callback:(XYDChatArrayResultBlock)callback;

@end

NS_ASSUME_NONNULL_END
