//
//  XYDConversationViewModel.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/8.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDConversationViewModel.h"
#import "XYDConversationVCtrl.h"
#import "XYDChatMessage.h"
#import "NSObject+XYDAssociatedObject.h"
#import "XYDChatCellIdentifierFactory.h"
#import "XYDConversation.h"
#import "XYDConversation+Extionsion.h"
#import "XYDChatMessageCell.h"

#import "XYDChatSessionService.h"
#import "XYDChatSettingService.h"
#import "XYDChatConversationService.h"

#import "XYDSoundManager.h"
#import "XYDChatHelper.h"

#import "UITableView+FDTemplateLayoutCell.h"

@interface XYDConversationViewModel ()

@property (nonatomic, weak) XYDConversationVCtrl *parentConversationViewController;
@property (nonatomic, strong) NSMutableArray *dataArray;

/*!
 * 懒加载，只在下拉刷新和第一次进入时，做消息流插入，所以在conversationViewController的生命周期里，只load一次就可以。
 */
@property (nonatomic, copy) NSArray *allFailedMessageIds;
@property (nonatomic, strong) NSArray *allFailedMessages;

@end

@implementation XYDConversationViewModel

- (instancetype)initWithParentViewController:(XYDConversationVCtrl *)parentConversationViewController {
    if (self = [super init]) {
        _dataArray = [NSMutableArray array];
        self.parentConversationViewController = parentConversationViewController;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:XYDChatNotificationMessageReceived object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conversationInvalided:) name:XYDChatNotificationCurrentConversationInvalided object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backgroundImageChanged:) name:XYDChatNotificationConversationViewControllerBackgroundImageDidChanged object:nil];
        __unsafe_unretained typeof(self) weakSelf = self;
        [self xyd_executeAtDealloc:^{
            weakSelf.delegate = nil;
            [[NSNotificationCenter defaultCenter] removeObserver:weakSelf];
        }];
    }
    return self;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id message = self.dataArray[indexPath.row];
    NSString *identifier = [XYDChatCellIdentifierFactory cellIdentifierForMessageConfiguration:message conversationType:[self.parentConversationViewController getConversationIfExists].xydChat_type];
    XYDChatMessageCell *messageCell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    messageCell.tableView = self.parentConversationViewController.tableView;
    messageCell.indexPath = indexPath;
    [messageCell configureCellWithData:message];
    messageCell.delegate = self.parentConversationViewController;
    return messageCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id message = self.dataArray[indexPath.row];
    NSString *identifier = [XYDChatCellIdentifierFactory cellIdentifierForMessageConfiguration:message conversationType:[self.parentConversationViewController getConversationIfExists].xydChat_type];
    return [tableView fd_heightForCellWithIdentifier:identifier cacheByIndexPath:indexPath configuration:^(XYDChatMessageCell *cell) {
        [cell configureCellWithData:message];
    }];
}

#pragma mark - XYDChatChatServerDelegate

- (void)receiveMessage:(NSNotification *)notification {
    NSDictionary *userInfo = notification.object;
    if (!userInfo) {
        return;
    }
    __block NSArray<XYDChatMessage *> *messages = userInfo[XYDChatDidReceiveMessagesUserInfoMessagesKey];
    XYDConversation *conversation = userInfo[XYDChatDidReceiveMessagesUserInfoConversationKey];
    BOOL isCurrentConversationMessage = [conversation.conversationId isEqualToString:self.parentConversationViewController.conversationId];
    if (!isCurrentConversationMessage) {
        return;
    }
    XYDConversation *currentConversation = [self.parentConversationViewController getConversationIfExists];
    if (currentConversation.muted == NO) {
        [[XYDSoundManager defaultManager] playReceiveSoundIfNeed];
    }
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
//        NSArray *XYDChatMessages = [NSMutableArray xydChat_messagesWithAVIMMessages:messages];
//        dispatch_async(dispatch_get_main_queue(),^{
//            
//        });
//    });
}

- (void)backgroundImageChanged:(NSNotification *)notification {
    NSDictionary *userInfo = notification.object;
    if (!userInfo) {
        return;
    }
    NSString *userInfoConversationId = userInfo[XYDChatNotificationConversationViewControllerBackgroundImageDidChangedUserInfoConversationIdKey];
    NSString *conversationId = self.parentConversationViewController.conversationId;
    BOOL isCurrentConversationMessage = [userInfoConversationId isEqualToString:conversationId];
    if (!isCurrentConversationMessage) {
        return;
    }
    [self resetBackgroundImage];
}

- (void)setDefaultBackgroundImage {
    UIImage *image = [self imageInBundlePathForImageName:@"conversationViewController_default_backgroundImage"];
    [self.parentConversationViewController.view setBackgroundColor:[UIColor colorWithPatternImage:image]];
}

- (void)resetBackgroundImage {
    NSString *conversationId = self.parentConversationViewController.conversationId;
//    NSString *conversationViewControllerBackgroundImageKey = [NSString stringWithFormat:@"%@%@_%@", XYDChatCustomConversationViewControllerBackgroundImageNamePrefix, [XYDChatSessionService sharedInstance].clientId, conversationId];
    NSString *conversationViewControllerBackgroundImageKey = nil;
    NSString *conversationViewControllerBackgroundImage = [[NSUserDefaults standardUserDefaults] objectForKey:conversationViewControllerBackgroundImageKey];
    if (conversationViewControllerBackgroundImage == nil) {
        conversationViewControllerBackgroundImage = [[NSUserDefaults standardUserDefaults] objectForKey:XYDChatDefaultConversationViewControllerBackgroundImageName];
        if (conversationViewControllerBackgroundImage == nil) {
            [self setDefaultBackgroundImage];
        } else {
            NSString *imagePath = [XYDChatHelper getPathForConversationBackgroundImage];
            UIImage *image = [UIImage imageNamed:imagePath];
            [self.parentConversationViewController.view setBackgroundColor:[UIColor colorWithPatternImage:image]];
        }
    } else {
        NSString *imagePath = [XYDChatHelper getPathForConversationBackgroundImage];
        UIImage *image = [UIImage imageNamed:imagePath];
        [self.parentConversationViewController.view setBackgroundColor:[UIColor colorWithPatternImage:image]];
    }
}

- (void)receivedNewMessages:(NSArray *)messages {
    [self appendMessagesToTrailing:messages];
    if ([self.delegate respondsToSelector:@selector(reloadAfterReceiveMessage)]) {
        [self.delegate reloadAfterReceiveMessage];
    }
}

- (void)conversationInvalided:(NSNotification *)notification {
//    NSString *clientId = notification.object;
//    [[LCChatKit sharedInstance] deleteRecentConversationWithConversationId:self.currentConversationId];
//    [[XYDChatUserSystemService sharedInstance] getProfilesInBackgroundForUserIds:@[ clientId ] callback:^(NSArray<id<XYDChatUserDelegate>> *users, NSError *error) {
//        id<XYDChatUserDelegate> user;
//        @try {
//            user = users[0];
//        } @catch (NSException *exception) {}
//        
//        NSInteger code = 4401;
//        //错误码参考：https://leancloud.cn/docs/realtime_v2.html#%E4%BA%91%E7%AB%AF%E9%94%99%E8%AF%AF%E7%A0%81%E8%AF%B4%E6%98%8E
//        NSString *errorReasonText = @"INVALID_MESSAGING_TARGET 您已被被管理员移除该群";
//        NSDictionary *errorInfo = @{
//                                    @"code":@(code),
//                                    NSLocalizedDescriptionKey : errorReasonText,
//                                    };
//        NSError *error_ = [NSError errorWithDomain:NSStringFromClass([self class])
//                                              code:code
//                                          userInfo:errorInfo];
//        
//        XYDChatConversationInvalidedHandler conversationInvalidedHandler = [[XYDChatConversationService sharedInstance] conversationInvalidedHandler];
//        if (conversationInvalidedHandler) {
//            conversationInvalidedHandler(self.currentConversation.conversationId, self.parentConversationViewController, user, error_);
//        }
//    }];
}

- (void)appendMessagesToTrailing:(NSArray *)messages {
    id lastObject = (self.dataArray.count > 0) ? [self.dataArray lastObject] : nil;
    [self appendMessagesToDataArrayTrailing:[self messagesWithSystemMessages:messages lastMessage:lastObject]];
}

- (void)appendMessagesToDataArrayTrailing:(NSArray *)messages {
    if (messages.count > 0) {
        @synchronized (self) {
            [self.dataArray addObjectsFromArray:messages];
        }
    }
}

/*!
 * 与`-addMessages`方法的区别在于，第一次加载历史消息时需要查找最后一条消息之余还有没有消息。
 * 时间戳必须传0，后续方法会根据是否为了0，来判断是否是第一次进对话页面。
 */
- (void)addMessagesFirstTime:(NSArray *)messages {
    [self appendMessagesToDataArrayTrailing:[self messagesWithLocalMessages:messages freshTimestamp:0]];
}

/**
 *  lazy load allFailedMessages
 *
 *  @return NSArray
 */
- (NSArray *)allFailedMessages {
    if (_allFailedMessages == nil) {
//        NSArray *allFailedMessages = [[XYDChatConversationService sharedInstance] failedMessagesByConversationId:self.currentConversationId];
//        _allFailedMessages = allFailedMessages;
    }
    return _allFailedMessages;
}

/**
 *  lazy load allFailedMessageIds
 *
 *  @return NSArray
 */
- (NSArray *)allFailedMessageIds {
    if (_allFailedMessageIds == nil) {
//        NSArray *allFailedMessageIds = [[XYDChatConversationService sharedInstance] failedMessageIdsByConversationId:self.parentConversationViewController.conversationId];
//        _allFailedMessageIds = allFailedMessageIds;
    }
    return _allFailedMessageIds;
}

- (NSArray<XYDChatMessage *> *)failedMessagesWithPredicate:(NSPredicate *)predicate {
    NSArray *allFailedMessageIdsByConversationId = self.allFailedMessageIds;
    NSArray *failedMessageIds = [allFailedMessageIdsByConversationId filteredArrayUsingPredicate:predicate];
    NSArray<XYDChatMessage *> *failedXYDChatMessages;
    if (failedMessageIds.count > 0) {
//        failedXYDChatMessages = [[XYDChatConversationService sharedInstance] failedMessagesByMessageIds:failedMessageIds];
    }
    return failedXYDChatMessages;
}

/*!
 * @param messages 从服务端刷新下来的，夹杂着本地失败消息（但还未插入原有的旧消息self.dataArray里)。
 * 该方法能让preload时动态判断插入时间戳，同时也用在第一次加载时插入时间戳。
 */
- (NSArray *)messagesWithSystemMessages:(NSArray *)messages lastMessage:(id)lastMessage {
    NSMutableArray *messageWithSystemMessages = lastMessage ? @[lastMessage].mutableCopy : @[].mutableCopy;
    for (id message in messages) {
        [messageWithSystemMessages addObject:message];
//        [message xydChat_shouldDisplayTimestampForMessages:messageWithSystemMessages callback:^(BOOL shouldDisplayTimestamp, NSTimeInterval messageTimestamp) {
//            if (shouldDisplayTimestamp) {
//                [messageWithSystemMessages insertObject:[XYDChatMessage systemMessageWithTimestamp:messageTimestamp] atIndex:(messageWithSystemMessages.count - 1)];
//            }
//        }];
    }
    if (lastMessage) {
        [messageWithSystemMessages removeObjectAtIndex:0];
    }
    return [messageWithSystemMessages copy];
}

/*!
 * 用于加载历史记录，首次进入加载以及下拉刷新加载。
 */
- (NSArray *)messagesWithSystemMessages:(NSArray *)messages {
    return [self messagesWithSystemMessages:messages lastMessage:nil];
}

- (NSArray *)oldestFailedMessagesBeforeMessage:(id)message {
//    NSString *startDate = [NSString stringWithFormat:@"%@", @([message xydChat_messageTimestamp])];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF <= %@) AND (SELF MATCHES %@)", startDate, xydChat_TIMESTAMP_REGEX];
//    NSArray<XYDChatMessage *> *failedXYDChatMessages = [self failedMessagesWithPredicate:predicate];
//    return failedXYDChatMessages;
    return nil;
}

/*!
 * freshTimestamp 下拉刷新的时间戳, 为0表示从当前时间开始查询。
 * //TODO:自定义消息暂时不支持失败缓存
 * @param messages 服务端返回到消息，如果一次拉去的是10条，那么这个数组将是10条，或少于10条。
 */
- (NSArray *)messagesWithLocalMessages:(NSArray *)messages freshTimestamp:(int64_t)timestamp {
    NSMutableArray *messagesWithLocalMessages = [NSMutableArray arrayWithCapacity:messages.count];
    BOOL shouldLoadMoreMessagesScrollToTop = self.parentConversationViewController.shouldLoadMoreMessagesScrollToTop;
    //情况一：当前对话，没有历史消息，只有失败消息的情况，直接返回数据库所有失败消息
    if (!shouldLoadMoreMessagesScrollToTop && messages.count == 0 && (timestamp == 0)) {
        NSArray *failedMessagesByConversationId = self.allFailedMessages;
        messagesWithLocalMessages = [NSMutableArray arrayWithArray:failedMessagesByConversationId];
        return [self messagesWithSystemMessages:messagesWithLocalMessages];
    }
    //情况二：正常情况，服务端有消息返回
    
    //服务端的历史纪录已经加载完成，将比服务端最旧的一条消息还旧的失败消息拼接到顶端。
    if (!shouldLoadMoreMessagesScrollToTop && messages.count > 0) {
        id message = messages[0];
        NSArray *oldestFailedMessagesBeforeMessage = [self oldestFailedMessagesBeforeMessage:message];
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:oldestFailedMessagesBeforeMessage];
        [mutableArray addObjectsFromArray:[messagesWithLocalMessages copy]];
        messagesWithLocalMessages = [mutableArray mutableCopy];
    }
    
    /*!
     *
     messages追加失败消息时，涉及到的概念对应关系：
     
     index        |  参数        |     参数       |     屏幕位置
     --------------|-------------|----------------|-------------
     0            |             |                |      顶部
     1            |   fromDate  |  formerMessage |      上
     2            |     --      |  failedMessage |      中
     3            |    toDate   |     message    |      下
     ...          |             |                |
     n(last)      |   fromDate  |   lastMessage  |     队尾，最后一条消息
     -           |     --      |  failedMessage |
     fromTimestamp     |    toDate   |                |  上次上拉刷新顶端，第一条消息
     
     */
    __block int64_t fromDate;
    __block int64_t toDate;
    //messages追加失败消息，第一步：
    //对应于上图中index里的0到3
    [messages enumerateObjectsUsingBlock:^(id _Nonnull message, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            [messagesWithLocalMessages addObject:message];
            return;
        }
        id formerMessage = [messages objectAtIndex:idx - 1];
//        fromDate = [formerMessage xydChat_messageTimestamp];
//        toDate = [message xydChat_messageTimestamp];
        [self appendFailedMessagesToMessagesWithLocalMessages:messagesWithLocalMessages fromDate:fromDate toDate:toDate];
        [messagesWithLocalMessages addObject:message];
    }];
    //messages追加失败消息，第二步：
    //对应于上图中index里的n(last)到fromTimestamp
    //总是追加最后一条消息到上次下拉刷新之间的失败消息，如果历史记录里只有一条消息，也依然。
    id lastMessage = [messages lastObject];
    if (lastMessage) {
//        fromDate = [lastMessage xydChat_messageTimestamp];
//        toDate = timestamp;
//        if (timestamp == 0) {
//            toDate = xydChat_FUTURE_TIMESTAMP;
//        }
        [self appendFailedMessagesToMessagesWithLocalMessages:messagesWithLocalMessages fromDate:fromDate toDate:toDate];
    }
    return [self messagesWithSystemMessages:messagesWithLocalMessages];
}

- (void)appendFailedMessagesToMessagesWithLocalMessages:(NSMutableArray *)messagesWithLocalMessages fromDate:(int64_t)fromDate toDate:(int64_t)toDate {
    NSArray<XYDChatMessage *> *failedXYDChatMessages = [self failedXYDChatMessagesWithFromDate:fromDate toDate:toDate];
    if (failedXYDChatMessages.count > 0) {
        [messagesWithLocalMessages addObjectsFromArray:failedXYDChatMessages];
    }
}

- (NSArray *)failedXYDChatMessagesWithFromDate:(int64_t)fromDate toDate:(int64_t)toDate {
    NSString *fromDateString = [NSString stringWithFormat:@"%@", @(fromDate)];
    NSString *toDateString = [NSString stringWithFormat:@"%@", @(toDate)];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF >= %@) AND (SELF <= %@) AND (SELF MATCHES %@)", fromDateString, toDateString , xydChat_TIMESTAMP_REGEX];
//    NSArray<XYDChatMessage *> *failedXYDChatMessages = [self failedMessagesWithPredicate:predicate];
//    return failedXYDChatMessages;
    return nil;
}

#pragma mark - Public Methods

- (void)sendCustomMessage:(XYDChatMessage *)customMessage {
    [self sendMessage:customMessage];
}

- (void)sendMessage:(id)message {
    __weak __typeof(&*self) wself = self;
    [self sendMessage:message
        progressBlock:^(NSInteger percentDone) {
            [self.delegate messageSendStateChanged:XYDChatMessageSendStateSending withProgress:percentDone/100.f forIndex:[self.dataArray indexOfObject:message]];
        }
              success:^(BOOL succeeded, NSError *error) {
//                  if (![message xydChat_isCustomMessage]) {
//                      [(XYDChatMessage *)message setSendStatus:XYDChatMessageSendStateSent];
//                  }
                  
                  [[XYDSoundManager defaultManager] playSendSoundIfNeed];
                  [self.delegate messageSendStateChanged:XYDChatMessageSendStateSent withProgress:1.0f forIndex:[self.dataArray indexOfObject:message]];
              } failed:^(BOOL succeeded, NSError *error) {
                  __strong __typeof(wself)self = wself;
//                  if (![message xydChat_isCustomMessage]) {
//                      [(XYDChatMessage *)message setSendStatus:XYDChatMessageSendStateFailed];
//                      if (self.currentConversationId.length > 0) {
//                          [[XYDChatConversationService sharedInstance] insertFailedXYDChatMessage:message];
//                      }
//                  } else {
//                      //TODO:自定义消息的失败缓存
//                  }
                  [self.delegate messageSendStateChanged:XYDChatMessageSendStateFailed withProgress:0.0f forIndex:[self.dataArray indexOfObject:message]];
              }];
}

- (void)sendCustomMessage:(XYDChatMessage *)aMessage
            progressBlock:(XYDChatProgressBlock)progressBlock
                  success:(XYDChatBooleanResultBlock)success
                   failed:(XYDChatBooleanResultBlock)failed {
    [self sendMessage:aMessage progressBlock:progressBlock success:success failed:failed];
}

- (void)sendMessage:(id)aMessage
      progressBlock:(XYDChatProgressBlock)progressBlock
            success:(XYDChatBooleanResultBlock)success
             failed:(XYDChatBooleanResultBlock)failed {
    if (!aMessage) {
        NSInteger code = 0;
        NSString *errorReasonText = @"message is nil";
        NSDictionary *errorInfo = @{
                                    @"code":@(code),
                                    NSLocalizedDescriptionKey : errorReasonText,
                                    };
        NSError *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                             code:code
                                         userInfo:errorInfo];
        
        !failed ?: failed(YES, error);
        return;
    }
    self.parentConversationViewController.allowScrollToBottom = YES;
    NSString *messageUUID =  [NSString stringWithFormat:@"%@", @(kGetCurrent_Timestamp)];
//    if (![aMessage xydChat_isCustomMessage]) {
//        [(XYDChatMessage *)aMessage setLocalMessageId:messageUUID];
//    } else {
//        //TODO:
//        //自定义消息的失败id
//    }
    [self.delegate messageSendStateChanged:XYDChatMessageSendStateSending withProgress:0.0f forIndex:[self.dataArray indexOfObject:aMessage]];
    XYDChatMessage *XYDChatMessage;
//    if (![aMessage xydChat_isCustomMessage]) {
//        XYDChatMessage *message = (XYDChatMessage *)aMessage;
//        message.conversationId = self.currentConversationId;
//        
//        message.sendStatus = XYDChatMessageSendStateSending;
//        id<XYDChatUserDelegate> sender = [[XYDChatUserSystemService sharedInstance] fetchCurrentUser];
//        message.sender = sender;
//        message.ownerType = XYDChatMessageOwnerTypeSelf;
//        XYDChatMessage = [XYDChatMessage xydChat_messageWithXYDChatMessage:message];
//    } else {
//        XYDChatMessage = aMessage;
//    }
//    [XYDChatMessage xydChat_setObject:@([self.parentConversationViewController getConversationIfExists].xydChat_type) forKey:XYDChatCustomMessageConversationTypeKey];
//    [XYDChatMessage setValue:[XYDChatSessionService sharedInstance].clientId forKey:@"clientId"];//for XYDChatSendMessageHookBlock
//    [self.XYDChatMessage addObject:XYDChatMessage];
    [self preloadMessageToTableView:aMessage callback:^{
        if (!self.currentConversationId || self.currentConversationId.length == 0) {
            NSInteger code = 0;
            NSString *errorReasonText = @"Conversation invalid";
            NSDictionary *errorInfo = @{
                                        @"code":@(code),
                                        NSLocalizedDescriptionKey : errorReasonText,
                                        };
            NSError *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                                 code:code
                                             userInfo:errorInfo];
            !failed ?: failed(YES, error);
        }
        
//        void(^sendMessageCallBack)() = ^() {
//            [[XYDChatConversationService sharedInstance] sendMessage:XYDChatMessage
//                                                     conversation:self.currentConversation
//                                                    progressBlock:progressBlock
//                                                         callback:^(BOOL succeeded, NSError *error) {
//                                                             if (error) {
//                                                                 !failed ?: failed(succeeded, error);
//                                                             } else {
//                                                                 !success ?: success(succeeded, nil);
//                                                             }
//                                                             // cache file type messages even failed
//                                                             [XYDChatConversationService cacheFileTypeMessages:@[XYDChatMessage] callback:nil];
//                                                         }];
//            
//        };
//        
//        XYDChatSendMessageHookBlock sendMessageHookBlock = [[XYDChatConversationService sharedInstance] sendMessageHookBlock];
//        if (!sendMessageHookBlock) {
//            sendMessageCallBack();
//        } else {
//            XYDChatSendMessageHookCompletionHandler completionHandler = ^(BOOL granted, NSError *aError) {
//                if (granted) {
//                    sendMessageCallBack();
//                } else {
//                    !failed ?: failed(YES, aError);
//                }
//            };
//            sendMessageHookBlock(self.parentConversationViewController, XYDChatMessage, completionHandler);
//        }
    }];
}

- (void)sendLocalFeedbackTextMessge:(NSString *)localFeedbackTextMessge {
    XYDChatMessage *localFeedbackMessge = [[XYDChatMessage alloc] initWithLocalFeedbackText:localFeedbackTextMessge];
    [self appendMessagesToDataArrayTrailing:@[localFeedbackMessge]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0];
    dispatch_async(dispatch_get_main_queue(),^{
        [self.parentConversationViewController.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.parentConversationViewController scrollToBottomAnimated:YES];
    });
}

- (void)resendMessageForMessageCell:(XYDChatMessageCell *)messageCell {
//    NSString *title = [NSString stringWithFormat:@"%@?", XYDChatLocalizedStrings(@"resend")];
//    XYDChatAlertController *alert = [XYDChatAlertController alertControllerWithTitle:title
//                                                                       message:@""
//                                                                preferredStyle:XYDChatAlertControllerStyleAlert];
//    NSString *cancelActionTitle = XYDChatLocalizedStrings(@"cancel");
//    XYDChatAlertAction *cancelAction = [XYDChatAlertAction actionWithTitle:cancelActionTitle style:XYDChatAlertActionStyleDefault
//                                                             handler:^(XYDChatAlertAction * action) {}];
//    [alert addAction:cancelAction];
//    NSString *resendActionTitle = XYDChatLocalizedStrings(@"resend");
//    XYDChatAlertAction *resendAction = [XYDChatAlertAction actionWithTitle:resendActionTitle style:XYDChatAlertActionStyleDefault
//                                                             handler:^(XYDChatAlertAction * action) {
//                                                                 [self resendMessageAtIndexPath:messageCell.indexPath];
//                                                             }];
//    [alert addAction:resendAction];
//    [alert showWithSender:nil controller:self.parentConversationViewController animated:YES completion:NULL];
}

/*!
 * 自定义消息暂不支持失败缓存，不支持重发
 */
- (void)resendMessageAtIndexPath:(NSIndexPath *)indexPath {
//    XYDChatMessage *XYDChatMessage = self.dataArray[indexPath.row];
//    NSUInteger row = indexPath.row;
//    @try {
//        XYDChatMessage *message = self.dataArray[row - 1];
//        if (message.mediaType == kAVIMMessageMediaTypeSystem && !message.isLocalMessage) {
//            [self.dataArray xydChat_removeMessageAtIndex:row - 1];
//            [self.XYDChatMessage xydChat_removeMessageAtIndex:row - 1];
//            row -= 1;
//        }
//    } @catch (NSException *exception) {}
//    
//    [self.dataArray xydChat_removeMessageAtIndex:row];
//    [self.XYDChatMessage xydChat_removeMessageAtIndex:row];
//    NSString *oldFailedMessageId = XYDChatMessage.localMessageId;
//    [self.parentConversationViewController.tableView reloadData];
//    self.parentConversationViewController.allowScrollToBottom = YES;
//    [self sendMessage:XYDChatMessage];
//    [[XYDChatConversationService sharedInstance] deleteFailedMessageByRecordId:oldFailedMessageId];
}

- (void)preloadMessageToTableView:(id)aMessage callback:(XYDChatVoidBlock)callback {
//    if (![aMessage xydChat_isCustomMessage]) {
//        XYDChatMessage *message = (XYDChatMessage *)aMessage;
//        message.sendStatus = XYDChatMessageSendStateSending;
//    }
    NSUInteger oldLastMessageCount = self.dataArray.count;
    [self appendMessagesToTrailing:@[aMessage]];
    NSUInteger newLastMessageCout = self.dataArray.count;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0];
    [self.delegate messageSendStateChanged:XYDChatMessageSendStateSending withProgress:0.0f forIndex:indexPath.row];
    NSMutableArray *indexPaths = [NSMutableArray arrayWithObject:indexPath];
    NSUInteger additionItemsCount = newLastMessageCout - oldLastMessageCount;
    if (additionItemsCount > 1) {
        for (NSUInteger index = 2; index <= additionItemsCount; index++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newLastMessageCout - index inSection:0];
            [indexPaths addObject:indexPath];
        }
    }
    dispatch_async(dispatch_get_main_queue(),^{
        [self.parentConversationViewController.tableView insertRowsAtIndexPaths:[indexPaths copy] withRowAnimation:UITableViewRowAnimationNone];
        [self.parentConversationViewController scrollToBottomAnimated:YES];
        !callback ?: callback();
    });
}

#pragma mark - Getters

- (NSUInteger)messageCount {
    return self.dataArray.count;
}

- (XYDConversation *)currentConversation {
    return [self.parentConversationViewController getConversationIfExists];
}

- (NSString *)currentConversationId {
    return self.currentConversation.conversationId;
}

- (void)loadMessagesFirstTimeWithCallback:(XYDChatBoolResultBlock)callback {
//    [self queryAndCacheMessagesWithTimestamp:0 block:^(NSArray *XYDChatMessages, NSError *error) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
//            BOOL succeed = [self.parentConversationViewController filterAVIMError:error];
//            if (succeed) {
//                NSMutableArray *XYDChatSucceedMessags = [NSMutableArray xydChat_messagesWithAVIMMessages:XYDChatMessages];
//                [self addMessagesFirstTime:XYDChatSucceedMessags];
//                NSMutableArray *allMessages = [NSMutableArray arrayWithArray:XYDChatMessages];
//                self.XYDChatMessage = allMessages;
//                dispatch_async(dispatch_get_main_queue(),^{
//                    [self.parentConversationViewController.tableView reloadData];
//                    [self.parentConversationViewController scrollToBottomAnimated:NO];
//                    self.parentConversationViewController.loadingMoreMessage = NO;
//                });
//                if (self.XYDChatMessage.count > 0) {
//                    [[XYDChatConversationService sharedInstance] updateConversationAsRead];
//                }
//            } else {
//                self.parentConversationViewController.loadingMoreMessage = NO;
//            }
//            !callback ?: callback(succeed, self.XYDChatMessage, error);
//        });
//    }];
}

- (void)queryAndCacheMessagesWithTimestamp:(int64_t)timestamp block:(XYDChatArrayResultBlock)block {
//    if (self.parentConversationViewController.loadingMoreMessage) {
//        return;
//    }
//    if (self.dataArray.count == 0) {
//        timestamp = 0;
//    }
//    self.parentConversationViewController.loadingMoreMessage = YES;
//    [[XYDChatConversationService sharedInstance] queryTypedMessagesWithConversation:self.currentConversation
//                                                                       timestamp:timestamp
//                                                                           limit:kXYDChatOnePageSize
//                                                                           block:^(NSArray *XYDChatMessages, NSError *error) {
//                                                                               self.parentConversationViewController.shouldLoadMoreMessagesScrollToTop = YES;
//                                                                               if (XYDChatMessages.count == 0) {
//                                                                                   self.parentConversationViewController.loadingMoreMessage = NO;
//                                                                                   self.parentConversationViewController.shouldLoadMoreMessagesScrollToTop = NO;
//                                                                                   !block ?: block(XYDChatMessages, error);
//                                                                                   return;
//                                                                               }
//                                                                               [XYDChatConversationService cacheFileTypeMessages:XYDChatMessages callback:^(BOOL succeeded, NSError *error) {
//                                                                                   if (XYDChatMessages.count < kXYDChatOnePageSize) {
//                                                                                       self.parentConversationViewController.shouldLoadMoreMessagesScrollToTop = NO;
//                                                                                   }
//                                                                                   !block ?: block(XYDChatMessages, error);
//                                                                               }];
//                                                                           }];
}

- (void)loadOldMessages {
//    XYDChatMessage *msg = [self.XYDChatMessage xydChat_messageAtIndex:0];
//    int64_t timestamp = msg.sendTimestamp;
//    [self queryAndCacheMessagesWithTimestamp:timestamp block:^(NSArray *XYDChatMessages, NSError *error) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
//            if ([self.parentConversationViewController filterAVIMError:error]) {
//                NSMutableArray *XYDChatMessages = [[NSMutableArray xydChat_messagesWithAVIMMessages:XYDChatMessages] mutableCopy];
//                NSMutableArray *newMessages = [NSMutableArray arrayWithArray:XYDChatMessages];
//                [newMessages addObjectsFromArray:self.XYDChatMessage];
//                self.XYDChatMessage = newMessages;
//                [self insertOldMessages:[self messagesWithLocalMessages:XYDChatMessages freshTimestamp:timestamp] completion: ^{
//                    self.parentConversationViewController.loadingMoreMessage = NO;
//                }];
//            } else {
//                dispatch_async(dispatch_get_main_queue(),^{
//                    self.parentConversationViewController.loadingMoreMessage = NO;
//                });
//            }
//        });
//    }];
}

- (void)insertOldMessages:(NSArray *)oldMessages completion:(void (^)())completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSMutableArray *messages = [NSMutableArray arrayWithArray:oldMessages];
        [messages addObjectsFromArray:self.dataArray];
        CGSize beforeContentSize = self.parentConversationViewController.tableView.contentSize;
        NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:oldMessages.count];
        [oldMessages enumerateObjectsUsingBlock:^(id message, NSUInteger idx, BOOL *stop) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [indexPaths addObject:indexPath];
        }];
        dispatch_async(dispatch_get_main_queue(),^{
            BOOL animationEnabled = [UIView areAnimationsEnabled];
            if (animationEnabled) {
                [UIView setAnimationsEnabled:NO];
                [self.parentConversationViewController.tableView beginUpdates];
                self.dataArray = [messages mutableCopy];
                [self.parentConversationViewController.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                [self.parentConversationViewController.tableView reloadData];
                [self.parentConversationViewController.tableView endUpdates];
                CGSize afterContentSize = self.parentConversationViewController.tableView.contentSize;
                CGPoint afterContentOffset = self.parentConversationViewController.tableView.contentOffset;
                CGPoint newContentOffset = CGPointMake(afterContentOffset.x, afterContentOffset.y + afterContentSize.height - beforeContentSize.height);
                [self.parentConversationViewController.tableView setContentOffset:newContentOffset animated:NO] ;
                [UIView setAnimationsEnabled:YES];
            }
            !completion ?: completion();
        });
    });
}

- (void)getAllVisibleImagesForSelectedMessage:(XYDChatMessage *)message
                             allVisibleImages:(NSArray **)allVisibleImages
                             allVisibleThumbs:(NSArray **)allVisibleThumbs
                         selectedMessageIndex:(NSNumber **)selectedMessageIndex {
    NSMutableArray *allVisibleImages_ = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *allVisibleThumbs_ = [[NSMutableArray alloc] initWithCapacity:0];
//    NSUInteger idx = 0;
//    for (XYDChatMessage *message_ in self.dataArray) {
//        if ([message_ xydChat_isCustomMessage]) {
//            continue;
//        }
//        BOOL isImageType = (message_.mediaType == kAVIMMessageMediaTypeImage || message_.photo || message_.originPhotoURL);
//        if (isImageType) {
//            UIImage *placeholderImage = ({
//                NSString *imageName = @"Placeholder_Accept_Defeat";
//                UIImage *image = [UIImage xydChat_imageNamed:imageName bundleName:@"Placeholder" bundleForClass:[self class]];
//                image;});
//            //大图设置
//            UIImage *image = message_.photo;
//            if (image) {
//                [allVisibleImages_ addObject:image];
//            } else if (message_.originPhotoURL) {
//                [allVisibleImages_ addObject:message_.originPhotoURL];
//            } else {
//                [allVisibleImages_ addObject:placeholderImage];
//            }
//            //缩略图设置
//            UIImage *thumb = message_.thumbnailPhoto;
//            if (thumb) {
//                [allVisibleThumbs_ addObject:thumb];
//            } else if (message_.thumbnailURL) {
//                [allVisibleThumbs_ addObject:message_.thumbnailURL];
//            } else {
//                [allVisibleThumbs_ addObject:placeholderImage];
//            }
//            if ((message == message_) && (*selectedMessageIndex == nil)){
//                *selectedMessageIndex = @(idx);
//            }
//            idx++;
//        }
//    }
//    if (*allVisibleImages == nil) {
//        *allVisibleImages = [allVisibleImages_ copy];
//    }
//    if (*allVisibleThumbs == nil) {
//        *allVisibleThumbs = [allVisibleThumbs_ copy];
//    }
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.parentConversationViewController.isUserScrolling = YES;
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    }
//    [self.parentConversationViewController.chatBar endInputing];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.parentConversationViewController.isUserScrolling = NO;
    BOOL allowScrollToBottom = self.parentConversationViewController.allowScrollToBottom;
    CGFloat frameBottomToContentBottom = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y;
    //200：差不多是两行
    if (frameBottomToContentBottom < 200) {
        allowScrollToBottom = YES;
    } else {
        allowScrollToBottom = NO;
    }
    self.parentConversationViewController.allowScrollToBottom = allowScrollToBottom;
}

- (UIImage *)imageInBundlePathForImageName:(NSString *)imageName {
//    UIImage *image = [UIImage xydChat_imageNamed:imageName bundleName:@"Other" bundleForClass:[self class]];
//    return image;
    return nil;
}

@end
