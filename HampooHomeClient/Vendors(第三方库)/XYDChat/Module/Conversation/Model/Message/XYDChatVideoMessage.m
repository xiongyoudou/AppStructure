//
//  XYDChatVideoMessage.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/11.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatVideoMessage.h"

@implementation XYDChatVideoMessage


+ (void)load {
    [self registerSubclass];
}

+ (XYDChatMessageMediaType)classMediaType {
    return XYDChatMessageMediaTypeVideo;
}

- (instancetype)initWithVideoConverPhoto:(UIImage *)videoConverPhoto
                               videoPath:(NSString *)videoPath
                                videoURL:(NSURL *)videoURL
                                senderId:(NSString *)senderId
                                  sender:(id<XYDUserDelegate>)sender
                               timestamp:(NSTimeInterval)timestamp
                         serverMessageId:(NSString *)serverMessageId {
    self = [super init];
    if (self) {
        _videoConverPhoto = videoConverPhoto;
        _videoPath = videoPath;
        _videoURL = videoURL;
        _sender = sender;
        _senderId = senderId;
        _timestamp = timestamp;
        _serverMessageId = serverMessageId;
        _mediaType = XYDChatMessageMediaTypeVideo;
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
