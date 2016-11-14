//
//  XYDChatSystemMessage.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/11.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatMessage.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYDChatSystemMessage : XYDChatMessage

@property (nonatomic, copy, readonly) NSString *systemText;

- (void)setSystemText:(NSString *)text;

@end


NS_ASSUME_NONNULL_END
