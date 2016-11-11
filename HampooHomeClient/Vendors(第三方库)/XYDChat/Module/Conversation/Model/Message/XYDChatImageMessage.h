//
//  XYDChatImageMessage.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/11.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatTypeMessage.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYDChatImageMessage : XYDChatTypeMessage<XYDChatTypedMessageSubclassing>

/// Width of the image in pixels.
@property(nonatomic, assign, readonly) uint width;

/// Height of the image in pixels.
@property(nonatomic, assign, readonly) uint height;

/// File size in bytes.
@property(nonatomic, assign, readonly) uint64_t size;

/// Image format, png, jpg, etc. Simply get it from the file extension.
@property(nonatomic, copy, readonly, nullable) NSString *format;

@property (nonatomic, copy, readonly) NSString *photoPath;
@property (nonatomic, strong, readonly) NSURL *thumbnailURL;
@property (nonatomic, strong, readonly) NSURL *originPhotoURL;
@property (nonatomic, strong, readwrite) UIImage *photo;
@property (nonatomic, strong, readwrite) UIImage *thumbnailPhoto;

@end

NS_ASSUME_NONNULL_END
