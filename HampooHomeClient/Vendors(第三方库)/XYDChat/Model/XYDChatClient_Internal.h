//
//  XYDChatClient_Internal.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/15.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatClient"

@interface XYDChatClient ()

+ (NSDictionary *)userOptions;
+ (dispatch_queue_t)imClientQueue;
+ (BOOL)checkErrorForSignature:(AVIMSignature *)signature command:(AVIMGenericCommand *)command;
+ (void)_assertClientIdsIsValid:(NSArray *)clientIds;

@property (nonatomic, copy)   NSString              *clientId;
@property (nonatomic, assign) AVIMClientStatus       status;
@property (nonatomic, strong) AVIMWebSocketWrapper  *socketWrapper;
@property (nonatomic, strong) NSMutableDictionary   *conversations;
@property (nonatomic, strong) NSMutableDictionary   *messages;
@property (nonatomic, strong) AVIMGenericCommand    *openCommand;
@property (nonatomic, assign) int32_t                openTimes;
@property (nonatomic, copy)   NSString              *tag;
@property (nonatomic, assign) BOOL                   onceOpened;

- (void)setStatus:(AVIMClientStatus)status;
- (AVIMConversation *)conversationWithId:(NSString *)conversationId;
- (void)sendCommand:(AVIMGenericCommand *)command;
- (AVIMSignature *)signatureWithClientId:(NSString *)clientId conversationId:(NSString *)conversationId action:(NSString *)action actionOnClientIds:(NSArray *)clientIds;
- (void)addMessage:(AVIMMessage *)message;
- (void)removeMessageById:(NSString *)messageId;
- (AVIMMessage *)messageById:(NSString *)messageId;

/*!
 * Cache conversations to memory and sqlite.
 * @param conversations Conversations to be cached.
 */
- (void)cacheConversations:(NSArray *)conversations;

- (void)cacheConversationsIfNeeded:(NSArray *)conversations;

@end
