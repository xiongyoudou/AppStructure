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

@end
