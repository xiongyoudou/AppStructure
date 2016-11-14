//
//  XYDChatTextMessage.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/11.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatTextMessage.h"

@implementation XYDChatTextMessage

+ (void)load {
    [self registerSubclass];
}

+ (XYDChatMessageMediaType)classMediaType {
    return XYDChatMessageMediaTypeText;
}


+ (instancetype)messageWithText:(NSString *)text
                     attributes:(NSDictionary *)attributes {
    XYDChatTextMessage *message = [[self alloc] init];
    message.text = text;
    message.attributes = attributes;
    return message;
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



@end
