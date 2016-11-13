//
//  XYDChatSystemMessage.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/11.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatSystemMessage.h"

@implementation XYDChatSystemMessage

- (instancetype)initWithSystemText:(NSString *)text {
    self = [super init];
    if (self) {
        _systemText = text;
        _mediaType = XYDChatMessageMediaTypeSystem;
        _ownerType = XYDChatMessageOwnerTypeSystem;
    }
    return self;
}

@end
