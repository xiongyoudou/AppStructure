//
//  XYDChatMacro.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/9.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 基本宏
#define WAIT_TIL_TRUE(signal, interval) \
do {                                       \
while(!(signal)) {                     \
@autoreleasepool {                 \
if (![[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:(interval)]]) { \
[NSThread sleepForTimeInterval:(interval)]; \
}                              \
}                                  \
}                                      \
} while (0)

#define WAIT_WITH_ROUTINE_TIL_TRUE(signal, interval, routine) \
do {                                       \
while(!(signal)) {                     \
@autoreleasepool {                 \
routine;                       \
if (![[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:(interval)]]) { \
[NSThread sleepForTimeInterval:(interval)]; \
}                              \
}                                  \
}                                      \
} while (0)

#pragma mark - 通知宏

#pragma mark - Notification Name
///=============================================================================
/// @name Notification Name
///=============================================================================

/**
 *  未读数改变了。通知去服务器同步 installation 的badge
 */
static NSString *const XYDChatNotificationUnreadsUpdated = @"XYDChatNotificationUnreadsUpdated";

/**
 *  消息到来了，通知聊天页面和最近对话页面刷新
 */
static NSString *const XYDChatNotificationMessageReceived = @"XYDChatNotificationMessageReceived";
/**
 *  消息到来了，通知聊天页面和最近对话页面刷新
 */
static NSString *const XYDChatNotificationCustomMessageReceived = @"XYDChatNotificationCustomMessageReceived";

static NSString *const XYDChatNotificationCustomTransientMessageReceived = @"XYDChatNotificationCustomTransientMessageReceived";

/**
 *  消息到达对方了，通知聊天页面更改消息状态
 */
static NSString *const XYDChatNotificationMessageDelivered = @"XYDChatNotificationMessageDelivered";

/**
 *  对话的元数据变化了，通知页面刷新
 */
static NSString *const XYDChatNotificationConversationUpdated = @"XYDChatNotificationConversationUpdated";

/**
 *  聊天服务器连接状态更改了，通知最近对话和聊天页面是否显示红色警告条
 */
static NSString *const XYDChatNotificationConnectivityUpdated = @"XYDChatNotificationConnectivityUpdated";

/**
 * 会话失效，如当群被解散或当前用户不再属于该会话时，对应会话会失效应当被删除并且关闭聊天窗口
 */
static NSString *const XYDChatNotificationCurrentConversationInvalided = @"XYDChatNotificationCurrentConversationInvalided";

/**
 * 对话聊天背景切换
 */
static NSString *const XYDChatNotificationConversationViewControllerBackgroundImageDidChanged = @"XYDChatNotificationConversationViewControllerBackgroundImageDidChanged";

static NSString *const XYDChatNotificationConversationViewControllerBackgroundImageDidChangedUserInfoConversationIdKey = @"XYDChatNotificationConversationViewControllerBackgroundImageDidChangedUserInfoConversationIdKey";


static NSString *const XYDChatNotificationConversationInvalided = @"XYDChatNotificationConversationInvalided";
static NSString *const XYDChatNotificationConversationListDataSourceUpdated = @"XYDChatNotificationConversationListDataSourceUpdated";
static NSString *const XYDChatNotificationContactListDataSourceUpdated = @"XYDChatNotificationContactListDataSourceUpdated";

static NSString *const XYDChatNotificationContactListDataSourceUpdatedUserInfoDataSourceKey = @"XYDChatNotificationContactListDataSourceUpdatedUserInfoDataSourceKey";

static NSString *const XYDChatNotificationContactListDataSourceUserIdType = @"XYDChatNotificationContactListDataSourceUserIdType";
static NSString *const XYDChatNotificationContactListDataSourceContactObjType = @"XYDChatNotificationContactListDataSourceContactObjType";
static NSString *const XYDChatNotificationContactListDataSourceUpdatedUserInfoDataSourceTypeKey = @"XYDChatNotificationContactListDataSourceUpdatedUserInfoDataSourceTypeKey";
