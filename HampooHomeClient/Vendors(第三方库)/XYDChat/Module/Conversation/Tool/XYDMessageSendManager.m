//
//  XYDMessageSendManager.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/24.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDMessageSendManager.h"

@interface XYDMessageSendManager () {
    NSUInteger _uploadImageCount;
}

@end

@implementation XYDMessageSendManager

+ (instancetype)instance {
    static XYDMessageSendManager* messageSendManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        messageSendManager = [[XYDMessageSendManager alloc] init];
    });
    return messageSendManager;
}

- (id)init {
    self = [super init];
    if (self) {
        _uploadImageCount = 0;
        _waitToSendMessage = [[NSMutableArray alloc] init];
        _sendMessageSendQueue = dispatch_queue_create("com.mogujie.Duoduo.sendMessageSend", NULL);
        
    }
    return self;
}

- (void)sendMessage:(XYDChatMessage *)message completion:(XYDChatMessageResultBlock)completion {
   
}

@end
