//
//  XYDConversation+Extionsion.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/15.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDConversation+Extionsion.h"
#import "XYDChatSessionService.h"
#import "XYDChatSettingService.h"
#import "XYDChatUserDelegate.h"
#import "XYDChatUserSystemService.h"
#import "XYDChatMacro.h"

@implementation XYDConversation (Extionsion)

- (XYDChatMessage *)xydChat_lastMessage {
    return objc_getAssociatedObject(self, @selector(xydChat_lastMessage));
}

- (void)setXydChat_lastMessage:(XYDChatMessage *)xydChat_lastMessage {
    objc_setAssociatedObject(self, @selector(xydChat_lastMessage), xydChat_lastMessage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)xydChat_unreadCount {
    NSNumber *xydChat_unreadCountObject = objc_getAssociatedObject(self, @selector(xydChat_unreadCount));
    return [xydChat_unreadCountObject intValue];
}

- (NSString *)xydChat_badgeText {
    NSString *badgeText;
    NSUInteger unreadCount = self.xydChat_unreadCount;
    if (unreadCount > 99) {
        badgeText = XYDChatBadgeTextForNumberGreaterThanLimit;
    } else {
        badgeText = [NSString stringWithFormat:@"%@", @(unreadCount)];
    }
    return badgeText;
}

- (void)setXydChat_unreadCount:(NSInteger)xydChat_unreadCount {
    NSNumber *xydChat_unreadCountObject = [NSNumber numberWithInteger:xydChat_unreadCount];
    objc_setAssociatedObject(self, @selector(xydChat_unreadCount), xydChat_unreadCountObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)xydChat_mentioned {
    NSNumber *xydChat_mentionedObject = objc_getAssociatedObject(self, @selector(xydChat_mentioned));
    return [xydChat_mentionedObject boolValue];
}

- (void)setXydChat_mentioned:(BOOL)xydChat_mentioned {
    NSNumber *xydChat_mentionedObject = [NSNumber numberWithBool:xydChat_mentioned];
    objc_setAssociatedObject(self, @selector(xydChat_mentioned), xydChat_mentionedObject, OBJC_ASSOCIATION_ASSIGN);
}

- (NSString *)xydChat_draft {
    return objc_getAssociatedObject(self, @selector(xydChat_draft));
}

- (void)setXydChat_draft:(NSString *)xydChat_draft {
    objc_setAssociatedObject(self, @selector(xydChat_draft), xydChat_draft, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (XYDChatConversationType)xydChat_type {
    if (self.members.count == 2) {
        return XYDChatConversationTypeSingle;
    }
    //系统对话按照群聊处理
    return XYDChatConversationTypeGroup;
}

- (NSString *)xydChat_displayName {
    BOOL disablePreviewUserId = [XYDChatSettingService sharedInstance].isDisablePreviewUserId;
    NSString *displayName;
    if ([self xydChat_type] == XYDChatConversationTypeSingle) {
        NSString *peerId = [self xydChat_peerId];
        NSError *error = nil;
        NSArray *peers = [[XYDChatUserSystemService sharedInstance] getCachedProfilesIfExists:@[peerId] error:&error];
        id<XYDChatUserDelegate> peer;
        if (peers.count > 0) {
            peer = peers[0];
        }
        displayName = peer.name ?: peerId;
        if (!peer.name && disablePreviewUserId) {
            NSString *defaultNickNameWhenNil = XYDChatLocalizedStrings(@"nickNameIsNil");
            displayName = defaultNickNameWhenNil.length > 0 ? defaultNickNameWhenNil : @"";
        }
        return displayName;
    }
    if (self.name.length > 0) {
        return self.name;
    }
    if (self.members.count == 0) {
        return XYDChatLocalizedStrings(@"SystemConversation");
    }
    return XYDChatLocalizedStrings(@"GroupConversation");
    return nil;
}

- (NSString *)xydChat_peerId {
    NSArray *members = self.members;
    if (members.count == 0) {
        [NSException raise:@"invalid conversation" format:@"invalid conversation"];
    }
    if (members.count == 1) {
        return members[0];
    }
    NSString *peerId;
    if ([members[0] isEqualToString:[XYDChatSessionService sharedInstance].clientId]) {
        peerId = members[1];
    } else {
        peerId = members[0];
    }
    return peerId;
    return nil;
}

- (NSString *)xydChat_title {
    NSString *displayName = self.xydChat_displayName;
    if (!self.xydChat_displayName || self.xydChat_displayName.length == 0 ||  [self.xydChat_displayName isEqualToString:XYDChatLocalizedStrings(@"nickNameIsNil")]) {
        displayName = XYDChatLocalizedStrings(@"Chat");
    }
    if (self.xydChat_type == XYDChatConversationTypeSingle || self.members.count == 0) {
        return displayName;
    } else {
        return [NSString stringWithFormat:@"%@(%ld)", displayName, (long)self.members.count];
        
    }
    return nil;
}

- (void)xydChat_setObject:(id)object forKey:(NSString *)key callback:(XYDChatBooleanResultBlock)callback {
//    AVIMConversationUpdateBuilder *updateBuilder = [self newUpdateBuilder] ;
//    updateBuilder.attributes = self.attributes;
//    [updateBuilder setObject:object forKey:key];
//    [self update:[updateBuilder dictionary] callback:callback];
}

- (void)xydChat_removeObjectForKey:(NSString *)key callback:(XYDChatBooleanResultBlock)callback {
//    AVIMConversationUpdateBuilder *updateBuilder = [self newUpdateBuilder] ;
//    updateBuilder.attributes = self.attributes;
//    [updateBuilder removeObjectForKey:key];
//    [self update:[updateBuilder dictionary] callback:callback];
}


@end
