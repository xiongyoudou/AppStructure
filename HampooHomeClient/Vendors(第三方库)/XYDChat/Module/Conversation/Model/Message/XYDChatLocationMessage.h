//
//  XYDChatLocationMessage.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/11.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatMessage.h"
#import <CoreLocation/CoreLocation.h>
NS_ASSUME_NONNULL_BEGIN

@interface XYDChatLocationMessage : XYDChatMessage<XYDChatTypedMessageSubclassing>

/**
 *  Latitude. Should be 0~90.
 */
@property(nonatomic, assign, readonly) float latitude;

/**
 *  Longitude, Should be 0~360.
 */
@property(nonatomic, assign, readonly) float longitude;
@property (nonatomic, strong, readonly) UIImage *localPositionPhoto;

/*!
 创建位置消息。
 @param latitude － 纬度
 @param longitude － 经度
 */
- (void)setlatitude:(float)latitude longitude:(float)longitude;

@end

NS_ASSUME_NONNULL_END
