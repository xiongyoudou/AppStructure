//
//  XYDChatAudioMessage.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/11.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatAudioMessage.h"

@implementation XYDChatAudioMessage

+ (void)load {
    [self registerSubclass];
}

+ (XYDChatMessageMediaType)classMediaType {
    return XYDChatMessageMediaTypeAudio;
}

- (void)setVoiceURLStr:(NSString *)voiceURLStr
         voiceDuration:(float)voiceDuration {
    _voiceURLStr = voiceURLStr;
    _voiceDuration = voiceDuration;
}

- (void)setLocalVoicePath:(NSString * _Nonnull)localVoicePath duration:(float)duration {
    _localVoicePath = localVoicePath;
    _voiceDuration = duration;
}


@end
