//
//  XYDChatLocationMessage.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/11.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatLocationMessage.h"
#import "XYDGeoPoint.h"
#import "XYDChatTypeMessage_interal.h"
#import "XYDGeoPoint.h"

@implementation XYDChatLocationMessage
@synthesize location = _location;

+ (void)load {
    [self registerSubclass];
}

+ (XYDChatMessageMediaType)classMediaType {
    return XYDChatMessageMediaTypeLocation;
}

+ (instancetype)messageWithText:(NSString *)text
                       latitude:(float)latitude
                      longitude:(float)longitude
                     attributes:(NSDictionary *)attributes {
    XYDChatLocationMessage *message = [[self alloc] init];
    message.text = text;
    message.attributes = attributes;
    XYDGeoPoint *location = [XYDGeoPoint geoPointWithLatitude:latitude longitude:longitude];
    message.location = location;
    return message;
}

- (instancetype)initWithLocalPositionPhoto:(UIImage *)localPositionPhoto
                              geolocations:(NSString *)geolocations
                                  location:(CLLocation *)location
                                  senderId:(NSString *)senderId
                                    sender:(id<XYDUserDelegate>)sender
                                 timestamp:(NSTimeInterval)timestamp
                           serverMessageId:(NSString *)serverMessageId {
    self = [super init];
    if (self) {
        _localPositionPhoto = localPositionPhoto;
        _geolocations = geolocations;
        _location = location;
        _sender = sender;
        _senderId = senderId;
        _timestamp = timestamp;
        _serverMessageId = serverMessageId;
        _mediaType = XYDChatMessageMediaTypeLocation;
    }
    return self;
}


- (instancetype)initWithLocalFeedbackText:(NSString *)localFeedbackText {
    self = [super init];
    if (self) {
        _systemText = localFeedbackText;
        _localMessageId = [[NSUUID UUID] UUIDString];
        _timestamp = XYDChat_CURRENT_TIMESTAMP;
        _mediaType = XYDChatMessageMediaTypeSystem;
        _ownerType = XYDChatMessageOwnerTypeSystem;
    }
    return self;
}

//- (float)longitude {
//    return self.location.longitude;
//}
//
//- (float)latitude {
//    return self.location.latitude;
//}

//- (XYDGeoPoint *)location {
//    if (_location)
//        return _location;
//    return nil;
//}
//
//- (void)setLocation:(XYDGeoPoint *)location {
//    _location = location;
//}

@end
