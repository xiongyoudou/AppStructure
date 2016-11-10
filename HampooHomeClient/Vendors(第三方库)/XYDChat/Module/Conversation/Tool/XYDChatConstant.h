//
//  XYDChatConstant.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/9.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDUserDelegate.h"
#ifndef XYDChatConstant_h
#define XYDChatConstant_h

#pragma mark - Base ViewController Life Time Block
///=============================================================================
/// @name Base ViewController Life Time Block
///=============================================================================

//Callback with Custom type
typedef void (^XYDChatUserResultsCallBack)(NSArray<id<XYDUserDelegate>> *users, NSError *error);
typedef void (^XYDChatUserResultCallBack)(id<XYDUserDelegate> user, NSError *error);
//Callback with Foundation type
typedef void (^XYDChatBooleanResultBlock)(BOOL succeeded, NSError *error);
typedef void (^XYDChatViewControllerBooleanResultBlock)(__kindof UIViewController *viewController, BOOL succeeded, NSError *error);

typedef void (^XYDChatIntegerResultBlock)(NSInteger number, NSError *error);
typedef void (^XYDChatStringResultBlock)(NSString *string, NSError *error);
typedef void (^XYDChatDictionaryResultBlock)(NSDictionary * dict, NSError *error);
typedef void (^XYDChatArrayResultBlock)(NSArray *objects, NSError *error);
typedef void (^XYDChatSetResultBlock)(NSSet *channels, NSError *error);
typedef void (^XYDChatDataResultBlock)(NSData *data, NSError *error);
typedef void (^XYDChatIdResultBlock)(id object, NSError *error);
typedef void (^XYDChatIdBoolResultBlock)(BOOL succeeded, id object, NSError *error);
typedef void (^XYDChatRequestAuthorizationBoolResultBlock)(BOOL granted, NSError *error);

//Callback with Function object
typedef void (^XYDChatVoidBlock)(void);
typedef void (^XYDChatErrorBlock)(NSError *error);
typedef void (^XYDChatImageResultBlock)(UIImage * image, NSError *error);
typedef void (^XYDChatProgressBlock)(NSInteger percentDone);

#pragma mark - Conversation Enum : Message Type and operation
///=============================================================================
/// @name Conversation Enum : Message Type and operation
///=============================================================================


typedef int8_t XYDChatMessageMediaType;
//SDK定义的消息类型，自定义类型使用大于0的值
enum : XYDChatMessageMediaType {
    XYDChatMessageMediaTypeNone = 0,
    XYDChatMessageMediaTypeText = -1,
    XYDChatMessageMediaTypeImage = -2,
    XYDChatMessageMediaTypeAudio = -3,
    XYDChatMessageMediaTypeVideo = -4,
    XYDChatMessageMediaTypeLocation = -5,
    XYDChatMessageMediaTypeFile = -6,
    kAVIMMessageMediaTypeSystem = -7,
};

/**
 *  消息聊天类型
 */
typedef NS_ENUM(NSUInteger, XYDChatConversationType){
    XYDChatConversationTypeSingle = 0 /**< 单人聊天,不显示nickname */,
    XYDChatConversationTypeGroup /**< 群组聊天,显示nickname */,
};

/**
 *  消息拥有者类型
 */
typedef NS_ENUM(NSUInteger, XYDChatMessageOwnerType){
    XYDChatMessageOwnerTypeUnknown = 0 /**< 未知的消息拥有者 */,
    XYDChatMessageOwnerTypeSystem /**< 系统消息 */,
    XYDChatMessageOwnerTypeSelf /**< 自己发送的消息 */,
    XYDChatMessageOwnerTypeOther /**< 接收到的他人消息 */,
};

/**
 *  消息发送状态,自己发送的消息时有
 */
typedef NS_ENUM(NSUInteger, XYDChatMessageSendState){
    XYDChatMessageSendStateNone = 0,
    XYDChatMessageSendStateSending = 1, /**< 消息发送中 */
    XYDChatMessageSendStateSent, /**< 消息发送成功 */
    XYDChatMessageSendStateDelivered, /**< 消息对方已接收*/
    XYDChatMessageSendStateFailed, /**< 消息发送失败 */
};

/**
 *  消息读取状态,接收的消息时有
 */
typedef NS_ENUM(NSUInteger, XYDChatMessageReadState) {
    XYDChatMessageUnRead = 0 /**< 消息未读 */,
    XYDChatMessageReading /**< 正在接收 */,
    XYDChatMessageReaded /**< 消息已读 */,
};

/**
 *  录音消息的状态
 */
typedef NS_ENUM(NSUInteger, XYDChatVoiceMessageState){
    XYDChatVoiceMessageStateNormal,/**< 未播放状态 */
    XYDChatVoiceMessageStateDownloading,/**< 正在下载中 */
    XYDChatVoiceMessageStatePlaying,/**< 正在播放 */
    XYDChatVoiceMessageStateCancel,/**< 播放被取消 */
};

/**
 *  XYDChatChatMessageCell menu对应action类型
 */
typedef NS_ENUM(NSUInteger, XYDChatChatMessageCellMenuActionType) {
    XYDChatChatMessageCellMenuActionTypeCopy, /**< 复制 */
    XYDChatChatMessageCellMenuActionTypeRelay, /**< 转发 */
};

// 通用动画时间
static CGFloat const XYDChatAnimateDuration = .25f;

#endif /* XYDChatConstant_h */
