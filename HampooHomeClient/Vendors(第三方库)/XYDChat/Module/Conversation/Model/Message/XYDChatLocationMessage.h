//
//  XYDChatLocationMessage.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/11.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatTypeMessage.h"
#import <CoreLocation/CoreLocation.h>
NS_ASSUME_NONNULL_BEGIN

@interface XYDChatLocationMessage : XYDChatTypeMessage<XYDChatTypedMessageSubclassing>

/**
 *  Latitude. Should be 0~90.
 */
@property(nonatomic, assign, readonly) float latitude;

/**
 *  Longitude, Should be 0~360.
 */
@property(nonatomic, assign, readonly) float longitude;
@property (nonatomic, strong,readonly)  CLLocation *location;
@property (nonatomic, strong, readonly) UIImage *localPositionPhoto;
@property (nonatomic, copy, readonly) NSString *geolocations;

/*!
 创建位置消息。
 @param text － 消息文本.
 @param latitude － 纬度
 @param longitude － 经度
 @param attributes － 用户附加属性
 */
+ (instancetype)messageWithText:(NSString *)text
                       latitude:(float)latitude
                      longitude:(float)longitude
                     attributes:(nullable NSDictionary *)attributes;

@end

NS_ASSUME_NONNULL_END
