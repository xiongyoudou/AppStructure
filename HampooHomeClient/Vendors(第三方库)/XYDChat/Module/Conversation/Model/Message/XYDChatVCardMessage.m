//
//  XYDChatVCardMessage.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/15.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatVCardMessage.h"

@implementation XYDChatVCardMessage

+ (void)load {
    [self registerSubclass];
}

+ (XYDChatMessageMediaType)classMediaType {
    return XYDChatMessageMediaTypeVideo;
}

@end
