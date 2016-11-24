//
//  XYDChatMessage+Internal.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/24.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatMessage.h"

// 将属性暴露给应该使用的类使用
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

@end
