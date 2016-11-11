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

@class XYDFile;
@class XYDConversation;

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
typedef void (^XYDChatStreamResultBlock)(NSInputStream * stream, NSError *error);
typedef void (^XYDChatFileResultBlock)(XYDFile * file, NSError * error);
typedef void (^XYDChatImageResultBlock)(UIImage * image, NSError * error);
typedef void (^XYDChatObjResultBlock)(id object, NSError *error);
typedef void (^XYDChatBoolResultBlock)(BOOL succeeded, id object, NSError *error);
typedef void (^XYDChatRequestAuthorizationBoolResultBlock)(BOOL granted, NSError *error);
typedef void (^XYDChatConversationResultBlock)(XYDConversation * conversation, NSError * error);

//Callback with Function object
typedef void (^XYDChatVoidBlock)(void);
typedef void (^XYDChatErrorBlock)(NSError *error);
typedef void (^XYDChatImageResultBlock)(UIImage * image, NSError *error);
typedef void (^XYDChatProgressBlock)(NSInteger percentDone);

#pragma mark - Conversation Enum : Message Type and operation
///=============================================================================
/// @name Conversation Enum : Message Type and operation
///=============================================================================

#pragma mark - Custom Message Cell
///=============================================================================
/// @name Custom Message Cell
///=============================================================================

FOUNDATION_EXTERN NSMutableDictionary const * XYDChatChatMessageCellMediaTypeDict;
FOUNDATION_EXTERN NSMutableDictionary const *_typeDict;

static NSString *const XYDChatCellIdentifierDefault = @"XYDChatCellIdentifierDefault";
static NSString *const XYDChatCellIdentifierCustom = @"XYDChatCellIdentifierCustom";
static NSString *const XYDChatCellIdentifierGroup = @"XYDChatCellIdentifierGroup";
static NSString *const XYDChatCellIdentifierSingle = @"XYDChatCellIdentifierSingle";
static NSString *const XYDChatCellIdentifierOwnerSelf = @"XYDChatCellIdentifierOwnerSelf";
static NSString *const XYDChatCellIdentifierOwnerOther = @"XYDChatCellIdentifierOwnerOther";
static NSString *const XYDChatCellIdentifierOwnerSystem = @"XYDChatCellIdentifierOwnerSystem";

typedef int8_t XYDChatMessageMediaType;

FOUNDATION_EXTERN NSMutableDictionary const * XYDChatInputViewPluginDict;
FOUNDATION_EXTERN NSMutableArray const * XYDChatInputViewPluginArray;
static NSString *const XYDChatInputViewPluginTypeKey = @"XYDChatInputViewPluginTypeKey";
static NSString *const XYDChatInputViewPluginClassKey = @"XYDChatInputViewPluginClassKey";


/**
 *  默认插件的类型定义
 */
typedef NS_ENUM(NSUInteger, XYDChatInputViewPluginType) {
    XYDChatInputViewPluginTypeDefault = 0,       /**< 默认未知类型 */
    XYDChatInputViewPluginTypeTakePhoto = -1,         /**< 拍照 */
    XYDChatInputViewPluginTypePickImage = -2,         /**< 选择照片 */
    XYDChatInputViewPluginTypeLocation = -3,          /**< 地理位置 */
    XYDChatInputViewPluginTypeShortVideo = -4,        /**< 短视频 */
    //    XYDChatInputViewPluginTypeMorePanel= -7,         /**< 显示更多面板 */
    //    XYDChatInputViewPluginTypeText = -1,              /**< 文本输入 */
    //    XYDChatInputViewPluginTypeVoice = -2,             /**< 语音输入 */
};

//SDK定义的消息类型，自定义类型使用大于0的值
enum : XYDChatMessageMediaType {
    XYDChatMessageMediaTypeNone = 0,
    XYDChatMessageMediaTypeText = -1,
    XYDChatMessageMediaTypeImage = -2,
    XYDChatMessageMediaTypeAudio = -3,
    XYDChatMessageMediaTypeVideo = -4,
    XYDChatMessageMediaTypeLocation = -5,
    XYDChatMessageMediaTypeFile = -6,
    XYDChatMessageMediaTypeSystem = -7,
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

/*!
 *  提示信息的类型定义
 */
typedef enum : NSUInteger {
    /// 普通消息
    XYDChatMessageNotificationTypeMessage = 0,
    /// 警告
    XYDChatMessageNotificationTypeWarning,
    /// 错误
    XYDChatMessageNotificationTypeError,
    /// 成功
    XYDChatMessageNotificationTypeSuccess
} XYDChatMessageNotificationType;

/*!
 * HUD的行为
 */
typedef enum : NSUInteger {
    /// 展示
    XYDChatMessageHUDActionTypeShow,
    /// 隐藏
    XYDChatMessageHUDActionTypeHide,
    /// 错误
    XYDChatMessageHUDActionTypeError,
    /// 成功
    XYDChatMessageHUDActionTypeSuccess
} XYDChatMessageHUDActionType;

static NSInteger const kXYDChatOnePageSize = 10;
static NSString *const XYDChat_CONVERSATION_TYPE = @"type";
static NSString *const XYDChatInstallationKeyChannels = @"channels";

static NSString *const XYDChatDidReceiveMessagesUserInfoConversationKey = @"conversation";
static NSString *const XYDChatDidReceiveMessagesUserInfoMessagesKey = @"receivedMessages";
static NSString *const XYDChatDidReceiveCustomMessageUserInfoMessageKey = @"receivedCustomMessage";

#define XYDChat_CURRENT_TIMESTAMP ([[NSDate date] timeIntervalSince1970] * 1000)
#define XYDChat_FUTURE_TIMESTAMP ([[NSDate distantFuture] timeIntervalSince1970] * 1000)
//整数或小数
#define XYDChat_TIMESTAMP_REGEX @"^[0-9]*(.)?[0-9]*$"

// 通用动画时间
static CGFloat const XYDChatAnimateDuration = .25f;

#endif /* XYDChatConstant_h */
