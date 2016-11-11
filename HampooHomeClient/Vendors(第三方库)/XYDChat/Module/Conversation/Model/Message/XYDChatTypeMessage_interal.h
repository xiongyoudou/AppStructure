//
//  XYDChatTypeMessage+XYDChatTypeMessage_interal.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/11.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatTypeMessage.h"
#import "XYDChatMessage_interal.h"

@interface XYDChatTypeMessage ()

@property(nonatomic, strong)XYDFile *file;
@property(nonatomic, strong)XYDGeoPoint *location;
@property(nonatomic, strong)NSString *attachedFilePat

+ (Class)classForMediaType:(XYDChatMessageMediaType)mediaType;
+ (instancetype)messageWithDictionary:(NSDictionary *)dictionary;

@end
