//
//  XYDChatMessage.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/9.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatMessage.h"
#import "XYDChatMessage_interal.h"

/*
 {
 "cmd": "direct",
 "cid": "549bc8a5e4b0606024ec1677",
 "r": false,
 "transient": false,
 "i": 5343,
 "msg": "hello, world",
 "appId": "appid",
 "peerId": "Tom"
 }
 */

@interface XYDChatMessage ()

@end

@implementation XYDChatMessage

+ (instancetype)messageWithContent:(NSString *)content {
    XYDChatMessage *message = [[self alloc] init];
    message.content = content;
    return message;
}

- (id)copyWithZone:(NSZone *)zone {
    XYDChatMessage *message = [[self class] allocWithZone:zone];
    if (message) {
        message.status = _status;
        message.messageId = _messageId;
        message.clientId = _clientId;
        message.conversationId = _conversationId;
        message.content = _content;
        message.sendTimestamp = _sendTimestamp;
        message.deliveredTimestamp = _deliveredTimestamp;
    }
    return message;
}

#pragma mark - 实现归档所需的两个方法

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:self.ioType forKey:@"ioType"];
    [coder encodeInteger:self.status forKey:@"status"];
    [coder encodeObject:self.messageId forKey:@"messageId"];
    [coder encodeObject:self.clientId forKey:@"clientId"];
    [coder encodeObject:self.conversationId forKey:@"conversationId"];
    [coder encodeObject:self.content forKey:@"content"];
    [coder encodeInteger:self.sendTimestamp forKey:@"sendTimestamp"];
    [coder encodeInteger:self.deliveredTimestamp forKey:@"deliveredTimestamp"];
    [coder encodeObject:self.localClientId forKey:@"localClientId"];
}

- (id)initWithCoder:(NSCoder *)coder {
    if ((self = [self init])) {
        self.ioType = [coder decodeIntegerForKey:@"ioType"];
        self.status = [coder decodeIntegerForKey:@"status"];
        self.messageId = [[coder decodeObjectForKey:@"messageId"]copy];
        self.clientId = [[coder decodeObjectForKey:@"clientId"]copy];
        self.conversationId = [[coder decodeObjectForKey:@"conversationId"]copy];
        self.content = [[coder decodeObjectForKey:@"content"]copy];
        self.sendTimestamp = [coder decodeIntegerForKey:@"sendTimestamp"];
        self.deliveredTimestamp = [coder decodeIntegerForKey:@"deliveredTimestamp"];
        self.localClientId = [[coder decodeObjectForKey:@"localClientId"]copy];
    }
    return self;
}

- (NSString *)messageId {
    return _messageId ?: (_messageId = [self tempMessageId]);
}

- (NSString *)payload {
    return self.content;
}

/* [-9223372036854775808 .. 9223372036854775807]~ */
- (NSString *)tempMessageId {
    static int64_t idx = INT64_MIN;
    return [NSString stringWithFormat:@"%lld~", idx++];
}

- (XYDChatMessageIOType)ioType {
    if (!self.clientId || !self.localClientId) {
        return XYDChatMessageIOTypeOut;
    }
    
    if ([self.clientId isEqualToString:self.localClientId]) {
        return XYDChatMessageIOTypeOut;
    } else {
        return XYDChatMessageIOTypeIn;
    }
}

@end
