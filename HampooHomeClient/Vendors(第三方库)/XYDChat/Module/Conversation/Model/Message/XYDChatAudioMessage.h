//
//  XYDChatAudioMessage.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/11.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatTypeMessage.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYDChatAudioMessage : XYDChatTypeMessage<XYDChatTypedMessageSubclassing>

/// File size in bytes.
@property(nonatomic, assign, readonly) uint64_t size;

/// Audio's duration in seconds.
@property(nonatomic, assign, readonly) float duration;

/// Audio format, mp3, aac, etc. Simply get it by the file extension.
@property(nonatomic, copy, readonly, nullable) NSString *format;

@property (nonatomic, copy, readonly) NSString *voicePath;
@property (nonatomic, strong, readonly) NSURL *voiceURL;
@property (nonatomic, copy, readonly) NSString *voiceDuration;

@end


NS_ASSUME_NONNULL_END
