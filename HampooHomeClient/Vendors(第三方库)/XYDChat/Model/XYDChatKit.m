//
//  XYDChatKit.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/10.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatKit.h"
#import "XYDChatSessionService.h"
#import "XYDChatSettingService.h"
#import "XYDConversationService.h"
#import "XYDChatUIService.h"
#import "XYDChatConstant.h"

@interface XYDChatKit ()
/*!
 *  appId
 */
@property (nonatomic, copy, readwrite) NSString *appId;

/*!
 *  appkey
 */
@property (nonatomic, copy, readwrite) NSString *appKey;
@end

@implementation XYDChatKit
@synthesize forceReconnectSessionBlock = _forceReconnectSessionBlock;
@synthesize clientId = _clientId;
@synthesize fetchProfilesBlock = _fetchProfilesBlock;
@synthesize openProfileBlock = _openProfileBlock;
@synthesize previewImageMessageBlock = _previewImageMessageBlock;
@synthesize previewLocationMessageBlock = _previewLocationMessageBlock;
@synthesize longPressMessageBlock = _longPressMessageBlock;
@synthesize showNotificationBlock = _showNotificationBlock;
@synthesize HUDActionBlock = _HUDActionBlock;
@synthesize avatarImageViewCornerRadiusBlock = _avatarImageViewCornerRadiusBlock;
@synthesize useDevPushCerticate = _useDevPushCerticate;
@synthesize didSelectConversationsListCellBlock = _didSelectConversationsListCellBlock;
@synthesize didDeleteConversationsListCellBlock = _didDeleteConversationsListCellBlock;
@synthesize conversationEditActionBlock = _conversationEditActionBlock;
@synthesize markBadgeWithTotalUnreadCountBlock = _markBadgeWithTotalUnreadCountBlock;
@synthesize conversationInvalidedHandler = _conversationInvalidedHandler;
@synthesize fetchConversationHandler = _fetchConversationHandler;
@synthesize loadLatestMessagesHandler = _loadLatestMessagesHandler;
@synthesize disableSingleSignOn = _disableSingleSignOn;
@synthesize filterMessagesBlock = _filterMessagesBlock;

#pragma mark -

+ (id)copyWithZone:(NSZone *)zone {
    // Not allow copying to a different zone
    return [self sharedInstance];
}

/**
 * create a singleton instance of LCChatKit
 */
+ (instancetype)sharedInstance {
    static XYDChatKit *_sharedLCChatKit = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLCChatKit = [[self alloc] init];
    });
    return _sharedLCChatKit;
}

#pragma mark -
#pragma mark - LCChatKit Method

+ (void)setAppId:(NSString *)appId appKey:(NSString *)appKey {
    [XYDChatKit sharedInstance].appId = appId;
    [XYDChatKit sharedInstance].appKey = appKey;

}

#pragma mark -
#pragma mark - Service Delegate Method

- (XYDChatSessionService *)sessionService {
    return [XYDChatSessionService sharedInstance];
}
//
//- (XYDChatUserSystemService *)userSystemService {
//    return [XYDChatUserSystemService sharedInstance];
//}

//- (XYDChatSignatureService *)signatureService {
//    return [XYDChatSignatureService sharedInstance];
//}

- (XYDChatSettingService *)settingService {
    return [XYDChatSettingService sharedInstance];
}

- (XYDChatUIService *)UIService {
    return [XYDChatUIService sharedInstance];
}

- (XYDConversationService *)conversationService {
    return [XYDConversationService sharedInstance];
}

//- (XYDChatConversationListService *)conversationListService {
//    return [XYDChatConversationListService sharedInstance];
//}

#pragma mark - XYDChatSessionService
///=============================================================================
/// @name XYDChatSessionService
///=============================================================================

- (NSString *)clientId {
//    return self.sessionService.clientId;
    return nil;
}

//- (XYDChatClient *)client {
//    return self.sessionService.client;
//}

- (void)openWithClientId:(NSString *)clientId callback:(XYDChatBooleanResultBlock)callback {
//    [self.sessionService openWithClientId:clientId callback:callback];
}

- (void)openWithClientId:(NSString *)clientId force:(BOOL)force callback:(XYDChatBooleanResultBlock)callback {
//    [self.sessionService openWithClientId:clientId force:force callback:callback];
}

- (void)closeWithCallback:(XYDChatBooleanResultBlock)callback {
//    [self.sessionService closeWithCallback:callback];
}

- (void)setForceReconnectSessionBlock:(XYDChatForceReconnectSessionBlock)forceReconnectSessionBlock {
//    [self.sessionService setForceReconnectSessionBlock:forceReconnectSessionBlock];
}

- (void)setDisableSingleSignOn:(BOOL)disableSingleSignOn {
//    self.sessionService.disableSingleSignOn = disableSingleSignOn;
}

#pragma mark - XYDChatUserSystemService
///=============================================================================
/// @name XYDChatUserSystemService
///=============================================================================

- (void)setFetchProfilesBlock:(XYDChatFetchProfilesBlock)fetchProfilesBlock {
//    [self.userSystemService setFetchProfilesBlock:fetchProfilesBlock];
}

- (void)removeCachedProfileForPeerId:(NSString *)peerId {
//    [self.userSystemService removeCachedProfileForPeerId:peerId];
}

- (void)removeAllCachedProfiles {
//    [self.userSystemService removeAllCachedProfiles];
}

- (void)getCachedProfileIfExists:(NSString *)userId name:(NSString **)name avatarURL:(NSURL **)avatarURL error:(NSError * __autoreleasing *)error {
//    [self.userSystemService getCachedProfileIfExists:userId name:name avatarURL:avatarURL error:error];
}

- (NSArray<id<XYDChatUserDelegate>> *)getCachedProfilesIfExists:(NSArray<NSString *> *)userIds error:(NSError * __autoreleasing *)error {
//    return [self.userSystemService getCachedProfilesIfExists:userIds error:error];
    return nil;
}
- (NSArray<id<XYDChatUserDelegate>> *)getCachedProfilesIfExists:(NSArray<NSString *> *)userIds shouldSameCount:(BOOL)shouldSameCount error:(NSError * __autoreleasing *)error {
//    return [self.userSystemService getCachedProfilesIfExists:userIds shouldSameCount:shouldSameCount error:error];
    return nil;
}

- (void)getProfileInBackgroundForUserId:(NSString *)userId callback:(XYDChatUserResultCallBack)callback {
//    [self.userSystemService getProfileInBackgroundForUserId:userId callback:callback];
}

- (void)getProfilesInBackgroundForUserIds:(NSArray<NSString *> *)userIds callback:(XYDChatUserResultsCallBack)callback {
//    [self.userSystemService getProfilesInBackgroundForUserIds:userIds callback:callback];
}

- (NSArray<id<XYDChatUserDelegate>> *)getProfilesForUserIds:(NSArray<NSString *> *)userIds error:(NSError * __autoreleasing *)error {
//    return [self.userSystemService getProfilesForUserIds:userIds error:error];
    return nil;
}

#pragma mark - XYDChatSignatureService
///=============================================================================
/// @name XYDChatSignatureService
///=============================================================================

//- (void)setGenerateSignatureBlock:(XYDChatGenerateSignatureBlock)generateSignatureBlock {
//    [self.signatureService setGenerateSignatureBlock:generateSignatureBlock];
//}

//- (XYDChatGenerateSignatureBlock)generateSignatureBlock {
//    return [self.signatureService generateSignatureBlock];
//    return nil;
//}

#pragma mark - XYDChatUIService
///=============================================================================
/// @name XYDChatUIService
///=============================================================================

- (void)setOpenProfileBlock:(XYDChatOpenProfileBlock)openProfileBlock {
//    [self.UIService setOpenProfileBlock:openProfileBlock];
}

- (void)setPreviewImageMessageBlock:(XYDChatPreviewImageMessageBlock)previewImageMessageBlock {
//    [self.UIService setPreviewImageMessageBlock:previewImageMessageBlock];
}

- (void)setPreviewLocationMessageBlock:(XYDChatPreviewLocationMessageBlock)previewLocationMessageBlock {
//    [self.UIService setPreviewLocationMessageBlock:previewLocationMessageBlock];
}

- (void)setShowNotificationBlock:(XYDChatShowNotificationBlock)showNotificationBlock {
//    [self.UIService setShowNotificationBlock:showNotificationBlock];
}
- (void)setHUDActionBlock:(XYDChatHUDActionBlock)HUDActionBlock {
//    [self.UIService setHUDActionBlock:HUDActionBlock];
}

- (void)setAvatarImageViewCornerRadiusBlock:(XYDChatAvatarImageViewCornerRadiusBlock)avatarImageViewCornerRadiusBlock {
//    [self.UIService setAvatarImageViewCornerRadiusBlock:avatarImageViewCornerRadiusBlock];
}

- (XYDChatAvatarImageViewCornerRadiusBlock)avatarImageViewCornerRadiusBlock {
//    return self.UIService.avatarImageViewCornerRadiusBlock;
    return nil;
}

- (void)setLongPressMessageBlock:(XYDChatLongPressMessageBlock)longPressMessageBlock {
//    return [self.UIService setLongPressMessageBlock:longPressMessageBlock];
}

- (XYDChatLongPressMessageBlock)longPressMessageBlock {
//    return self.UIService.longPressMessageBlock;
    return nil;
}

#pragma mark - XYDChatSettingService
///=============================================================================
/// @name XYDChatSettingService
///=============================================================================

+ (void)setAllLogsEnabled:(BOOL)enabled {
//    [XYDChatSettingService setAllLogsEnabled:YES];
}

+ (BOOL)allLogsEnabled {
//    return [XYDChatSettingService allLogsEnabled];
    return NO;
}

+ (NSString *)ChatKitVersion {
    return [XYDChatSettingService ChatKitVersion];
}

- (void)syncBadge {
    [self.settingService syncBadge];
}

- (BOOL)useDevPushCerticate {
    return [self.settingService useDevPushCerticate];
}

- (void)setUseDevPushCerticate:(BOOL)useDevPushCerticate {
    self.settingService.useDevPushCerticate = useDevPushCerticate;
}

- (BOOL)isDisablePreviewUserId {
    return self.settingService.isDisablePreviewUserId;
}

- (void)setDisablePreviewUserId:(BOOL)disablePreviewUserId {
    self.settingService.disablePreviewUserId = disablePreviewUserId;
}

- (void)setBackgroundImage:(UIImage *)image forConversationId:(NSString *)conversationId scaledToSize:(CGSize)scaledToSize {
    [self.settingService setBackgroundImage:image forConversationId:conversationId scaledToSize:scaledToSize];
}

#pragma mark - XYDConversationService
///=============================================================================
/// @name XYDConversationService
///=============================================================================

- (void)setFetchConversationHandler:(XYDChatFetchConversationHandler)fetchConversationHandler {
//    [self.conversationService setFetchConversationHandler:fetchConversationHandler];
}

- (void)setConversationInvalidedHandler:(XYDChatConversationInvalidedHandler)conversationInvalidedHandler {
//    [self.conversationService setConversationInvalidedHandler:conversationInvalidedHandler];
}

- (void)setLoadLatestMessagesHandler:(XYDChatLoadLatestMessagesHandler)loadLatestMessagesHandler {
//    [self.conversationService setLoadLatestMessagesHandler:loadLatestMessagesHandler];
}

- (void)setFilterMessagesBlock:(XYDChatFilterMessagesBlock)filterMessagesBlock {
//    [self.conversationService setFilterMessagesBlock:filterMessagesBlock];
}

- (void)setSendMessageHookBlock:(XYDChatSendMessageHookBlock)sendMessageHookBlock {
//    [self.conversationService setSendMessageHookBlock:sendMessageHookBlock];
}

- (void)createConversationWithMembers:(NSArray *)members type:(XYDChatConversationType)type unique:(BOOL)unique callback:(XYDChatConversationResultBlock)callback {
//    [self.conversationService createConversationWithMembers:members type:type unique:unique callback:callback];
}

- (void)fecthConversationWithConversationId:(NSString *)conversationId callback:(XYDChatConversationResultBlock)callback {
//    [self.conversationService fecthConversationWithConversationId:conversationId callback:callback];
}

- (void)fecthConversationWithPeerId:(NSString *)peerId callback:(XYDChatConversationResultBlock)callback {
//    [self.conversationService fecthConversationWithPeerId:peerId callback:callback];
}

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    [self.conversationService didReceiveRemoteNotification:userInfo];
}

- (void)insertRecentConversation:(XYDConversation *)conversation {
//    [self.conversationService insertRecentConversation:conversation];
}

- (void)increaseUnreadCountWithConversationId:(NSString *)conversationId {
//    [self.conversationService increaseUnreadCountWithConversationId:conversationId];
}

- (void)deleteRecentConversationWithConversationId:(NSString *)conversationId {
//    [self.conversationService deleteRecentConversationWithConversationId:conversationId];
}

- (void)updateUnreadCountToZeroWithConversationId:(NSString *)conversationId {
//    [self.conversationService updateUnreadCountToZeroWithConversationId:conversationId];
}

- (BOOL)removeAllCachedRecentConversations {
//    return [self.conversationService removeAllCachedRecentConversations];
    return NO;
}

- (void)sendWelcomeMessageToPeerId:(NSString *)peerId text:(NSString *)text block:(XYDChatBooleanResultBlock)block {
//    [self.conversationService sendWelcomeMessageToPeerId:peerId text:text block:block];
}

- (void)sendWelcomeMessageToConversationId:(NSString *)conversationId text:(NSString *)text block:(XYDChatBooleanResultBlock)block {
//    [self.conversationService sendWelcomeMessageToConversationId:conversationId text:text block:block];
}

#pragma mark - XYDChatConversationsListService
///=============================================================================
/// @name XYDChatConversationsListService
///=============================================================================

- (void)setDidSelectConversationsListCellBlock:(XYDChatDidSelectConversationsListCellBlock)didSelectConversationsListCellBlock {
//    [self.conversationListService setDidSelectConversationsListCellBlock:didSelectConversationsListCellBlock];
}

- (void)setDidDeleteConversationsListCellBlock:(XYDChatDidDeleteConversationsListCellBlock)didDeleteConversationsListCellBlock {
//    [self.conversationListService setDidDeleteConversationsListCellBlock:didDeleteConversationsListCellBlock];
}

- (void)setConversationEditActionBlock:(XYDChatConversationEditActionsBlock)conversationEditActionBlock {
//    [self.conversationListService setConversationEditActionBlock:conversationEditActionBlock];
}

- (void)setMarkBadgeWithTotalUnreadCountBlock:(XYDChatMarkBadgeWithTotalUnreadCountBlock)markBadgeWithTotalUnreadCountBlock {
//    [self.conversationListService setMarkBadgeWithTotalUnreadCountBlock:markBadgeWithTotalUnreadCountBlock];
}

//TODO:CacheService;


@end
