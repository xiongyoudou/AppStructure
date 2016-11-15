//
//  XYDSoundManager.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/15.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDSoundManager.h"
#import "XYDChatSettingService.h"
#import <AudioToolbox/AudioToolbox.h>

@interface XYDSoundManager ()

@property (nonatomic, assign) SystemSoundID loudReceiveSound;
@property (nonatomic, assign) SystemSoundID sendSound;
@property (nonatomic, assign) SystemSoundID receiveSound;

@end

@implementation XYDSoundManager

+ (instancetype)defaultManager {
    static XYDSoundManager *soundManager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        soundManager = [[XYDSoundManager alloc] init];
    });
    return soundManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setDefaultSettings];
        [self createSoundWithURL:[self soundURLWithName:@"loudReceive"] soundId:&_loudReceiveSound];
        [self createSoundWithURL:[self soundURLWithName:@"send"] soundId:&_sendSound];
        [self createSoundWithURL:[self soundURLWithName:@"receive"] soundId:&_receiveSound];
    }
    return self;
}

- (NSURL *)soundURLWithName:(NSString *)soundName {
    NSBundle *bundle = [NSBundle xyd_bundleForName:@"VoiceMessageSource" class:[self class]];
    NSURL *url = [bundle URLForResource:soundName withExtension:@"caf"];
    return url;
}

- (void)createSoundWithURL:(NSURL *)URL soundId:(SystemSoundID *)soundId {
    OSStatus errorCode = AudioServicesCreateSystemSoundID((__bridge CFURLRef)(URL) , soundId);
    if (errorCode != 0) {
//        XYDLog(@"create sound failed");
    }
}

- (void)playSendSoundIfNeed {
    if (self.needPlaySoundWhenChatting) {
        AudioServicesPlaySystemSound(_sendSound);
    }
}

- (void)playReceiveSoundIfNeed {
    if (self.needPlaySoundWhenChatting) {
        AudioServicesPlaySystemSound(_receiveSound);
    }
}

- (void)playLoudReceiveSoundIfNeed {
    if (self.needPlaySoundWhenNotChatting) {
        AudioServicesPlaySystemSound(_loudReceiveSound);
    }
}

- (void)vibrateIfNeed {
    if (self.needVibrateWhenNotChatting) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

#pragma mark - local data

- (void)setNeedPlaySoundWhenChatting:(BOOL)needPlaySoundWhenChatting {
    _needPlaySoundWhenChatting = needPlaySoundWhenChatting;
    [[NSUserDefaults standardUserDefaults] setObject:@(self.needPlaySoundWhenChatting) forKey:XYDCHAT_STRING_BY_SEL(needPlaySoundWhenChatting)];
}

- (void)setNeedPlaySoundWhenNotChatting:(BOOL)needPlaySoundWhenNotChatting {
    _needPlaySoundWhenNotChatting = needPlaySoundWhenNotChatting;
    [[NSUserDefaults standardUserDefaults] setObject:@(self.needPlaySoundWhenNotChatting) forKey:XYDCHAT_STRING_BY_SEL(needPlaySoundWhenNotChatting)];
}

- (void)setNeedVibrateWhenNotChatting:(BOOL)needVibrateWhenNotChatting {
    _needVibrateWhenNotChatting = needVibrateWhenNotChatting;
    [[NSUserDefaults standardUserDefaults] setObject:@(self.needVibrateWhenNotChatting) forKey:XYDCHAT_STRING_BY_SEL(needVibrateWhenNotChatting)];
}

- (void)setDefaultSettings {
    NSDictionary *defaultSettings = [XYDChatSettingService sharedInstance].defaultSettings;
    NSDictionary *conversationSettings = defaultSettings[@"Conversation"];
    self.needPlaySoundWhenChatting =  [conversationSettings[XYDCHAT_STRING_BY_SEL(needPlaySoundWhenChatting)] boolValue];
    self.needPlaySoundWhenNotChatting  = [conversationSettings[XYDCHAT_STRING_BY_SEL(needPlaySoundWhenNotChatting)] boolValue];
    self.needVibrateWhenNotChatting = [conversationSettings[XYDCHAT_STRING_BY_SEL(needVibrateWhenNotChatting)] boolValue];
}

@end
