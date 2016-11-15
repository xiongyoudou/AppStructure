//
//  XYDChatInputViewPluginVCard.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/15.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatInputViewPluginVCard.h"
#import "XYDConversationVCtrl.h"
#import "XYDChatHelper.h"
#import "XYDChatVCardMessage.h"
#import "XYDConversation.h"
#import "XYDConversation+Extionsion.h"

@implementation XYDChatInputViewPluginVCard
@synthesize inputViewRef = _inputViewRef;
@synthesize sendCustomMessageHandler = _sendCustomMessageHandler;

#pragma mark -
#pragma mark - Override Methods

#pragma mark -
#pragma mark - XYDChatInputViewPluginSubclassing Method

+ (void)load {
    [self registerCustomInputViewPlugin];
}

+ (XYDChatInputViewPluginType)classPluginType {
    return XYDChatInputViewPluginTypeVCard;
}

#pragma mark -
#pragma mark - XYDChatInputViewPluginDelegate Method

/**
 * 插件图标
 */
- (UIImage *)pluginIconImage {
    return [self imageInBundlePathForImageName:@"chat_bar_icons_location"];
}

/**
 * 插件名称
 */
- (NSString *)pluginTitle {
    return @"名片";
}

/**
 * 插件对应的 view，会被加载到 inputView 上
 */
- (UIView *)pluginContentView {
    return nil;
}

/**
 * 插件被选中运行
 */
- (void)pluginDidClicked {
    [super pluginDidClicked];
    [self presentSelectMemberViewController];
}

/**
 * 发送自定消息的实现
 */
- (XYDChatObjResultBlock)sendCustomMessageHandler {
    if (_sendCustomMessageHandler) {
        return _sendCustomMessageHandler;
    }
    if (!self.conversationViewController.isAvailable) {
        [self.conversationViewController sendLocalFeedbackTextMessge:@"名片发送失败"];
        return nil;
    }
    XYDChatObjResultBlock sendCustomMessageHandler = ^(id object, NSError *error) {
//        XYDChatVCardMessage *vCardMessage = [XYDChatVCardMessage vCardMessageWithClientId:object conversationType:[self.conversationViewController getConversationIfExists].xydChat_type];
//        [self.conversationViewController sendCustomMessage:vCardMessage progressBlock:^(NSInteger percentDone) {
//        } success:^(BOOL succeeded, NSError *error) {
//            [self.conversationViewController sendLocalFeedbackTextMessge:@"名片发送成功"];
//        } failed:^(BOOL succeeded, NSError *error) {
//            [self.conversationViewController sendLocalFeedbackTextMessge:@"名片发送失败"];
//        }];
//        //important: avoid retain cycle!
//        _sendCustomMessageHandler = nil;
    };
    _sendCustomMessageHandler = sendCustomMessageHandler;
    return sendCustomMessageHandler;
}

#pragma mark -
#pragma mark - Private Methods

- (UIImage *)imageInBundlePathForImageName:(NSString *)imageName {
    UIImage *image = [XYDChatHelper getImageWithNamed:imageName bundleName:@"ChatKeyboard" bundleForClass:[self class]];
    return image;
}

- (void)presentSelectMemberViewController {
    XYDConversation *conversation = [self.conversationViewController getConversationIfExists];
    NSArray *allPersonIds;
//    if (conversation.xydChat_type == XYDChatConversationTypeGroup) {
//        allPersonIds = conversation.members;
//    } else {
//        allPersonIds = [[XYDChatContactManager defaultManager] fetchContactPeerIds];
//    }
//    NSArray *users = [[LCChatKit sharedInstance] getCachedProfilesIfExists:allPersonIds shouldSameCount:YES error:nil];
//    NSString *currentClientID = [[LCChatKit sharedInstance] clientId];
//    XYDChatContactListViewController *contactListViewController = [[XYDChatContactListViewController alloc] initWithContacts:[NSSet setWithArray:users] userIds:[NSSet setWithArray:allPersonIds] excludedUserIds:[NSSet setWithArray:@[currentClientID]] mode:XYDChatContactListModeSingleSelection];
//    contactListViewController.title = @"发送名片";
//    [contactListViewController setViewDidDismissBlock:^(XYDChatBaseViewController *viewController) {
//        [self.inputViewRef open];
//        [self.inputViewRef beginInputing];
//    }];
//    [contactListViewController setSelectedContactCallback:^(UIViewController *viewController, NSString *peerId) {
//        [viewController dismissViewControllerAnimated:YES completion:^{
//            [self.inputViewRef open];
//        }];
//        if (peerId.length > 0) {
//            !self.sendCustomMessageHandler ?: self.sendCustomMessageHandler(peerId, nil);
//        }
//    }];
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:contactListViewController];
//    [self.conversationViewController presentViewController:navigationController animated:YES completion:^{
//        [self.inputViewRef close];
//    }];
}


@end
