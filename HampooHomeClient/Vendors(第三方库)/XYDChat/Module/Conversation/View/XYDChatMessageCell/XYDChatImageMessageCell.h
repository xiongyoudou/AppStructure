//
//  XYDChatImageMessageCell.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/9.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatMessageCell.h"

@interface XYDChatImageMessageCell : XYDChatMessageCell<XYDChatMessageCellSubclassing>

/**
 *  用来显示image的UIImageView
 */
@property (nonatomic, strong, readonly) UIImageView *messageImageView;

- (void)setUploadProgress:(CGFloat)uploadProgress;

@end
