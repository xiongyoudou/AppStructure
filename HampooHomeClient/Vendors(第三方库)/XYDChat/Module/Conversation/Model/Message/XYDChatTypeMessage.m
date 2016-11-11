//
//  XYDChatTypeMessage.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/9.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatTypeMessage.h"
#import "XYDFile.h"
#import "XYDGeoPoint.h"

NSMutableDictionary const *_typeDict = nil;

@interface XYDChatTypeMessage ()


@end

@implementation XYDChatTypeMessage

+ (void)registerSubclass {
    if ([self conformsToProtocol:@protocol(XYDChatTypedMessageSubclassing)]) {
        Class<XYDChatTypedMessageSubclassing> class = self;
        XYDChatMessageMediaType mediaType = [class classMediaType];
        [self registerClass:class forMediaType:mediaType];
    }
}

+ (Class)classForMediaType:(XYDChatMessageMediaType)mediaType {
    Class class = [_typeDict objectForKey:@(mediaType)];
    if (!class) {
        class = [XYDChatTypeMessage class];
    }
    return class;
}

+ (void)registerClass:(Class)class forMediaType:(XYDChatMessageMediaType)mediaType {
    if (!_typeDict) {
        _typeDict = [[NSMutableDictionary alloc] init];
    }
    Class c = [_typeDict objectForKey:@(mediaType)];
    if (!c || [class isSubclassOfClass:c]) {
        [_typeDict setObject:class forKey:@(mediaType)];
    }
}

+ (instancetype)messageWithText:(NSString *)text
                      mediaType:(XYDChatMessageMediaType)mediaType
               attachedFilePath:(NSString *)attachedFilePath
                     attributes:(NSDictionary *)attributes {
    XYDChatTypeMessage *message = [[self alloc] init];
    message.text = text;
    message.mediaType = mediaType;
    message.attributes = attributes;
    message.attachedFilePath = attachedFilePath;
    return message;
}

+ (instancetype)messageWithText:(NSString *)text
               attachedFilePath:(NSString *)attachedFilePath
                     attributes:(NSDictionary *)attributes {
    XYDChatTypeMessage *message = [[self alloc] init];
    message.text = text;
    message.attributes = attributes;
    message.attachedFilePath = attachedFilePath;
    return message;
}

+ (instancetype)messageWithText:(NSString *)text
                           file:(XYDFile *)file
                     attributes:(NSDictionary *)attributes {
    XYDChatTypeMessage *message = [[self alloc] init];
    message.text = text;
    message.attributes = attributes;
    message.file = file;
    return message;
}

+ (XYDFile *)fileFromDictionary:(NSDictionary *)dictionary {
    return dictionary ? [XYDFile fileFromDictionary:dictionary] : nil;
}

+ (XYDGeoPoint *)locationFromDictionary:(NSDictionary *)dictionary {
    if (dictionary) {
        return nil;
    } else {
        return nil;
    }
}

#pragma mark - 归档

- (id)copyWithZone:(NSZone *)zone {
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    
}

- (instancetype)init {
    if (![self conformsToProtocol:@protocol(XYDChatTypedMessageSubclassing)]) {
        [NSException raise:@"XYDChatNotSubclassException" format:@"Class does not conform XYDChatTypedMessageSubclassing protocol."];
    }
    if ((self = [super init])) {
        self.mediaType = [[self class] classMediaType];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    if ((self = [super initWithCoder:coder])) {
        
    }
    return self;
}



- (NSString *)payload {
  
}

- (instancetype)initWithText:(NSString *)text
                    senderId:(NSString *)senderId
                      sender:(id<XYDUserDelegate>)sender
                   timestamp:(NSTimeInterval)timestamp
             serverMessageId:(NSString *)serverMessageId {
    self = [super init];
    if (self) {
        _text = text;
        _sender = sender;
        _senderId = senderId;
        _timestamp = timestamp;
        _serverMessageId = serverMessageId;
        _mediaType = XYDChatMessageMediaTypeText;
    }
    return self;
}

- (NSString *)messageId {
    if (_serverMessageId) {
        return _serverMessageId;
    }
    if (_localMessageId) {
        return _localMessageId;
    }
    return nil;
}

- (NSString *)localDisplayName {
    NSString *localDisplayName = self.sender.name ?: self.senderId;
    if (!self.sender.name && [XYDChatSettingService sharedInstance].isDisablePreviewUserId) {
        //        NSString *defaultNickNameWhenNil = XYDChatLocalizedStrings(@"nickNameIsNil");
        //        localDisplayName = defaultNickNameWhenNil.length > 0 ? defaultNickNameWhenNil : @"";
    }
    return localDisplayName;
}

- (BOOL)isLocalMessage {
    if (!_serverMessageId &&_localMessageId) {
        return YES;
    }
    return NO;
}

- (void)setlocalMessageId:(NSString *)localMessageId {
    _localMessageId = localMessageId;
    _timestamp = [localMessageId doubleValue];
}

+ (instancetype)systemMessageWithTimestamp:(NSTimeInterval)time {
    NSDate *timestamp = [NSDate dateWithTimeIntervalSince1970:time / 1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
#ifdef XYDChatIsDebugging
    //如果定义了XYDChatIsDebugging则执行从这里到#endif的代码
    [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
#endif
    NSString *text = [dateFormatter stringFromDate:timestamp];
    XYDChatMsg *timeMessage = [[XYDChatMsg alloc] initWithSystemText:text];
    return timeMessage;
}

- (instancetype)initWithSystemText:(NSString *)text {
    self = [super init];
    if (self) {
        _systemText = text;
        _mediaType = XYDChatMessageMediaTypeSystem;
        _ownerType = XYDChatMessageOwnerTypeSystem;
    }
    return self;
}

- (instancetype)initWithLocalFeedbackText:(NSString *)localFeedbackText {
    self = [super init];
    if (self) {
        _systemText = localFeedbackText;
        _localMessageId = [[NSUUID UUID] UUIDString];
        _timestamp = XYDChat_CURRENT_TIMESTAMP;
        _mediaType = XYDChatMessageMediaTypeSystem;
        _ownerType = XYDChatMessageOwnerTypeSystem;
    }
    return self;
}

+ (instancetype)localFeedbackText:(NSString *)localFeedbackText {
    return [[self alloc] initWithLocalFeedbackText:localFeedbackText];
}

- (instancetype)initWithPhoto:(UIImage *)photo
               thumbnailPhoto:(UIImage *)thumbnailPhoto
                    photoPath:(NSString *)photoPath
                 thumbnailURL:(NSURL *)thumbnailURL
               originPhotoURL:(NSURL *)originPhotoURL
                     senderId:(NSString *)senderId
                       sender:(id<XYDUserDelegate>)sender
                    timestamp:(NSTimeInterval)timestamp
              serverMessageId:(NSString *)serverMessageId {
    self = [super init];
    if (self) {
        _photo = photo;
        _thumbnailPhoto = thumbnailPhoto;
        _photoPath = photoPath;
        _thumbnailURL = thumbnailURL;
        _originPhotoURL = originPhotoURL;
        _timestamp = timestamp;
        _serverMessageId = serverMessageId;
        _sender = sender;
        _senderId = senderId;
        _mediaType = XYDChatMessageMediaTypeImage;
    }
    return self;
}

- (instancetype)initWithVideoConverPhoto:(UIImage *)videoConverPhoto
                               videoPath:(NSString *)videoPath
                                videoURL:(NSURL *)videoURL
                                senderId:(NSString *)senderId
                                  sender:(id<XYDUserDelegate>)sender
                               timestamp:(NSTimeInterval)timestamp
                         serverMessageId:(NSString *)serverMessageId {
    self = [super init];
    if (self) {
        _videoConverPhoto = videoConverPhoto;
        _videoPath = videoPath;
        _videoURL = videoURL;
        _sender = sender;
        _senderId = senderId;
        _timestamp = timestamp;
        _serverMessageId = serverMessageId;
        _mediaType = XYDChatMessageMediaTypeVideo;
    }
    return self;
}

- (instancetype)initWithVoicePath:(NSString *)voicePath
                         voiceURL:(NSURL *)voiceURL
                    voiceDuration:(NSString *)voiceDuration
                         senderId:(NSString *)senderId
                           sender:(id<XYDUserDelegate>)sender
                        timestamp:(NSTimeInterval)timestamp
                  serverMessageId:(NSString *)serverMessageId {
    
    return [self initWithVoicePath:voicePath voiceURL:voiceURL voiceDuration:voiceDuration senderId:senderId sender:sender timestamp:timestamp hasRead:YES serverMessageId:serverMessageId];
}

- (instancetype)initWithVoicePath:(NSString *)voicePath
                         voiceURL:(NSURL *)voiceURL
                    voiceDuration:(NSString *)voiceDuration
                         senderId:(NSString *)senderId
                           sender:(id<XYDUserDelegate>)sender
                        timestamp:(NSTimeInterval)timestamp
                          hasRead:(BOOL)hasRead
                  serverMessageId:(NSString *)serverMessageId {
    self = [super init];
    if (self) {
        _voicePath = voicePath;
        _voiceURL = voiceURL;
        _voiceDuration = voiceDuration;
        _sender = sender;
        _senderId = senderId;
        _timestamp = timestamp;
        _serverMessageId = serverMessageId;
        _read = hasRead;
        _mediaType = XYDChatMessageMediaTypeAudio;
    }
    return self;
}

- (instancetype)initWithLocalPositionPhoto:(UIImage *)localPositionPhoto
                              geolocations:(NSString *)geolocations
                                  location:(CLLocation *)location
                                  senderId:(NSString *)senderId
                                    sender:(id<XYDUserDelegate>)sender
                                 timestamp:(NSTimeInterval)timestamp
                           serverMessageId:(NSString *)serverMessageId {
    self = [super init];
    if (self) {
        _localPositionPhoto = localPositionPhoto;
        _geolocations = geolocations;
        _location = location;
        _sender = sender;
        _senderId = senderId;
        _timestamp = timestamp;
        _serverMessageId = serverMessageId;
        _mediaType = XYDChatMessageMediaTypeLocation;
    }
    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        
        _text = [aDecoder decodeObjectForKey:@"text"];
        _systemText = [aDecoder decodeObjectForKey:@"systemText"];
        
        _photo = [aDecoder decodeObjectForKey:@"photo"];
        _thumbnailURL = [aDecoder decodeObjectForKey:@"thumbnailURL"];
        _originPhotoURL = [aDecoder decodeObjectForKey:@"originPhotoURL"];
        
        _videoConverPhoto = [aDecoder decodeObjectForKey:@"videoConverPhoto"];
        _videoPath = [aDecoder decodeObjectForKey:@"videoPath"];
        _videoURL = [aDecoder decodeObjectForKey:@"videoURL"];
        
        _voicePath = [aDecoder decodeObjectForKey:@"voicePath"];
        _voiceURL = [aDecoder decodeObjectForKey:@"voiceURL"];
        _voiceDuration = [aDecoder decodeObjectForKey:@"voiceDuration"];
        
        _emotionPath = [aDecoder decodeObjectForKey:@"emotionPath"];
        
        _localPositionPhoto = [aDecoder decodeObjectForKey:@"localPositionPhoto"];
        _geolocations = [aDecoder decodeObjectForKey:@"geolocations"];
        _location = [aDecoder decodeObjectForKey:@"location"];
        
        _sender = [aDecoder decodeObjectForKey:@"sender"];
        _senderId = [aDecoder decodeObjectForKey:@"senderId"];
        
        _timestamp = [aDecoder decodeInt64ForKey:@"timestamp"];
        _serverMessageId = [aDecoder decodeObjectForKey:@"serverMessageId"];
        _localMessageId = [aDecoder decodeObjectForKey:@"localMessageId"];
        
        _conversationId = [aDecoder decodeObjectForKey:@"conversationId"];
        _mediaType = [aDecoder decodeIntForKey:@"mediaType"];
        //        _messageGroupType = [aDecoder decodeIntForKey:@"messageGroupType"];
        _messageReadState = [aDecoder decodeIntForKey:@"messageReadState"];
        _ownerType = [aDecoder decodeIntForKey:@"ownerType"];
        _read = [aDecoder decodeBoolForKey:@"read"];
        _sendStatus = [aDecoder decodeIntForKey:@"sendStatus"];
        _photoPath = [aDecoder decodeObjectForKey:@"photoPath"];
        _thumbnailPhoto = [aDecoder decodeObjectForKey:@"thumbnailPhoto"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.text forKey:@"text"];
    [aCoder encodeObject:self.systemText forKey:@"systemText"];
    
    [aCoder encodeObject:self.photo forKey:@"photo"];
    [aCoder encodeObject:self.thumbnailURL forKey:@"thumbnailURL"];
    [aCoder encodeObject:self.originPhotoURL forKey:@"originPhotoURL"];
    
    [aCoder encodeObject:self.videoConverPhoto forKey:@"videoConverPhoto"];
    [aCoder encodeObject:self.videoPath forKey:@"videoPath"];
    [aCoder encodeObject:self.videoURL forKey:@"videoURL"];
    
    [aCoder encodeObject:self.voicePath forKey:@"voicePath"];
    [aCoder encodeObject:self.voiceURL forKey:@"voiceURL"];
    [aCoder encodeObject:self.voiceDuration forKey:@"voiceDuration"];
    
    [aCoder encodeObject:self.emotionPath forKey:@"emotionPath"];
    
    [aCoder encodeObject:self.localPositionPhoto forKey:@"localPositionPhoto"];
    [aCoder encodeObject:self.geolocations forKey:@"geolocations"];
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.sender forKey:@"sender"];
    [aCoder encodeObject:self.senderId forKey:@"senderId"];
    
    [aCoder encodeInt64:self.timestamp forKey:@"timestamp"];
    [aCoder encodeObject:self.serverMessageId forKey:@"serverMessageId"];
    [aCoder encodeObject:self.localMessageId forKey:@"localMessageId"];
    
    [aCoder encodeObject:self.conversationId forKey:@"conversationId"];
    [aCoder encodeInt:self.mediaType forKey:@"mediaType"];
    //    [aCoder encodeInt:self.messageGroupType forKey:@"messageGroupType"];
    [aCoder encodeInt:self.messageReadState forKey:@"messageReadState"];
    [aCoder encodeInt:self.ownerType forKey:@"ownerType"];
    [aCoder encodeBool:self.read forKey:@"read"];
    [aCoder encodeInt:self.sendStatus forKey:@"sendStatus"];
    [aCoder encodeObject:self.photoPath forKey:@"photoPath"];
    [aCoder encodeObject:self.thumbnailPhoto forKey:@"thumbnailPhoto"];
    
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    XYDChatMsg *message;
    switch (self.mediaType) {
        case XYDChatMessageMediaTypeText: {
            message = [[[self class] allocWithZone:zone] initWithText:[self.text copy]
                                                             senderId:[self.senderId copy]
                                                               sender:[self.sender copyWithZone:nil]
                                                            timestamp:self.timestamp
                                                      serverMessageId:[self.serverMessageId copy]];
            
        }
            break;
        case XYDChatMessageMediaTypeImage: {
            message =  [[[self class] allocWithZone:zone] initWithPhoto:[self.photo copy]
                                                         thumbnailPhoto:[self.thumbnailPhoto copy]
                                                              photoPath:[self.photoPath copy]
                                                           thumbnailURL:[self.thumbnailURL copy]
                                                         originPhotoURL:[self.originPhotoURL copy]
                                                               senderId:[self.senderId copy]
                                                                 sender:[self.sender copyWithZone:nil]
                                                              timestamp:self.timestamp
                                                        serverMessageId:[self.serverMessageId copy]];
            
        }
            break;
        case XYDChatMessageMediaTypeVideo: {
            message = [[[self class] allocWithZone:zone] initWithVideoConverPhoto:[self.videoConverPhoto copy]
                                                                        videoPath:[self.videoPath copy]
                                                                         videoURL:[self.videoURL copy]
                                                                         senderId:[self.senderId copy]
                                                                           sender:[self.sender copyWithZone:nil]
                                                                        timestamp:self.timestamp
                                                                  serverMessageId:[self.serverMessageId copy]];
            
        }
            break;
        case XYDChatMessageMediaTypeAudio: {
            message =  [[[self class] allocWithZone:zone] initWithVoicePath:[self.voicePath copy]
                                                                   voiceURL:[self.voiceURL copy]
                                                              voiceDuration:[self.voiceDuration copy]
                                                                   senderId:[self.senderId copy]
                                                                     sender:[self.sender copyWithZone:nil]
                                                                  timestamp:self.timestamp
                                                            serverMessageId:[self.serverMessageId copy]];
            
        }
            break;
            //        case XYDChatMessageTypeEmotion: {
            //            message =  [[[self class] allocWithZone:zone] initWithEmotionPath:[self.emotionPath copy]
            //                                                                  emotionName:[self.emotionName copy]
            //                                                                       senderId:[self.senderId copy]
            //                                                                         sender:[self.sender copyWithZone:nil]
            //                                                                    timestamp:self.timestamp
            //                                                              serverMessageId:[self.serverMessageId copy]];
            //
            //        }
            //            break;
        case XYDChatMessageMediaTypeLocation: {
            message =  [[[self class] allocWithZone:zone] initWithLocalPositionPhoto:[self.localPositionPhoto copy]
                                                                        geolocations:[self.geolocations copy]
                                                                            location:[self.location copy]
                                                                            senderId:[self.senderId copy]
                                                                              sender:[self.sender copyWithZone:nil]
                                                                           timestamp:self.timestamp
                                                                     serverMessageId:[self.serverMessageId copy]];
        }
            break;
        case XYDChatMessageMediaTypeSystem: {
            message = [[[self class] allocWithZone:zone] initWithSystemText:[self.systemText copy]];
        }
            break;
        case XYDChatMessageMediaTypeNone: {
            //TODO:
        }
            break;
    }
    //    message.photo = [self.photo copy];
    //    message.photoPath = [self.photoPath copy];
    
    message.localMessageId = [self.localMessageId copy];
    message.conversationId = [self.conversationId copy];
    message.mediaType = self.mediaType;
    //    message.messageGroupType = self.messageGroupType;
    message.messageReadState = self.messageReadState;
    message.sendStatus = self.sendStatus;
    message.read = self.read;
    return message;
}


@end
