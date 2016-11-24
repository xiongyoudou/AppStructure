//
//  XYDConversation.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/11.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDConversation.h"
#import "XYDChatClient.h"
#import "XYDChatClient_Internal.h"

#import "XYDChatMessage.h"
#import "XYDChatMessage_Internal.h"
#import "XYDChatFileMessage.h"
#import "XYDFile.h"

#import "XYDChatErrorUtil.h"

@implementation XYDConversation

- (instancetype)initWithConversationId:(NSString *)conversationId {
    if (self = [super init]) {
        self.conversationId = conversationId;
    }
    return self;
}

- (NSString *)clientId {
    return _imClient.clientId;
}

- (void)setImClient:(XYDChatClient *)imClient {
    _imClient = imClient;
}

- (void)setConversationId:(NSString *)conversationId {
    _conversationId = [conversationId copy];
}

- (void)setMembers:(NSArray *)members {
    _members = members;
}

//- (XYDChatConversationUpdateBuilder *)newUpdateBuilder {
//    XYDChatConversationUpdateBuilder *builder = [[XYDChatConversationUpdateBuilder alloc] init];
//    return builder;
//}

- (void)addMembers:(NSArray *)members {
    if (members.count > 0) {
        self.members = ({
            NSMutableOrderedSet *allMembers = [NSMutableOrderedSet orderedSetWithArray:self.members ?: @[]];
            [allMembers addObjectsFromArray:members];
            [allMembers array];
        });
    }
}

- (void)addMember:(NSString *)clientId {
    if (clientId) {
        [self addMembers:@[clientId]];
    }
}

- (void)removeMembers:(NSArray *)members {
    if (members.count > 0) {
        if (_members.count > 0) {
            NSMutableArray *array = [_members mutableCopy];
            [array removeObjectsInArray:members];
            self.members = [array copy];
        }
    }
}

- (void)removeMember:(NSString *)clientId {
    if (clientId) {
        [self removeMembers:@[clientId]];
    }
}

- (void)setCreator:(NSString *)creator {
    _creator = creator;
}

- (void)fetchWithCallback:(XYDChatBooleanResultBlock)callback {
//    XYDChatConversationQuery *query = [self.imClient conversationQuery];
//    query.cachePolicy = kXYDChatCachePolicyNetworkOnly;
//    [query getConversationById:self.conversationId callback:^(XYDConversation *conversation, NSError *error) {
//        if (conversation && conversation != self) {
//            [self setKeyedConversation:[conversation keyedConversation]];
//        }
//        [XYDChatBlockHelper callBooleanResultBlock:callback error:error];
//    }];
}

- (void)joinWithCallback:(XYDChatBooleanResultBlock)callback {
//    [self addMembersWithClientIds:@[_imClient.clientId] callback:callback];
}

- (void)addMembersWithClientIds:(NSArray *)clientIds callback:(XYDChatBooleanResultBlock)callback {
//    [[XYDChatClient class] _assertClientIdsIsValid:clientIds];
//    dispatch_async([XYDChatClient imClientQueue], ^{
//        XYDChatGenericCommand *genericCommand = [[XYDChatGenericCommand alloc] init];
//        genericCommand.needResponse = YES;
//        genericCommand.cmd = XYDChatCommandType_Conv;
//        genericCommand.peerId = _imClient.clientId;
//        genericCommand.op = XYDChatOpType_Add;
//        
//        XYDChatConvCommand *command = [[XYDChatConvCommand alloc] init];
//        command.cid = self.conversationId;
//        command.mArray = [NSMutableArray arrayWithArray:clientIds];
//        NSString  *actionString = [XYDChatCommandFormatter signatureActionForKey:genericCommand.op];
//        NSString *clientIdString = [NSString stringWithFormat:@"%@",genericCommand.peerId];
//        NSArray *clientIds = [command.mArray copy];
//        XYDChatSignature *signature = [_imClient signatureWithClientId:clientIdString conversationId:command.cid action:actionString actionOnClientIds:clientIds];
//        [genericCommand XYDChat_addRequiredKeyWithCommand:command];
//        [genericCommand XYDChat_addRequiredKeyForConvMessageWithSignature:signature];
//        if ([XYDChatClient checkErrorForSignature:signature command:genericCommand]) {
//            return;
//        }
//        [genericCommand setCallback:^(XYDChatGenericCommand *outCommand, XYDChatGenericCommand *inCommand, NSError *error) {
//            if (!error) {
//                XYDChatConvCommand *conversationOutCommand = outCommand.convMessage;
//                [self addMembers:[conversationOutCommand.mArray copy]];
//                [self removeCachedConversation];
//                [XYDChatBlockHelper callBooleanResultBlock:callback error:nil];
//            } else {
//                [XYDChatBlockHelper callBooleanResultBlock:callback error:error];
//            }
//        }];
//        
//        
//        [_imClient sendCommand:genericCommand];
//    });
}

- (void)quitWithCallback:(XYDChatBooleanResultBlock)callback {
//    [self removeMembersWithClientIds:@[_imClient.clientId] callback:callback];
}

- (void)removeMembersWithClientIds:(NSArray *)clientIds callback:(XYDChatBooleanResultBlock)callback {
//    NSString *myClientId = _imClient.clientId;
//    
//    [[XYDChatClient class] _assertClientIdsIsValid:clientIds];
//    dispatch_async([XYDChatClient imClientQueue], ^{
//        XYDChatGenericCommand *genericCommand = [[XYDChatGenericCommand alloc] init];
//        genericCommand.needResponse = YES;
//        genericCommand.cmd = XYDChatCommandType_Conv;
//        genericCommand.peerId = _imClient.clientId;
//        genericCommand.op = XYDChatOpType_Remove;
//        
//        XYDChatConvCommand *command = [[XYDChatConvCommand alloc] init];
//        command.cid = self.conversationId;
//        command.mArray = [NSMutableArray arrayWithArray:clientIds];
//        NSString *actionString = [XYDChatCommandFormatter signatureActionForKey:genericCommand.op];
//        NSString *clientIdString = [NSString stringWithFormat:@"%@",genericCommand.peerId];
//        NSArray *clientIds = [command.mArray copy];
//        
//        XYDChatSignature *signature = [_imClient signatureWithClientId:clientIdString conversationId:command.cid action:actionString actionOnClientIds:clientIds];
//        [genericCommand XYDChat_addRequiredKeyWithCommand:command];
//        [genericCommand XYDChat_addRequiredKeyForConvMessageWithSignature:signature];
//        if ([XYDChatClient checkErrorForSignature:signature command:genericCommand]) {
//            return;
//        }
//        [genericCommand setCallback:^(XYDChatGenericCommand *outCommand, XYDChatGenericCommand *inCommand, NSError *error) {
//            if (!error) {
//                XYDChatConvCommand *conversationOutCommand = outCommand.convMessage;
//                [self removeMembers:[conversationOutCommand.mArray copy]];
//                [self removeCachedConversation];
//                if ([clientIds containsObject:myClientId]) {
//                    [self removeCachedMessages];
//                }
//                
//                [XYDChatBlockHelper callBooleanResultBlock:callback error:nil];
//            } else {
//                [XYDChatBlockHelper callBooleanResultBlock:callback error:error];
//            }
//        }];
//        
//        [_imClient sendCommand:genericCommand];
//    });
}

- (void)countMembersWithCallback:(XYDChatIntegerResultBlock)callback {
//    dispatch_async([XYDChatClient imClientQueue], ^{
//        XYDChatGenericCommand *genericCommand = [[XYDChatGenericCommand alloc] init];
//        genericCommand.needResponse = YES;
//        genericCommand.cmd = XYDChatCommandType_Conv;
//        genericCommand.peerId = _imClient.clientId;
//        genericCommand.op = XYDChatOpType_Count;
//        
//        XYDChatConvCommand *command = [[XYDChatConvCommand alloc] init];
//        command.cid = self.conversationId;
//        
//        [genericCommand XYDChat_addRequiredKeyWithCommand:command];
//        [genericCommand setCallback:^(XYDChatGenericCommand *outCommand, XYDChatGenericCommand *inCommand, NSError *error) {
//            if (!error) {
//                XYDChatConvCommand *conversationInCommand = inCommand.convMessage;
//                [XYDChatBlockHelper callIntegerResultBlock:callback number:conversationInCommand.count error:nil];
//            } else {
//                [XYDChatBlockHelper callIntegerResultBlock:callback number:0 error:nil];
//            }
//        }];
//        [_imClient sendCommand:genericCommand];
//    });
}

- (void)update:(NSDictionary *)updateDict callback:(XYDChatBooleanResultBlock)callback {
//    dispatch_async([XYDChatClient imClientQueue], ^{
//        NSDictionary *attr = updateDict;
//        XYDChatGenericCommand *genericCommand = [[XYDChatGenericCommand alloc] init];
//        genericCommand.needResponse = YES;
//        genericCommand.cmd = XYDChatCommandType_Conv;
//        genericCommand.peerId = self.imClient.clientId;
//        
//        XYDChatConvCommand *convCommand = [[XYDChatConvCommand alloc] init];
//        convCommand.cid = self.conversationId;
//        genericCommand.op = XYDChatOpType_Update;
//        convCommand.attr = [XYDChatCommandFormatter JSONObjectWithDictionary:[attr copy]];
//        [genericCommand XYDChat_addRequiredKeyWithCommand:convCommand];
//        [genericCommand setCallback:^(XYDChatGenericCommand *outCommand, XYDChatGenericCommand *inCommand, NSError *error) {
//            if (!error) {
//                XYDChatConvCommand *conversationOutcCommand = outCommand.convMessage;
//                
//                NSData *data = [XYDChatCommandFormatter dataWithJSONObject:conversationOutcCommand.attr];
//                NSDictionary *attr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//                NSString *name = [attr objectForKey:KEY_NAME];
//                NSDictionary *attrs = [attr objectForKey:KEY_ATTR];
//                if (name) {
//                    self.name = name;
//                }
//                if (attrs) {
//                    NSMutableDictionary *attributes = [self.attributes mutableCopy];
//                    if (!attributes) {
//                        attributes = [[NSMutableDictionary alloc] init];
//                    }
//                    [attributes addEntriesFromDictionary:attrs];
//                    self.attributes = attributes;
//                }
//                [self removeCachedConversation];
//            }
//            [XYDChatBlockHelper callBooleanResultBlock:callback error:error];
//        }];
//        [_imClient sendCommand:genericCommand];
//    });
    
}

- (void)muteWithCallback:(XYDChatBooleanResultBlock)callback {
//    dispatch_async([XYDChatClient imClientQueue], ^{
//        XYDChatGenericCommand *genericCommand = [[XYDChatGenericCommand alloc] init];
//        genericCommand.needResponse = YES;
//        genericCommand.cmd = XYDChatCommandType_Conv;
//        genericCommand.peerId = _imClient.clientId;
//        genericCommand.op = XYDChatOpType_Mute;
//        
//        XYDChatConvCommand *convCommand = [[XYDChatConvCommand alloc] init];
//        convCommand.cid = self.conversationId;
//        [genericCommand XYDChat_addRequiredKeyWithCommand:convCommand];
//        [genericCommand setCallback:^(XYDChatGenericCommand *outCommand, XYDChatGenericCommand *inCommand, NSError *error) {
//            if (!error) {
//                self.muted = YES;
//                [self removeCachedConversation];
//                [XYDChatBlockHelper callBooleanResultBlock:callback error:nil];
//            } else {
//                [XYDChatBlockHelper callBooleanResultBlock:callback error:error];
//            }
//        }];
//        [_imClient sendCommand:genericCommand];
//    });
}

- (void)unmuteWithCallback:(XYDChatBooleanResultBlock)callback {
//    dispatch_async([XYDChatClient imClientQueue], ^{
//        XYDChatGenericCommand *genericCommand = [[XYDChatGenericCommand alloc] init];
//        genericCommand.needResponse = YES;
//        genericCommand.cmd = XYDChatCommandType_Conv;
//        genericCommand.peerId = _imClient.clientId;
//        genericCommand.op = XYDChatOpType_Unmute;
//        
//        XYDChatConvCommand *convCommand = [[XYDChatConvCommand alloc] init];
//        convCommand.cid = self.conversationId;
//        [genericCommand XYDChat_addRequiredKeyWithCommand:convCommand];
//        [genericCommand setCallback:^(XYDChatGenericCommand *outCommand, XYDChatGenericCommand *inCommand, NSError *error) {
//            if (!error) {
//                self.muted = NO;
//                [self removeCachedConversation];
//                [XYDChatBlockHelper callBooleanResultBlock:callback error:nil];
//            } else {
//                [XYDChatBlockHelper callBooleanResultBlock:callback error:error];
//            }
//        }];
//        [_imClient sendCommand:genericCommand];
//    });
}

- (void)markAsReadInBackground {
//    __weak typeof(self) ws = self;
//    
//    dispatch_async([XYDChatClient imClientQueue], ^{
//        [ws.imClient sendCommand:({
//            XYDChatGenericCommand *genericCommand = [[XYDChatGenericCommand alloc] init];
//            genericCommand.needResponse = YES;
//            genericCommand.cmd = XYDChatCommandType_Read;
//            genericCommand.peerId = ws.imClient.clientId;
//            
//            XYDChatReadCommand *readCommand = [[XYDChatReadCommand alloc] init];
//            readCommand.cid = ws.conversationId;
//            [genericCommand XYDChat_addRequiredKeyWithCommand:readCommand];
//            genericCommand;
//        })];
//    });
}

- (void)sendMessage:(XYDChatMessage *)message
           callback:(XYDChatBooleanResultBlock)callback
{
    [self sendMessage:message option:nil callback:callback];
}

- (void)sendMessage:(XYDChatMessage *)message
             option:(XYDChatMessageOption *)option
           callback:(XYDChatBooleanResultBlock)callback
{
    [self sendMessage:message option:option progressBlock:nil callback:callback];
}

- (void)sendMessage:(XYDChatMessage *)message
      progressBlock:(XYDChatProgressBlock)progressBlock
           callback:(XYDChatBooleanResultBlock)callback
{
    [self sendMessage:message option:nil progressBlock:progressBlock callback:callback];
}

- (void)sendMessage:(XYDChatMessage *)message
             option:(XYDChatMessageOption *)option
      progressBlock:(XYDChatProgressBlock)progressBlock
           callback:(XYDChatBooleanResultBlock)callback
{
//    message.clientId = _imClient.clientId;
    message.conversationId = _conversationId;
    if (self.imClient.status != XYDChatClientStatusOpened) {
        message.status = XYDChatMessageStatusFailed;
        NSError *error = [XYDChatErrorUtil errorWithCode:kXYDChatErrorClientNotOpen reason:@"You can only send message when the status of the client is opened."];
        if (callback)callback(error == nil,error);
        return;
    }
    message.status = XYDChatMessageStatusSending;
    
    XYDFile *file = nil;
    if (message.mediaType == XYDChatMessageMediaTypeFile) {
        file = [(XYDChatFileMessage *)message file];
        if (!file) {
            NSString *attachedFilePath = [(XYDChatFileMessage *)message attachedFilePath];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:attachedFilePath]) {
                NSError *error = [NSError fileNotFoundError];
                if (callback)callback(error == nil,error);
                return;
            }
            NSString *name = [attachedFilePath lastPathComponent];
            file = [XYDFile fileWithName:name contentsAtPath:attachedFilePath];
        }
        
        
    }
    if (file) {
        // 文件是否已上传
        if ([file isDirty]) {
            /* File need to be uploaded */
            // 先上传文件
            [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [self sendRealMessage:message option:option callback:callback];
                } else {
                    message.status = XYDChatMessageStatusFailed;
                    if (callback)callback(error == nil,error);
                }
            } progressBlock:progressBlock];
        } else {
            [self sendRealMessage:message option:option callback:callback];
        }
    }else {
        [self sendRealMessage:message option:option callback:callback];
    }
}

// 开始准备发送消息
- (void)sendRealMessage:(XYDChatMessage *)message option:(XYDChatMessageOption *)option callback:(XYDChatBooleanResultBlock)callback {
   
}

#pragma mark -

- (NSArray *)takeContinuousMessages:(NSArray *)messages {
    NSMutableArray *continuousMessages = [NSMutableArray array];
    
//    for (XYDChatMessage *message in messages.reverseObjectEnumerator) {
//        if (!message.breakpoint) {
//            [continuousMessages insertObject:message atIndex:0];
//        } else {
//            break;
//        }
//    }
//    
//    return continuousMessages;
    return nil;
}
//
//- (LCIMMessageCache *)messageCache {
//    NSString *clientId = self.clientId;
//    
//    return clientId ? [LCIMMessageCache cacheWithClientId:clientId] : nil;
//}

//- (LCIMMessageCacheStore *)messageCacheStore {
//    NSString *clientId = self.clientId;
//    NSString *conversationId = self.conversationId;
//    
//    return clientId && conversationId ? [[LCIMMessageCacheStore alloc] initWithClientId:clientId conversationId:conversationId] : nil;
//}
//
//- (LCIMConversationCache *)conversationCache {
//    NSString *clientId = self.clientId;
//    
//    return clientId ? [[LCIMConversationCache alloc] initWithClientId:clientId] : nil;
//}

- (void)cacheContinuousMessages:(NSArray *)messages {
//    [self cacheContinuousMessages:messages withBreakpoint:YES];
}

- (void)cacheContinuousMessages:(NSArray *)messages plusMessage:(XYDChatMessage *)message {
    NSMutableArray *cachedMessages = [NSMutableArray array];
    
    if (messages) [cachedMessages addObjectsFromArray:messages];
    if (message)  [cachedMessages addObject:message];
    
//    [self cacheContinuousMessages:cachedMessages withBreakpoint:YES];
}

- (void)cacheContinuousMessages:(NSArray *)messages withBreakpoint:(BOOL)breakpoint {
    if (breakpoint) {
//        [[self messageCache] addContinuousMessages:messages forConversationId:self.conversationId];
//    } else {
//        [[self messageCacheStore] insertMessages:messages];
    }
}

//- (void)removeCachedConversation {
//    [[self conversationCache] removeConversationForId:self.conversationId];
//}

//- (void)removeCachedMessages {
//    [[self messageCacheStore] cleanCache];
//}

#pragma mark - Message Query

- (void)sendACKIfNeeded:(NSArray *)messages {
//    NSDictionary *userOptions = [XYDChatClient userOptions];
//    BOOL useUnread = [userOptions[XYDChatUserOptionUseUnread] boolValue];
//    
//    if (useUnread) {
//        XYDChatClient *client = self.imClient;
//        XYDChatGenericCommand *genericCommand = [[XYDChatGenericCommand alloc] init];
//        genericCommand.cmd = XYDChatCommandType_Ack;
//        genericCommand.needResponse = YES;
//        genericCommand.peerId = client.clientId;
//        
//        XYDChatAckCommand *ackOutCommand = [[XYDChatAckCommand alloc] init];
//        ackOutCommand.cid = self.conversationId;
//        int64_t fromts = [[messages firstObject] sendTimestamp];
//        int64_t tots   = [[messages lastObject] sendTimestamp];
//        ackOutCommand.fromts = MIN(fromts, tots);
//        ackOutCommand.tots   = MAX(fromts, tots);
//        [genericCommand XYDChat_addRequiredKeyWithCommand:ackOutCommand];
//        [client sendCommand:genericCommand];
//    }
}

//- (void)queryMessagesFromServerWithCommand:(XYDChatGenericCommand *)genericCommand
//                                  callback:(XYDChatArrayResultBlock)callback
//{
//    XYDChatLogsCommand *logsOutCommand = genericCommand.logsMessage;
//    dispatch_async([XYDChatClient imClientQueue], ^{
//        [genericCommand setCallback:^(XYDChatGenericCommand *outCommand, XYDChatGenericCommand *inCommand, NSError *error) {
//            if (!error) {
//                XYDChatLogsCommand *logsInCommand = inCommand.logsMessage;
//                XYDChatLogsCommand *logsOutCommand = outCommand.logsMessage;
//                NSArray *logs = [logsInCommand.logsArray copy];
//                NSMutableArray *messages = [[NSMutableArray alloc] init];
//                for (XYDChatLogItem *logsItem in logs) {
//                    XYDChatMessage *message = nil;
//                    id data = [logsItem data_p];
//                    if (![data isKindOfClass:[NSString class]]) {
//                        XYDChatLoggerError(XYDChatOSCloudIMErrorDomain, @"Received an invalid message.");
//                        continue;
//                    }
//                    XYDChatMessageObject *messageObject = [[XYDChatMessageObject alloc] initWithJSON:data];
//                    if ([messageObject isValidTypedMessageObject]) {
//                        XYDChatMessage *m = [XYDChatMessage messageWithMessageObject:messageObject];
//                        message = m;
//                    } else {
//                        XYDChatMessage *m = [[XYDChatMessage alloc] init];
//                        m.content = data;
//                        message = m;
//                    }
//                    message.conversationId = logsOutCommand.cid;
//                    message.sendTimestamp = [logsItem timestamp];
//                    message.clientId = [logsItem from];
//                    message.messageId = [logsItem msgId];
//                    [messages addObject:message];
//                }
//                
//                [self postprocessMessages:messages];
//                [self sendACKIfNeeded:messages];
//                
//                [XYDChatBlockHelper callArrayResultBlock:callback array:messages error:nil];
//            } else {
//                [XYDChatBlockHelper callArrayResultBlock:callback array:nil error:error];
//            }
//        }];
//        [genericCommand XYDChat_addRequiredKeyWithCommand:logsOutCommand];
//        [_imClient sendCommand:genericCommand];
//    });
//}

- (void)queryMessagesFromServerBeforeId:(NSString *)messageId
                              timestamp:(int64_t)timestamp
                                  limit:(NSUInteger)limit
                               callback:(XYDChatArrayResultBlock)callback
{
//    XYDChatGenericCommand *genericCommand = [[XYDChatGenericCommand alloc] init];
//    genericCommand.needResponse = YES;
//    genericCommand.cmd = XYDChatCommandType_Logs;
//    genericCommand.peerId = _imClient.clientId;
//    
//    XYDChatLogsCommand *logsCommand = [[XYDChatLogsCommand alloc] init];
//    logsCommand.cid    = _conversationId;
//    logsCommand.mid    = messageId;
//    logsCommand.t      = LCIM_VALID_TIMESTAMP(timestamp);
//    logsCommand.l      = LCIM_VALID_LIMIT(limit);
//    
//    [genericCommand XYDChat_addRequiredKeyWithCommand:logsCommand];
//    [self queryMessagesFromServerWithCommand:genericCommand callback:callback];
}

- (void)queryMessagesFromServerBeforeId:(NSString *)messageId
                              timestamp:(int64_t)timestamp
                            toMessageId:(NSString *)toMessageId
                            toTimestamp:(int64_t)toTimestamp
                                  limit:(NSUInteger)limit
                               callback:(XYDChatArrayResultBlock)callback
{
//    XYDChatGenericCommand *genericCommand = [[XYDChatGenericCommand alloc] init];
//    XYDChatLogsCommand *logsCommand = [[XYDChatLogsCommand alloc] init];
//    genericCommand.needResponse = YES;
//    genericCommand.cmd = XYDChatCommandType_Logs;
//    genericCommand.peerId = _imClient.clientId;
//    logsCommand.cid    = _conversationId;
//    logsCommand.mid    = messageId;
//    logsCommand.tmid   = toMessageId;
//    logsCommand.tt     = MAX(toTimestamp, 0);
//    logsCommand.t      = MAX(timestamp, 0);
//    logsCommand.l      = LCIM_VALID_LIMIT(limit);
//    [genericCommand XYDChat_addRequiredKeyWithCommand:logsCommand];
//    [self queryMessagesFromServerWithCommand:genericCommand callback:callback];
}

- (void)queryMessagesFromServerWithLimit:(NSUInteger)limit
                                callback:(XYDChatArrayResultBlock)callback
{
//    limit = LCIM_VALID_LIMIT(limit);
//    
//    [self queryMessagesFromServerBeforeId:nil
//                                timestamp:LCIM_DISTANT_FUTURE_TIMESTAMP
//                                    limit:limit
//                                 callback:^(NSArray *messages, NSError *error)
//     {
//         if (self.imClient.messageQueryCacheEnabled) {
//             [self cacheContinuousMessages:messages];
//         }
//         [XYDChatBlockHelper callArrayResultBlock:callback array:messages error:error];
//     }];
}

- (NSArray *)queryMessagesFromCacheWithLimit:(NSUInteger)limit {
//    limit = LCIM_VALID_LIMIT(limit);
//    NSArray *cachedMessages = [[self messageCacheStore] latestMessagesWithLimit:limit];
//    [self postprocessMessages:cachedMessages];
//    
//    return cachedMessages;
    return nil;
}

- (void)queryMessagesWithLimit:(NSUInteger)limit
                      callback:(XYDChatArrayResultBlock)callback
{
//    limit = LCIM_VALID_LIMIT(limit);
//    
//    BOOL socketOpened = self.imClient.status == XYDChatClientStatusOpened;
//    // 如果屏蔽了本地缓存则全部走网络
//    if (!self.imClient.messageQueryCacheEnabled) {
//        if (!socketOpened) {
//            NSError *error = [XYDChatErrorUtil errorWithCode:kXYDChatErrorClientNotOpen reason:@"Client not open when query messages from server."];
//            [XYDChatBlockHelper callArrayResultBlock:callback array:nil error:error];
//            return;
//        }
//        [self queryMessagesFromServerWithLimit:limit callback:callback];
//        return;
//    }
//    if (socketOpened) {
//        /* If connection is open, query messages from server */
//        [self queryMessagesFromServerBeforeId:nil
//                                    timestamp:LCIM_DISTANT_FUTURE_TIMESTAMP
//                                  toMessageId:nil
//                                  toTimestamp:0
//                                        limit:limit
//                                     callback:^(NSArray *messages, NSError *error)
//         {
//             if (!error) {
//                 /* Everything is OK, we cache messages and return */
//                 BOOL truncated = [messages count] < limit;
//                 [self cacheContinuousMessages:messages withBreakpoint:!truncated];
//                 
//                 NSArray *cachedMessages = [self queryMessagesFromCacheWithLimit:limit];
//                 [XYDChatBlockHelper callArrayResultBlock:callback array:cachedMessages error:nil];
//             } else if ([error.domain isEqualToString:NSURLErrorDomain]) {
//                 /* If network has an error, fallback to query from cache */
//                 NSArray *messages = [self queryMessagesFromCacheWithLimit:limit];
//                 [XYDChatBlockHelper callArrayResultBlock:callback array:messages error:nil];
//             } else {
//                 /* If error is not network relevant, return it */
//                 [XYDChatBlockHelper callArrayResultBlock:callback array:messages error:error];
//             }
//         }];
//    } else {
//        /* Otherwise, query messages from cache */
//        NSArray *messages = [self queryMessagesFromCacheWithLimit:limit];
//        [XYDChatBlockHelper callArrayResultBlock:callback array:messages error:nil];
//    }
}

- (void)queryMessagesBeforeId:(NSString *)messageId
                    timestamp:(int64_t)timestamp
                        limit:(NSUInteger)limit
                     callback:(XYDChatArrayResultBlock)callback
{
//    limit     = LCIM_VALID_LIMIT(limit);
//    timestamp = LCIM_VALID_TIMESTAMP(timestamp);
//    /*
//     * Firstly,if message query cache is not enabled,just forward query request.
//     */
//    if (!self.imClient.messageQueryCacheEnabled) {
//        [self queryMessagesFromServerBeforeId:messageId
//                                    timestamp:timestamp
//                                        limit:limit
//                                     callback:^(NSArray *messages, NSError *error)
//         {
//             [XYDChatBlockHelper callArrayResultBlock:callback array:messages error:error];
//         }];
//        return;
//    }
//    /*
//     * Secondly,if message query cache is enabled, fetch message from cache.
//     */
//    BOOL continuous = YES;
//    LCIMMessageCache *cache = [self messageCache];
//    LCIMMessageCacheStore *cacheStore = [self messageCacheStore];
//    XYDChatMessage *fromMessage = [cacheStore messageForId:messageId];
//    NSArray *cachedMessages = [cache messagesBeforeTimestamp:timestamp
//                                                   messageId:messageId
//                                              conversationId:self.conversationId
//                                                       limit:limit
//                                                  continuous:&continuous];
//    
//    [self postprocessMessages:cachedMessages];
//    
//    /*
//     * If message is continuous or socket connect is not opened, return fetched messages directly.
//     */
//    BOOL socketOpened = self.imClient.status == XYDChatClientStatusOpened;
//    
//    if ((continuous && [cachedMessages count] == limit) || !socketOpened) {
//        [XYDChatBlockHelper callArrayResultBlock:callback array:cachedMessages error:nil];
//        return;
//    }
//    
//    /*
//     * If cached messages exist, only fetch the rest uncontinuous messages.
//     */
//    if ([cachedMessages count] > 0) {
//        NSArray *continuousMessages = [self takeContinuousMessages:cachedMessages];
//        
//        BOOL hasContinuous = [continuousMessages count] > 0;
//        
//        /*
//         * Then, fetch rest of messages from remote server.
//         */
//        NSUInteger restCount = 0;
//        XYDChatMessage *startMessage = nil;
//        
//        if (hasContinuous) {
//            restCount = limit - [continuousMessages count];
//            startMessage = [continuousMessages firstObject];
//        } else {
//            restCount = limit;
//            XYDChatMessage *last = [cachedMessages lastObject];
//            startMessage = [cache nextMessageForMessage:last
//                                         conversationId:self.conversationId];
//        }
//        
//        /*
//         * If start message not nil, query messages before it.
//         */
//        if (startMessage) {
//            [self queryMessagesFromServerBeforeId:startMessage.messageId
//                                        timestamp:startMessage.sendTimestamp
//                                            limit:restCount
//                                         callback:^(NSArray *messages, NSError *error)
//             {
//                 if (!messages) {
//                     messages = @[];
//                 }
//                 
//                 NSMutableArray *fetchedMessages = [NSMutableArray arrayWithArray:messages];
//                 
//                 if (hasContinuous) {
//                     [fetchedMessages addObjectsFromArray:continuousMessages];
//                 }
//                 
//                 [self cacheContinuousMessages:fetchedMessages plusMessage:fromMessage];
//                 [XYDChatBlockHelper callArrayResultBlock:callback array:fetchedMessages error:nil];
//             }];
//        } else {
//            /*
//             * Otherwise, just forward query request.
//             */
//            [self queryMessagesFromServerBeforeId:messageId
//                                        timestamp:timestamp
//                                            limit:limit
//                                         callback:^(NSArray *messages, NSError *error)
//             {
//                 [self cacheContinuousMessages:messages plusMessage:fromMessage];
//                 [XYDChatBlockHelper callArrayResultBlock:callback array:messages error:error];
//             }];
//        }
//    } else {
//        /*
//         * Otherwise, just forward query request.
//         */
//        [self queryMessagesFromServerBeforeId:messageId
//                                    timestamp:timestamp
//                                        limit:limit
//                                     callback:^(NSArray *messages, NSError *error)
//         {
//             [self cacheContinuousMessages:messages plusMessage:fromMessage];
//             [XYDChatBlockHelper callArrayResultBlock:callback array:messages error:error];
//         }];
//    }
}

//- (void)postprocessMessages:(NSArray *)messages {
//    for (XYDChatMessage *message in messages) {
//        message.status = XYDChatMessageStatusSent;
//        message.localClientId = self.imClient.clientId;
//    }
//}
//
//#pragma mark - Keyed Conversation
//
- (XYDArchivedConversation *)keyedConversation {
//    XYDChatKeyedConversation *keyedConversation = [[XYDChatKeyedConversation alloc] init];
//    
//    keyedConversation.conversationId = self.conversationId;
//    keyedConversation.clientId       = self.imClient.clientId;
//    keyedConversation.creator        = self.creator;
//    keyedConversation.createAt       = self.createAt;
//    keyedConversation.updateAt       = self.updateAt;
//    keyedConversation.lastMessageAt  = self.lastMessageAt;
//    keyedConversation.name           = self.name;
//    keyedConversation.members        = self.members;
//    keyedConversation.attributes     = self.attributes;
//    keyedConversation.transient      = self.transient;
//    keyedConversation.muted          = self.muted;
//    
//    return keyedConversation;
    return nil;
}

- (void)setKeyedConversation:(XYDArchivedConversation *)keyedConversation {
//    self.conversationId    = keyedConversation.conversationId;
//    self.creator           = keyedConversation.creator;
//    self.createAt          = keyedConversation.createAt;
//    self.updateAt          = keyedConversation.updateAt;
//    self.lastMessageAt     = keyedConversation.lastMessageAt;
//    self.name              = keyedConversation.name;
//    self.members           = keyedConversation.members;
//    self.attributes        = keyedConversation.attributes;
//    self.transient         = keyedConversation.transient;
//    self.muted             = keyedConversation.muted;
}


@end
