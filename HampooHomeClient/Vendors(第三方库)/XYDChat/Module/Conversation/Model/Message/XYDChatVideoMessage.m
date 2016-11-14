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

- (void)setVideoURLStr:(NSString * _Nonnull)videoURLStr {
    _videoURLStr = videoURLStr;
}

- (void)setLocalVideoPath:(NSString * _Nonnull)localVideoPath {
    _localVideoPath = localVideoPath;
}

@end
