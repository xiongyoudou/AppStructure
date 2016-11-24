//
//  XYDMessageSendManager.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/24.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYDChatConstant.h"
@class XYDChatMessage;

@interface XYDMessageSendManager : NSObject

@property (nonatomic,readonly)dispatch_queue_t sendMessageSendQueue;
@property (nonatomic,readonly)NSMutableArray* waitToSendMessage;
+ (instancetype)instance;

- (void)sendMessage:(XYDChatMessage *)message completion:(XYDChatMessageResultBlock)completion;

@end
