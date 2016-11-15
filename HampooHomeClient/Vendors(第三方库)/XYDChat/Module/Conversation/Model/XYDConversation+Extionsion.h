//
//  XYDConversation+Extionsion.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/15.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDConversation.h"
#import "XYDChatConstant.h"
#import "XYDChatMessage.h"

@interface XYDConversation (Extionsion)

/**
 *  最后一条消息。通过 SDK 的消息缓存找到的
 */
@property (nonatomic, strong) XYDChatMessage *xydChat_lastMessage;

/**
 *  未读消息数，保存在了数据库。收消息的时候，更新数据库
 */
@property (nonatomic, assign) NSInteger xydChat_unreadCount;

/*!
 * 如果未读消息数未超出100，显示数字，否则消息省略号
 */
- (NSString *)xydChat_badgeText;

/**
 *  是否有人提到了你，配合 @ 功能。不能看最后一条消息。
 *  因为可能倒数第二条消息提到了你，所以维护一个标记。
 */
@property (nonatomic, assign) BOOL xydChat_mentioned;

/*!
 * 草稿
 */
@property (nonatomic, copy) NSString *xydChat_draft;

/**
 *  对话的类型，通过成员数量来判断。系统对话按照群聊来处理。
 *
 *  @return 单聊或群聊
 */
- (XYDChatConversationType)xydChat_type;

/**
 *  单聊对话的对方的 clientId
 */
- (NSString *)xydChat_peerId;

/**
 *  对话显示的名称。单聊显示对方名字，群聊显示对话的 name
 */
- (NSString *)xydChat_displayName;

/**
 *  对话的标题。如 兴趣群(30)
 */
- (NSString *)xydChat_title;

- (void)xydChat_setObject:(id)object forKey:(NSString *)key callback:(XYDChatBooleanResultBlock)callback;

- (void)xydChat_removeObjectForKey:(NSString *)key callback:(XYDChatBooleanResultBlock)callback;

@end
