//
//  XYDChatConstant.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/9.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatUserDelegate.h"
#ifndef XYDChatConstant_h
#define XYDChatConstant_h

@class XYDFile;
@class XYDConversation;
@class XYDConversationVCtrl;
@class XYDChatMessage;

#pragma mark - Base ViewController Life Time Block
///=============================================================================
/// @name Base ViewController Life Time Block
///=============================================================================

//Callback with Custom type
typedef void (^XYDChatUserResultsCallBack)(NSArray<id<XYDChatUserDelegate>> *users, NSError *error);
typedef void (^XYDChatUserResultCallBack)(id<XYDChatUserDelegate> user, NSError *error);
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
typedef void (^XYDChatMessageResultBlock)(XYDChatMessage * message, NSError * error);

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

FOUNDATION_EXTERN NSMutableDictionary const * XYDChatInputViewPluginDict;
FOUNDATION_EXTERN NSMutableArray const * XYDChatInputViewPluginArray;
static NSString *const XYDChatInputViewPluginTypeKey = @"XYDChatInputViewPluginTypeKey";
static NSString *const XYDChatInputViewPluginClassKey = @"XYDChatInputViewPluginClassKey";


/**
 *  未读数改变了。通知去服务器同步 installation 的badge
 */
static NSString *const XYDChatNotificationUnreadsUpdated = @"XYDChatNotificationUnreadsUpdated";

/**
 *  消息到来了，通知聊天页面和最近对话页面刷新
 */
static NSString *const XYDChatNotificationMessageReceived = @"XYDChatNotificationMessageReceived";
/**
 *  消息到来了，通知聊天页面和最近对话页面刷新
 */
static NSString *const XYDChatNotificationCustomMessageReceived = @"XYDChatNotificationCustomMessageReceived";

static NSString *const XYDChatNotificationCustomTransientMessageReceived = @"XYDChatNotificationCustomTransientMessageReceived";

/**
 *  消息到达对方了，通知聊天页面更改消息状态
 */
static NSString *const XYDChatNotificationMessageDelivered = @"XYDChatNotificationMessageDelivered";

/**
 *  对话的元数据变化了，通知页面刷新
 */
static NSString *const XYDChatNotificationConversationUpdated = @"XYDChatNotificationConversationUpdated";

/**
 *  聊天服务器连接状态更改了，通知最近对话和聊天页面是否显示红色警告条
 */
static NSString *const XYDChatNotificationConnectivityUpdated = @"XYDChatNotificationConnectivityUpdated";

/**
 * 会话失效，如当群被解散或当前用户不再属于该会话时，对应会话会失效应当被删除并且关闭聊天窗口
 */
static NSString *const XYDChatNotificationCurrentConversationInvalided = @"XYDChatNotificationCurrentConversationInvalided";

/**
 * 对话聊天背景切换
 */
static NSString *const XYDChatNotificationConversationViewControllerBackgroundImageDidChanged = @"XYDChatNotificationConversationViewControllerBackgroundImageDidChanged";

static NSString *const XYDChatNotificationConversationViewControllerBackgroundImageDidChangedUserInfoConversationIdKey = @"XYDChatNotificationConversationViewControllerBackgroundImageDidChangedUserInfoConversationIdKey";


static NSString *const XYDChatNotificationConversationInvalided = @"XYDChatNotificationConversationInvalided";
static NSString *const XYDChatNotificationConversationListDataSourceUpdated = @"XYDChatNotificationConversationListDataSourceUpdated";
static NSString *const XYDChatNotificationContactListDataSourceUpdated = @"XYDChatNotificationContactListDataSourceUpdated";

static NSString *const XYDChatNotificationContactListDataSourceUpdatedUserInfoDataSourceKey = @"XYDChatNotificationContactListDataSourceUpdatedUserInfoDataSourceKey";

static NSString *const XYDChatNotificationContactListDataSourceUserIdType = @"XYDChatNotificationContactListDataSourceUserIdType";
static NSString *const XYDChatNotificationContactListDataSourceContactObjType = @"XYDChatNotificationContactListDataSourceContactObjType";
static NSString *const XYDChatNotificationContactListDataSourceUpdatedUserInfoDataSourceTypeKey = @"XYDChatNotificationContactListDataSourceUpdatedUserInfoDataSourceTypeKey";

#pragma mark - 枚举类型定义

/**
 *  默认插件的类型定义
 */
typedef NS_ENUM(NSUInteger, XYDChatInputViewPluginType) {
    // 默认插件类型
    XYDChatInputViewPluginTypeDefault = 0,       /**< 默认未知类型 */
    XYDChatInputViewPluginTypeTakePhoto = -1,         /**< 拍照 */
    XYDChatInputViewPluginTypePickImage = -2,        /**< 选择照片 */
    XYDChatInputViewPluginTypeLocation = -3,         /**< 地理位置 */
    XYDChatInputViewPluginTypeShortVideo = -4,        /**< 短视频 */
    
    // 自定义插件类型（数值的正负是为了区分开来，代码中会用作判断）
    XYDChatInputViewPluginTypeRedPacket = 1,        /**< 红包 */
    XYDChatInputViewPluginTypeChange = 2,            /**< 零钱 */
    XYDChatInputViewPluginTypeVCard = 3,             /**< 名片 */
    XYDChatInputViewPluginTypeConverBackground = 4, /**< 修改聊天背景 */
    //    XYDChatInputViewPluginTypeMorePanel= -7,         /**< 显示更多面板 */
    //    XYDChatInputViewPluginTypeText = -1,              /**< 文本输入 */
    //    XYDChatInputViewPluginTypeVoice = -2,             /**< 语音输入 */
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

/* Cache policy */
typedef NS_ENUM(int, XYDChatCachePolicy) {
    /* Query from server and do not save result to local cache. */
    XYDChatCachePolicyIgnoreCache = 0,
    
    /* Only query from local cache. */
    XYDChatCachePolicyCacheOnly,
    
    /* Only query from server, and save result to local cache. */
    XYDChatCachePolicyNetworkOnly,
    
    /* Firstly query from local cache, if fails, query from server. */
    XYDChatCachePolicyCacheElseNetwork,
    
    /* Firstly query from server, if fails, query local cache. */
    XYDChatCachePolicyNetworkElseCache,
    
    /* Firstly query from local cache, then query from server. The callback will be called twice. */
    XYDChatCachePolicyCacheThenNetwork,
};

static NSString *const XYDChatBadgeTextForNumberGreaterThanLimit = @"···";

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

#pragma mark - 自定义UI行为
///=============================================================================
/// @name 自定义UI行为
///=============================================================================
// 通用动画时间
static CGFloat const XYDChatAnimateDuration = 0.25f;
static NSString *const XYDChatCustomConversationViewControllerBackgroundImageNamePrefix = @"CONVERSATION_BACKGROUND_";
static NSString *const XYDChatDefaultConversationViewControllerBackgroundImageName = @"CONVERSATION_BACKGROUND_ALL";


#endif /* XYDChatConstant_h */
