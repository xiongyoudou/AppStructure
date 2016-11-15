//
//  XYDConversation_Internal.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/15.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDConversation.h"
@class XYDArchivedConversation;

#define KEY_NAME @"name"
#define KEY_ATTR @"attr"
#define KEY_TIMESTAMP @"timestamp"
#define KEY_DATA @"data"
#define KEY_FROM @"from"
#define KEY_MSGID @"msgId"

@interface XYDConversation ()

@property(nonatomic, copy)   NSString     *name;            // 对话名字
@property(nonatomic, strong) NSDate       *createAt;        // 创建时间
@property(nonatomic, strong) NSDate       *updateAt;        // 最后更新时间
@property(nonatomic, strong) NSDate       *lastMessageAt;   // 对话中最后一条消息的发送时间
@property(nonatomic, strong) NSDictionary *attributes;      // 自定义属性
@property(nonatomic, assign) BOOL          muted;           // 静音状态
@property(nonatomic, assign) BOOL          transient;       // 是否为临时会话（开放群组）

//@property(nonatomic, strong)AVIMConversationUpdateBuilder *updateBuilder;
- (instancetype)initWithConversationId:(NSString *)conversationId;
- (void)setConversationId:(NSString *)conversationId;
- (void)setMembers:(NSArray *)members;
- (void)setCreator:(NSString *)creator;
//- (void)setImClient:(AVIMClient *)imClient;
- (void)addMembers:(NSArray *)members;
- (void)addMember:(NSString *)clientId;
- (void)removeMembers:(NSArray *)members;
- (void)removeMember:(NSString *)clientId;

- (void)setKeyedConversation:(XYDArchivedConversation *)keyedConversation;

@end
