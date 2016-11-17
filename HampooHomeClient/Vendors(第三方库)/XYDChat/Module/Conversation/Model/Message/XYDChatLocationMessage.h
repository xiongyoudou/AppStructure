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

@interface XYDChatLocationMessage : XYDChatMessage<XYDChatMessageSubclassing>


@property(nonatomic, assign, readonly) CLLocation *location;

@property (nonatomic, strong, readonly) UIImage *localPositionPhoto;

// 地理位置上的文字描述
@property (nonatomic, strong, readonly) NSString *geolocations;

- (void)setPostionPhoto:(UIImage *)postionPhoto location:(CLLocation *)location;

@end

NS_ASSUME_NONNULL_END
