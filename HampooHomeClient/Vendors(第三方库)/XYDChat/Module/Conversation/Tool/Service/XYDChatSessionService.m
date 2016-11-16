//
//  XYDChatSessionService.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/10.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatSessionService.h"
#import "XYDConversationService.h"
#import "XYDChatKit.h"
#import "NSObject+XYDisFirstLaunch.h"
#import "XYDChatClientOpenOption.h"
#import "XYDChatSettingService.h"
#import "XYDChatUIService.h"
#import "XYDSoundManager.h"

NSString *const XYDChatSessionServiceErrorDomain = @"XYDChatSessionServiceErrorDomain";

@interface XYDChatSessionService ()<XYDChatClientDelegate,XYDChatSignatureDataSource>

@property (nonatomic, assign, readwrite) BOOL connect;
@property (nonatomic, assign, getter=isPlayingSound) BOOL playingSound;
@property (nonatomic, assign, getter=isRequestingSingleSignOn) BOOL requestingSingleSignOn;

@end

@implementation XYDChatSessionService
@synthesize clientId = _clientId;
@synthesize client = _client;
@synthesize forceReconnectSessionBlock = _forceReconnectSessionBlock;
@synthesize disableSingleSignOn = _disableSingleSignOn;

- (void)openWithClientId:(NSString *)clientId callback:(XYDChatBooleanResultBlock)callback {
    [self openWithClientId:clientId force:YES callback:callback];
}

- (void)openWithClientId:(NSString *)clientId force:(BOOL)force callback:(XYDChatBooleanResultBlock)callback {
    if ([clientId xyd_isSpace]) {
        NSInteger code = 0;
        NSString *errorReasonText = @"clientId not valid";
        NSDictionary *errorInfo = @{
                                    @"code":@(code),
                                    NSLocalizedDescriptionKey : errorReasonText,
                                    };
        NSError *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                             code:code
                                         userInfo:errorInfo];
        
        !callback ?: callback(NO, error);
        return;
    }
    [self openSevice];
    _clientId = clientId;
    [[XYDConversationService sharedInstance] setupDatabaseWithUserId:_clientId];
    //判断是否是第一次使用该appId
    [[XYDChatKit sharedInstance] xyd_isFirstLaunchToEvent:[XYDChatKit sharedInstance].appId
                                               evenUpdate:YES
                                              firstLaunch:^BOOL(){
                                                  return [[XYDChatKit sharedInstance] removeAllCachedRecentConversations];
                                              }];
    //    [[CDFailedMessageStore store] setupStoreWithDatabasePath:dbPath];
    NSString *tag;
    if (!self.disableSingleSignOn) {
        tag = clientId;
    }
    _client = [[XYDChatClient alloc] initWithClientId:clientId tag:tag];
    _client.delegate = self;
    /* 实现了generateSignatureBlock，将对 im 的 open , start(create conv), kick, invite 操作签名，更安全.
     可以从你的服务器获得签名，也可以部署云代码获取 https://leancloud.cn/docs/leanengine_overview.html .
     */
//    if ([[XYDChatKit sharedInstance] generateSignatureBlock]) {
//        _client.signatureDataSource = self;
//    }
    XYDChatClientOpenOption *option = [XYDChatClientOpenOption new];
    option.force = force;
    [_client openWithOption:option callback:^(BOOL succeeded, NSError *error) {
        [self updateConnectStatus];
        !callback ?: callback(succeeded, error);
        if (error.code == 4111) {
            [self handleSingleSignOnError:error callback:^(BOOL succeeded, NSError *error) {
                !callback ?: callback(succeeded, error);
            }];
        }
    }];
}

- (void)closeWithCallback:(XYDChatBooleanResultBlock)callback {
    [_client closeWithCallback:^(BOOL succeeded, NSError *error) {
        !callback ?: callback(succeeded, error);
        if (succeeded) {
            [self closeService];
        }
    }];
}

- (void)openSevice {
//    [XYDChatConversationListService sharedInstance];
    [XYDConversationService sharedInstance];
    [XYDChatSessionService sharedInstance];
    [XYDChatSettingService sharedInstance];
//    [XYDChatSignatureService sharedInstance];
    [XYDChatUIService sharedInstance];
//    [XYDChatUserSystemService sharedInstance];
}

- (void)closeService {
    [XYDSingleton destroyAllInstance];
}

- (void)setForceReconnectSessionBlock:(XYDChatForceReconnectSessionBlock)forceReconnectSessionBlock {
    _forceReconnectSessionBlock = forceReconnectSessionBlock;
}

- (void)reconnectForViewController:(UIViewController *)viewController callback:(XYDChatBooleanResultBlock)aCallback {
    [self reconnectForViewController:viewController error:nil granted:YES callback:aCallback];
}

- (void)reconnectForViewController:(UIViewController *)viewController error:(NSError *)aError granted:(BOOL)granted callback:(XYDChatBooleanResultBlock)aCallback {
//    XYDChatForceReconnectSessionBlock forceReconnectSessionBlock = _forceReconnectSessionBlock;
//    XYDChatBooleanResultBlock completionHandler = ^(BOOL succeeded, NSError *error) {
//        XYDChatHUDActionBlock HUDActionBlock = [XYDChatUIService sharedInstance].HUDActionBlock;
//        !HUDActionBlock ?: HUDActionBlock(viewController, viewController.view, nil, XYDChatMessageHUDActionTypeHide);
//        if (succeeded) {
//            !HUDActionBlock ?: HUDActionBlock(viewController, viewController.view, XYDChatLocalizedStrings(@"connectSucceeded"), XYDChatMessageHUDActionTypeSuccess);
//        } else {
//            !HUDActionBlock ?: HUDActionBlock(viewController, viewController.view, XYDChatLocalizedStrings(@"connectFailed"), XYDChatMessageHUDActionTypeError);
//            XYDChatLog(@"%@", error.description);
//        }
//        !aCallback ?: aCallback(succeeded, error);
//    };
//    !forceReconnectSessionBlock ?: forceReconnectSessionBlock(aError, granted, viewController, completionHandler);
}

#pragma mark - XYDChatClientDelegate

- (void)imClientPaused:(XYDChatClient *)imClient {
    [self updateConnectStatus];
}

- (void)imClientResuming:(XYDChatClient *)imClient {
    [self updateConnectStatus];
}

- (void)imClientResumed:(XYDChatClient *)imClient {
    [self updateConnectStatus];
}

- (void)handleSingleSignOnError:(NSError *)aError callback:(XYDChatBooleanResultBlock)aCallback {
    if (aError.code == 4111) {
        [self requestForceSingleSignOnAuthorizationWithCallback:^(BOOL granted, NSError *theError) {
            [self reconnectForViewController:nil error:aError granted:granted callback:aCallback];
        }];
    }
}

- (void)client:(XYDChatClient *)client didOfflineWithError:(NSError *)aError {
    [self handleSingleSignOnError:aError callback:nil];
}

- (void)requestForceSingleSignOnAuthorizationWithCallback:(XYDChatRequestAuthorizationBoolResultBlock)callback {
    if (self.isRequestingSingleSignOn) {
        return;
    }
//    self.requestingSingleSignOn = YES;
//    NSString *title = XYDChatLocalizedStrings(@"requestForceSingleSignOnAuthorization");
//    XYDChatAlertController *alert = [XYDChatAlertController alertControllerWithTitle:title
//                                                                       message:@""
//                                                                preferredStyle:XYDChatAlertControllerStyleAlert];
//    NSString *cancelActionTitle = XYDChatLocalizedStrings(@"cancel") ?: @"取消";
//    XYDChatAlertAction* cancelAction = [XYDChatAlertAction actionWithTitle:cancelActionTitle style:XYDChatAlertActionStyleDefault
//                                                             handler:^(XYDChatAlertAction * action) {
//                                                                 NSInteger code = 0;
//                                                                 NSString *errorReasonText = @"request force single sign on failed";
//                                                                 NSDictionary *errorInfo = @{
//                                                                                             @"code":@(code),
//                                                                                             NSLocalizedDescriptionKey : errorReasonText,
//                                                                                             };
//                                                                 NSError *error = [NSError errorWithDomain:XYDChatSessionServiceErrorDomain
//                                                                                                      code:code
//                                                                                                  userInfo:errorInfo];
//                                                                 !callback ?: callback(NO, error);
//                                                                 self.requestingSingleSignOn = NO;
//                                                             }];
//    [alert addAction:cancelAction];
//    
//    NSString *forceOpenActionTitle = XYDChatLocalizedStrings(@"ok") ?: @"确认";
//    XYDChatAlertAction *forceOpenAction = [XYDChatAlertAction actionWithTitle:forceOpenActionTitle style:XYDChatAlertActionStyleDefault
//                                                                handler:^(XYDChatAlertAction * action) {
//                                                                    !callback ?: callback(YES, nil);
//                                                                    self.requestingSingleSignOn = NO;
//                                                                }];
//    [alert addAction:forceOpenAction];
//    [alert showWithSender:nil controller:nil animated:YES completion:NULL];
}

#pragma mark - status

// 除了 sdk 的上面三个回调调用了，还在 open client 的时候调用了，好统一处理
- (void)updateConnectStatus {
    self.connect = _client.status == XYDChatClientStatusOpened;
    [[NSNotificationCenter defaultCenter] postNotificationName:XYDChatNotificationConnectivityUpdated object:@(self.connect)];
}

#pragma mark - signature

- (XYDChatSignature *)signatureWithClientId:(NSString *)clientId
                          conversationId:(NSString *)conversationId
                                  action:(NSString *)action
                       actionOnClientIds:(NSArray *)clientIds {
    __block XYDChatSignature *signature_;
//    XYDChatGenerateSignatureBlock generateSignatureBlock = [[LCChatKit sharedInstance] generateSignatureBlock];
//    XYDChatGenerateSignatureCompletionHandler completionHandler = ^(XYDChatSignature *signature, NSError *error) {
//        if (!error) {
//            signature_ = signature;
//        } else {
//            NSLog(@"%@",error);
//        }
//    };
//    generateSignatureBlock(clientId, conversationId, action, clientIds, completionHandler);
//    return signature_;
    return nil;
}

#pragma mark - XYDChatMessageDelegate

/*!
 * 低版本如果不支持某自定义消息，该自定义消息会走该代理
 */
- (void)conversation:(XYDConversation *)conversation didReceiveCommonMessage:(XYDChatMessage *)message {
//    XYDChatMessage *typedMessage = [message XYDChat_getValidTypedMessage];
//    [self conversation:conversation didReceiveTypedMessage:typedMessage];
}

- (void)conversation:(XYDConversation *)conversation didReceiveTypedMessage:(XYDChatMessage *)message {
//    if (!message.messageId) {
//        XYDChatLog(@"🔴类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), @"Receive Message , but MessageId is nil");
//        return;
//    }
//    void (^fetchedConversationCallback)() = ^() {
//        [self receiveMessage:message conversation:conversation];
//    };
//    [self makeSureConversation:conversation isAvailableCallback:fetchedConversationCallback];
}

- (void)conversation:(XYDConversation *)conversation messageDelivered:(XYDChatMessage *)message {
    if (message != nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:XYDChatNotificationMessageDelivered object:message];
    }
}

- (void)conversation:(XYDConversation *)conversation didReceiveUnread:(NSInteger)unread {
    if (unread <= 0) return;
//    XYDChatLog(@"conversatoin:%@ didReceiveUnread:%@", conversation, @(unread));
    void (^fetchedConversationCallback)() = ^() {
        [conversation queryMessagesFromServerWithLimit:unread callback:^(NSArray *objects, NSError *error) {
            if (!error && (objects.count > 0)) {
                [self receiveMessages:objects conversation:conversation isUnreadMessage:YES];
            }
        }];
        [self playLoudReceiveSoundIfNeededForConversation:conversation];
        [conversation markAsReadInBackground];
    };
    [self makeSureConversation:conversation isAvailableCallback:fetchedConversationCallback];
}

- (void)makeSureConversation:(XYDConversation *)conversation isAvailableCallback:(XYDChatVoidBlock)callback {
    if (!conversation.createAt && ![[XYDConversationService sharedInstance] isRecentConversationExistWithConversationId:conversation.conversationId]) {
        [conversation fetchWithCallback:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                !callback ?: callback();
                return;
            }
//            XYDChatLog(@"🔴类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), error);
        }];
    } else {
        !callback ?: callback();
    }
}

- (void)conversation:(XYDConversation *)conversation kickedByClientId:(NSString *)clientId {
    [[NSNotificationCenter defaultCenter] postNotificationName:XYDChatNotificationConversationInvalided object:clientId];
    if ([[XYDConversationService sharedInstance].currentConversationId isEqualToString:conversation.conversationId]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:XYDChatNotificationCurrentConversationInvalided object:clientId];
    }
}

#pragma mark - receive message handle

- (void)receiveMessage:(XYDChatMessage *)message conversation:(XYDConversation *)conversation {
    if (message.mediaType > 0) {
        NSDictionary *userInfo = @{
                                   XYDChatDidReceiveMessagesUserInfoConversationKey : conversation,
                                   XYDChatDidReceiveCustomMessageUserInfoMessageKey : message,
                                   };
        [[NSNotificationCenter defaultCenter] postNotificationName:XYDChatNotificationCustomTransientMessageReceived object:userInfo];
    }
    [self receiveMessages:@[message] conversation:conversation isUnreadMessage:NO];
}

- (void)receiveMessages:(NSArray<XYDChatMessage *> *)messages conversation:(XYDConversation *)conversation isUnreadMessage:(BOOL)isUnreadMessage {
    
    void (^checkMentionedMessageCallback)() = ^(NSArray *filterdMessages) {
        // - 插入最近对话列表
        // 下面的XYDChatNotificationMessageReceived也会通知ConversationListVC刷新
        [[XYDConversationService sharedInstance] insertRecentConversation:conversation shouldRefreshWhenFinished:NO];
        [[XYDConversationService sharedInstance] increaseUnreadCount:filterdMessages.count withConversationId:conversation.conversationId shouldRefreshWhenFinished:NO];
        // - 播放接收音
        if (!isUnreadMessage) {
            [self playLoudReceiveSoundIfNeededForConversation:conversation];
        }
        NSDictionary *userInfo = @{
                                   XYDChatDidReceiveMessagesUserInfoConversationKey : conversation,
                                   XYDChatDidReceiveMessagesUserInfoMessagesKey : filterdMessages,
                                   };
        // - 通知相关页面接收到了消息：“当前对话页面”、“最近对话页面”；
        
        [[NSNotificationCenter defaultCenter] postNotificationName:XYDChatNotificationMessageReceived object:userInfo];
    };
    
    void(^filteredMessageCallback)(NSArray *originalMessages) = ^(NSArray *filterdMessages) {
        if (filterdMessages.count == 0) { return; }
        // - 在最近对话列表页时，检查是否有人@我
        if (![[XYDConversationService sharedInstance].currentConversationId isEqualToString:conversation.conversationId]) {
            // 没有在聊天的时候才增加未读数和设置mentioned
            [self isMentionedByMessages:filterdMessages callback:^(BOOL succeeded, NSError *error) {
                !checkMentionedMessageCallback ?: checkMentionedMessageCallback(filterdMessages);
                if (succeeded) {
                    [[XYDConversationService sharedInstance] updateMentioned:YES conversationId:conversation.conversationId];
                    // 下面的XYDChatNotificationMessageReceived也会通知ConversationListVC刷新
                    // [[NSNotificationCenter defaultCenter] postNotificationName:XYDChatNotificationUnreadsUpdated object:nil];
                }
            }];
        } else {
            !checkMentionedMessageCallback ?: checkMentionedMessageCallback(filterdMessages);
        }
    };
    
    XYDChatFilterMessagesBlock filterMessagesBlock = [XYDConversationService sharedInstance].filterMessagesBlock;
    if (filterMessagesBlock) {
        XYDChatFilterMessagesCompletionHandler filterMessagesCompletionHandler = ^(NSArray *filteredMessages, NSError *error) {
            if (!error) {
                !filteredMessageCallback ?: filteredMessageCallback([filteredMessages copy]);
            }
        };
        filterMessagesBlock(conversation, messages, filterMessagesCompletionHandler);
    } else {
        !filteredMessageCallback ?: filteredMessageCallback(messages);
    }
}

/*!
 * 如果是未读消息，会在 query 时播放一次，避免重复播放
 */
- (void)playLoudReceiveSoundIfNeededForConversation:(XYDConversation *)conversation {
    if ([XYDConversationService sharedInstance].chatting) {
        return;
    }
    if (conversation.muted) {
        return;
    }
    if (self.isPlayingSound) {
        return;
    }
    self.playingSound = YES;
    [[XYDSoundManager defaultManager] playLoudReceiveSoundIfNeed];
    [[XYDSoundManager defaultManager] vibrateIfNeed];
    //一定时间之内只播放声音一次
    NSUInteger delaySeconds = 1;
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        self.playingSound = NO;
    });
}

#pragma mark - mention

- (void)isMentionedByMessages:(NSArray<XYDChatMessage *> *)messages callback:(XYDChatBooleanResultBlock)callback {
    if (!messages || messages.count == 0) {
        NSInteger code = 0;
        NSString *errorReasonText = @"no message to check";
        NSDictionary *errorInfo = @{
                                    @"code":@(code),
                                    NSLocalizedDescriptionKey : errorReasonText,
                                    };
        NSError *error = [NSError errorWithDomain:XYDChatSessionServiceErrorDomain
                                             code:code
                                         userInfo:errorInfo];
        !callback ?: callback(NO, error);
        return;
    }
    
    __block BOOL isMentioned = NO;
//    [[XYDChatUserSystemService sharedInstance] fetchCurrentUserInBackground:^(id<XYDChatUserDelegate> currentUser, NSError *error) {
//        NSString *queueBaseLabel = [NSString stringWithFormat:@"com.chatkit.%@", NSStringFromClass([self class])];
//        const char *queueName = [[NSString stringWithFormat:@"%@.%@.ForBarrier",queueBaseLabel, [[NSUUID UUID] UUIDString]] UTF8String];
//        dispatch_queue_t queue = dispatch_queue_create(queueName, DISPATCH_QUEUE_CONCURRENT);
//        
//        [messages enumerateObjectsUsingBlock:^(XYDChatMessage * _Nonnull message, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (![message isKindOfClass:[XYDChatTextMessage class]]) {
//                return;
//            }
//            dispatch_async(queue, ^(void) {
//                if (isMentioned) {
//                    return;
//                }
//                NSString *text = ((XYDChatTextMessage *)message).text;
//                BOOL isMentioned_ = [self isMentionedByText:text currentUser:currentUser];
//                //只要有一个提及，就callback
//                if (isMentioned_) {
//                    isMentioned = YES;
//                    *stop = YES;
//                    return;
//                }
//            });
//        }];
//        
//        dispatch_barrier_async(queue, ^{
//            //最后一个也没有提及就callback
//            NSError *error = nil;
//            if (!isMentioned) {
//                NSInteger code = 0;
//                NSString *errorReasonText = @"not mentioned";
//                NSDictionary *errorInfo = @{
//                                            @"code":@(code),
//                                            NSLocalizedDescriptionKey : errorReasonText,
//                                            };
//                error = [NSError errorWithDomain:XYDChatSessionServiceErrorDomain                                                         code:code
//                                        userInfo:errorInfo];
//            }
//            dispatch_async(dispatch_get_main_queue(),^{
//                !callback ?: callback(isMentioned, error);
//            });
//        });
//        
//    }];
}

- (BOOL)isMentionedByText:(NSString *)text currentUser:(id<XYDChatUserDelegate>)currentUser {
    if (!text || (text.length == 0)) {
        return NO;
    }
    NSString *patternWithUserName = [NSString stringWithFormat:@"@%@ ",currentUser.name ?: currentUser.clientId];
    NSString *patternWithLowercaseAll = @"@all ";
    NSString *patternWithUppercaseAll = @"@All ";
    BOOL isMentioned = [text xyd_containsaString:patternWithUserName] || [text xyd_containsaString:patternWithLowercaseAll] || [text xyd_containsaString:patternWithUppercaseAll];
    if(isMentioned) {
        return YES;
    } else {
        return NO;
    }
}

@end
