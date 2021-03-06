//
//  XYDChatVoiceMessageCell.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/9.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatMessageCell.h"
#import "XYDAudioPlayer.h"


@interface XYDChatVoiceMessageCell : XYDChatMessageCell<XYDChatMessageCellSubclassing>

@property (nonatomic, assign) XYDChatVoiceMessageState voiceMessageState;

@end
