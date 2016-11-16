//
//  XYDChatFileMessage.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/11.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatMessage.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYDChatFileMessage : XYDChatMessage<XYDChatMessageSubclassing>

@property (nonatomic, strong, readonly, nullable) XYDFile               *file;       // 附件
@property(nonatomic, strong)NSString *attachedFilePath;  //附件


@end


NS_ASSUME_NONNULL_END
