//
//  XYDChatAudioMessage.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/11.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatMessage.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYDChatAudioMessage : XYDChatMessage<XYDChatTypedMessageSubclassing>

@property (nonatomic, strong, readonly) NSString *voiceURLStr;
@property (nonatomic, assign, readonly) float voiceDuration;

@property (nonatomic, copy, readonly) NSString *localVoicePath;

- (void)setVoiceURLStr:(NSString *)voiceURLStr
       voiceDuration:(float)voiceDuration;

- (void)setLocalVoicePath:(NSString * _Nonnull)localVoicePath;

@end


NS_ASSUME_NONNULL_END
