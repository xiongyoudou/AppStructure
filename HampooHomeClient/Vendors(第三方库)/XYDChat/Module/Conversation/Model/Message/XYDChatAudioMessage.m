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

- (instancetype)initWithVoicePath:(NSString *)voicePath
                         voiceURL:(NSURL *)voiceURL
                    voiceDuration:(NSString *)voiceDuration
                         senderId:(NSString *)senderId
                           sender:(id<XYDUserDelegate>)sender
                        timestamp:(NSTimeInterval)timestamp
                  serverMessageId:(NSString *)serverMessageId {
    
    return [self initWithVoicePath:voicePath voiceURL:voiceURL voiceDuration:voiceDuration senderId:senderId sender:sender timestamp:timestamp hasRead:YES serverMessageId:serverMessageId];
}

- (instancetype)initWithVoicePath:(NSString *)voicePath
                         voiceURL:(NSURL *)voiceURL
                    voiceDuration:(NSString *)voiceDuration
                         senderId:(NSString *)senderId
                           sender:(id<XYDUserDelegate>)sender
                        timestamp:(NSTimeInterval)timestamp
                          hasRead:(BOOL)hasRead
                  serverMessageId:(NSString *)serverMessageId {
    self = [super init];
    if (self) {
        _voicePath = voicePath;
        _voiceURL = voiceURL;
        _voiceDuration = voiceDuration;
        _sender = sender;
        _senderId = senderId;
        _timestamp = timestamp;
        _serverMessageId = serverMessageId;
        _read = hasRead;
        _mediaType = XYDChatMessageMediaTypeAudio;
    }
    return self;
}


//- (void)setSize:(uint64_t)size {
//    AVIMGeneralObject *metaData = [[AVIMGeneralObject alloc] initWithMutableDictionary:self.file.metaData];
//    metaData.size = size;
//}
//
//- (uint64_t)size {
//    AVIMGeneralObject *metaData = [[AVIMGeneralObject alloc] initWithMutableDictionary:self.file.metaData];
//    return metaData.size;
//}
//
//- (void)setFormat:(NSString *)format {
//    AVIMGeneralObject *metaData = [[AVIMGeneralObject alloc] initWithMutableDictionary:self.file.metaData];
//    metaData.format = format;
//}
//
//- (NSString *)format {
//    AVIMGeneralObject *metaData = [[AVIMGeneralObject alloc] initWithMutableDictionary:self.file.metaData];
//    return metaData.format;
//}
//
//- (void)setDuration:(float)duration {
//    AVIMGeneralObject *metaData = [[AVIMGeneralObject alloc] initWithMutableDictionary:self.file.metaData];
//    metaData.duration = duration;
//}
//
//- (float)duration {
//    AVIMGeneralObject *metaData = [[AVIMGeneralObject alloc] initWithMutableDictionary:self.file.metaData];
//    return metaData.duration;
//}

@end
