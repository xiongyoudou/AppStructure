//
//  XYDChatTypeMessage.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/9.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatMessage.h"
#import "XYDChatConstant.h"
#import <CoreLocation/CoreLocation.h>

@class XYDFile;
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
};

NS_ASSUME_NONNULL_BEGIN

@protocol XYDChatTypedMessageSubclassing <NSObject>
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
@interface XYDChatTypeMessage : XYDChatMessage

@property (nonatomic, assign)                     XYDChatMessageMediaType  mediaType;  // 消息类型，可自定义
@property (nonatomic,   copy, nullable)           NSString             *text;       // 消息文本
@property (nonatomic, strong, nullable)           NSDictionary         *attributes; // 自定义属性
@property (nonatomic, copy, readonly) NSString *serverMessageId;
@property (nonatomic, assign) NSTimeInterval timestamp;
@property (nonatomic, assign, readonly) XYDChatMessageReadState messageReadState;
/*!
 * 有localMessageId且没有serviceMessageId的属于localMessage，其中
 * systemMessage不属于localMessage，localFeedbackText属于。
 */
@property (nonatomic, assign, getter=isLocalMessage) BOOL localMessage;
/*!
 * just for failed message store, its value is always not same to serverMessageId. value is same to timestamp.
 */
@property (nonatomic, copy, readwrite) NSString *localMessageId;

@property (nonatomic, copy, readonly) NSString *localDisplayName;


@property(nonatomic, strong)NSString *attachedFilePath;  //附件

/**
 *  子类调用此方法进行注册，一般可在子类的 [+(void)load] 方法里面调用
 */
+ (void)registerSubclass;

/*!
 使用本地文件，创建消息。
 @param text － 消息文本。
 @param attachedFilePath － 本地文件路径。
 @param attributes － 用户附加属性。
 */
+ (instancetype)messageWithText:(NSString *)text
               attachedFilePath:(NSString *)attachedFilePath
                     attributes:(nullable NSDictionary *)attributes;

/*!
 使用 XYDFile，创建消息。
 @param text － 消息文本。
 @param file － AVFile 对象。
 @param attributes － 用户附加属性。
 */
+ (instancetype)messageWithText:(NSString *)text
                           file:(XYDFile *)file
                     attributes:(nullable NSDictionary *)attributes;

- (instancetype)initWithText:(NSString *)text
                    senderId:(NSString *)senderId
                      sender:(id<XYDUserDelegate>)sender
                   timestamp:(NSTimeInterval)timestamp
             serverMessageId:(NSString *)serverMessageId;

- (instancetype)initWithSystemText:(NSString *)text;
+ (instancetype)systemMessageWithTimestamp:(NSTimeInterval)timestamp;
- (instancetype)initWithLocalFeedbackText:(NSString *)localFeedbackText;
+ (instancetype)localFeedbackText:(NSString *)localFeedbackText;

/**
 *  初始化图片类型的消息
 *
 *  @param photo          目标图片
 *  @param photoPath      目标图片的本地路径
 *  @param thumbnailURL   目标图片在服务器的缩略图地址
 *  @param originPhotoURL 目标图片在服务器的原图地址
 *  @param sender         发送者
 *  @param timestamp           发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithPhoto:(UIImage *)photo
               thumbnailPhoto:(UIImage *)thumbnailPhoto
                    photoPath:(NSString *)photoPath
                 thumbnailURL:(NSURL *)thumbnailURL
               originPhotoURL:(NSURL *)originPhotoURL
                     senderId:(NSString *)senderId
                       sender:(id<XYDUserDelegate>)sender
                    timestamp:(NSTimeInterval)timestamp
              serverMessageId:(NSString *)serverMessageId;

/**
 *  初始化视频类型的消息
 *
 *  @param videoConverPhoto 目标视频的封面图
 *  @param videoPath        目标视频的本地路径，如果是下载过，或者是从本地发送的时候，会存在
 *  @param videoURL         目标视频在服务器上的地址
 *  @param sender           发送者
 *  @param timestamp             发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithVideoConverPhoto:(UIImage *)videoConverPhoto
                               videoPath:(NSString *)videoPath
                                videoURL:(NSURL *)videoURL
                                senderId:(NSString *)senderId
                                  sender:(id<XYDUserDelegate>)sender
                               timestamp:(NSTimeInterval)timestamp
                         serverMessageId:(NSString *)serverMessageId;

/**
 *  初始化语音类型的消息
 *
 *  @param voicePath        目标语音的本地路径
 *  @param voiceURL         目标语音在服务器的地址
 *  @param voiceDuration    目标语音的时长
 *  @param sender           发送者
 *  @param timestamp             发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithVoicePath:(NSString *)voicePath
                         voiceURL:(NSURL *)voiceURL
                    voiceDuration:(NSString *)voiceDuration
                         senderId:(NSString *)senderId
                           sender:(id<XYDUserDelegate>)sender
                        timestamp:(NSTimeInterval)timestamp
                  serverMessageId:(NSString *)serverMessageId;

/**
 *  初始化语音类型的消息。增加已读未读标记
 *
 *  @param voicePath        目标语音的本地路径
 *  @param voiceURL         目标语音在服务器的地址
 *  @param voiceDuration    目标语音的时长
 *  @param sender           发送者
 *  @param timestamp             发送时间
 *  @param hasRead           已读未读标记
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithVoicePath:(NSString *)voicePath
                         voiceURL:(NSURL *)voiceURL
                    voiceDuration:(NSString *)voiceDuration
                         senderId:(NSString *)senderId
                           sender:(id<XYDUserDelegate>)sender
                        timestamp:(NSTimeInterval)timestamp
                          hasRead:(BOOL)hasRead
                  serverMessageId:(NSString *)serverMessageId;

- (instancetype)initWithLocalPositionPhoto:(UIImage *)localPositionPhoto
                              geolocations:(NSString *)geolocations
                                  location:(CLLocation *)location
                                  senderId:(NSString *)senderId
                                    sender:(id<XYDUserDelegate>)sender
                                 timestamp:(NSTimeInterval)timestamp
                           serverMessageId:(NSString *)serverMessageId;

@end

NS_ASSUME_NONNULL_END
