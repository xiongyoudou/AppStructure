//
//  XYDChatImageMessage.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/11.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatImageMessage.h"

@implementation XYDChatImageMessage

+ (void)load {
    [self registerSubclass];
}

+ (XYDChatMessageMediaType)classMediaType {
    return XYDChatMessageMediaTypeImage;
}

- (instancetype)initWithPhoto:(UIImage *)photo
               thumbnailPhoto:(UIImage *)thumbnailPhoto
                    photoPath:(NSString *)photoPath
                 thumbnailURL:(NSURL *)thumbnailURL
               originPhotoURL:(NSURL *)originPhotoURL
                     senderId:(NSString *)senderId
                       sender:(id<XYDUserDelegate>)sender
                    timestamp:(NSTimeInterval)timestamp
              serverMessageId:(NSString *)serverMessageId {
    self = [super init];
    if (self) {
        _photo = photo;
        _thumbnailPhoto = thumbnailPhoto;
        _photoPath = photoPath;
        _thumbnailURL = thumbnailURL;
        _originPhotoURL = originPhotoURL;
        _timestamp = timestamp;
        _serverMessageId = serverMessageId;
        _sender = sender;
        _senderId = senderId;
        _mediaType = XYDChatMessageMediaTypeImage;
    }
    return self;
}


@end
