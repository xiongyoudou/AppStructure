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

#import "XYDChatTextMessage.h"
#import "XYDChatSystemMessage.h"
#import "XYDChatImageMessage.h"
#import "XYDChatLocationMessage.h"
#import "XYDChatFileMessage.h"
#import "XYDChatAudioMessage.h"
#import "XYDChatVideoMessage.h"

NSMutableDictionary const *_typeDict = nil;

@interface XYDChatMessage ()

@property (nonatomic, assign, readwrite) NSTimeInterval timestamp;
@property (nonatomic, copy, readwrite) NSString *serverMessageId;
@property (nonatomic, copy, readwrite) NSString *localMessageId;
@property (nonatomic, assign, getter=isLocalMessage, readwrite) BOOL localMessage;
@property (nonatomic, copy, readwrite) NSString *senderId;
@property (nonatomic, copy, readwrite) NSString *conversationId;
@property (nonatomic, copy, readwrite) NSString *toUserId;
@property (nonatomic, assign, readwrite) XYDChatMessageSendState sendStatus;
@property (nonatomic, assign, readwrite) XYDChatMessageOwnerType ownerType;
@property (nonatomic, assign, readwrite) XYDChatMessageStatus status;
@property (nonatomic, assign, readwrite) XYDChatMessageMediaType mediaType;
@property (nonatomic, assign, readwrite) XYDChatMessageReadState messageReadState;
@property (nonatomic, strong, nullable,readwrite) NSDictionary *attributes;

@end

@implementation XYDChatMessage

+ (void)registerSubclass {
    if ([self conformsToProtocol:@protocol(XYDChatTypedMessageSubclassing)]) {
        Class<XYDChatTypedMessageSubclassing> class = self;
        XYDChatMessageMediaType mediaType = [class classMediaType];
        [self registerClass:class forMediaType:mediaType];
    }
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

#pragma mark - 需要计算的属性值

- (NSString *)localDisplayName {
    NSString *localDisplayName = self.sender.name ?: self.senderId;
    if (!self.sender.name && [XYDChatSettingService sharedInstance].isDisablePreviewUserId) {
    }
    return localDisplayName;
}

- (BOOL)isLocalMessage {
    if (!_serverMessageId &&_localMessageId) {
        return YES;
    }
    return NO;
}

#pragma mark - 生成相应类型的消息
- (instancetype)initWithText:(NSString *)text
                  toUserId:(NSString *)toSenderId {
    XYDChatTextMessage *message = [XYDChatTextMessage new];
    [message setText:text];
    message.toUserId = toSenderId;
    [self dealWithSendMessage:message];
    return message;
}

- (instancetype)initWithText:(NSString *)text
                      convId:(NSString *)convId {
    XYDChatTextMessage *message = [XYDChatTextMessage new];
    [message setText:text];
    message.conversationId = convId;
    [self dealWithSendMessage:message];
    return message;
}

- (instancetype)initWithSystemText:(NSString *)text {
    XYDChatSystemMessage *message = [XYDChatSystemMessage new];
    [message setSystemText:text];
    [self dealWithSendMessage:message];
    return message;
}

- (instancetype)initWithLocalFeedbackText:(NSString *)localFeedbackText{
    XYDChatTextMessage *message = [XYDChatTextMessage new];
    [message setText:localFeedbackText];
    message.localMessage = YES;
    [self dealWithSendMessage:message];
    return message;
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


#pragma mark - private methods

// 处理即将发送的消息
- (void)dealWithSendMessage:(XYDChatMessage *)message {
    message.timestamp = [NSString xyd_UUIDTimestampDoubleValue];
    message.localMessageId = [NSString stringWithFormat:@"%f",message.timestamp];
    
}

@end
