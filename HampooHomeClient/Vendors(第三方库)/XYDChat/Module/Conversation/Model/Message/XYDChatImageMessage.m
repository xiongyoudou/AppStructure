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

- (void)setThumbnailUrlStr:(NSString *)thumbnail originalUrlStr:(NSString *)original {
    _thumbnailURLStr = thumbnail;
    _originPhotoURLStr = original;
}

- (void)setPhoto:(UIImage *)photo thumbnailPhoto:(UIImage *)thumbnailPhoto {
    _photo = photo;
    _thumbnailPhoto = thumbnailPhoto;
}


@end
