//
//  XYDChatErrorUtil.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/17.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *XYDChatErrorDomain;

extern NSInteger const kXYDChatErrorInvalidCommand;  //非法的请求命令
extern NSInteger const kXYDChatErrorInvalidArguments;  //非法参数
extern NSInteger const kXYDChatErrorConversationNotFound;  //会话未找到
extern NSInteger const kXYDChatErrorTimeout;  //请求超时
extern NSInteger const kXYDChatErrorConnectionLost;  //连接断开
extern NSInteger const kXYDChatErrorInvalidData;  //非法数据
extern NSInteger const kXYDChatErrorMessageTooLong;  //消息内容太长
extern NSInteger const kXYDChatErrorClientNotOpen;  //client 没有打开

// 处理聊天过程中的各种错误
@interface XYDChatErrorUtil : NSObject

+ (NSError *)errorWithCode:(NSInteger)code reason:(NSString *)reason;

@end
