//
//  XYDChatInputViewPluginRedPacket.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/15.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatInputViewPluginRedPacket.h"
#import "XYDConversationVCtrl.h"
#import "XYDChatHelper.h"
#import "RedpacketViewControl.h"
#import "XYDConversation.h"
#import "XYDChatRedPacketMessage.h"

@interface XYDChatInputViewPluginRedPacket ()

/**
 *  发红包的控制器
 */
@property (nonatomic, strong) RedpacketViewControl *redpacketControl;

@end

@implementation XYDChatInputViewPluginRedPacket
@synthesize inputViewRef = _inputViewRef;
@synthesize sendCustomMessageHandler = _sendCustomMessageHandler;

+ (void)load {
    [self registerSubclass];
}

+ (XYDChatInputViewPluginType)classPluginType {
    return 3;
}

#pragma mark -
#pragma mark - XYDChatInputViewPluginDelegate Method

/*!
 * 插件图标
 */
- (UIImage *)pluginIconImage {
    return [self imageInBundlePathForImageName:@"redpacket_redpacket"];
}

/*!
 * 插件名称
 */
- (NSString *)pluginTitle {
    return @"红包";
}

/*!
 * 插件对应的 view，会被加载到 inputView 上
 */
- (UIView *)pluginContentView {
    return nil;
}

- (void)pluginDidClicked {
    self.redpacketControl.conversationController = self.conversationViewController;
    XYDConversation *conversation = [self.conversationViewController getConversationIfExists];
    RedpacketUserInfo * userInfo = [RedpacketUserInfo new];
    RPSendRedPacketViewControllerType rptype;
    if (conversation) {
        if (conversation.members.count > 2) {
            userInfo.userId = self.conversationViewController.conversationId;
            rptype = RPSendRedPacketViewControllerMember;
        } else {
            rptype = RPSendRedPacketViewControllerSingle;
            [conversation.members enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                if (![[RedpacketConfig sharedConfig].redpacketUserInfo.userId isEqualToString:obj]) {
//                    userInfo.userId = obj;
//                }
            }];
        }
    }
    self.redpacketControl.converstationInfo = userInfo;
    [self.redpacketControl presentRedPacketViewControllerWithType:rptype memberCount:conversation.members.count];
}

- (RedpacketViewControl *)redpacketControl {
    if (_redpacketControl) return _redpacketControl;
    
    _redpacketControl = [RedpacketViewControl new];
    _redpacketControl.delegate = self;
    
    // 设置红包 SDK 功能回调
    [_redpacketControl setRedpacketGrabBlock:nil andRedpacketBlock:^(RedpacketMessageModel *redpacket) {
        // 用户发红包的通知
        // SDK 默认的消息需要改变
        redpacket.redpacket.redpacketOrgName = @"LeacCloud红包";
        [self sendRedpacketMessage:redpacket];
        _redpacketControl = nil;
    }];
    return _redpacketControl;
}

// 发送红包消息
- (void)sendRedpacketMessage:(RedpacketMessageModel *)redpacket {
    XYDChatRedPacketMessage * message = [[XYDChatRedPacketMessage alloc]init];
    message.rpModel = redpacket;
    [self.conversationViewController sendCustomMessage:message];
}

- (void)getGroupMemberListCompletionHandle:(void (^)(NSArray<RedpacketUserInfo *> *))completionHandle {
    __weak typeof(self) weakSlef = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray * usersArray = [NSMutableArray array];
        XYDConversation *conversation = [weakSlef.conversationViewController getConversationIfExists];
        [conversation.members enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            RedpacketUserInfo * userInfo = [RedpacketUserInfo new];
            userInfo.userId = obj;
            userInfo.userNickname = obj;
            [usersArray addObject:userInfo];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandle(usersArray);
        });
    });
}
#pragma mark -
#pragma mark - Private Methods

- (UIImage *)imageInBundlePathForImageName:(NSString *)imageName {
    UIImage *image = [XYDChatHelper getImageWithNamed:imageName bundleName:@"RedpacketResource" bundleForClass:[self class]];
    return image;
}

@end
