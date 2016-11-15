//
//  XYDChatCellIdentifierFactory.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/15.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatCellIdentifierFactory.h"
#import "XYDChatMessage.h"

@implementation XYDChatCellIdentifierFactory

+ (NSString *)cellIdentifierForMessageConfiguration:(id)message conversationType:(XYDChatConversationType)conversationType {
    NSString *groupKey;
    switch (conversationType) {
        case XYDChatConversationTypeGroup:
            groupKey = XYDChatCellIdentifierGroup;
            break;
        case XYDChatConversationTypeSingle:
            groupKey = XYDChatCellIdentifierSingle;
            break;
        default:
            groupKey = @"";
            break;
    }
    
    return [self cellIdentifierForCustomMessageConfiguration:(XYDChatMessage *)message groupKey:groupKey];
}

+ (NSString *)cellIdentifierForCustomMessageConfiguration:(XYDChatMessage *)message groupKey:(NSString *)groupKey {
    XYDChatMessageOwnerType messageOwner = message.ownerType;
    XYDChatMessageMediaType messageType = message.mediaType;
    NSNumber *key = [NSNumber numberWithInteger:messageType];
    NSString *typeKey = NSStringFromClass([XYDChatChatMessageCellMediaTypeDict objectForKey:key]);
    NSAssert(typeKey.length > 0, @"🔴类名与方法名：%@（在第%@行），描述：%@,%@", @(__PRETTY_FUNCTION__), @(__LINE__), @(message.mediaType), NSStringFromClass([message class]));
    NSString *ownerKey;
    switch (messageOwner) {
        case XYDChatMessageOwnerTypeSelf:
            ownerKey = XYDChatCellIdentifierOwnerSelf;
            break;
        case XYDChatMessageOwnerTypeOther:
            ownerKey = XYDChatCellIdentifierOwnerOther;
            break;
        case XYDChatMessageOwnerTypeSystem:
            ownerKey = XYDChatCellIdentifierOwnerOther;
            break;
        default:
            NSAssert(NO, @"Message Owner Unknow");
            break;
    }
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"%@_%@_%@", typeKey, ownerKey, groupKey];
    return cellIdentifier;
}

@end
