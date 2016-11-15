//
//  XYDConversationVCtrl.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/8.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDConversationVCtrl.h"
#import "XYDChatInputBarDelegate.h"
#import "XYDChatMessageCell.h"
#import "XYDConversationViewModel.h"
#import "XYDChatConversationService.h"
#import "XYDChatSessionService.h"
#import "XYDUserDelegate.h"
#import "XYDConversation.h"
#import "XYDChatInputBar.h"
#import "XYDChatStatusView.h"
#import "XYDConversation.h"
#import "XYDConversation+Extionsion.h"
#import "XYDAudioPlayer.h"
#import "XYDChatMessage.h"
#import "XYDUserDelegate.h"
#import "XYDWebViewController.h"

NSString *const XYDConversationVCtrlErrorDomain = @"XYDConversationVCtrlErrorDomain";

@interface XYDConversationVCtrl ()<XYDChatInputBarDelegate,XYDChatMessageCellDelegate,XYDChatConversationViewModelDelegate>

@property (nonatomic, strong, readwrite) XYDConversation *conversation;
//@property (copy, nonatomic) NSString *messageSender /**< 正在聊天的用户昵称 */;
//@property (copy, nonatomic) NSString *XYDChatatarURL /**< 正在聊天的用户头像 */;
/**< 正在聊天的用户 */
@property (nonatomic, copy) id<XYDUserDelegate> user;
/**< 正在聊天的用户clientId */
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, strong) XYDConversationViewModel *chatViewModel;
@property (nonatomic, copy) XYDChatFetchConversationHandler fetchConversationHandler;
@property (nonatomic, copy) XYDChatLoadLatestMessagesHandler loadLatestMessagesHandler;
@property (nonatomic, copy, readwrite) NSString *conversationId;
@property (nonatomic, strong) XYDWebViewController *webViewController;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (nonatomic, assign, getter=isFirstTimeJoinGroup) BOOL firstTimeJoinGroup;

@end

@implementation XYDConversationVCtrl

- (void)setFetchConversationHandler:(XYDChatFetchConversationHandler)fetchConversationHandler {
    _fetchConversationHandler = fetchConversationHandler;
}

- (void)setLoadLatestMessagesHandler:(XYDChatLoadLatestMessagesHandler)loadLatestMessagesHandler {
    _loadLatestMessagesHandler = loadLatestMessagesHandler;
}

#pragma mark -
#pragma mark - initialization Method

- (instancetype)initWithConversationId:(NSString *)conversationId {
    self = [super init];
    if (!self) {
        return nil;
    }
    _conversationId = [conversationId copy];
    [self setup];
    return self;
}

- (instancetype)initWithPeerId:(NSString *)peerId {
    self = [super init];
    if (!self) {
        return nil;
    }
    _peerId = [peerId copy];
    [self setup];
    return self;
}

- (XYDConversation *)getConversationIfExists {
    if (_conversation) {
        return _conversation;
    }
    return nil;
}

/**
 *  lazy load conversation
 *
 *  @return XYDConversation
 */
- (XYDConversation *)conversation {
    if (_conversation) { return _conversation; }
    do {
        /* If object is clean, ignore sXYDChate request. */
        if (_peerId) {
//            [[XYDChatConversationService sharedInstance] fecthConversationWithPeerId:self.peerId callback:^(XYDConversation *conversation, NSError *error) {
//                //SDK没有好友观念，任何两个ID均可会话，请APP层自行处理好友关系。
//                [self refreshConversation:conversation isJoined:YES error:error];
//            }];
            break;
        }
        /* If object is clean, ignore sXYDChate request. */
        if (_conversationId) {
//            [[XYDChatConversationService sharedInstance] fecthConversationWithConversationId:self.conversationId callback:^(XYDConversation *conversation, NSError *error) {
//                if (error) {
//                    //如果用户已经已经被踢出群，此时依然能拿到 Conversation 对象，不会报 4401 错误，需要单独判断。即使后期服务端在这种情况下返回error，这里依然能正确处理。
//                    [self refreshConversation:conversation isJoined:NO error:error];
//                    return;
//                }
//                NSString *currentClientId = [XYDChatSessionService sharedInstance].clientId;
//                //系统对话无成员概念，对应字段的优先顺序 sys > tr > memeber
//                if (conversation.members.count == 0 && (!conversation.transient)) {
//                    [self refreshConversation:conversation isJoined:YES];
//                    return;
//                }
//                BOOL containsCurrentClientId = [conversation.members containsObject:currentClientId];
//                if (containsCurrentClientId) {
//                    [self refreshConversation:conversation isJoined:YES];
//                    return;
//                }
//                if (self.isEnableAutoJoin) {
//                    [conversation joinWithCallback:^(BOOL succeeded, NSError *error) {
//                        [self refreshConversation:conversation isJoined:succeeded error:error];
//                        if (succeeded) {
//                            self.firstTimeJoinGroup = YES;
//                        }
//                    }];
//                } else {
//                    NSInteger code = 4401;
//                    //错误码参考：https://leancloud.cn/docs/realtime_v2.html#%E4%BA%91%E7%AB%AF%E9%94%99%E8%AF%AF%E7%A0%81%E8%AF%B4%E6%98%8E
//                    NSString *errorReasonText = @"INVALID_MESSAGING_TARGET 您已被被管理员移除该群";
//                    NSDictionary *errorInfo = @{
//                                                @"code":@(code),
//                                                NSLocalizedDescriptionKey : errorReasonText,
//                                                };
//                    NSError *error_ = [NSError errorWithDomain:NSStringFromClass([self class])
//                                                          code:code
//                                                      userInfo:errorInfo];
//                    [self refreshConversation:conversation isJoined:NO error:error_];
//                }
//            }];
            break;
        }
    } while (NO);
    return _conversation;
}

#pragma mark - Life Cycle

- (void)setup {
    self.allowScrollToBottom = YES;
    self.loadingMoreMessage = NO;
    self.disableTextShowInFullScreen = NO;
//    BOOL clientStatusOpened = [XYDChatSessionService sharedInstance].client.status == XYDChatIMClientStatusOpened;
//    if (!clientStatusOpened) {
//        [self refreshConversation:nil isJoined:NO];
//        [[XYDChatSessionService sharedInstance] reconnectForViewController:self callback:^(BOOL succeeded, NSError *error) {
//            if (succeeded) {
//                [self conversation];
//            }
//        }];
//    }
}

#ifdef CYLDebugging
- (BOOL)willDealloc {
    if (![super willDealloc]) {
        return NO;
    }
    MLCheck(self.chatViewModel);
    return YES;
}
#endif


/**
 *  lazy load chatViewModel
 *
 *  @return XYDConversationViewModel
 */
- (XYDConversationViewModel *)chatViewModel {
    if (_chatViewModel == nil) {
        XYDConversationViewModel *chatViewModel = [[XYDConversationViewModel alloc] initWithParentViewController:self];
        chatViewModel.delegate = self;
        _chatViewModel = chatViewModel;
    }
    return _chatViewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan = NO;
    self.tableView.delegate = self.chatViewModel;
    self.tableView.dataSource = self.chatViewModel;
    self.chatBar.delegate = self;
    [self.view addSubview:self.chatBar];
    [self.view addSubview:self.clientStatusView];
    [self updateStatusView];
    [self initBarButton];
//    [[XYDChatUserSystemService sharedInstance] fetchCurrentUserInBackground:^(id<XYDChatUserDelegate> user, NSError *error) {
//        self.user = user;
//    }];
    [self.chatViewModel setDefaultBackgroundImage];
    self.navigationItem.title = @"聊天";
//    !self.viewDidLoadBlock ?: self.viewDidLoadBlock(self);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self conversation];
//    !self.viewWillAppearBlock ?: self.viewWillAppearBlock(self, animated);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.chatBar open];
    [self sXYDChateCurrentConversationInfoIfExists];
//    !self.viewDidAppearBlock ?: self.viewDidAppearBlock(self, animated);
}

- (void)loadDraft {
    [self.chatBar appendString:_conversation.xydChat_draft];
    [self.chatBar beginInputing];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self.chatBar close];
    NSString *conversationId = [self getConversationIdIfExists:nil];
    if (conversationId) {
//        [[XYDChatConversationService sharedInstance] updateDraft:self.chatBar.cachedText conversationId:conversationId];
    }
    [self clearCurrentConversationInfo];
    [[XYDAudioPlayer sharePlayer] stopAudioPlayer];
    [XYDAudioPlayer sharePlayer].identifier = nil;
    [XYDAudioPlayer sharePlayer].URLString = nil;
//    !self.viewWillDisappearBlock ?: self.viewWillDisappearBlock(self, animated);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    if (_conversation && (self.chatViewModel.XYDChatMessage.count > 0)) {
//        [[XYDChatConversationService sharedInstance] updateConversationAsRead];
//    }
//    !self.viewDidDisappearBlock ?: self.viewDidDisappearBlock(self, animated);
}

- (void)dealloc {
    _chatViewModel.delegate = nil;
//    !self.viewControllerWillDeallocBlock ?: self.viewControllerWillDeallocBlock(self);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
//    !self.didReceiveMemoryWarningBlock ?: self.didReceiveMemoryWarningBlock(self);
}

#pragma mark -
#pragma mark - public Methods

- (void)sendTextMessage:(NSString *)text {
    if ([text length] > 0 ) {
//        XYDChatMessage *XYDChatMessage = [[XYDChatMessage alloc] initWithText:text
//                                                            senderId:self.userId
//                                                              sender:self.user
//                                                           timestamp:XYDChat_CURRENT_TIMESTAMP
//                                                     serverMessageId:nil];
//        [self makeSureSendValidMessage:XYDChatMessage afterFetchedConversationShouldWithAssert:NO];
//        [self.chatViewModel sendMessage:XYDChatMessage];
    }
}

- (void)sendImages:(NSArray<UIImage *> *)pictures {
    for (UIImage *image in pictures) {
        [self sendImageMessage:image];
    }
}

- (void)sendImageMessage:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
    [self sendImageMessageData:imageData];
}

- (void)sendImageMessageData:(NSData *)imageData {
//    NSString *path = [[XYDChatSettingService sharedInstance] tmpPath];
//    NSError *error;
//    [imageData writeToFile:path options:NSDataWritingAtomic error:&error];
//    UIImage *representationImage = [[UIImage alloc] initWithData:imageData];
//    UIImage *thumbnailPhoto = [representationImage XYDChat_imageByScalingAspectFill];
//    if (error == nil) {
//        XYDChatMessage *message = [[XYDChatMessage alloc] initWithPhoto:representationImage
//                                                   thumbnailPhoto:thumbnailPhoto
//                                                        photoPath:path
//                                                     thumbnailURL:nil
//                                                   originPhotoURL:nil
//                                                         senderId:self.userId
//                                                           sender:self.user
//                                                        timestamp:XYDChat_CURRENT_TIMESTAMP
//                                                  serverMessageId:nil
//                                ];
//        [self makeSureSendValidMessage:message afterFetchedConversationShouldWithAssert:NO];
//        [self.chatViewModel sendMessage:message];
//    } else {
//        [self alert:@"write image to file error"];
//    }
}

- (void)sendVoiceMessageWithPath:(NSString *)voicePath time:(NSTimeInterval)recordingSeconds {
    
//    XYDChatMessage *message = [[XYDChatMessage alloc] initWithVoicePath:voicePath
//                                                         voiceURL:nil
//                                                    voiceDuration:[NSString stringWithFormat:@"%@", @(recordingSeconds)]
//                                                         senderId:self.userId
//                                                           sender:self.user
//                                                        timestamp:XYDChat_CURRENT_TIMESTAMP
//                                                  serverMessageId:nil];
//    [self makeSureSendValidMessage:message afterFetchedConversationShouldWithAssert:NO];
//    [self.chatViewModel sendMessage:message];
}

- (void)sendLocationMessageWithLocationCoordinate:(CLLocationCoordinate2D)locationCoordinate locatioTitle:(NSString *)locationTitle {
    
//    XYDChatMessage *message = [[XYDChatMessage alloc] initWithLocalPositionPhoto:({
//        NSString *imageName = @"message_sender_location";
//        UIImage *image = [UIImage XYDChat_imageNamed:imageName bundleName:@"MessageBubble" bundleForClass:[self class]];
//        image;})
//                                                              geolocations:locationTitle
//                                                                  location:[[CLLocation alloc] initWithLatitude:locationCoordinate.latitude
//                                                                                                      longitude:locationCoordinate.longitude]
//                                                                  senderId:self.userId
//                                                                    sender:self.user
//                                                                 timestamp:XYDChat_CURRENT_TIMESTAMP
//                                                           serverMessageId:nil];
//    [self makeSureSendValidMessage:message afterFetchedConversationShouldWithAssert:NO];
//    [self.chatViewModel sendMessage:message];
}

- (void)sendLocalFeedbackTextMessge:(NSString *)localFeedbackTextMessge {
    [self.chatViewModel sendLocalFeedbackTextMessge:localFeedbackTextMessge];
}

- (void)sendCustomMessage:(XYDChatMessage *)customMessage {
    [self makeSureSendValidMessageAfterFetchedConversation:customMessage];
    [self.chatViewModel sendCustomMessage:customMessage];
}

- (void)sendCustomMessage:(XYDChatMessage *)customMessage
            progressBlock:(XYDChatProgressBlock)progressBlock
                  success:(XYDChatBooleanResultBlock)success
                   failed:(XYDChatBooleanResultBlock)failed {
    [self makeSureSendValidMessageAfterFetchedConversation:customMessage];
    [self.chatViewModel sendCustomMessage:customMessage progressBlock:progressBlock success:success failed:failed];
}

- (void)makeSureSendValidMessageAfterFetchedConversation:(id)message {
    [self makeSureSendValidMessage:message afterFetchedConversationShouldWithAssert:YES];
}

- (void)makeSureSendValidMessage:(id)message afterFetchedConversationShouldWithAssert:(BOOL)withAssert {
    NSString *formatString = @"\n\n\
    ------ BEGIN NSException Log ---------------\n \
    class name: %@                              \n \
    ------line: %@                              \n \
    ----reason: %@                              \n \
    ------ END -------------------------------- \n\n";
    if (!self.isXYDChatailable) {
        NSString *reason = [NSString stringWithFormat:formatString,
                            @(__PRETTY_FUNCTION__),
                            @(__LINE__),
                            @"Remember to check if `isXYDChatailable` is ture, making sure sending message after conversation has been fetched"];
        if (!withAssert) {
//            XYDChatLog(@"🔴类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), reason);
            return;
        }
        NSAssert(NO, reason);
    }
    if ([message isKindOfClass:[XYDChatMessage class]]) {
        return;
    }
    if ([message isKindOfClass:[XYDChatMessage class]]) {
        return;
    }
    if ([[message class] isSubclassOfClass:[XYDChatMessage class]]) {
        NSString *reason = [NSString stringWithFormat:formatString,
                            @(__PRETTY_FUNCTION__),
                            @(__LINE__),
                            @"ChatKit only support sending XYDChatMessage"];
        @throw [NSException exceptionWithName:NSGenericException
                                       reason:reason
                                     userInfo:nil];
    }
}

#pragma mark - UI init

- (void)initBarButton {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backBtn];
}

- (void)clearCurrentConversationInfo {
//    [XYDChatConversationService sharedInstance].currentConversationId = nil;
}

- (void)sXYDChateCurrentConversationInfoIfExists {
//    NSString *conversationId = [self getConversationIdIfExists:nil];
//    if (conversationId) {
//        [XYDChatConversationService sharedInstance].currentConversationId = conversationId;
//    }
//    
//    if (_conversation) {
//        [XYDChatConversationService sharedInstance].currentConversation = self.conversation;
//    }
}

- (void)setupnavigationItemTitleWithConversation:(XYDConversation *)conversation {
//    XYDChatConversationnavigationTitleView *navigationItemTitle = [[XYDChatConversationnavigationTitleView alloc] initWithConversation:conversation navigationController:self.navigationController];
//    navigationItemTitle.frame = CGRectZero;
//    //仅修高度,xyw值不变
//    navigationItemTitle.frame = ({
//        CGRect frame = navigationItemTitle.frame;
//        CGFloat containerViewHeight = self.navigationController.navigationBar.frame.size.height;
//        CGFloat containerViewWidth = self.navigationController.navigationBar.frame.size.width - 130;
//        frame.size.width = containerViewWidth;
//        frame.size.height = containerViewHeight;
//        frame;
//    });
//    self.navigationItem.titleView = navigationItemTitle;
}

- (void)fetchConversationHandler:(XYDConversation *)conversation {
//    XYDChatFetchConversationHandler fetchConversationHandler;
//    do {
//        if (_fetchConversationHandler) {
//            fetchConversationHandler = _fetchConversationHandler;
//            break;
//        }
//        XYDChatFetchConversationHandler generalFetchConversationHandler = [XYDChatConversationService sharedInstance].fetchConversationHandler;
//        if (generalFetchConversationHandler) {
//            fetchConversationHandler = generalFetchConversationHandler;
//            break;
//        }
//    } while (NO);
//    if (fetchConversationHandler) {
//        dispatch_async(dispatch_get_main_queue(),^{
//            fetchConversationHandler(conversation, self);
//        });
//    }
}

- (void)loadLatestMessagesHandler:(BOOL)succeeded error:(NSError *)error {
//    XYDChatLoadLatestMessagesHandler loadLatestMessagesHandler;
//    do {
//        if (_loadLatestMessagesHandler) {
//            loadLatestMessagesHandler = _loadLatestMessagesHandler;
//            break;
//        }
//        XYDChatLoadLatestMessagesHandler generalLoadLatestMessagesHandler = [XYDChatConversationService sharedInstance].loadLatestMessagesHandler;
//        if (generalLoadLatestMessagesHandler) {
//            loadLatestMessagesHandler = generalLoadLatestMessagesHandler;
//            break;
//        }
//    } while (NO);
//    if (loadLatestMessagesHandler) {
//        dispatch_async(dispatch_get_main_queue(),^{
//            loadLatestMessagesHandler(self, succeeded, error);
//        });
//    }
}

- (void)refreshConversation:(XYDConversation *)conversation isJoined:(BOOL)isJoined {
    [self refreshConversation:conversation isJoined:isJoined error:nil];
}

- (NSString *)getConversationIdIfExists:(XYDConversation *)conversation {
    NSString *conversationId;
    do {
        if (self.conversationId) {
            conversationId = self.conversationId;
            break;
        }
        if (_conversation) {
            conversationId = self.conversation.conversationId;
            break;
        }
        if (conversation) {
            conversationId = conversation.conversationId;
            break;
        }
    } while (NO);
    return conversationId;
}

- (void)notJoinedHandler:(XYDConversation *)conversation error:(NSError *)aError {
    void(^notJoinedHandler)(id<XYDUserDelegate> user, NSError *error) = ^(id<XYDUserDelegate> user, NSError *error) {
//        XYDChatConversationInvalidedHandler conversationInvalidedHandler = [[XYDChatConversationService sharedInstance] conversationInvalidedHandler];
//        NSString *conversationId = [self getConversationIdIfExists:conversation];
//        //错误码参考：https://leancloud.cn/docs/realtime_v2.html#%E4%BA%91%E7%AB%AF%E9%94%99%E8%AF%AF%E7%A0%81%E8%AF%B4%E6%98%8E
//        if (error.code == 4401 && conversationId.length > 0) {
//            //如果被管理员踢出群之后，再进入该会话，本地可能有缓存，要清除掉，防止下次再次进入。
//            [[XYDChatConversationService sharedInstance] deleteRecentConversationWithConversationId:conversationId];
//        }
//        conversationInvalidedHandler(conversationId, self, user, error);
    };
    
    if (conversation && (conversation.creator.length > 0)) {
//        [[XYDChatUserSystemService sharedInstance] getProfilesInBackgroundForUserIds:@[ conversation.creator ] callback:^(NSArray<id<XYDChatUserDelegate>> *users, NSError *error) {
//            id<XYDChatUserDelegate> user;
//            @try {
//                user = users[0];
//            } @catch (NSException *exception) {}
//            !notJoinedHandler ?: notJoinedHandler(user, aError);
//        }];
    } else {
        !notJoinedHandler ?: notJoinedHandler(nil, aError);
    }
}

/*!
 * conversation 不一定有值，可能为 nil
 */
- (void)refreshConversation:(XYDConversation *)aConversation isJoined:(BOOL)isJoined error:(NSError *)error {
    if (error) {
        [self notJoinedHandler:aConversation error:error];
        aConversation = nil;
    }
    
    XYDConversation *conversation;
    if (isJoined && !error) {
        conversation = aConversation;
    }
    _conversation = conversation;
    [self sXYDChateCurrentConversationInfoIfExists];
    [self callbackCurrentConversationEvenNotExists:conversation callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self handleLoadHistoryMessagesHandlerIfIsJoined:isJoined];
        }
    }];
}

- (void)callbackCurrentConversationEvenNotExists:(XYDConversation *)conversation callback:(XYDChatBooleanResultBlock)callback {
//    if (conversation.createAt) {
//        if (!conversation.imClient) {
//            [conversation setValue:[XYDChatSessionService sharedInstance].client forKey:@"imClient"];
//            XYDChatLog(@"🔴类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), @"imClient is nil");
//        }
//        BOOL hasDraft = (conversation.XYDChat_draft.length > 0);
//        if (hasDraft) {
//            [self loadDraft];
//        }
//        self.conversationId = conversation.conversationId;
//        [self.chatViewModel resetBackgroundImage];
//        //系统对话
//        if (conversation.members.count == 0) {
//            self.navigationItem.title = conversation.XYDChat_title;
//            [self fetchConversationHandler:conversation];
//            !callback ?: callback(YES, nil);
//            return;
//        }
//        [[LCChatKit sharedInstance] getProfilesInBackgroundForUserIds:conversation.members callback:^(NSArray<id<XYDChatUserDelegate>> *users, NSError *error) {
//            if (!self.disableTitleAutoConfig && (users.count > 0)) {
//                [self setupnavigationItemTitleWithConversation:conversation];
//            }
//            [self fetchConversationHandler:conversation];
//            !callback ?: callback(YES, nil);
//        }];
//    } else {
//        [self fetchConversationHandler:conversation];
//        NSInteger code = 0;
//        NSString *errorReasonText = @"error reason";
//        NSDictionary *errorInfo = @{
//                                    @"code":@(code),
//                                    NSLocalizedDescriptionKey : errorReasonText,
//                                    };
//        NSError *error = [NSError errorWithDomain:NSStringFromClass([self class])
//                                             code:code
//                                         userInfo:errorInfo];
//        
//        !callback ?: callback(NO, error);
//    }
}

- (BOOL)isXYDChatailable {
    BOOL isXYDChatailable = self.conversation;
    return isXYDChatailable;
}

//TODO:Conversation为nil,不callback
- (void)handleLoadHistoryMessagesHandlerIfIsJoined:(BOOL)isJoined {
    if (!isJoined) {
        BOOL succeeded = NO;
        //错误码参考：https://leancloud.cn/docs/realtime_v2.html#服务器端错误码说明
        NSInteger code = 4312;
        NSString *errorReasonText = @"拉取对话消息记录被拒绝，当前用户不再对话中";
        NSDictionary *errorInfo = @{
                                    @"code" : @(code),
                                    NSLocalizedDescriptionKey : errorReasonText,
                                    };
        NSError *error = [NSError errorWithDomain:XYDConversationVCtrlErrorDomain
                                             code:code
                                         userInfo:errorInfo];
        [self loadLatestMessagesHandler:succeeded error:error];
        return;
    }
    __weak __typeof(self) weakSelf = self;
    [self.chatViewModel loadMessagesFirstTimeWithCallback:^(BOOL succeeded, id object, NSError *error) {
        dispatch_async(dispatch_get_main_queue(),^{
            [weakSelf loadLatestMessagesHandler:succeeded error:error];
            BOOL isFirstTimeMeet = (([object count] == 0) && succeeded);
            [self sendWelcomeMessageIfNeeded:isFirstTimeMeet];
        });
    }];
}

- (void)sendWelcomeMessageIfNeeded:(BOOL)isFirstTimeMeet {
//    //系统对话
//    if (_conversation.members.count == 0) {
//        return;
//    }
//    __block NSString *welcomeMessage;
//    XYDChatConversationType conversationType = _conversation.XYDChat_type;
//    switch (conversationType) {
//        case XYDChatConversationTypeSingle:
//            welcomeMessage = XYDChatLocalizedStrings(@"SingleWelcomeMessage");
//            break;
//        case XYDChatConversationTypeGroup:
//            welcomeMessage = XYDChatLocalizedStrings(@"GroupWelcomeMessage");
//            break;
//        default:
//            break;
//    }
//    BOOL isAllowInUserSetting = ([welcomeMessage length] > 0);
//    if (!isAllowInUserSetting) {
//        return;
//    }
//    BOOL isSessionavailable = [XYDChatSessionService sharedInstance].connect;
//    BOOL isNeverChat = (isSessionavailable && isFirstTimeMeet);
//    BOOL shouldSendWelcome = self.isFirstTimeJoinGroup || isNeverChat;
//    if (shouldSendWelcome) {
//        [[XYDChatUserSystemService sharedInstance] fetchCurrentUserInBackground:^(id<XYDChatUserDelegate> user, NSError *error) {
//            NSString *userName = user.name;
//            if (userName.length > 0 && (conversationType == XYDChatConversationTypeGroup)) {
//                welcomeMessage = [NSString stringWithFormat:@"%@%@", XYDChatLocalizedStrings(@"GroupWelcomeMessageWithNickName"), userName];
//            }
//            [self sendTextMessage:welcomeMessage];
//        }];
//    }
}

- (NSString *)userId {
//    return [LCChatKit sharedInstance].clientId;
    return nil;
}

#pragma mark - XYDChatInputBarDelegate

- (void)chatBar:(XYDChatInputBar *)chatBar sendMessage:(NSString *)message {
    [self sendTextMessage:message];
}

- (void)chatBar:(XYDChatInputBar *)chatBar sendVoice:(NSString *)voiceFileName seconds:(NSTimeInterval)seconds{
    [self sendVoiceMessageWithPath:voiceFileName time:seconds];
}

- (void)chatBar:(XYDChatInputBar *)chatBar sendPictures:(NSArray<UIImage *> *)pictures{
    [self sendImages:pictures];
}

- (void)didInputAtSign:(XYDChatInputBar *)chatBar {
//    //系统对话
//    if (_conversation.members.count == 0) {
//        return;
//    }
//    if (self.conversation.XYDChat_type == XYDChatConversationTypeGroup) {
//        [self presentSelectMemberViewController];
//    }
}

- (void)presentSelectMemberViewController {
//    NSString *cuttentClientId = [XYDChatSessionService sharedInstance].clientId;
//    NSArray<id<XYDChatUserDelegate>> *users = [[XYDChatUserSystemService sharedInstance] getCachedProfilesIfExists:self.conversation.members shouldSameCount:YES error:nil];
//    XYDChatContactListViewController *contactListViewController = [[XYDChatContactListViewController alloc] initWithContacts:[NSSet setWithArray:users] userIds:[NSSet setWithArray:self.conversation.members] excludedUserIds:[NSSet setWithArray:@[cuttentClientId]] mode:XYDChatContactListModeMultipleSelection];
//    [contactListViewController setViewDidDismissBlock:^(XYDChatBaseViewController *viewController) {
//        [self.chatBar open];
//        [self.chatBar beginInputing];
//    }];
//    [contactListViewController setSelectedContactCallback:^(UIViewController *viewController, NSString *peerId) {
//        [viewController dismissViewControllerAnimated:YES completion:^{
//            [self.chatBar open];
//        }];
//        if (peerId.length > 0) {
//            NSArray *peerNames = [[LCChatKit sharedInstance] getCachedProfilesIfExists:@[peerId] error:nil];
//            NSString *peerName;
//            @try {
//                id<XYDChatUserDelegate> user = peerNames[0];
//                peerName = user.name ?: user.clientId;
//            } @catch (NSException *exception) {
//                peerName = peerId;
//            }
//            peerName = [NSString stringWithFormat:@"@%@ ", peerName];
//            [self.chatBar appendString:peerName];
//        }
//    }];
//    [contactListViewController setSelectedContactsCallback:^(UIViewController *viewController, NSArray<NSString *> *peerIds) {
//        if (peerIds.count > 0) {
//            NSArray<id<XYDChatUserDelegate>> *peers = [[XYDChatUserSystemService sharedInstance] getCachedProfilesIfExists:peerIds error:nil];
//            NSMutableArray *peerNames = [NSMutableArray arrayWithCapacity:peers.count];
//            [peers enumerateObjectsUsingBlock:^(id<XYDChatUserDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                if (obj.name) {
//                    [peerNames addObject:obj.name];
//                } else {
//                    [peerNames addObject:obj.clientId];
//                }
//            }];
//            NSArray *realPeerNames;
//            if (peerNames.count > 0) {
//                realPeerNames = peerNames;
//            } else {
//                realPeerNames = peerIds;
//            }
//            NSString *peerName = [[realPeerNames valueForKey:@"description"] componentsJoinedByString:@" @"];
//            peerName = [NSString stringWithFormat:@"@%@ ", peerName];
//            [self.chatBar appendString:peerName];
//        }
//    }];
//    UInavigationController *navigationController = [[UInavigationController alloc] initWithRootViewController:contactListViewController];
//    [self presentViewController:navigationController animated:YES completion:^{
//        [self.chatBar close];
//    }];
}

- (void)chatBar:(XYDChatInputBar *)chatBar sendLocation:(CLLocationCoordinate2D)locationCoordinate locationText:(NSString *)locationText {
    [self sendLocationMessageWithLocationCoordinate:locationCoordinate locatioTitle:locationText];
}

- (void)chatBarFrameDidChange:(XYDChatInputBar *)chatBar shouldScrollToBottom:(BOOL)shouldScrollToBottom {
    [UIView animateWithDuration:XYDChatAnimateDuration animations:^{
        [self.tableView layoutIfNeeded];
        self.allowScrollToBottom = shouldScrollToBottom;
        [self scrollToBottomAnimated:NO];
    } completion:nil];
}


#pragma mark - XYDChatMessageCellDelegate

- (void)messageCellTappedHead:(XYDChatMessageCell *)messageCell {
//    XYDChatOpenProfileBlock openProfileBlock = [XYDChatUIService sharedInstance].openProfileBlock;
//    !openProfileBlock ?: openProfileBlock(messageCell.message.senderId, messageCell.message.sender, self);
}

- (void)messageCellTappedBlank:(XYDChatMessageCell *)messageCell {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)messageCellTappedMessage:(XYDChatMessageCell *)messageCell {
//    if (!messageCell) {
//        return;
//    }
//    [self.chatBar close];
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:messageCell];
//    XYDChatMessage *message = [self.chatViewModel.dataArray XYDChat_messageAtIndex:indexPath.row];
//    switch (messageCell.mediaType) {
//        case kXYDChatIMMessageMediaTypeAudio: {
//            NSString *voiceFileName = message.voicePath;//必须带后缀，.mp3；
//            [[XYDChatXYDChatAudioPlayer sharePlayer] playAudioWithURLString:voiceFileName identifier:message.messageId];
//        }
//            break;
//        case kXYDChatIMMessageMediaTypeImage: {
//            ///FIXME:4S等低端机型在图片超过1M时，有几率会Crash，尤其是全景图。
//            XYDChatPreviewImageMessageBlock previewImageMessageBlock = [XYDChatUIService sharedInstance].previewImageMessageBlock;
//            UIImageView *placeholderView = [(XYDChatImageMessageCell *)messageCell messageImageView];
//            NSDictionary *userInfo = @{
//                                       /// 传递触发的UIViewController对象
//                                       XYDChatPreviewImageMessageUserInfoKeyFromController : self,
//                                       /// 传递触发的UIView对象
//                                       XYDChatPreviewImageMessageUserInfoKeyFromView : self.tableView,
//                                       XYDChatPreviewImageMessageUserInfoKeyFromPlaceholderView : placeholderView
//                                       };
//            NSArray *allVisibleImages = nil;
//            NSArray *allVisibleThumbs = nil;
//            NSNumber *selectedMessageIndex = nil;
//            [self.chatViewModel getAllVisibleImagesForSelectedMessage:messageCell.message allVisibleImages:&allVisibleImages allVisibleThumbs:&allVisibleThumbs selectedMessageIndex:&selectedMessageIndex];
//            
//            if (previewImageMessageBlock) {
//                previewImageMessageBlock(selectedMessageIndex.unsignedIntegerValue, allVisibleImages, allVisibleThumbs, userInfo);
//            } else {
//                [self previewImageMessageWithInitialIndex:selectedMessageIndex.unsignedIntegerValue allVisibleImages:allVisibleImages allVisibleThumbs:allVisibleThumbs placeholderImageView:placeholderView fromViewController:self];
//            }
//        }
//            break;
//        case kXYDChatIMMessageMediaTypeLocation: {
//            NSDictionary *userInfo = @{
//                                       /// 传递触发的UIViewController对象
//                                       XYDChatPreviewLocationMessageUserInfoKeyFromController : self,
//                                       /// 传递触发的UIView对象
//                                       XYDChatPreviewLocationMessageUserInfoKeyFromView : self.tableView,
//                                       };
//            XYDChatPreviewLocationMessageBlock previewLocationMessageBlock = [XYDChatUIService sharedInstance].previewLocationMessageBlock;
//            !previewLocationMessageBlock ?: previewLocationMessageBlock(message.location, message.geolocations, userInfo);
//        }
//            break;
//        default: {
//            //            //TODO:自定义消息的点击事件
//            //            NSString *formatString = @"\n\n\
//            //            ------ BEGIN NSException Log ---------------\n \
//            //            class name: %@                              \n \
//            //            ------line: %@                              \n \
//            //            ----reason: %@                              \n \
//            //            ------ END -------------------------------- \n\n";
//            //            NSString *reason = [NSString stringWithFormat:formatString,
//            //                                @(__PRETTY_FUNCTION__),
//            //                                @(__LINE__),
//            //                                @"messageCell.messageType not handled"];
//            //            //手动创建一个异常导致的崩溃事件 http://is.gd/EfVfN0
//            //            @throw [NSException exceptionWithName:NSGenericException
//            //                                           reason:reason
//            //                                         userInfo:nil];
//        }
//            break;
//    }
//    [self.chatBar open];
}

- (void)previewImageMessageWithInitialIndex:(NSUInteger)initialIndex
                           allVisibleImages:(NSArray *)allVisibleImages
                           allVisibleThumbs:(NSArray *)allVisibleThumbs
                       placeholderImageView:(UIImageView *)placeholderImageView
                         fromViewController:(XYDConversationVCtrl *)fromViewController{
//    // Browser
//    NSMutableArray *photos = [[NSMutableArray alloc] initWithCapacity:[allVisibleImages count]];
//    NSMutableArray *thumbs = [[NSMutableArray alloc] initWithCapacity:[allVisibleThumbs count]];
//    XYDChatPhoto *photo;
//    for (NSUInteger index = 0; index < allVisibleImages.count; index++) {
//        id image_ = allVisibleImages[index];
//        
//        if ([image_ isKindOfClass:[UIImage class]]) {
//            photo = [XYDChatPhoto photoWithImage:image_];
//        } else {
//            photo = [XYDChatPhoto photoWithURL:image_];
//        }
//        if (index == initialIndex) {
//            photo.placeholderImageView = placeholderImageView;
//        }
//        [photos addObject:photo];
//    }
//    // Options
//    self.photos = photos;
//    self.thumbs = thumbs;
//    // Create browser
//    XYDChatPhotoBrowser *browser = [[XYDChatPhotoBrowser alloc] initWithPhotos:photos];
//    browser.delegate = self;
//    [browser setInitialPageIndex:initialIndex];
//    browser.usePopAnimation = YES;
//    browser.animationDuration = 0.15;
//    // Show
//    [fromViewController presentViewController:browser animated:YES completion:nil];
}

- (void)avatarImageViewLongPressed:(XYDChatMessageCell *)messageCell {
//    if (messageCell.message.senderId == [LCChatKit sharedInstance].clientId || self.conversation.XYDChat_type == XYDChatConversationTypeSingle) {
//        return;
//    }
//    NSString *userName = messageCell.message.localDisplayName;
//    if (userName.length == 0 || !userName || [userName isEqualToString:XYDChatLocalizedStrings(@"nickNameIsNil")]) {
//        return;
//    }
//    NSString *appendString = [NSString stringWithFormat:@"@%@ ", userName];
//    [self.chatBar appendString:appendString];
}

- (void)textMessageCellDoubleTapped:(XYDChatMessageCell *)messageCell {
//    if (self.disableTextShowInFullScreen) {
//        return;
//    }
//    XYDChatTextFullScreenViewController *textFullScreenViewController = [[XYDChatTextFullScreenViewController alloc] initWithText:messageCell.message.text];
//    [self.navigationController pushViewController:textFullScreenViewController animated:NO];
}

- (void)resendMessage:(XYDChatMessageCell *)messageCell {
    [self.chatViewModel resendMessageForMessageCell:messageCell];
}

- (void)fileMessageDidDownload:(XYDChatMessageCell *)messageCell {
    [self reloadAfterReceiveMessage];
}

- (void)messageCell:(XYDChatMessageCell *)messageCell didTapLinkText:(NSString *)linkText linkType:(MLLinkType)linkType {
//    switch (linkType) {
//        case MLLinkTypeURL: {
//            linkText =  [linkText lowercaseString];
//            XYDChatWebViewController *webViewController = [[XYDChatWebViewController alloc] init];
//            if (![linkText hasPrefix:@"http"]) {
//                linkText = [NSString stringWithFormat:@"http://%@", linkText];
//            }
//            webViewController.URL = [NSURL URLWithString:linkText];
//            XYDChatSafariActivity *activity = [[XYDChatSafariActivity alloc] init];
//            webViewController.applicationActivities = @[activity];
//            webViewController.excludedActivityTypes = @[UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypePostToWeibo];
//            [self.navigationController pushViewController:webViewController animated:YES];
//        }
//            break;
//        case MLLinkTypePhoneNumber: {
//            NSString *title = [NSString stringWithFormat:@"%@?", XYDChatLocalizedStrings(@"call")];
//            XYDChatAlertController *alert = [XYDChatAlertController alertControllerWithTitle:title
//                                                                               message:@""
//                                                                        preferredStyle:XYDChatAlertControllerStyleAlert];
//            NSString *cancelActionTitle = XYDChatLocalizedStrings(@"cancel");
//            XYDChatAlertAction* cancelAction = [XYDChatAlertAction actionWithTitle:cancelActionTitle style:XYDChatAlertActionStyleDefault
//                                                                     handler:^(XYDChatAlertAction * action) {}];
//            [alert addAction:cancelAction];
//            NSString *resendActionTitle = XYDChatLocalizedStrings(@"call");
//            XYDChatAlertAction* resendAction = [XYDChatAlertAction actionWithTitle:resendActionTitle style:XYDChatAlertActionStyleDefault
//                                                                     handler:^(XYDChatAlertAction * action) {
//                                                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat: @"tel:%@", linkText]]];
//                                                                     }];
//            [alert addAction:resendAction];
//            [alert showWithSender:nil controller:self animated:YES completion:NULL];
//        }
//            break;
//        default:
//            break;
//    }
}

#pragma mark - XYDConversationViewModelDelegate

- (void)messageReadStateChanged:(XYDChatMessageReadState)readState withProgress:(CGFloat)progress forIndex:(NSUInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    XYDChatMessageCell *messageCell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (![self.tableView.visibleCells containsObject:messageCell]) {
        return;
    }
    messageCell.messageReadState = readState;
}

- (void)messageSendStateChanged:(XYDChatMessageSendState)sendState withProgress:(CGFloat)progress forIndex:(NSUInteger)index {
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//    XYDChatMessageCell *messageCell = [self.tableView cellForRowAtIndexPath:indexPath];
//    if (![self.tableView.visibleCells containsObject:messageCell]) {
//        return;
//    }
//    if (messageCell.mediaType == kXYDChatIMMessageMediaTypeImage) {
//        [(XYDChatImageMessageCell *)messageCell setUploadProgress:progress];
//    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//        messageCell.messageSendState = sendState;
//    });
}

- (void)reloadAfterReceiveMessage {
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
}

#pragma mark - XYDChatXYDChatAudioPlayerDelegate

- (void)loadMoreMessagesScrollTotop {
    [self.chatViewModel loadOldMessages];
}

- (void)updateStatusView {
//    if (!self.shouldCheckSessionStatus) {
//        return;
//    }
//    BOOL isConnected = [XYDChatSessionService sharedInstance].connect;
//    if (isConnected) {
//        self.clientStatusView.hidden = YES;
//    } else {
//        self.clientStatusView.hidden = NO;
//    }
}



@end
