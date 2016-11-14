//
//  XYDChatMessage.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/9.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatMessage.h"
#import "XYDFile.h"
#import "XYDGeoPoint.h"
#import "XYDChatSettingService.h"

NSMutableDictionary const *_typeDict = nil;

@interface XYDChatMessage ()


@end

@implementation XYDChatMessage

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
        class = [XYDChatMessage class];
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
- (instancetype)init {
    if (![self conformsToProtocol:@protocol(XYDChatTypedMessageSubclassing)]) {
        [NSException raise:@"XYDChatNotSubclassException" format:@"Class does not conform XYDChatTypedMessageSubclassing protocol."];
    }
    if ((self = [super init])) {
        self.mediaType = [[self class] classMediaType];
    }
    return self;
}

- (NSString *)payload {
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
    XYDChatMessage *timeMessage = [[XYDChatMessage alloc] initWithSystemText:text];
    return timeMessage;
}



+ (instancetype)localFeedbackText:(NSString *)localFeedbackText {
    return [[self alloc] initWithLocalFeedbackText:localFeedbackText];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _timestamp = [aDecoder decodeInt64ForKey:@"timestamp"];
        _serverMessageId = [aDecoder decodeObjectForKey:@"serverMessageId"];
        _localMessageId = [aDecoder decodeObjectForKey:@"localMessageId"];
        _localMessage = [aDecoder decodeBoolForKey:@"localMessage"];
        _senderId = [aDecoder decodeObjectForKey:@"senderId"];
         _conversationId = [aDecoder decodeObjectForKey:@"conversationId"];
        _sendStatus = [aDecoder decodeIntegerForKey:@"sendStatus"];
        _ownerType = [aDecoder decodeIntegerForKey:@"ownerType"];
        _status = [aDecoder decodeIntegerForKey:@"status"];
        _mediaType = [aDecoder decodeIntegerForKey:@"mediaType"];
        _messageReadState = [aDecoder decodeIntegerForKey:@"messageReadState"];
        _localMessage = [aDecoder decodeBoolForKey:@"localMessage"];
        _attributes = [aDecoder decodeObjectForKey:@"attributes"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt64:self.timestamp forKey:@"_timestamp"];
    [aCoder encodeObject:self.serverMessageId forKey:@"serverMessageId"];
    [aCoder encodeObject:self.localMessageId forKey:@"localMessageId"];
    [aCoder encodeBool:self.localMessage forKey:@"localMessage"];
    [aCoder encodeObject:self.senderId forKey:@"senderId"];
    [aCoder encodeObject:self.conversationId forKey:@"conversationId"];
    [aCoder encodeInteger:self.sendStatus forKey:@"sendStatus"];
    [aCoder encodeInteger:self.ownerType forKey:@"ownerType"];
    [aCoder encodeInteger:self.status forKey:@"status"];
    [aCoder encodeInteger:self.mediaType forKey:@"mediaType"];
    [aCoder encodeInteger:self.messageReadState forKey:@"messageReadState"];
    [aCoder encodeBool:self.localMessage forKey:@"localMessage"];
    [aCoder encodeObject:self.attributes forKey:@"attributes"];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    XYDChatMessage *message;
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
