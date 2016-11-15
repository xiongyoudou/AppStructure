//
//  XYDChatClient.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/15.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatClient.h"
#import "XYDConversation.h"
#import "XYDChatMessage.h"
#import "XYDConversationQuery.h"

NSString *const XYDChatTagDefault = @"default";

static const int kMaxClientIdLength = 64;
static XYDChatClient *defaultClient = nil;

static dispatch_queue_t imClientQueue = NULL;
static dispatch_queue_t defaultClientAccessQueue = NULL;

NS_INLINE
BOOL isValidTag(NSString *tag) {
    return tag && ![tag isEqualToString:XYDChatTagDefault];
}

@implementation XYDChatClient

static BOOL XYDChatClientHasInstantiated = NO;

+ (void)initialize {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        imClientQueue = dispatch_queue_create("cn.leancloud.im", DISPATCH_QUEUE_SERIAL);
        defaultClientAccessQueue = dispatch_queue_create("cn.leancloud.imclient", DISPATCH_QUEUE_SERIAL);
    });
}

+ (instancetype)alloc {
    XYDChatClientHasInstantiated = YES;
    return [super alloc];
}

+ (instancetype)defaultClient {
    __block XYDChatClient *client = nil;
    dispatch_sync(defaultClientAccessQueue, ^{
        if (!defaultClient) {
            defaultClient = [[self alloc] init];
        }
        client = defaultClient;
    });
    return client;
}

+ (void)setTimeoutIntervalInSeconds:(NSTimeInterval)seconds {
//    [XYDChatWebSocketWrapper setTimeoutIntervalInSeconds:seconds];
}

+ (void)resetDefaultClient {
    dispatch_sync(defaultClientAccessQueue, ^{
        defaultClient = nil;
    });
}

+ (dispatch_queue_t)imClientQueue {
    return imClientQueue;
}

//+ (BOOL)checkErrorForSignature:(XYDChatSignature *)signature command:(XYDChatGenericCommand *)command {
//    if (signature.error) {
//        XYDChatCommandResultBlock callback = command.callback;
//        if (callback) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                callback(command, nil, signature.error);
//            });
//        }
//        return YES;
//    } else {
//        return NO;
//    }
//}

+ (void)_assertClientIdsIsValid:(NSArray *)clientIds {
    for (id item in clientIds) {
        if (![item isKindOfClass:[NSString class]]) {
            [NSException raise:NSInternalInconsistencyException format:@"ClientId should be NSString but %@ found.", NSStringFromClass([item class])];
            return;
        }
        if ([item length] == 0 || [item length] > kMaxClientIdLength) {
            [NSException raise:NSInternalInconsistencyException format:@"ClientId length should be in range [1, 64] but found '%@' length %lu.", item, (unsigned long)[item length]];
            return;
        }
    }
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self doInitialization];
    }
    
    return self;
}

- (instancetype)initWithClientId:(NSString *)clientId {
    return [self initWithClientId:clientId tag:nil];
}

- (instancetype)initWithClientId:(NSString *)clientId tag:(NSString *)tag {
    self = [super init];
    
    if (self) {
        _clientId = [clientId copy];
        _tag = [tag copy];
        
        [self doInitialization];
    }
    
    return self;
}

- (void)doInitialization {
//    _status = XYDChatClientStatusNone;
//    _conversations = [[NSMutableDictionary alloc] init];
//    _messages = [[NSMutableDictionary alloc] init];
//    _messageQueryCacheEnabled = YES;
//    
//    /* Observe push notification device token and websocket open event. */
//    
//    LCObserver *selfObserver = LCObserverMake(self);
//    
//    @weakify(self);
//    
//    [selfObserver
//     addTarget:self
//     forKeyPath:NSStringFromSelector(@selector(onceOpened))
//     options:0
//     block:^(id object, id target, NSDictionary *change) {
//         @strongify(self);
//         [self registerPushChannelInBackground];
//     }];
//    
//    [selfObserver
//     addTarget:[AVInstallation currentInstallation]
//     forKeyPath:NSStringFromSelector(@selector(deviceToken))
//     options:0
//     block:^(id object, id target, NSDictionary *change) {
//         @strongify(self);
//         [self registerPushChannelInBackground];
//     }];
}

//- (LCIMConversationCache *)conversationCache {
//    NSString *clientId = self.clientId;
//    
//    return clientId ? [[LCIMConversationCache alloc] initWithClientId:clientId] : nil;
//}

- (void)setClientId:(NSString *)clientId {
//    _clientId = [clientId copy];
//    
//    [_conversations removeAllObjects];
//    [_messages removeAllObjects];
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        LCIMConversationCache *cache = [self conversationCache];
//        [cache cleanAllExpiredConversations];
//    });
}

- (void)dealloc {
//    AVLoggerInfo(AVLoggerDomainIM, @"XYDChatClient dealloc.");
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [_socketWrapper decreaseObserverCount];
}

- (void)addConversation:(XYDConversation *)conversation {
//    return [_conversations setObject:conversation forKey:conversation.conversationId];
}

- (void)cacheConversations:(NSArray *)conversations {
    for (XYDConversation *conversation in conversations) {
        [self addConversation:conversation];
    }
}

- (void)cacheConversationsIfNeeded:(NSArray *)conversations {
//    for (XYDConversation *conversation in conversations) {
//        if (self.conversations[conversation.conversationId] == nil) {
//            [self addConversation:conversation];
//        }
//    }
}

- (XYDConversation *)conversationForId:(NSString *)conversationId {
//    XYDConversation *conversation = [_conversations objectForKey:conversationId];
    
    /* Disable conversation cache for consistent */
    
    /*
     if (!conversation) {
     conversation = [[self conversationCache] conversationForId:conversationId];
     
     if (conversation) {
     [self addConversation:conversation];
     }
     }
     */
    
//    return conversation;
    return nil;
}

- (void)addMessage:(XYDChatMessage *)message {
//    NSString *messageId = message.messageId;
//    if (messageId) {
//        [_messages setObject:message forKey:messageId];
//    }
}

- (void)removeMessageById:(NSString *)messageId {
//    [_messages removeObjectForKey:messageId];
}

- (XYDChatMessage *)messageById:(NSString *)messageId {
//    return [_messages objectForKey:messageId];
    return nil;
}

- (XYDConversation *)conversationWithId:(NSString *)conversationId {
    if (!conversationId) {
        
        return nil;
    }
    XYDConversation *conversation = [self conversationForId:conversationId];
    if (!conversation) {
//        conversation = [[XYDConversation alloc] initWithConversationId:conversationId];
//        conversation.imClient = self;
//        [self addConversation:conversation];
    }
    return conversation;
}

//- (void)sendCommand:(XYDChatGenericCommand *)command {
//    BOOL sendable = (
//                     _socketWrapper != nil &&
//                     _status != XYDChatClientStatusClosing &&
//                     _status != XYDChatClientStatusClosed
//                     );
//    
//    if (sendable) {
//        [_socketWrapper sendCommand:command];
//    } else {
//        XYDChatCommandResultBlock callback = command.callback;
//        if (callback) {
//            NSError *error = [XYDChatErrorUtil errorWithCode:kXYDChatErrorClientNotOpen reason:@"Client not open when send a message."];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                callback(command, nil, error);
//            });
//        }
//    }
//}

//- (void)changeStatus:(XYDChatClientStatus)status {
//    XYDChatClientStatus oldStatus = self.status;
//    self.status = status;
//    
//    switch (status) {
//        case XYDChatClientStatusPaused:
//            [self receivePaused];
//            break;
//            
//        case XYDChatClientStatusResuming:
//            [self receiveResuming];
//            break;
//            
//        case XYDChatClientStatusOpened: {
//            if (oldStatus == XYDChatClientStatusResuming) {
//                [self receiveResumed];
//            }
//        }
//            break;
//            
//        default:
//            break;
//    }
//}

- (XYDChatSignature *)signatureWithClientId:(NSString *)clientId conversationId:(NSString *)conversationId action:(NSString *)action actionOnClientIds:(NSArray *)clientIds {
    XYDChatSignature *signature = nil;
    if ([_signatureDataSource respondsToSelector:@selector(signatureWithClientId:conversationId:action:actionOnClientIds:)]) {
        signature = [_signatureDataSource signatureWithClientId:clientId conversationId:conversationId action:action actionOnClientIds:clientIds];
    }
    return signature;
}

//- (XYDChatWebSocketWrapper *)socketWrapperForSecurity:(BOOL)security {
//    XYDChatWebSocketWrapper *socketWrapper = nil;
//    
//    if (security) {
//        socketWrapper = [XYDChatWebSocketWrapper sharedSecurityInstance];
//    } else {
//        socketWrapper = [XYDChatWebSocketWrapper sharedInstance];
//    }
//    
//    if (socketWrapper) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(websocketOpened:) name:XYDChat_NOTIFICATION_WEBSOCKET_OPENED object:socketWrapper];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(websocketClosed:) name:XYDChat_NOTIFICATION_WEBSOCKET_CLOSED object:socketWrapper];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(websocketReconnect:) name:XYDChat_NOTIFICATION_WEBSOCKET_RECONNECT object:socketWrapper];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCommand:) name:XYDChat_NOTIFICATION_WEBSOCKET_COMMAND object:socketWrapper];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveError:) name:XYDChat_NOTIFICATION_WEBSOCKET_ERROR object:socketWrapper];
//        
//        [socketWrapper increaseObserverCount];
//    }
//    
//    return socketWrapper;
//}

//- (XYDChatGenericCommand *)openCommandWithAppId:(NSString *)appId
//                                    clientId:(NSString *)clientId
//                                         tag:(NSString *)tag
//                                       force:(BOOL)force
//                                    callback:(XYDChatCommandResultBlock)callback
//{
//    XYDChatGenericCommand *genericCommand = [[XYDChatGenericCommand alloc] init];
//    genericCommand.needResponse = YES;
//    genericCommand.cmd = XYDChatCommandType_Session;
//    genericCommand.op = XYDChatOpType_Open;
//    genericCommand.appId = appId;
//    genericCommand.peerId = clientId ?: _clientId;
//    
//    objc_setAssociatedObject(genericCommand, @selector(tag), tag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    objc_setAssociatedObject(genericCommand, @selector(force), @(force), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    
//    XYDChatSessionCommand *sessionCommand = [[XYDChatSessionCommand alloc] init];
//    NSString *sessionToken = [[LCIMClientSessionTokenCacheStore sharedInstance] sessionTokenForClientId:clientId tag:tag];
//    
//    /* When client is opened by user actively, ignore session token. */
//    if (sessionToken && self.openTimes > 0) {
//        sessionCommand.st = sessionToken;
//    } else {
//        sessionCommand.ua = @"ios" @"/" SDK_VERSION;
//        sessionCommand.deviceToken = [AVInstallation currentInstallation].deviceToken ?: [AVUtils deviceUUID];
//        
//        if (!tag)
//            tag = _tag;
//        
//        /* If tag is setted and not default, send it to server. */
//        if (isValidTag(tag)) {
//            sessionCommand.tag = tag;
//        }
//    }
//    [genericCommand XYDChat_addRequiredKeyWithCommand:sessionCommand];
//    genericCommand.callback = callback;
//    return genericCommand;
//}

- (void)sendOpenCommand {
//    XYDChatGenericCommand *command = self.openCommand;
//    
//    if (!command) {
//        AVLoggerError(AVLoggerDomainIM, @"Command not found, can not open client.");
//        return;
//    }
//    
//    NSString *actionString = [XYDChatCommandFormatter signatureActionForKey:command.op];
//    XYDChatSignature *signature = [self signatureWithClientId:command.peerId conversationId:nil action:actionString actionOnClientIds:nil];
//    
//    if ([XYDChatClient checkErrorForSignature:signature command:command]) {
//        AVLoggerError(AVLoggerDomainIM, @"Signature error, can not open client.");
//        return;
//    }
//    /* NOTE: this will trigger an action that `command.sessionMessage.st = nil;` */
//    [command XYDChat_addRequiredKeyForSessionMessageWithSignature:signature];
//    
//    /* By default, we make non-initiative connection. */
//    BOOL force = NO;
//    
//    if (self.openTimes == 0) {
//        /* If force, we make an initiative login. */
//        if ([objc_getAssociatedObject(command, @selector(force)) boolValue]) {
//            force = YES;
//        } else {
//            /* However, if client has tag, we make a passive connection for the first time.
//             * This connection may be rejected by server because of gone offline by the same client on other device.
//             */
//            BOOL hasTag = isValidTag(objc_getAssociatedObject(command, @selector(tag)));
//            
//            if (hasTag) {
//                force = NO;
//            } else {
//                force = YES;
//            }
//        }
//    }
//    
//    command.sessionMessage.r = !force;
//    
//    OSAtomicIncrement32(&_openTimes);
//    
//    [self sendCommand:command];
}

- (void)registerPushChannelInBackground {
//    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
//    NSString *deviceToken = currentInstallation.deviceToken;
//    
//    if (deviceToken && self.onceOpened && (self.status == XYDChatClientStatusOpened) && self.clientId) {
//        /* Add client id to installation channels. */
//        [currentInstallation addUniqueObject:self.clientId forKey:@"channels"];
//        [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            if (error)
//                AVLoggerError(AVLoggerDomainIM, @"Register push channel failed: %@", error);
//        }];
//        
//        /* Report current device token to cloud. */
//        [self reportDeviceToken:deviceToken];
//    }
}

- (void)reportDeviceToken:(NSString *)deviceToken {
//    XYDChatGenericCommand *genericCommand = [[XYDChatGenericCommand alloc] init];
//    genericCommand.cmd = XYDChatCommandType_Report;
//    genericCommand.op = XYDChatOpType_Upload;
//    genericCommand.appId = [AVOSCloud getApplicationId];
//    genericCommand.peerId = _clientId;
//    
//    XYDChatReportCommand *reportCommand = [[XYDChatReportCommand alloc] init];
//    reportCommand.initiative = YES;
//    reportCommand.type = @"token";
//    reportCommand.data_p = deviceToken;
//    
//    [genericCommand XYDChat_addRequiredKeyWithCommand:reportCommand];
//    
//    [self sendCommand:genericCommand];
}

//- (void)cacheClientSessionTokenForCommand:(XYDChatGenericCommand *)command tag:(NSString *)tag {
//    LCIMClientSessionTokenCacheStore *cacheStore = [LCIMClientSessionTokenCacheStore sharedInstance];
//    [cacheStore setSessionToken:command.sessionMessage.st TTL:command.sessionMessage.stTtl forClientId:command.peerId tag:tag];
//}

- (void)clearClientSessionTokenForClientId:(NSString *)clientId {
//    LCIMClientSessionTokenCacheStore *cacheStore = [LCIMClientSessionTokenCacheStore sharedInstance];
//    [cacheStore clearForClientId:clientId];
}

//- (BOOL)shouldRetryForCommand:(XYDChatGenericCommand *)command {
//    if ([command hasErrorMessage]) {
//        XYDChatErrorCommand *errorCommand = command.errorMessage;
//        
//        if (errorCommand.code == LCIMErrorCodeSessionTokenExpired) {
//            [self clearClientSessionTokenForClientId:command.peerId];
//            return YES;
//        }
//    }
//    
//    return NO;
//}

- (void)openWithCallback:(XYDChatBooleanResultBlock)callback {
    [self openWithClientId:self.clientId security:YES tag:self.tag force:NO callback:callback];
}

- (void)openWithOption:(XYDChatClientOpenOption *)option callback:(XYDChatBooleanResultBlock)callback {
//    BOOL force = NO;
//    
//    if (option)
//        force = option.force;
//    
//    [self openWithClientId:self.clientId security:YES tag:self.tag force:force callback:callback];
}

- (void)openWithClientId:(NSString *)clientId callback:(XYDChatBooleanResultBlock)callback {
    [self openWithClientId:clientId security:YES tag:nil force:NO callback:callback];
}

- (void)openWithClientId:(NSString *)clientId tag:(NSString *)tag callback:(XYDChatBooleanResultBlock)callback {
    [self openWithClientId:clientId security:YES tag:tag force:NO callback:callback];
}

- (void)openWithClientId:(NSString *)clientId security:(BOOL)security tag:(NSString *)tag force:(BOOL)force callback:(XYDChatBooleanResultBlock)callback {
//    // Validate client id
//    if (!clientId) {
//        [NSException raise:NSInternalInconsistencyException format:@"Client id can not be nil."];
//    } else if ([clientId length] > kMaxClientIdLength) {
//        [NSException raise:NSInvalidArgumentException format:@"Client id length should less than %d characters.", kMaxClientIdLength];
//    }
//    
//    // Validate application id
//    NSString *appId = [AVOSCloud getApplicationId];
//    
//    if (!appId) {
//        [NSException raise:NSInternalInconsistencyException format:@"Application id can not be nil."];
//    }
//    
//    callback = [XYDChatBlockHelper calledOnceBlockWithBooleanResultBlock:callback];
//    
//    @weakify(self);
//    dispatch_async(imClientQueue, ^{
//        @strongify(self);
//        
//        if (self.status == XYDChatClientStatusNone || self.status == XYDChatClientStatusClosed) {
//            self.clientId = clientId;
//            self.tag = tag;
//            self.socketWrapper = [self socketWrapperForSecurity:security];
//            self.openTimes = 0;
//            self.openCommand = [self openCommandWithAppId:appId
//                                                 clientId:clientId
//                                                      tag:tag
//                                                    force:force
//                                                 callback:^(XYDChatGenericCommand *outCommand, XYDChatGenericCommand *inCommand, NSError *error)
//                                {
//                                    if (!error) {
//                                        self.onceOpened = YES;
//                                        
//                                        /* NOTE: this will trigger an action that puts client id into channels of current installation. */
//                                        [self changeStatus:XYDChatClientStatusOpened];
//                                        
//                                        [XYDChatBlockHelper callBooleanResultBlock:callback error:nil];
//                                        
//                                        [self cacheClientSessionTokenForCommand:(XYDChatGenericCommand *)inCommand tag:tag];
//                                    } else {
//                                        [self changeStatus:XYDChatClientStatusClosed];
//                                        
//                                        if ([self shouldRetryForCommand:inCommand]) {
//                                            [self openWithClientId:clientId security:security tag:tag force:force callback:callback];
//                                        } else {
//                                            [XYDChatBlockHelper callBooleanResultBlock:callback error:error];
//                                        }
//                                    }
//                                    
//                                    outCommand.callback = nil;
//                                }];
//            
//            [self changeStatus:XYDChatClientStatusOpening];
//            
//            if ([self.socketWrapper isConnectionOpen]) {
//                [self sendOpenCommand];
//            } else {
//                [self.socketWrapper openWebSocketConnectionWithCallback:^(BOOL succeeded, NSError *error) {
//                    [self changeStatus:XYDChatClientStatusNone];
//                    [XYDChatBlockHelper callBooleanResultBlock:callback error:error];
//                    self.openCommand.callback = nil;
//                }];
//            }
//        } else {
//            [XYDChatBlockHelper callBooleanResultBlock:callback error:nil];
//        }
//    });
}

- (void)closeWithCallback:(XYDChatBooleanResultBlock)callback {
//    dispatch_async(imClientQueue, ^{
//        XYDChatGenericCommand *genericCommand = [[XYDChatGenericCommand alloc] init];
//        genericCommand.needResponse = YES;
//        genericCommand.cmd = XYDChatCommandType_Session;
//        genericCommand.peerId = _clientId;
//        genericCommand.op = XYDChatOpType_Close;
//        XYDChatSessionCommand *sessionCommand = [[XYDChatSessionCommand alloc] init];
//        [genericCommand XYDChat_addRequiredKeyWithCommand:sessionCommand];
//        [genericCommand setCallback:^(XYDChatGenericCommand *outCommand, XYDChatGenericCommand *inCommand, NSError *error) {
//            [[NSNotificationCenter defaultCenter] removeObserver:self name:XYDChat_NOTIFICATION_WEBSOCKET_OPENED object:_socketWrapper];
//            [[NSNotificationCenter defaultCenter] removeObserver:self name:XYDChat_NOTIFICATION_WEBSOCKET_COMMAND object:_socketWrapper];
//            [[NSNotificationCenter defaultCenter] removeObserver:self name:XYDChat_NOTIFICATION_WEBSOCKET_RECONNECT object:_socketWrapper];
//            [[NSNotificationCenter defaultCenter] removeObserver:self name:XYDChat_NOTIFICATION_WEBSOCKET_CLOSED object:_socketWrapper];
//            [[NSNotificationCenter defaultCenter] removeObserver:self name:XYDChat_NOTIFICATION_WEBSOCKET_ERROR object:_socketWrapper];
//            [[AVInstallation currentInstallation] removeObject:_clientId forKey:@"channels"];
//            if ([[AVInstallation currentInstallation] deviceToken]) {
//                [[AVInstallation currentInstallation] saveInBackground];
//            }
//            [self changeStatus:XYDChatClientStatusClosed];
//            [XYDChatBlockHelper callBooleanResultBlock:callback error:error];
//        }];
//        [self sendCommand:genericCommand];
//        [self changeStatus:XYDChatClientStatusClosing];
//    });
}

- (void)createConversationWithName:(NSString *)name clientIds:(NSArray *)clientIds callback:(XYDChatConversationResultBlock)callback {
//    [self createConversationWithName:name clientIds:clientIds attributes:nil options:XYDConversationOptionNone callback:callback];
}

- (void)createConversationWithName:(NSString *)name clientIds:(NSArray *)clientIds attributes:(NSDictionary *)attributes options:(XYDChatConversationOption)options callback:(XYDChatConversationResultBlock)callback {
//    [[self class] _assertClientIdsIsValid:clientIds];
//    dispatch_async(imClientQueue, ^{
//        XYDChatGenericCommand *genericCommand = [[XYDChatGenericCommand alloc] init];
//        genericCommand.needResponse = YES;
//        NSMutableDictionary *attr = nil;
//        
//        if (name || attributes) {
//            attr = [[NSMutableDictionary alloc] init];
//            
//            if (name) [attr setObject:name forKey:KEY_NAME];
//            if (attributes) [attr setObject:attributes forKey:KEY_ATTR];
//        }
//        
//        BOOL transient = options & XYDConversationOptionTransient;
//        BOOL unique    = options & XYDConversationOptionUnique;
//        genericCommand.cmd = XYDChatCommandType_Conv;
//        genericCommand.peerId = _clientId;
//        genericCommand.op = XYDChatOpType_Start;
//        
//        XYDChatConvCommand *convCommand = [[XYDChatConvCommand alloc] init];
//        convCommand.attr = [XYDChatCommandFormatter JSONObjectWithDictionary:[attr copy]];
//        
//        if (transient) {
//            convCommand.transient = YES;
//        } else {
//            /* If conversation is non-transient, we insert creator to member list. */
//            convCommand.mArray = [NSMutableArray arrayWithArray:({
//                NSMutableSet *members = [NSMutableSet setWithArray:clientIds ?: @[]];
//                [members addObject:self.clientId];
//                [members allObjects];
//            })];
//        }
//        
//        if (unique) {
//            convCommand.unique = YES;
//        }
//        
//        [genericCommand XYDChat_addRequiredKeyWithCommand:convCommand];
//        
//        NSString *acition = [XYDChatCommandFormatter signatureActionForKey:genericCommand.op];
//        XYDChatSignature *signature = [self signatureWithClientId:genericCommand.peerId conversationId:nil action:acition actionOnClientIds:[convCommand.mArray copy]];
//        [genericCommand XYDChat_addRequiredKeyForConvMessageWithSignature:signature];
//        if ([XYDChatClient checkErrorForSignature:signature command:genericCommand]) {
//            return;
//        }
//        [genericCommand setCallback:^(XYDChatGenericCommand *outCommand, XYDChatGenericCommand *inCommand, NSError *error) {
//            if (!error) {
//                XYDChatConvCommand *conversationInCommand = inCommand.convMessage;
//                XYDChatConvCommand *conversationOutCommand = outCommand.convMessage;
//                XYDConversation *conversation = [self conversationWithId:conversationInCommand.cid];
//                NSDictionary *dict = [self parseJsonFromMessage:conversationOutCommand.attr];
//                conversation.name = [dict objectForKey:KEY_NAME];
//                conversation.attributes = [dict objectForKey:KEY_ATTR];
//                conversation.creator = self.clientId;
//                conversation.createAt = [AVObjectUtils dateFromString:[conversationInCommand cdate]];
//                conversation.transient = conversationOutCommand.transient;
//                [conversation addMembers:[conversationOutCommand.mArray copy]];
//                [conversation addMember:outCommand.peerId];
//                [self addConversation:conversation];
//                [XYDChatBlockHelper callConversationResultBlock:callback conversation:conversation error:nil];
//            } else {
//                [XYDChatBlockHelper callConversationResultBlock:callback conversation:nil error:error];
//            }
//        }];
//        
//        [self sendCommand:genericCommand];
//    });
}

//- (NSDictionary *)parseJsonFromMessage:(XYDChatJsonObjectMessage *)jsonObjectMessage {
//    NSString *jsonString = [jsonObjectMessage data_p];
//    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
//                                                         options:0
//                                                           error:NULL];
//    return dict;
//}
//
//- (XYDConversation *)conversationWithKeyedConversation:(XYDChatKeyedConversation *)keyedConversation {
//    NSString *conversationId = keyedConversation.conversationId;
//    XYDConversation *conversation = [self conversationForId:conversationId];
//    
//    if (!conversation) {
//        conversation = [self conversationWithId:conversationId];
//        [conversation setKeyedConversation:keyedConversation];
//    }
//    
//    return conversation;
//}

- (XYDConversationQuery *)conversationQuery {
    XYDConversationQuery *query = [[XYDConversationQuery alloc] init];
//    query.client = self;
    return query;
}

- (void)websocketOpened:(NSNotification *)notification {
//    dispatch_async(imClientQueue, ^{
//        [self sendOpenCommand];
//    });
//    [self changeStatus:XYDChatClientStatusOpened];
}

- (void)websocketClosed:(NSNotification *)notification {
//    [self changeStatus:XYDChatClientStatusPaused];
}

- (void)websocketReconnect:(NSNotification *)notification {
//    [self changeStatus:XYDChatClientStatusResuming];
}

- (void)addMessageId:(NSString *)messageId {
//    [_socketWrapper addMessageId:messageId];
}

- (BOOL)messageIdExists:(NSString *)messageId {
//    return [_socketWrapper messageIdExists:messageId];
    return NO;
}

#pragma mark - process received messages

- (void)receiveCommand:(NSNotification *)notification {
//    NSDictionary *dict = notification.userInfo;
//    
//    XYDChatGenericCommand *command = [dict objectForKey:@"command"];
//    // 因为是 notification ，可能收到其它 client 的广播
//    // 根据文档，每条消息都带有 peerId
//    /* Filter out other client's command */
//    if ([command.peerId isEqualToString:self.clientId] == NO) {
//        return;
//    }
//    
//    XYDChatCommandType commandType = command.cmd;
//    switch (commandType) {
//        case XYDChatCommandType_Session:
//            [self processSessionCommand:command];
//            break;
//        case XYDChatCommandType_Direct:
//            [self processDirectCommand:command];
//            break;
//        case XYDChatCommandType_Unread:
//            [self processUnreadCommand:command];
//            break;
//        case XYDChatCommandType_Conv:
//            [self processConvCommand:command];
//            break;
//        case XYDChatCommandType_Rcp:
//            [self processReceiptCommand:command];
//            break;
//            
//        default:
//            break;
//    }
}

//- (void)processDirectCommand:(XYDChatGenericCommand *)genericCommand {
//    XYDChatDirectCommand *directCommand = genericCommand.directMessage;
//    
//    if (directCommand.id_p && [self messageIdExists:directCommand.id_p]) {
//        return;
//    }
//    if (directCommand.id_p) {
//        [self addMessageId:directCommand.id_p];
//    }
//    XYDChatMessage *message = nil;
//    if (![directCommand.msg isKindOfClass:[NSString class]]) {
//        AVLoggerError(AVOSCloudIMErrorDomain, @"Received an invalid message.");
//        [self sendAckCommandAccordingToDirectCommand:directCommand andGenericCommand:genericCommand];
//        return;
//    }
//    XYDChatTypedMessageObject *messageObject = [[XYDChatTypedMessageObject alloc] initWithJSON:directCommand.msg];
//    if ([messageObject isValidTypedMessageObject]) {
//        message = [XYDChatTypedMessage messageWithMessageObject:messageObject];
//    } else {
//        message = [[XYDChatMessage alloc] init];
//    }
//    message.content = directCommand.msg;
//    message.sendTimestamp = directCommand.timestamp;
//    message.conversationId = directCommand.cid;
//    message.clientId = directCommand.fromPeerId;
//    message.messageId = directCommand.id_p;
//    message.status = XYDChatMessageStatusDelivered;
//    message.offline = directCommand.offline;
//    message.hasMore = directCommand.hasMore;
//    message.localClientId = self.clientId;
//    message.transient = directCommand.transient;
//    
//    [self receiveMessage:message];
//    [self sendAckCommandAccordingToDirectCommand:directCommand andGenericCommand:genericCommand];
//}
//
//- (void)sendAckCommandAccordingToDirectCommand:(XYDChatDirectCommand *)directCommand andGenericCommand:(XYDChatGenericCommand *)genericCommand {
//    if (directCommand.id_p && !directCommand.transient && ![directCommand.fromPeerId isEqualToString:_clientId]) {
//        XYDChatGenericCommand *genericAckCommand = [[XYDChatGenericCommand alloc] init];
//        genericCommand.needResponse = YES;
//        genericAckCommand.cmd = XYDChatCommandType_Ack;
//        genericAckCommand.peerId = _clientId;
//        
//        XYDChatAckCommand *ackCommand = [[XYDChatAckCommand alloc] init];
//        ackCommand.cid = directCommand.cid;
//        ackCommand.mid = directCommand.id_p;
//        [genericAckCommand XYDChat_addRequiredKeyWithCommand:ackCommand];
//        [self sendCommand:genericAckCommand];
//    }
//}

/*!
 * Fetch conversation if conversation not filled.
 * @param conversation Conversation which should be fetched.
 * @param block        Callback block.
 * @note  Block will be dispatched to main thread.
 */
- (void)fetchConversationIfNeeded:(XYDConversation *)conversation withBlock:(void(^)(XYDConversation *conversation))block {
    /* FIX: Check whether conversation unfaulting has been fired or not */
    if (conversation.createAt) {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(conversation);
        });
    } else {
        __weak typeof(self) ws = self;
        [conversation fetchWithCallback:^(BOOL succeeded, NSError *error) {
            if (error) {
//                AVLoggerError(AVLoggerDomainIM, @"Fetching conversation failed: %@", error);
            } else {
                [ws addConversation:conversation];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                block(conversation);
            });
        }];
    }
}

//- (void)processUnreadCommand:(XYDChatGenericCommand *)genericCommand {
//    XYDChatUnreadCommand *unreadCommand = genericCommand.unreadMessage;
//    /* Filter out command matches current client */
//    if (![genericCommand.peerId isEqualToString:self.clientId]) return;
//    
//    for (XYDChatUnreadTuple *unreadTuple in unreadCommand.convsArray) {
//        NSString *conversationId = unreadTuple.cid;
//        XYDConversation *conversation = [self conversationWithId:conversationId];
//        
//        [self passUnread:unreadTuple.unread toConversation:conversation];
//    }
//}

- (void)passUnread:(NSInteger)unread toConversation:(XYDConversation *)conversation {
    if (!conversation) return;
    if (![self.delegate respondsToSelector:@selector(conversation:didReceiveUnread:)]) return;
    
    __weak typeof(self) ws = self;
    
    [self fetchConversationIfNeeded:conversation withBlock:^(XYDConversation *conversation) {
        [ws.delegate conversation:conversation didReceiveUnread:unread];
    }];
}

- (void)removeCachedConversationForId:(NSString *)conversationId {
//    [[self conversationCache] removeConversationForId:conversationId];
}

- (void)removeCachedMessagesForId:(NSString *)conversationId {
    NSString *clientId = self.clientId;
    
//    if (clientId && conversationId) {
//        LCIMMessageCacheStore *messageCacheStore = [[LCIMMessageCacheStore alloc] initWithClientId:clientId conversationId:conversationId];
//        [messageCacheStore cleanCache];
//    }
}

//- (void)passConvCommand:(XYDChatGenericCommand *)genericCommand toConversation:(XYDConversation *)conversation {
//    XYDChatConvCommand *convCommand = genericCommand.convMessage;
//    XYDChatOpType op = genericCommand.op;
//    NSString *conversationId = convCommand.cid;
//    NSString *initBy = convCommand.initBy;
//    NSArray *members = [convCommand.mArray copy];
//    
//    LCIMConversationCache *conversationCache = [self conversationCache];
//    switch (op) {
//            
//            // XYDChatOpType_Joined = 32,
//        case XYDChatOpType_Joined:
//            [conversation addMember:self.clientId];
//            [self receiveInvitedFromConversation:conversation byClientId:initBy];
//            break;
//            
//            // XYDChatOpType_MembersJoined = 33,
//        case XYDChatOpType_MembersJoined:
//            [conversation addMembers:members];
//            [self receiveMembersAddedFromConversation:conversation clientIds:members byClientId:initBy];
//            break;
//            
//            // XYDChatOpType_Left = 39,
//        case XYDChatOpType_Left:
//            [conversation removeMember:self.clientId];
//            [self receiveKickedFromConversation:conversation byClientId:initBy];
//            // Remove conversation and it's message from cache.
//            [conversationCache removeConversationAndItsMessagesForId:conversationId];
//            break;
//            
//            // XYDChatOpType_MembersLeft = 40,
//        case XYDChatOpType_MembersLeft:
//            [conversation removeMembers:members];
//            [self receiveMembersRemovedFromConversation:conversation clientIds:members byClientId:initBy];
//            break;
//            
//        default:
//            break;
//    }
//}

//- (void)processConvCommand:(XYDChatGenericCommand *)command {
//    NSString *conversationId = command.convMessage.cid;
//    XYDConversation *conversation = [self conversationWithId:conversationId];
//    
//    @weakify(self, ws);
//    [self fetchConversationIfNeeded:conversation withBlock:^(XYDConversation *conversation) {
//        [ws passConvCommand:command toConversation:conversation];
//    }];
//}
//
//- (void)processReceiptCommand:(XYDChatGenericCommand *)genericCommand {
//    XYDChatRcpCommand *rcpCommand = genericCommand.rcpMessage;
//    NSString *messageId = rcpCommand.id_p;
//    XYDChatMessage *message = [self messageById:messageId];
//    if (message) {
//        message.deliveredTimestamp = rcpCommand.t;
//        message.status = XYDChatMessageStatusDelivered;
//        
//        LCIMMessageCacheStore *cacheStore = [[LCIMMessageCacheStore alloc] initWithClientId:self.clientId conversationId:message.conversationId];
//        [cacheStore updateMessageWithoutBreakpoint:message];
//        
//        [self receiveMessageDelivered:message];
//    }
//}
//
//- (void)processSessionCommand:(XYDChatGenericCommand *)genericCommand {
//    XYDChatOpType op = genericCommand.op;
//    XYDChatSessionCommand *sessionCommand = genericCommand.sessionMessage;
//    if (op == XYDChatOpType_Closed) {
//        /* If the closed command has a code, it's an offline command. */
//        if (sessionCommand.code > 0) {
//            /* Close socket connect anyway. */
//            [self.socketWrapper closeWebSocketConnectionRetry:NO];
//            /* openClient only work when status is XYDChatClientStatusClosed or XYDChatClientStatusNone */
//            [self changeStatus:XYDChatClientStatusClosed];
//            if ([self.delegate respondsToSelector:@selector(client:didOfflineWithError:)]) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.delegate client:self didOfflineWithError:[genericCommand XYDChat_errorObject]];
//                });
//            }
//        }
//    }
//}

- (void)array:(NSMutableArray *)array addObject:(id)object {
    if (!object) {
        object = [NSNull null];
    }
    [array addObject:object];
}

- (void)receiveMessage:(XYDChatMessage *)message {
//    NSString *conversationId = message.conversationId;
//    
//    /* Only cache non-transient message */
//    if (!message.transient && self.messageQueryCacheEnabled) {
//        LCIMMessageCacheStore *cacheStore = [[LCIMMessageCacheStore alloc] initWithClientId:self.clientId conversationId:conversationId];
//        
//        /* If cache contains message, update message only */
//        if ([cacheStore containMessage:message]) {
//            [cacheStore updateMessageWithoutBreakpoint:message];
//            return;
//        }
//        
//        /* Otherwise, add message to cache and notify it to user */
//        [cacheStore insertMessage:message withBreakpoint:message.offline && message.hasMore];
//    }
//    
//    XYDConversation *conversation = [self conversationWithId:conversationId];
//    
//    __weak typeof(self) ws = self;
//    
//    [self fetchConversationIfNeeded:conversation withBlock:^(XYDConversation *conversation) {
//        /* Update lastMessageAt if needed. */
//        NSDate *messageSentAt = [NSDate dateWithTimeIntervalSince1970:(message.sendTimestamp / 1000.0)];
//        
//        if (!conversation.lastMessageAt || [conversation.lastMessageAt compare:messageSentAt] == NSOrderedAscending) {
//            conversation.lastMessageAt = messageSentAt;
//        }
//        
//        [ws passMessage:message toConversation:conversation];
//    }];
}

- (void)passMessage:(XYDChatMessage *)message toConversation:(XYDConversation *)conversation {
//    NSArray *arguments = @[conversation, message];
//    
//    if ([message isKindOfClass:[XYDChatTypedMessage class]]) {
//        if ([_delegate respondsToSelector:@selector(conversation:didReceiveTypedMessage:)]) {
//            [XYDChatRuntimeHelper callMethodInMainThreadWithTarget:_delegate selector:@selector(conversation:didReceiveTypedMessage:) arguments:arguments];
//        } else {
//            [XYDChatRuntimeHelper callMethodInMainThreadWithTarget:_delegate selector:@selector(conversation:didReceiveCommonMessage:) arguments:arguments];
//        }
//    } else if ([message isKindOfClass:[XYDChatMessage class]]) {
//        [XYDChatRuntimeHelper callMethodInMainThreadWithTarget:_delegate selector:@selector(conversation:didReceiveCommonMessage:) arguments:arguments];
//    }
}

- (void)receiveMessageDelivered:(XYDChatMessage *)message {
//    XYDConversation *conversation = [self conversationWithId:message.conversationId];
//    NSMutableArray *arguments = [[NSMutableArray alloc] init];
//    [self array:arguments addObject:conversation];
//    [self array:arguments addObject:message];
//    [XYDChatRuntimeHelper callMethodInMainThreadWithTarget:_delegate selector:@selector(conversation:messageDelivered:) arguments:arguments];
}

- (void)receiveInvitedFromConversation:(XYDConversation *)conversation byClientId:(NSString *)clientId {
//    NSMutableArray *arguments = [[NSMutableArray alloc] init];
//    [self array:arguments addObject:conversation];
//    [self array:arguments addObject:clientId];
//    [XYDChatRuntimeHelper callMethodInMainThreadWithTarget:_delegate selector:@selector(conversation:invitedByClientId:) arguments:arguments];
}

- (void)receiveKickedFromConversation:(XYDConversation *)conversation byClientId:(NSString *)clientId {
//    NSMutableArray *arguments = [[NSMutableArray alloc] init];
//    [self array:arguments addObject:conversation];
//    [self array:arguments addObject:clientId];
//    [XYDChatRuntimeHelper callMethodInMainThreadWithTarget:_delegate selector:@selector(conversation:kickedByClientId:) arguments:arguments];
}

- (void)receiveMembersAddedFromConversation:(XYDConversation *)conversation clientIds:(NSArray *)clientIds byClientId:(NSString *)clientId {
//    NSMutableArray *arguments = [[NSMutableArray alloc] init];
//    [self array:arguments addObject:conversation];
//    [self array:arguments addObject:clientIds];
//    [self array:arguments addObject:clientId];
//    [XYDChatRuntimeHelper callMethodInMainThreadWithTarget:_delegate selector:@selector(conversation:membersAdded:byClientId:) arguments:arguments];
}

- (void)receiveMembersRemovedFromConversation:(XYDConversation *)conversation clientIds:(NSArray *)clientIds byClientId:(NSString *)clientId {
//    NSMutableArray *arguments = [[NSMutableArray alloc] init];
//    [self array:arguments addObject:conversation];
//    [self array:arguments addObject:clientIds];
//    [self array:arguments addObject:clientId];
//    [XYDChatRuntimeHelper callMethodInMainThreadWithTarget:_delegate selector:@selector(conversation:membersRemoved:byClientId:) arguments:arguments];
}

- (void)receivePaused {
//    NSMutableArray *arguments = [[NSMutableArray alloc] init];
//    [self array:arguments addObject:self];
//    [XYDChatRuntimeHelper callMethodInMainThreadWithTarget:_delegate selector:@selector(imClientPaused:) arguments:arguments];
}

- (void)receivePausedWithError:(NSError *)error {
//    [XYDChatRuntimeHelper callMethodInMainThreadWithTarget:_delegate selector:@selector(imClientPaused:error:) arguments:@[self, error]];
}

- (void)receiveResuming {
//    NSMutableArray *arguments = [[NSMutableArray alloc] init];
//    [self array:arguments addObject:self];
//    [XYDChatRuntimeHelper callMethodInMainThreadWithTarget:_delegate selector:@selector(imClientResuming:) arguments:arguments];
}

- (void)receiveResumed {
//    NSMutableArray *arguments = [[NSMutableArray alloc] init];
//    [self array:arguments addObject:self];
//    [XYDChatRuntimeHelper callMethodInMainThreadWithTarget:_delegate selector:@selector(imClientResumed:) arguments:arguments];
}

- (void)receiveError:(NSNotification *)notification {
    if ([_delegate respondsToSelector:@selector(imClientPaused:error:)]) {
        NSError *error = [notification.userInfo objectForKey:@"error"];
        
        [self receivePausedWithError:error];
    } else if ([_delegate respondsToSelector:@selector(imClientPaused:)]) {
        [self receivePaused];
    }
}

static NSDictionary *XYDChatUserOptions = nil;

+ (void)setUserOptions:(NSDictionary *)userOptions {
    if (XYDChatClientHasInstantiated) {
        [NSException raise:NSInternalInconsistencyException format:@"XYDChatClient user options should be set before instantiation"];
    }
    XYDChatUserOptions = userOptions;
}

+ (NSDictionary *)userOptions {
    return XYDChatUserOptions;
}

@end
