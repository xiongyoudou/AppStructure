//
//  XYDChatMessage+XYDChatMessage_interal.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/9.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatMessage.h"

@interface XYDChatMessage ()

/*!
 * Wether message has breakpoint or not
 */
@property (assign) BOOL breakpoint;

/*!
 * Wether message is offline or not
 */
@property (nonatomic, assign) BOOL offline;

/*!
 * Wether has more messages before current message
 */
@property (nonatomic, assign) BOOL hasMore;

/*!
 * Id of local client which owns the message
 */
@property (nonatomic, copy) NSString *localClientId;

/*!
 * Wether message is transient or not
 */
@property (nonatomic, assign) BOOL transient;


//======================================================================
//====== override readonly property to readwrite for internal use ======
//======================================================================

@property (nonatomic, assign) XYDChatMessageIOType ioType;
/* 表示消息状态*/
@property (nonatomic, assign) XYDChatMessageStatus status;
/*消息 id*/
@property (nonatomic, copy) NSString *messageId;
/*消息发送/接收方 id*/
@property (nonatomic, copy) NSString *clientId;
/*消息所属对话的 id*/
@property (nonatomic, copy) NSString *conversationId;



@end
