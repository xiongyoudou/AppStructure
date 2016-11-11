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
