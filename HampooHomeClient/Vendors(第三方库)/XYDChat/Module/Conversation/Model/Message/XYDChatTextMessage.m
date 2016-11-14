//
//  XYDChatTextMessage.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/11.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatTextMessage.h"

@interface XYDChatTextMessage ()

@property (nonatomic,copy,nullable,readwrite) NSString *text;

@end

@implementation XYDChatTextMessage


+ (void)load {
    [self registerSubclass];
}

+ (XYDChatMessageMediaType)classMediaType {
    return XYDChatMessageMediaTypeText;
}

- (void)setText:(NSString *)text {
    _text = text;
}




@end
