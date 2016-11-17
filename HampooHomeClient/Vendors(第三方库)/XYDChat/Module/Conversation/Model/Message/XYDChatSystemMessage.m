//
//  XYDChatSystemMessage.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/11.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatSystemMessage.h"

@interface XYDChatSystemMessage ()
@property (nonatomic, copy, readwrite) NSString *systemText;
@property (nonatomic, assign, getter=isLocalMessage, readwrite) BOOL localMessage;
@end

@implementation XYDChatSystemMessage

- (void)setSystemText:(NSString *)text {
    _systemText = text;
}



@end
