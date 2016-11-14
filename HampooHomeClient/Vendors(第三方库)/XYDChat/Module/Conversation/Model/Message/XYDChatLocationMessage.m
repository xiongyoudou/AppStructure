//
//  XYDChatLocationMessage.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/11.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatLocationMessage.h"
#import "XYDGeoPoint.h"
#import "XYDGeoPoint.h"

@implementation XYDChatLocationMessage

+ (void)load {
    [self registerSubclass];
}

+ (XYDChatMessageMediaType)classMediaType {
    return XYDChatMessageMediaTypeLocation;
}

- (void)setlatitude:(float)latitude
          longitude:(float)longitude {
    _latitude = latitude;
    _longitude = longitude;
}



@end
