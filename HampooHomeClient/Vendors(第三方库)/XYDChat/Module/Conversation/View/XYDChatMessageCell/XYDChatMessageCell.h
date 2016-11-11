//
//  XYDChatMessageCell.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/9.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYDChatTypeMessage.h"
#import "MLLinkLabel.h"
#import "XYDChatContentView.h"
#import "XYDMessageSendStateView.h"

@class XYDChatMessageCell;

// 子类化该类遵守的协议
@protocol XYDChatMessageCellSubclassing <NSObject>
@required
/*!
 子类实现此方法用于返回该类对应的消息类型
 @return 消息类型
 */
+ (XYDChatMessageMediaType)classMediaType;
@end

@protocol LCCKChatMessageCellDelegate <NSObject>

- (void)messageCellTappedBlank:(XYDChatMessageCell *)messageCell;
- (void)messageCellTappedHead:(XYDChatMessageCell *)messageCell;
- (void)messageCellTappedMessage:(XYDChatMessageCell *)messageCell;
- (void)textMessageCellDoubleTapped:(XYDChatMessageCell *)messageCell;
- (void)resendMessage:(XYDChatMessageCell *)messageCell;
- (void)avatarImageViewLongPressed:(XYDChatMessageCell *)messageCell;
- (void)messageCell:(XYDChatMessageCell *)messageCell didTapLinkText:(NSString *)linkText linkType:(MLLinkType)linkType;
- (void)fileMessageDidDownload:(XYDChatMessageCell *)messageCell;

@end

@interface XYDChatMessageCell : UITableViewCell

+ (void)registerCustomMessageCell;
+ (void)registerSubclass;
- (void)addGeneralView;
@property (nonatomic, strong, readonly) XYDChatTypeMessage *message;

//FIXME:retain cycle
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *indexPath;

/**
 *  显示用户头像
 */
@property (nonatomic, strong) UIImageView *avatarImageView;

/**
 *  显示用户昵称的UILabel
 */
@property (nonatomic, strong) UILabel *nickNameLabel;

/**
 *  显示用户消息主体的View,所有的消息用到的textView,imageView都会被添加到这个view中 -> LCCKContentView 自带一个CAShapeLayer的蒙版
 */
@property (nonatomic, strong) XYDChatContentView *messageContentView;

/**
 *  显示消息阅读状态的UIImageView -> 主要用于VoiceMessage
 */
@property (nonatomic, strong) UIImageView *messageReadStateImageView;

/**
 *  显示消息发送状态的UIImageView -> 用于消息发送不成功时显示
 */
@property (nonatomic, strong) XYDMessageSendStateView *messageSendStateView;

/**
 *  messageContentView的背景层
 */
@property (nonatomic, strong) UIImageView *messageContentBackgroundImageView;

@property (nonatomic, weak) id<LCCKChatMessageCellDelegate> delegate;

/**
 *  消息的类型,只读类型,会根据自己的具体实例类型进行判断
 */
@property (nonatomic, assign, readonly) XYDChatMessageMediaType mediaType;

/**
 *  消息的所有者,只读类型,会根据自己的reuseIdentifier进行判断
 */
@property (nonatomic, assign, readonly) XYDChatMessageOwnerType messageOwner;

/**
 *  消息群组类型,只读类型,根据reuseIdentifier判断
 */
@property (nonatomic, assign) XYDChatConversationType messageChatType;

/**
 *  消息发送状态,当状态为LCCKMessageSendFail或LCCKMessageSendStateSending时,LCCKmessageSendStateImageView显示
 */
@property (nonatomic, assign) XYDChatMessageSendState messageSendState;

/**
 *  消息阅读状态,当状态为LCCKMessageUnRead时,LCCKmessageReadStateImageView显示
 */
@property (nonatomic, assign) XYDChatMessageReadState messageReadState;

#pragma mark - Public Methods

- (void)setup;
- (void)configureCellWithData:(id)message;


@end
