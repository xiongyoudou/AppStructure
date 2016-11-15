//
//  XYDChatClient.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/15.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYDChatSignature.h"
#import "XYDChatConstant.h"

@class XYDChatClientOpenOption;
@class XYDChatMessage;
@class XYDConversationQuery;
@class XYDArchivedConversation;
@class XYDConversation;
@protocol XYDChatClientDelegate;

typedef NS_ENUM(NSUInteger, XYDChatClientStatus) {
    /// Initial client status.
    XYDChatClientStatusNone,
    /// Indicate the client is connecting the server now.
    XYDChatClientStatusOpening,
    /// Indicate the client connected the server.
    XYDChatClientStatusOpened,
    /// Indicate the connection paused. Usually for the network reason.
    XYDChatClientStatusPaused,
    /// Indicate the connection is recovering.
    XYDChatClientStatusResuming,
    /// Indicate the connection is closing.
    XYDChatClientStatusClosing,
    /// Indicate the connection is closed.
    XYDChatClientStatusClosed
};

typedef NS_OPTIONS(uint64_t, XYDChatConversationOption) {
    /// Default conversation. At most allow 500 people to join the conversation.
    XYDChatConversationOptionNone      = 0,
    /// Transient conversation. No headcount limits. But the functionality is limited. No offline messages, no offline notifications, etc.
    XYDChatConversationOptionTransient = 1 << 0,
    /// Unique conversation. If the server detects the conversation with that members exists, will return it instead of creating a new one.
    XYDChatConversationOptionUnique    = 1 << 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface XYDChatClient : NSObject

/**
 *  The delegate which implements XYDChatClientDelegate protocol. It handles these events: connecting status changes, message coming and members of the conversation changes.
 */
@property (nonatomic, weak, nullable) id<XYDChatClientDelegate> delegate;

/**
 *  The delegate which implements XYDChatSignatureDataSource protocol. It is used to fetching signature from your server, and return an XYDChatSignature object.
 */
@property (nonatomic, weak, nullable) id<XYDChatSignatureDataSource> signatureDataSource;

/**
 *  The ID of the current client. Usually the user's ID.
 */
@property (nonatomic, copy, readonly, nullable) NSString *clientId;

/**
 * Tag of current client.
 * @brief If tag is not nil and "default", offline mechanism is enabled.
 * @discussion If one client id login on two different devices, previous opened client will be gone offline by later opened client.
 */
@property (nonatomic, copy, readonly, nullable) NSString *tag;

/**
 *  The connecting status of the current client.
 */
@property (nonatomic, readonly, assign) XYDChatClientStatus status;

/**
 * 控制是否打开历史消息查询的本地缓存功能,默认开启
 */
@property (nonatomic, assign) BOOL messageQueryCacheEnabled;

/*!
 Initializes a newly allocated client.
 @param clientId Identifier of client, nonnull requierd.
 */
- (instancetype)initWithClientId:(NSString *)clientId;

/*!
 Initializes a newly allocated client.
 @param clientId Identifier of client, nonnull requierd.
 @param tag      Tag of client.
 */
- (instancetype)initWithClientId:(NSString *)clientId tag:(nullable NSString *)tag;

/*!
 默认 XYDChatClient 实例
 @return XYDChatClient 实例
 */
+ (instancetype)defaultClient;

/*!
 * 设置用户选项。
 * 该接口用于控制 XYDChatClient 的一些细节行为。
 * @param userOptions 用户选项。
 */
+ (void)setUserOptions:(NSDictionary *)userOptions;

/*!
 * 设置实时通信的超时时间，默认 15 秒。
 * @param seconds 超时时间，单位是秒。
 */
+ (void)setTimeoutIntervalInSeconds:(NSTimeInterval)seconds;

/*!
 重置默认 XYDChatClient 实例
 置后再调用 +defaultClient 将返回新的实例
 */
+ (void)resetDefaultClient;

/*!
 开启某个账户的聊天
 @param callback － 聊天开启之后的回调
 */
- (void)openWithCallback:(XYDChatBooleanResultBlock)callback;

/*!
 * Open client with option.
 * @param option   Option to open client.
 * @param callback Callback for openning client.
 * @brief Open client with option of which the properties will override client's default option.
 */
- (void)openWithOption:(nullable XYDChatClientOpenOption *)option callback:(XYDChatBooleanResultBlock)callback;

/*!
 结束某个账户的聊天
 @param callback － 聊天关闭之后的回调
 */
- (void)closeWithCallback:(XYDChatBooleanResultBlock)callback;

/*!
 创建一个新的用户对话。
 在单聊的场合，传入对方一个 clientId 即可；群聊的时候，支持同时传入多个 clientId 列表
 @param name - 会话名称。
 @param clientIds - 聊天参与者（发起人除外）的 clientId 列表。
 @param callback － 对话建立之后的回调
 */
- (void)createConversationWithName:(NSString *)name
                         clientIds:(NSArray *)clientIds
                          callback:(XYDChatConversationResultBlock)callback;

/*!
 创建一个新的用户对话。
 在单聊的场合，传入对方一个 clientId 即可；群聊的时候，支持同时传入多个 clientId 列表
 @param name - 会话名称。
 @param clientIds - 聊天参与者（发起人除外）的 clientId 列表。
 @param attributes - 会话的自定义属性。
 @param options － 可选参数，可以使用或 “|” 操作表示多个选项
 @param callback － 对话建立之后的回调
 */
- (void)createConversationWithName:(NSString *)name
                         clientIds:(NSArray *)clientIds
                        attributes:(nullable NSDictionary *)attributes
                           options:(XYDChatConversationOption)options
                          callback:(XYDChatConversationResultBlock)callback;

/*!
 通过 conversationId 查找已激活会话。
 已激活会话是指通过查询、创建、或通过 KeyedConversation 所得到的会话。
 @param conversationId Conversation 的 id。
 @return 与 conversationId 匹配的会话，若找不到，返回 nil。
 */
- (nullable XYDConversation *)conversationForId:(NSString *)conversationId;

/*!
 创建一个绑定到当前 client 的会话。
 @param keyedConversation XYDChatKeyedConversation 对象。
 @return 已绑定到当前 client 的会话。
 */
- (XYDConversation *)conversationWithKeyedConversation:(XYDArchivedConversation *)keyedConversation;

/*!
 构造一个对话查询对象
 @return 对话查询对象.
 */
- (XYDConversationQuery *)conversationQuery;

@end

/**
 *  The XYDChatClientDelegate protocol defines methods to handle these events: connecting status changes, message comes and members of the conversation changes.
 */
@protocol XYDChatClientDelegate <NSObject>
@optional

/**
 *  当前聊天状态被暂停，常见于网络断开时触发。
 *  @param imClient 相应的 imClient
 */
- (void)imClientPaused:(XYDChatClient *)imClient;

/**
 *  当前聊天状态被暂停，常见于网络断开时触发。
 *  注意：该回调会覆盖 imClientPaused: 方法。
 *  @param imClient 相应的 imClient
 *  @param error    具体错误信息
 */
- (void)imClientPaused:(XYDChatClient *)imClient error:(NSError *)error;

/**
 *  当前聊天状态开始恢复，常见于网络断开后开始重新连接。
 *  @param imClient 相应的 imClient
 */
- (void)imClientResuming:(XYDChatClient *)imClient;

/**
 *  当前聊天状态已经恢复，常见于网络断开后重新连接上。
 *  @param imClient 相应的 imClient
 */
- (void)imClientResumed:(XYDChatClient *)imClient;

/*!
 接收到新的普通消息。
 @param conversation － 所属对话
 @param message - 具体的消息
 */
- (void)conversation:(XYDConversation *)conversation didReceiveCommonMessage:(XYDChatMessage *)message;

/*!
 接收到新的富媒体消息。
 @param conversation － 所属对话
 @param message - 具体的消息
 */
- (void)conversation:(XYDConversation *)conversation didReceiveTypedMessage:(XYDChatMessage *)message;

/*!
 消息已投递给对方。
 @param conversation － 所属对话
 @param message - 具体的消息
 */
- (void)conversation:(XYDConversation *)conversation messageDelivered:(XYDChatMessage *)message;

/*!
 对话中有新成员加入时所有成员都会收到这一通知。
 @param conversation － 所属对话
 @param clientIds - 加入的新成员列表
 @param clientId - 邀请者的 id
 */
- (void)conversation:(XYDConversation *)conversation membersAdded:(NSArray *)clientIds byClientId:(NSString *)clientId;

/*!
 对话中有成员离开时所有剩余成员都会收到这一通知。
 @param conversation － 所属对话
 @param clientIds - 离开的成员列表
 @param clientId - 操作者的 id
 */
- (void)conversation:(XYDConversation *)conversation membersRemoved:(NSArray *)clientIds byClientId:(NSString *)clientId;

/*!
 当前用户被邀请加入对话的通知。
 @param conversation － 所属对话
 @param clientId - 邀请者的 id
 */
- (void)conversation:(XYDConversation *)conversation invitedByClientId:(NSString *)clientId;

/*!
 当前用户被踢出对话的通知。
 @param conversation － 所属对话
 @param clientId - 操作者的 id
 */
- (void)conversation:(XYDConversation *)conversation kickedByClientId:(NSString *)clientId;

/*!
 收到未读通知。在该终端上线的时候，服务器会将对话的未读数发送过来。未读数可通过 -[XYDChatConversation markAsReadInBackground] 清零，服务端不会自动清零。
 @param conversation 所属会话。
 @param unread 未读消息数量。
 */
- (void)conversation:(XYDConversation *)conversation didReceiveUnread:(NSInteger)unread;

/*!
 客户端下线通知。
 @param client 已下线的 client。
 @param error 错误信息。
 */
- (void)client:(XYDChatClient *)client didOfflineWithError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
