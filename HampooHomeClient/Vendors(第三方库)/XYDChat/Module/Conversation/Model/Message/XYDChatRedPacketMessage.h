//
//  XYDChatRedPacketMessage.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/15.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatMessage.h"
#import "RedpacketMessageModel.h"

@interface XYDChatRedPacketMessage : XYDChatMessage<XYDChatTypedMessageSubclassing>

/**
 *  红包相关数据模型
 */
@property (nonatomic,strong)RedpacketMessageModel * rpModel;

@end
