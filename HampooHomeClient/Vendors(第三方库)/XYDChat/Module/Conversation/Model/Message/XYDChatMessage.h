//
//  XYDChatMessage.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/9.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatConstant.h"
#import <CoreLocation/CoreLocation.h>

@class XYDGeoPoint;

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
    XYDChatMessageMediaTypeSystem = -7,
    XYDChatMessageMediaTypeVCard = -8,
};

typedef NS_ENUM(int8_t, XYDChatMessageStatus) {
    XYDChatMessageStatusNone = 0,       // 无状态
    XYDChatMessageStatusSending = 1,    // 发送中
    XYDChatMessageStatusSent,           // 已发送
    XYDChatMessageStatusDelivered,      // 对方已读
    XYDChatMessageStatusFailed,         // 发送失败
};

NS_ASSUME_NONNULL_BEGIN

@protocol XYDChatMessageSubclassing <NSObject>
@required
/*!
 子类实现此方法用于返回该类对应的消息类型
 @return 消息类型
 */
+ (XYDChatMessageMediaType)classMediaType;
@end

/**
 *  多媒体类型消息的基类
 */
@interface XYDChatMessage : NSObject

@property (nonatomic, assign, readonly) NSTimeInterval timestamp;                   // 精确到毫秒，比如：1469413969460.018
@property (nonatomic, copy, readonly) NSString *serverMessageId;                    // 消息服务器id
@property (nonatomic, copy, readonly) NSString *localMessageId;                     // 发送失败的消息才需要有该属性，值和timestamp一样
@property (nonatomic, assign, getter=isLocalMessage, readonly) BOOL localMessage;   // 有localMessageId且没有serviceMessageId的属于localMessage;systemMessage不属于localMessage，localFeedbackText属于。
@property (nonatomic, copy, readonly) NSString *senderId;                           // 消息发送者id
@property (nonatomic, copy, readonly) NSString *conversationId;                     // 所属会话
@property (nonatomic, copy, readonly) NSString *toUserId;                           // 发送给用户的id
@property (nonatomic, assign, readonly) XYDChatMessageSendState sendStatus;         // 消息发送状态
@property (nonatomic, assign, readonly) XYDChatMessageOwnerType ownerType;          // 用来判断消息是否是对外发送
@property (nonatomic, assign, readonly) XYDChatMessageStatus status;                // 表示消息状态
@property (nonatomic, assign, readonly) XYDChatMessageMediaType mediaType;          // 消息类型，可自定义
@property (nonatomic, assign, readonly) XYDChatMessageReadState messageReadState;   // 已读状态

@property (nonatomic, strong, nullable) NSDictionary *attributes;          // 自定义属性

#pragma mark - 非持久化属性，通过其他关键属性计算得出

@property (nonatomic, strong, readonly) id<XYDChatUserDelegate> sender;          // 发送者用户信息
@property (nonatomic, copy, readonly) NSString *localDisplayName;                // 显示发送者的名称


/**
 *  子类调用此方法进行注册，一般可在子类的 [+(void)load] 方法里面调用
 */
+ (void)registerSubclass;

- (NSString *)messageId;

// 初始化文字类消息

- (instancetype)initWithText:(NSString *)text;
- (instancetype)initWithSystemText:(NSString *)text;
- (instancetype)initWithTimestamp:(NSTimeInterval)time;
- (instancetype)initWithLocalFeedbackText:(NSString *)localFeedbackText;

/**
 *  初始化图片类型的消息
 *
 *  @param thumbnailURLStr   目标图片在服务器的缩略图地址
 *  @param originPhotoURLStr 目标图片在服务器的原图地址
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithThumbnailURLStr:(NSString *)thumbnailURLStr
               originPhotoURLStr:(NSString *)originPhotoURLStr;

- (instancetype)initWithPhoto:(UIImage *)photo
               thumbnailPhoto:(UIImage *)thumbnailPhoto;

/**
 *  初始化视频类型的消息
 *
 *  @param voicePath   本地视频路径
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithVoicePath:(NSString *)voicePath duration:(float)duration;

// 初始化地理位置消息
- (instancetype)initWithPostionPhoto:(UIImage *)postionPhoto locations:(CLLocation *)location;

- (void)dealWithSendMessage:(XYDChatMessage *)message mediaType:(XYDChatMessageMediaType)mediaType;

@end

NS_ASSUME_NONNULL_END
