//
//  XYDConversationService.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/10.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDSingleton.h"
#import "XYDChatServiceDefinition.h"
#import "XYDConversation.h"
#import "XYDChatMessage.h"
#import "XYDChatConstant.h"
#import "XYDChatMessageOption.h"

FOUNDATION_EXTERN NSString *const XYDConversationServiceErrorDomain;

// 会话服务，处理一些会话的操作
@interface XYDConversationService : XYDSingleton<XYDConversationService>

/**
 *  当前正在聊天的 conversationId，当前不在聊天界面则为nil。如果想判断当前是否在对话页面，请判断该值是否为nil。
 */
@property (nonatomic, strong) NSString *currentConversationId;

/**
 *  推送弹框点击时记录的 convid
 */
@property (nonatomic, strong) NSString *remoteNotificationConversationId;

@property (nonatomic, assign, readonly, getter=isChatting) BOOL chatting;

/*!
 * 只要进过聊天页面，这个值总不为nil。当前不在聊天界面则为nil，这是因为考虑到可能会在对话页面，Present其它页面，比如联系人列表，需要用到currentConversation信息，所以如果想判断当前是否在对话页面，请判断currentConversationId是否为nil。
 */
@property (nonatomic, strong) XYDConversation *currentConversation;

/*!
 *  根据 conversationId 获取对话
 *  @param conversationId   对话的 id
 */
- (void)fecthConversationWithConversationId:(NSString *)conversationId callback:(XYDChatConversationResultBlock)callback;
- (void)fetchConversationsWithConversationIds:(NSSet *)conversationIds callback:(XYDChatArrayResultBlock)callback;

/*!
 *  根据 peerId 获取对话,
 *  @attention  This will create new If not exist.
 *  @param peerId   对方的 id
 */
- (void)fecthConversationWithPeerId:(NSString *)peerId callback:(XYDChatConversationResultBlock)callback;

- (void)sendMessage:(XYDChatMessage*)message
       conversation:(XYDConversation *)conversation
      progressBlock:(XYDChatProgressBlock)progressBlock
           callback:(XYDChatBooleanResultBlock)block;

- (void)sendMessage:(XYDChatMessage*)message
       conversation:(XYDConversation *)conversation
            options:(XYDChatMessageOption *)options
      progressBlock:(XYDChatProgressBlock)progressBlock
           callback:(XYDChatBooleanResultBlock)block;

- (void)queryTypedMessagesWithConversation:(XYDConversation *)conversation timestamp:(int64_t)timestamp limit:(NSInteger)limit block:(XYDChatArrayResultBlock)block;

/**
 *  删除对话对应的UIProfile缓存，比如当用户信息发生变化时
 *  @param  conversationID 对话，可以是单聊，也可是群聊
 */
- (void)removeCacheForConversationId:(NSString *)conversationID;
- (void)updateConversationAsRead;

#pragma mark - 最近对话的本地缓存，最近对话将保存在本地数据库中
///=============================================================================
/// @name 最近对话的本地缓存，最近对话将保存在本地数据库中
///=============================================================================

/**
 *  会在 openClient 时调用
 *  @param userId 跟自己的clientId相关的数据库路径
 */
- (void)setupDatabaseWithUserId:(NSString *)userId;

- (void)insertRecentConversation:(XYDConversation *)conversation shouldRefreshWhenFinished:(BOOL)shouldRefreshWhenFinished;

- (void)increaseUnreadCount:(NSUInteger)increaseUnreadCount withConversationId:(NSString *)conversationId shouldRefreshWhenFinished:(BOOL)shouldRefreshWhenFinished;
/**
 *  更新 mentioned 值，当接收到消息发现 @了我的时候，设为 YES，进入聊天页面，设为 NO
 *  @param mentioned  要更新的值
 *  @param conversationId 相应对话
 */
- (void)updateMentioned:(BOOL)mentioned conversationId:(NSString *)conversationId;
- (void)updateMentioned:(BOOL)mentioned conversationId:(NSString *)conversationId shouldRefreshWhenFinished:(BOOL)shouldRefreshWhenFinished;
/**
 *  更新 draft 值
 *  @param draft  要更新的值
 */
- (void)updateDraft:(NSString *)draft conversationId:(NSString *)conversationId;
- (void)updateDraft:(NSString *)draft conversationId:(NSString *)conversationId shouldRefreshWhenFinished:(BOOL)shouldRefreshWhenFinished;

/**
 *  更新每条最近对话记录里的 conversation 值，也即某对话的名字、成员可能变了，需要更新应用打开时，第一次加载最近对话列表时，会去向服务器要对话的最新数据，然后更新
 *  @param conversations 要更新的对话
 */
- (void)updateRecentConversation:(NSArray *)conversations;
- (void)updateRecentConversation:(NSArray *)conversations shouldRefreshWhenFinished:(BOOL)shouldRefreshWhenFinished;
- (void)increaseUnreadCountWithConversationId:(NSString *)conversationId shouldRefreshWhenFinished:(BOOL)shouldRefreshWhenFinished;

- (void)deleteRecentConversationWithConversationId:(NSString *)conversationId shouldRefreshWhenFinished:(BOOL)shouldRefreshWhenFinished;
- (void)updateUnreadCountToZeroWithConversationId:(NSString *)conversationId shouldRefreshWhenFinished:(BOOL)shouldRefreshWhenFinished;

/**
 *  从数据库查找所有的对话，即所有的最近对话
 *  @return 对话数据
 */
- (NSArray *)allRecentConversations;

/**
 *  判断某对话是否存在于本地数据库。接收到消息的时候用，sdk 传过来的对话的members 等数据可能是空的，如果本地数据库存在该对话，则不去服务器请求对话了。如果不存在，则向服务器请求对话的元数据。使得在最近对话列表，取出对话的时候，对话都有元数据。
 */
- (BOOL)isRecentConversationExistWithConversationId:(NSString *)conversationId;

- (NSString *)draftWithConversationId:(NSString *)conversationId;

#pragma mark - FailedMessageStore
///=============================================================================
/// @name FailedMessageStore
///=============================================================================

/*!
 *  失败消息的管理类，职责：
 * 新建一个表 ，保存每个对话失败的消息。(message, convid)
 * 每次进入聊天的时候，发现如果聊天连通，则把失败的消息发送出去。如果不通，则显示在列表后面。
 * 重发的时候，如果重发成功，则消除表里的记录。失败则不做操作。
 * 发送消息的时候，如果发送失败，则往失败的消息表里存一条记录。
 * 该类主要维护了两张表：
 
 表： failed_messages的结构如下：
 
 id       | conversationId | message
 -------------|----------------|-------------
 
 表：conversations的结构如下：
 
 id     |     data    | unreadCount |  mentioned
 -------------|-------------|-------------|-------------
 
 */

/**
 *  发送消息失败时调用
 *  @param message 相应的消息
 */
- (void)insertFailedMessage:(XYDChatMessage *)message;
- (void)insertFailedXYDChatMessage:(XYDChatMessage *)message;
/**
 *  重发成功的时候调用
 *  @param recordId 记录的 id
 *  @recordId
 */
- (BOOL)deleteFailedMessageByRecordId:(NSString *)recordId;

/**
 *  查找失败的消息。进入聊天页面时调用，若聊天服务连通，则把失败的消息重发，否则，加在列表尾部。
 *  @param conversationId 对话的 id
 *  @return 消息数组
 */
- (NSArray<XYDChatMessage *> *)failedMessagesByConversationId:(NSString *)conversationId;

- (NSArray<XYDChatMessage *> *)failedMessageIdsByConversationId:(NSString *)conversationId;

- (NSArray<XYDChatMessage *> *)failedMessagesByMessageIds:(NSArray *)messageIds;

+ (void)cacheFileTypeMessages:(NSArray<XYDChatMessage *> *)messages callback:(XYDChatBooleanResultBlock)callback;

@end
