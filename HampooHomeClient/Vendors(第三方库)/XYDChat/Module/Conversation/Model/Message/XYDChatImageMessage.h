//
//  XYDChatImageMessage.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/11.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatMessage.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYDChatImageMessage : XYDChatMessage<XYDChatMessageSubclassing>

@property (nonatomic, strong, readonly) NSString *thumbnailURLStr;
@property (nonatomic, strong, readonly) NSString *originPhotoURLStr;

// 这些属性通过计算得出
@property (nonatomic, strong, readonly)  NSString *localThumbnailPath;
@property (nonatomic, strong, readonly)  NSString *localOriginalPath;
@property (nonatomic, strong, readwrite) UIImage *thumbnailPhoto;
@property (nonatomic, strong, readwrite) UIImage *photo;

/// Width of the image in pixels.
@property(nonatomic, assign, readonly) uint width;

/// Height of the image in pixels.
@property(nonatomic, assign, readonly) uint height;

/// File size in bytes.
@property(nonatomic, assign, readonly) uint64_t size;

/// Image format, png, jpg, etc. Simply get it from the file extension.
@property(nonatomic, copy, readonly, nullable) NSString *format;

- (void)setThumbnailUrlStr:(NSString *)thumbnail originalUrlStr:(NSString *)original;
- (void)setPhoto:(UIImage *)photo thumbnailPhoto:(UIImage *)thumbnailPhoto;

@end

NS_ASSUME_NONNULL_END
