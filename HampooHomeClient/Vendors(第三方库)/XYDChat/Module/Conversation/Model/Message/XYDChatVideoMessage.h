//
//  XYDChatVideoMessage.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/11.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatMessage.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYDChatVideoMessage : XYDChatMessage<XYDChatTypedMessageSubclassing>

/// File size in bytes.
@property(nonatomic, assign, readonly) uint64_t size;

/// Duration of the video in seconds.
@property(nonatomic, assign, readonly) float duration;

/// Video format, mp4, m4v, etc. Simply get it from the file extension.
@property(nonatomic, copy, readonly, nullable) NSString *format;

@property (nonatomic, strong, readonly) UIImage *videoConverPhoto;
@property (nonatomic, copy, readonly) NSString *videoPath;
@property (nonatomic, strong, readonly) NSURL *videoURL;

@end

NS_ASSUME_NONNULL_END
