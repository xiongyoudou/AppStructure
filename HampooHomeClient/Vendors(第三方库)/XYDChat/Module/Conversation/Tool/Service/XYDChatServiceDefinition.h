//
//  XYDChatServiceDefinition.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/11.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#ifndef XYDChatServiceDefinition_h
#define XYDChatServiceDefinition_h

#pragma mark - XYDChatSessionService
#import "XYDChatUserDelegate.h"
#import "XYDChatConstant.h"
#import <CoreLocation/CoreLocation.h>
@class XYDConversationVCtrl;
@class XYDConversation;
@class XYDConversationListVCtrl;
@class XYDChatMessage;
@class XYDChatMenuItem;
@class XYDChatClient;

// 定义聊天应用中涉及到的各种服务


///=============================================================================
/// @name XYDChatSessionService：聊天会话服务
///=============================================================================

@protocol XYDChatSessionService <NSObject>

// session重连回调，返回重连结果
typedef void (^XYDChatReconnectSessionCompletionHandler)(BOOL succeeded, NSError *error);

/*!
 * @param granted granted fore single signOn
 * 默认允许重连，error的code为4111时，需要额外请求权限，才可标记为YES。
 */
typedef void (^XYDChatForceReconnectSessionBlock)(NSError *error, BOOL granted, __kindof UIViewController *viewController, XYDChatReconnectSessionCompletionHandler completionHandler);

// 客户端id
@property (nonatomic, copy, readonly) NSString *clientId;
// 客户端对象
@property (nonatomic, strong, readonly) XYDChatClient *client;
// 是否只允许单方登录
@property (nonatomic, assign) BOOL disableSingleSignOn;
@property (nonatomic, copy) XYDChatForceReconnectSessionBlock forceReconnectSessionBlock;

/*!
 * @param clientId You can use the user id in your user system as clientId, ChatKit will get the current user's information by both this id and the method `-[XYDChatChatService getProfilesForUserIds:callback:]`.
 * @param callback Callback
 */
- (void)openWithClientId:(NSString *)clientId callback:(XYDChatBooleanResultBlock)callback;

/*!
 * @param force Just for Single Sign On
 */
- (void)openWithClientId:(NSString *)clientId force:(BOOL)force callback:(XYDChatBooleanResultBlock)callback;
/*!
 * @brief Close the client
 * @param callback Callback
 */
- (void)closeWithCallback:(XYDChatBooleanResultBlock)callback;

/*!
 * set how you want to force reconnect session. It is usually usefully for losing session because of single sign-on, or weak network.
 */
- (void)setForceReconnectSessionBlock:(XYDChatForceReconnectSessionBlock)forceReconnectSessionBlock;

@end

#pragma mark - XYDChatUserSystemService
///=============================================================================
/// @name XYDChatUserSystemService：用户系统类型服务
///=============================================================================

@protocol XYDChatUserSystemService <NSObject>

// 通过userIds来获取用户的基本信息并返回，在获取结束之后的主线程上调用该block
typedef void(^XYDChatFetchProfilesCompletionHandler)(NSArray<id<XYDChatUserDelegate>> *users, NSError *error);

/*!
 *  @brief When LeanCloudChatKit wants to fetch profiles, this block will be invoked.
 *  @param userIds User ids
 *  @param completionHandler The block to execute with the users' information for the userIds. Always execute this block at some point during your implementation of this method on main thread. Specify users' information how you want ChatKit to show.
 */
typedef void(^XYDChatFetchProfilesBlock)(NSArray<NSString *> *userIds, XYDChatFetchProfilesCompletionHandler completionHandler);

@property (nonatomic, copy) XYDChatFetchProfilesBlock fetchProfilesBlock;

/*!
 *  @brief Add the ablitity to fetch profiles.
 *  @attention  You must get peer information by peer id with a synchronous implementation.
 *              If implemeted, this block will be invoked automatically by LeanCloudChatKit for fetching peer profile.
 */
- (void)setFetchProfilesBlock:(XYDChatFetchProfilesBlock)fetchProfilesBlock;

/*!
 * Remove all cached profiles-清楚缓存的个人信息
 */
- (void)removeAllCachedProfiles;

/**
 *  remove person profile cache-清楚某个对象用户的个人信息
 *
 */
- (void)removeCachedProfileForPeerId:(NSString *)peerId;

- (void)getCachedProfileIfExists:(NSString *)userId name:(NSString **)name avatarURL:(NSURL **)avatarURL error:(NSError * __autoreleasing *)error;
- (NSArray<id<XYDChatUserDelegate>> *)getCachedProfilesIfExists:(NSArray<NSString *> *)userIds error:(NSError * __autoreleasing *)error;

/*!
 * 如果从缓存查询到的userids数量不相符，则返回nil
 */
- (NSArray<id<XYDChatUserDelegate>> *)getCachedProfilesIfExists:(NSArray<NSString *> *)userIds shouldSameCount:(BOOL)shouldSameCount error:(NSError * __autoreleasing *)theError;
- (void)getProfileInBackgroundForUserId:(NSString *)userId callback:(XYDChatUserResultCallBack)callback;
- (void)getProfilesInBackgroundForUserIds:(NSArray<NSString *> *)userIds callback:(XYDChatUserResultsCallBack)callback;
- (NSArray<id<XYDChatUserDelegate>> *)getProfilesForUserIds:(NSArray<NSString *> *)userIds error:(NSError * __autoreleasing *)error;

@end

#pragma mark - XYDChatSignatureService
///=============================================================================
/// @name XYDChatSignatureService
///=============================================================================

@protocol XYDChatSignatureService <NSObject>

/*!
 *  @brief The block to execute with the signature information for session. Always execute this block at some point when fetching signature information completes on main thread. Specify signature information how you want ChatKit pin to these actions: open, start(create conversation), kick, invite.
 *  @attention If you fetch AVIMSignature fails, you should reture nil, meanwhile, give the error reason.
 */
//typedef void(^XYDChatGenerateSignatureCompletionHandler)(AVIMSignature *signature, NSError *error);

/*!
 *  @brief If implemeted, this block will be invoked automatically for pinning signature to these actions: open, start(create conversation), kick, invite.
 *  @param clientId - Id of operation initiator
 *  @param conversationId －  Id of target conversation
 *  @param action － Kinds of action:
 "open": log in an account
 "start": create a conversation
 "add": invite myself or others to the conversation
 "remove": kick someone out the conversation
 *  @param clientIds － Target id list for the action
 *  @param completionHandler The block to execute with the signature information for session. Always execute this block at some point during your implementation of this method on main thread. Specify signature information how you want ChatKit pin to these actions: open, start(create conversation), kick, invite.
 */
//typedef void(^XYDChatGenerateSignatureBlock)(NSString *clientId, NSString *conversationId, NSString *action, NSArray *clientIds, XYDChatGenerateSignatureCompletionHandler completionHandler);

//@property (nonatomic, copy) XYDChatGenerateSignatureBlock generateSignatureBlock;

/*!
 * @brief Add the ablitity to pin signature to these actions: open, start(create conversation), kick, invite.
 * @attention  If implemeted, this block will be invoked automatically for pinning signature to these actions: open, start(create conversation), kick, invite.
 */
//- (void)setGenerateSignatureBlock:(XYDChatGenerateSignatureBlock)generateSignatureBlock;

@end

#pragma mark - XYDChatUIService
///=============================================================================
/// @name XYDChatUIService
///=============================================================================

#import "XYDChatServiceDefinition.h"

@protocol XYDChatUIService <NSObject>

/// 传递触发的UIViewController对象
#define XYDChatPreviewImageMessageUserInfoKeyFromController    @"XYDChatPreviewImageMessageUserInfoKeyFromController"
/// 传递触发的UIView对象
#define XYDChatPreviewImageMessageUserInfoKeyFromView          @"XYDChatPreviewImageMessageUserInfoKeyFromView"
/// 传递触发的UIView对象
#define XYDChatPreviewImageMessageUserInfoKeyFromPlaceholderView          @"XYDChatPreviewImageMessageUserInfoKeyFromPlaceholderView"

/*!
 *  打开某个profile的回调block
 *  @param userId 被点击的user 的 userId (clientId) ，与 user 属性中 clientId 的区别在于，本属性永远不为空，但 user可能为空。
 *  @param parentController 用于打开的顶层控制器
 */
typedef void(^XYDChatOpenProfileBlock)(NSString *userId, id<XYDChatUserDelegate> user, __kindof UIViewController *parentController);

@property (nonatomic, copy) XYDChatOpenProfileBlock openProfileBlock;

/*!
 *  打开某个profile的回调block
 */
- (void)setOpenProfileBlock:(XYDChatOpenProfileBlock)openProfileBlock;

/*!
 *  当ChatKit需要预览图片消息时，会调用这个block
 *  @param index 用户点击的图片消息在imageMessages中的下标
 *  @param allVisibleImages 元素可能是图片，也可能是NSURL，以及混合。
 *  @param userInfo 用来传递上下文信息，例如，从某个Controller触发，或者从某个view触发等，键值在下面定义
 */
typedef void(^XYDChatPreviewImageMessageBlock)(NSUInteger index, NSArray *allVisibleImages, NSArray *allVisibleThumbs, NSDictionary *userInfo);

@property (nonatomic, copy) XYDChatPreviewImageMessageBlock previewImageMessageBlock;

/// 传递触发的UIViewController对象
#define XYDChatPreviewImageMessageUserInfoKeyFromController    @"XYDChatPreviewImageMessageUserInfoKeyFromController"
/// 传递触发的UIView对象
#define XYDChatPreviewImageMessageUserInfoKeyFromView          @"XYDChatPreviewImageMessageUserInfoKeyFromView"
/// 传递触发的UIView对象
#define XYDChatPreviewImageMessageUserInfoKeyFromPlaceholderView          @"XYDChatPreviewImageMessageUserInfoKeyFromPlaceholderView"

/*!
 *  当ChatKit需要预览图片消息时，会调用这个block.
 *  使用NSDictionary传递上下文信息，便于扩展
 */
- (void)setPreviewImageMessageBlock:(XYDChatPreviewImageMessageBlock)previewImageMessageBlock;

/*!
 *  当ChatKit需要预览地理位置消息时，会调用这个block
 *  @param location 地理位置坐标
 *  @param geolocations 地理位置的文字描述
 *  @param userInfo 用来传递上下文信息，例如，从某个Controller触发，或者从某个view触发等，键值在下面定义
 */
typedef void(^XYDChatPreviewLocationMessageBlock)(CLLocation *location, NSString *geolocations, NSDictionary *userInfo);

@property (nonatomic, copy) XYDChatPreviewLocationMessageBlock previewLocationMessageBlock;

/// 传递触发的UIViewController对象
#define XYDChatPreviewLocationMessageUserInfoKeyFromController    @"XYDChatPreviewLocationMessageUserInfoKeyFromController"
/// 传递触发的UIView对象
#define XYDChatPreviewLocationMessageUserInfoKeyFromView          @"XYDChatPreviewLocationMessageUserInfoKeyFromView"

/*!
 *  当ChatKit需要预览地理位置消息时，会调用这个block.
 *  使用NSDictionary传递上下文信息，便于扩展
 */
- (void)setPreviewLocationMessageBlock:(XYDChatPreviewLocationMessageBlock)previewLocationMessageBlock;

//TODO:可自定义长按能响应的消息类型
/*!
 *  ChatKit会在长按消息时，调用这个block
 *  @param message 被长按的消息
 *  @param userInfo 用来传递上下文信息，例如，从某个Controller触发，或者从某个view触发等，键值在下面定义
 */
typedef NSArray<XYDChatMenuItem *> *(^XYDChatLongPressMessageBlock)(XYDChatMessage *message, NSDictionary *userInfo);

@property (nonatomic, copy) XYDChatLongPressMessageBlock longPressMessageBlock;

/// 传递触发的UIViewController对象
#define XYDChatLongPressMessageUserInfoKeyFromController    @"XYDChatLongPressMessageUserInfoKeyFromController"
/// 传递触发的UIView对象
#define XYDChatLongPressMessageUserInfoKeyFromView          @"XYDChatLongPressMessageUserInfoKeyFromView"

/*!
 *  ChatKit会在长按消息时，调用这个block
 *  使用NSDictionary传递上下文信息，便于扩展
 */
- (void)setLongPressMessageBlock:(XYDChatLongPressMessageBlock)longPressMessageBlock;

/**
 *  当ChatKit需要显示通知时，会调用这个block。
 *  开发者需要实现并设置这个block，以便给用户提示。
 *  @param viewController 当前的controller
 *  @param title 标题
 *  @param subtitle 子标题
 *  @param type 类型
 */
typedef void(^XYDChatShowNotificationBlock)(__kindof UIViewController *viewController, NSString *title, NSString *subtitle, XYDChatMessageNotificationType type);

@property (nonatomic, copy) XYDChatShowNotificationBlock showNotificationBlock;

/**
 *  当ChatKit需要显示通知时，会调用这个block。
 *  开发者需要实现并设置这个block，以便给用户提示。
 */
- (void)setShowNotificationBlock:(XYDChatShowNotificationBlock)showNotificationBlock;

/**
 *  当ChatKit需要显示通知时，会调用这个block。
 *  开发者需要实现并设置这个block，以便给用户提示。
 *  @param viewController 当前的controller
 *  @param title 标题
 *  @param type 类型
 */

typedef void(^XYDChatHUDActionBlock)(__kindof UIViewController *viewController, UIView *view, NSString *title, XYDChatMessageHUDActionType type);

@property (nonatomic, copy) XYDChatHUDActionBlock HUDActionBlock;

/**
 *  当ChatKit需要显示通知时，会调用这个block。
 *  开发者需要实现并设置这个block，以便给用户提示。
 */
- (void)setHUDActionBlock:(XYDChatHUDActionBlock)HUDActionBlock;

typedef CGFloat (^XYDChatAvatarImageViewCornerRadiusBlock)(CGSize avatarImageViewSize);

@property (nonatomic, assign) XYDChatAvatarImageViewCornerRadiusBlock avatarImageViewCornerRadiusBlock;

/*!
 *  设置对话列表和聊天界面头像ImageView的圆角弧度
 *  注意，请在需要圆角矩形时设置，对话列表和聊天界面头像默认圆形。
 */
- (void)setAvatarImageViewCornerRadiusBlock:(XYDChatAvatarImageViewCornerRadiusBlock)avatarImageViewCornerRadiusBlock;

@end

#pragma mark - XYDChatSettingService
///=============================================================================
/// @name XYDChatSettingService
///=============================================================================

@protocol XYDChatSettingService <NSObject>

/*!
 * You should always use like this, never forgive to cancel log before publishing.
 
 ```
 #ifndef __OPTIMIZE__
 [[LCChatKit sharedInstance] setAllLogsEnabled:YES];
 #endif
 ```
 
 */
+ (void)setAllLogsEnabled:(BOOL)enabled;
+ (BOOL)allLogsEnabled;
+ (NSString *)ChatKitVersion;
- (void)syncBadge;

/*!
 * 禁止预览id
 * 如果不设置，或者设置为NO，在群聊需要显示最后一条消息的发送者时，会在网络请求用户昵称成功前，先显示id，然后，成功后再显示昵称。
 */
@property (nonatomic, assign, getter=isDisablePreviewUserId) BOOL disablePreviewUserId;

/*!
 *  是否使用开发证书去推送，默认为 NO。如果设为 YES 的话每条消息会带上这个参数，云代码利用 Hook 设置证书
 *  参考 https://github.com/leancloud/leanchat-cloudcode/blob/master/cloud/mchat.js
 */
@property (nonatomic, assign) BOOL useDevPushCerticate;
- (void)setBackgroundImage:(UIImage *)image forConversationId:(NSString *)conversationId scaledToSize:(CGSize)scaledToSize;

@end

#pragma mark - XYDConversationService
///=============================================================================
/// @name XYDConversationService
///=============================================================================

typedef void (^XYDChatConversationResultBlock)(XYDConversation *conversation, NSError *error);
typedef void (^XYDChatFetchConversationHandler) (XYDConversation *conversation, XYDConversationVCtrl *conversationController);
typedef void (^XYDChatConversationInvalidedHandler) (NSString *conversationId, XYDConversationVCtrl *conversationController, id<XYDChatUserDelegate> administrator, NSError *error);

@protocol XYDConversationService <NSObject>

@property (nonatomic, copy) XYDChatFetchConversationHandler fetchConversationHandler;

/*!
 * 设置获取 AVIMConversation 对象结束后的 Handler。 这里可以做异常处理，比如获取失败等操作。
 * 获取失败时，XYDChatConversationHandler 返回值中的AVIMConversation 为 nil，成功时为正确的 conversation 值。
 */
- (void)setFetchConversationHandler:(XYDChatFetchConversationHandler)fetchConversationHandler;

@property (nonatomic, copy) XYDChatConversationInvalidedHandler conversationInvalidedHandler;

/*!
 *  会话失效的处理 block，如当群被解散或当前用户不再属于该会话时，对应会话会失效应当被删除并且关闭聊天窗口
 */
- (void)setConversationInvalidedHandler:(XYDChatConversationInvalidedHandler)conversationInvalidedHandler;

typedef void (^XYDChatFilterMessagesCompletionHandler)(NSArray *filteredMessages, NSError *error);
//typedef void (^XYDChatFilterMessagesBlock)(XYDConversation *conversation, NSArray<AVIMTypedMessage *> *messages, XYDChatFilterMessagesCompletionHandler completionHandler);
typedef void (^XYDChatFilterMessagesBlock)(XYDConversation *conversation, NSArray<XYDChatMessage *> *messages, XYDChatFilterMessagesCompletionHandler completionHandler);

/*!
 * 用于筛选消息，比如：群定向消息、筛选黑名单消息、黑名单消息
 * @attention 同步方法异步方法皆可
 */
- (void)setFilterMessagesBlock:(XYDChatFilterMessagesBlock)filterMessagesBlock;

@property (nonatomic, copy) XYDChatFilterMessagesBlock filterMessagesBlock;

/*!
 * @param granted 该消息允许被发送
 * @param error 消息为何不允许被发送
 */
typedef void (^XYDChatSendMessageHookCompletionHandler)(BOOL granted, NSError *error);
typedef void (^XYDChatSendMessageHookBlock)(XYDConversationVCtrl *conversationController, XYDChatMessage __kindof *message, XYDChatSendMessageHookCompletionHandler completionHandler);

/*!
 * 用于HOOK掉发送消息的行为，可以实现比如：禁止黑名单用户发消息、禁止发送包含敏感词掉消息
 * @attention 同步方法异步方法皆可
 */
- (void)setSendMessageHookBlock:(XYDChatSendMessageHookBlock)sendMessageHookBlock;

@property (nonatomic, copy) XYDChatSendMessageHookBlock sendMessageHookBlock;

//TODO:未实现
typedef void (^XYDChatLoadLatestMessagesHandler)(XYDConversationVCtrl *conversationController, BOOL succeeded, NSError *error);

@property (nonatomic, copy) XYDChatLoadLatestMessagesHandler loadLatestMessagesHandler;

/*!
 * 设置获取历史纪录结束时的 Handler。 这里可以做异常处理，比如获取失败等操作。
 * 获取失败时，XYDChatViewControllerBooleanResultBlock 返回值中的 error 不为 nil，包含错误原因，成功时 succeeded 值为 YES。
 */
- (void)setLoadLatestMessagesHandler:(XYDChatLoadLatestMessagesHandler)loadLatestMessagesHandler;

- (void)createConversationWithMembers:(NSArray *)members type:(XYDChatConversationType)type unique:(BOOL)unique callback:(XYDChatConversationResultBlock)callback;

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;

/**
 *  插入一条最近对话
 */
- (void)insertRecentConversation:(XYDConversation *)conversation;

/**
 *  增加未读数
 *  @param conversationId 相应对话id
 */
- (void)increaseUnreadCountWithConversationId:(NSString *)conversationId;

/**
 *  最近对话列表左滑删除本地数据库的对话，将不显示在列表
 *  @param conversationId 相应对话id
 */
- (void)deleteRecentConversationWithConversationId:(NSString *)conversationId;

/**
 *  清空未读数
 *  @param conversationId 相应对话id
 */
- (void)updateUnreadCountToZeroWithConversationId:(NSString *)conversationId;

/**
 *  删除全部缓存，比如当切换用户时，如果同一个人显示的名称和头像需要变更
 */
- (BOOL)removeAllCachedRecentConversations;

- (void)sendWelcomeMessageToPeerId:(NSString *)peerId text:(NSString *)text block:(XYDChatBooleanResultBlock)block;
- (void)sendWelcomeMessageToConversationId:(NSString *)conversationId text:(NSString *)text block:(XYDChatBooleanResultBlock)block;

@end

#pragma mark - XYDChatConversationsListService
///=============================================================================
/// @name XYDChatConversationsListService
///=============================================================================

@protocol XYDChatConversationsListService <NSObject>

/*!
 *  选中某个对话后的回调
 *  @param conversation 被选中的对话
 */
typedef void(^XYDChatDidSelectConversationsListCellBlock)(NSIndexPath *indexPath, XYDConversation *conversation, XYDConversationListVCtrl *controller);

/*!
 *  选中某个对话后的回调
 */
@property (nonatomic, copy) XYDChatDidSelectConversationsListCellBlock didSelectConversationsListCellBlock;

/*!
 *  设置选中某个对话后的回调
 */
- (void)setDidSelectConversationsListCellBlock:(XYDChatDidSelectConversationsListCellBlock)didSelectConversationsListCellBlock;

/*!
 *  删除某个对话后的回调
 *  @param conversation 被选中的对话
 */
typedef void(^XYDChatDidDeleteConversationsListCellBlock)(NSIndexPath *indexPath, XYDConversation *conversation, XYDConversationListVCtrl *controller);

/*!
 *  删除某个对话后的回调
 */
@property (nonatomic, copy) XYDChatDidDeleteConversationsListCellBlock didDeleteConversationsListCellBlock;

/*!
 *  设置删除某个对话后的回调
 */
- (void)setDidDeleteConversationsListCellBlock:(XYDChatDidDeleteConversationsListCellBlock)didDeleteConversationsListCellBlock;

/*!
 *  对话左滑菜单设置block
 *  @return  需要显示的菜单数组
 */
typedef NSArray *(^XYDChatConversationEditActionsBlock)(NSIndexPath *indexPath, NSArray<UITableViewRowAction *> *editActions, XYDConversation *conversation, XYDConversationListVCtrl *controller);

/*!
 *  可以通过这个block设置对话列表中每个对话的左滑菜单，这个是同步调用的，需要尽快返回，否则会卡住UI
 */
@property (nonatomic, copy) XYDChatConversationEditActionsBlock conversationEditActionBlock;

/*!
 *  设置对话列表中每个对话的左滑菜单，这个是同步调用的，需要尽快返回，否则会卡住UI
 */
- (void)setConversationEditActionBlock:(XYDChatConversationEditActionsBlock)conversationEditActionBlock;

typedef void(^XYDChatMarkBadgeWithTotalUnreadCountBlock)(NSInteger totalUnreadCount, __kindof UIViewController *controller);

@property (nonatomic, copy) XYDChatMarkBadgeWithTotalUnreadCountBlock markBadgeWithTotalUnreadCountBlock;

/*!
 * 如果不是TabBar样式，请实现该Blcok。如果不实现，默认会把 App 当作是 TabBar 样式，修改 navigationController 的 tabBarItem 的 badgeValue 数字显示，数字超出99显示省略号。
 */
- (void)setMarkBadgeWithTotalUnreadCountBlock:(XYDChatMarkBadgeWithTotalUnreadCountBlock)markBadgeWithTotalUnreadCountBlock;

@end

#endif /* XYDChatServiceDefinition_h */
