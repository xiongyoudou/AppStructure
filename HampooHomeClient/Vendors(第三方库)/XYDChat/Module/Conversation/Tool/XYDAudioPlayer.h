//
//  XYDAudioPlayer.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/10.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

//  XYDAudioPlayer
//  提供一个可以播放本地,网路MP3等格式的播放控制
//  传入URLString,index->检测是否有正在加载,正在播放的音频(停止加载,停止播放)->检查URLString是本地还是网络路径(网络路径下载到本地,并且缓存到本地目录下)->开始播放加载到的audioData->播放结束

#import <Foundation/Foundation.h>

/**
 *  录音消息的状态
 */
typedef NS_ENUM(NSUInteger, XYDChatVoiceMessageState){
    XYDChatVoiceMessageStateNormal,/**< 未播放状态 */
    XYDChatVoiceMessageStateDownloading,/**< 正在下载中 */
    XYDChatVoiceMessageStatePlaying,/**< 正在播放 */
    XYDChatVoiceMessageStateCancel,/**< 播放被取消 */
};

@interface XYDAudioPlayer : NSObject

@property (nonatomic, copy) NSString *URLString;

/**
 *  identifier -> 主要作用是提供记录,用来控制对应的tableViewCell的状态
 */
@property (nonatomic, copy) NSString *identifier;

/**
 *  当前播放器播放的状态,当tableView滚动时,匹配index来设置对应的audioPlayerState
 */
@property (nonatomic, assign) XYDChatVoiceMessageState audioPlayerState;

+ (instancetype)sharePlayer;

- (void)playAudioWithURLString:(NSString *)URLString identifier:(NSString *)identifier;

- (void)stopAudioPlayer;

- (void)cleanAudioCache;

@end
