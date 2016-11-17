//
//  XYDChatUIService.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/10.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatUIService.h"

NSString *const XYDChatUIServiceErrorDomain = @"XYDChatUIServiceErrorDomain";

@implementation XYDChatUIService
@synthesize openProfileBlock = _openProfileBlock;
@synthesize previewImageMessageBlock = _previewImageMessageBlock;
@synthesize previewLocationMessageBlock = _previewLocationMessageBlock;
@synthesize longPressMessageBlock = _longPressMessageBlock;
@synthesize showNotificationBlock = _showNotificationBlock;
@synthesize HUDActionBlock = _HUDActionBlock;
@synthesize avatarImageViewCornerRadiusBlock = _avatarImageViewCornerRadiusBlock;


- (void)setPreviewImageMessageBlock:(XYDChatPreviewImageMessageBlock)previewImageMessageBlock {
    _previewImageMessageBlock = previewImageMessageBlock;
}

- (void)setPreviewLocationMessageBlock:(XYDChatPreviewLocationMessageBlock)previewLocationMessageBlock {
    _previewLocationMessageBlock = previewLocationMessageBlock;
}

- (void)setOpenProfileBlock:(XYDChatOpenProfileBlock)openProfileBlock {
    _openProfileBlock = openProfileBlock;
}

- (void)setShowNotificationBlock:(XYDChatShowNotificationBlock)showNotificationBlock {
    _showNotificationBlock = showNotificationBlock;
}

- (void)setHUDActionBlock:(XYDChatHUDActionBlock)HUDActionBlock {
    _HUDActionBlock = HUDActionBlock;
}

- (void)setUnreadCountChangedBlock:(XYDChatUnreadCountChangedBlock)unreadCountChangedBlock {
    _unreadCountChangedBlock = unreadCountChangedBlock;
}

- (void)setAvatarImageViewCornerRadiusBlock:(XYDChatAvatarImageViewCornerRadiusBlock)avatarImageViewCornerRadiusBlock {
    _avatarImageViewCornerRadiusBlock = avatarImageViewCornerRadiusBlock;
}

- (void)setLongPressMessageBlock:(XYDChatLongPressMessageBlock)longPressMessageBlock {
    _longPressMessageBlock = longPressMessageBlock;
}

@end
