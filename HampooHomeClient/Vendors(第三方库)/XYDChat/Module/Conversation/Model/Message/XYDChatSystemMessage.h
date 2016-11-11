//
//  XYDChatSystemMessage.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/11.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatTypeMessage.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYDChatSystemMessage : XYDChatTypeMessage

@property (nonatomic, copy, readonly) NSString *systemText;

@end


NS_ASSUME_NONNULL_END
