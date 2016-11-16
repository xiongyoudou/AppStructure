//
//  XYDChatSessionService.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/10.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDSingleton.h"
#import "XYDChatServiceDefinition.h"
#import "XYDChatClient.h"
#import "XYDChatConstant.h"

FOUNDATION_EXTERN NSString *const XYDChatSessionServiceErrorDemain;

@interface XYDChatSessionService : XYDSingleton<XYDChatSessionService>

@property (nonatomic, copy, readonly) NSString *clientId;

/*!
 * AVIMClient 实例
 */
@property (nonatomic, strong, readonly) XYDChatClient *client;

/**
 *  是否和聊天服务器连通
 */
@property (nonatomic, assign, readonly) BOOL connect;

- (void)reconnectForViewController:(UIViewController *)reconnectForViewController callback:(XYDChatBooleanResultBlock)aCallback;


@end
