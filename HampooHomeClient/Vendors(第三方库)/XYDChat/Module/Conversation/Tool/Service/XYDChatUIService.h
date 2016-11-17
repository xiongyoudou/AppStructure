//
//  XYDChatUIService.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/10.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDSingleton.h"
#import "XYDChatServiceDefinition.h"

FOUNDATION_EXTERN NSString *const XYDChatUIServiceErrorDomain;

@interface XYDChatUIService : XYDSingleton<XYDChatUIService>

/*!
 *  未读数发生变化
 */
typedef void(^XYDChatUnreadCountChangedBlock)(NSInteger count);
@property (nonatomic, copy, readonly) XYDChatUnreadCountChangedBlock unreadCountChangedBlock;
- (void)setUnreadCountChangedBlock:(XYDChatUnreadCountChangedBlock)unreadCountChangedBlock;
//TODO:
/**
 *  新消息通知
 */
typedef void(^XYDChatOnNewMessageBlock)(NSString *senderId, NSString *content, NSInteger type, NSDate *time);

@end
