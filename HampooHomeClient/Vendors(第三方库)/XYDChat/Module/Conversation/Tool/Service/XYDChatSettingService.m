//
//  XYDChatSettingManager.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/10.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatSettingService.h"
#import "XYDChatHelper.h"

NSString *const XYDChatSettingServiceErrorDomain = @"XYDChatSettingServiceErrorDomain";

@interface XYDChatSettingService ()

@property (nonatomic, strong) NSDictionary *defaultSettings;
@property (nonatomic, strong) NSDictionary *defaultTheme;
@property (nonatomic, strong) NSDictionary *messageBubbleCustomizeSettings;

@end

@implementation XYDChatSettingService
@synthesize useDevPushCerticate = _useDevPushCerticate;
@synthesize disablePreviewUserId = _disablePreviewUserId;

+ (NSString *)ChatKitVersion {
    return @"v0.8.0";
}

// 在files文件夹下生产一个随机名称的路径
- (NSString *)tmpPath {
    return [[self getFilesPath] stringByAppendingFormat:@"%@", [[NSUUID UUID] UUIDString]];
}

// 在Documetary下生产files/文件夹
- (NSString *)getFilesPath {
    NSString *appPath = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filesPath = [appPath stringByAppendingString:@"/files/"];
    NSFileManager *fileMan = [NSFileManager defaultManager];
    NSError *error;
    BOOL isDir = YES;
    if ([fileMan fileExistsAtPath:filesPath isDirectory:&isDir] == NO) {
        [fileMan createDirectoryAtPath:filesPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            [NSException raise:@"error when create dir" format:@"error"];
        }
    }
    return filesPath;
}

- (NSString *)getPathByObjectId:(NSString *)objectId {
    return [[self getFilesPath] stringByAppendingFormat:@"%@", objectId];
}


- (void)registerForRemoteNotification {
    
}


- (void)cleanBadge {
    UIApplication *application = [UIApplication sharedApplication];
    NSInteger num = application.applicationIconBadgeNumber;
    if (num != 0) {
        
        application.applicationIconBadgeNumber = 0;
    }
    [application cancelAllLocalNotifications];
}

- (void)syncBadge {
    
}

- (NSDictionary *)defaultSettings {
    if (_defaultSettings) {
        return _defaultSettings;
    }
    NSBundle *bundle = [XYDChatHelper getBundleForName:@"Other" class:[self class]];
    NSString *defaultSettingsFile = [bundle pathForResource:@"ChatKit-Settings" ofType:@"plist"];
    NSDictionary *defaultSettings = [[NSDictionary alloc] initWithContentsOfFile:defaultSettingsFile];
    _defaultSettings = defaultSettings;
    return _defaultSettings;
}

- (NSDictionary *)defaultTheme {
    if (_defaultTheme) {
        return _defaultTheme;
    }
    NSBundle *bundle = [XYDChatHelper getBundleForName:@"Other" class:[self class]];
    NSString *defaultThemeFile = [bundle pathForResource:@"ChatKit-Theme" ofType:@"plist"];
    NSDictionary *defaultTheme = [[NSDictionary alloc] initWithContentsOfFile:defaultThemeFile];
    _defaultTheme = defaultTheme;
    return _defaultTheme;
}

- (NSDictionary *)messageBubbleCustomizeSettings {
    if (_messageBubbleCustomizeSettings) {
        return _messageBubbleCustomizeSettings;
    }
    NSBundle *bundle = [XYDChatHelper getBundleForName:@"MessageBubble" class:[self class]];
    NSString *messageBubbleCustomizeSettingsFile = [bundle pathForResource:@"MessageBubble-Customize" ofType:@"plist"];
    NSDictionary *messageBubbleCustomizeSettings =  [[NSDictionary alloc] initWithContentsOfFile:messageBubbleCustomizeSettingsFile];
    _messageBubbleCustomizeSettings = messageBubbleCustomizeSettings;
    return _messageBubbleCustomizeSettings;
}

/**
 * @param capOrEdge 分为：cap_insets和edge_insets
 * @param position 主要分为：CommonLeft、CommonRight等
 */
- (UIEdgeInsets)messageBubbleCustomizeSettingsForPosition:(NSString *)position capOrEdge:(NSString *)capOrEdge {
    NSDictionary *CapOrEdgeDict = self.messageBubbleCustomizeSettings[@"BubbleStyle"][position][@"background"][capOrEdge];
    CGFloat top = [(NSNumber *)CapOrEdgeDict[@"top"] floatValue];
    CGFloat left = [(NSNumber *)CapOrEdgeDict[@"left"] floatValue];
    CGFloat bottom = [(NSNumber *)CapOrEdgeDict[@"bottom"] floatValue];
    CGFloat right = [(NSNumber *)CapOrEdgeDict[@"right"] floatValue];
    UIEdgeInsets CapOrEdge = UIEdgeInsetsMake(top, left, bottom, right);
    return CapOrEdge;
}

- (UIEdgeInsets)rightCapMessageBubbleCustomize {
    UIEdgeInsets rightCapMessageBubbleCustomizeSettings = [self messageBubbleCustomizeSettingsForPosition:@"CommonRight" capOrEdge:@"cap_insets"];
    return rightCapMessageBubbleCustomizeSettings;
}

- (UIEdgeInsets)rightEdgeMessageBubbleCustomize {
    UIEdgeInsets rightEdgeMessageBubbleCustomizeSettings = [self messageBubbleCustomizeSettingsForPosition:@"CommonRight" capOrEdge:@"edge_insets"];
    return rightEdgeMessageBubbleCustomizeSettings;
}

- (UIEdgeInsets)leftCapMessageBubbleCustomize {
    UIEdgeInsets leftCapMessageBubbleCustomizeSettings = [self messageBubbleCustomizeSettingsForPosition:@"CommonLeft" capOrEdge:@"cap_insets"];
    return leftCapMessageBubbleCustomizeSettings;
}

- (UIEdgeInsets)leftEdgeMessageBubbleCustomize {
    UIEdgeInsets leftEdgeMessageBubbleCustomizeSettings = [self messageBubbleCustomizeSettingsForPosition:@"CommonLeft" capOrEdge:@"edge_insets"];
    return leftEdgeMessageBubbleCustomizeSettings;
}

- (UIEdgeInsets)rightHollowCapMessageBubbleCustomize {
    UIEdgeInsets rightHollowCapMessageBubbleCustomize = [self messageBubbleCustomizeSettingsForPosition:@"HollowRight" capOrEdge:@"cap_insets"];
    return rightHollowCapMessageBubbleCustomize;
}

- (UIEdgeInsets)rightHollowEdgeMessageBubbleCustomize {
    UIEdgeInsets rightHollowCapMessageBubbleCustomize = [self messageBubbleCustomizeSettingsForPosition:@"HollowRight" capOrEdge:@"edge_insets"];
    return rightHollowCapMessageBubbleCustomize;
}

- (UIEdgeInsets)leftHollowCapMessageBubbleCustomize {
    UIEdgeInsets leftHollowCapMessageBubbleCustomize = [self messageBubbleCustomizeSettingsForPosition:@"HollowLeft" capOrEdge:@"cap_insets"];
    return leftHollowCapMessageBubbleCustomize;
}

- (UIEdgeInsets)leftHollowEdgeMessageBubbleCustomize {
    UIEdgeInsets leftHollowEdgeMessageBubbleCustomize = [self messageBubbleCustomizeSettingsForPosition:@"HollowLeft" capOrEdge:@"edge_insets"];
    return leftHollowEdgeMessageBubbleCustomize;
}

- (NSString *)imageNameForMessageBubbleCustomizeForPosition:(NSString *)position normalOrHighlight:(NSString *)normalOrHighlight {
    NSString *imageNameForMessageBubbleCustomizeForPosition = self.messageBubbleCustomizeSettings[@"BubbleStyle"][position][@"background"][normalOrHighlight];
    return imageNameForMessageBubbleCustomizeForPosition;
}

- (NSString *)leftNormalImageNameMessageBubbleCustomize {
    NSString *leftNormalImageNameMessageBubbleCustomize = [self imageNameForMessageBubbleCustomizeForPosition:@"CommonLeft" normalOrHighlight:@"image_name_normal"];
    return leftNormalImageNameMessageBubbleCustomize;
}

- (NSString *)leftHighlightImageNameMessageBubbleCustomize {
    NSString *leftHighlightImageNameMessageBubbleCustomize = [self imageNameForMessageBubbleCustomizeForPosition:@"CommonLeft" normalOrHighlight:@"image_name_highlight"];
    return leftHighlightImageNameMessageBubbleCustomize;
}

- (NSString *)rightHighlightImageNameMessageBubbleCustomize {
    NSString *rightHighlightImageNameMessageBubbleCustomize = [self imageNameForMessageBubbleCustomizeForPosition:@"CommonRight" normalOrHighlight:@"image_name_highlight"];
    return rightHighlightImageNameMessageBubbleCustomize;
}

- (NSString *)rightNormalImageNameMessageBubbleCustomize {
    NSString *rightNormalImageNameMessageBubbleCustomize = [self imageNameForMessageBubbleCustomizeForPosition:@"CommonRight" normalOrHighlight:@"image_name_normal"];
    return rightNormalImageNameMessageBubbleCustomize;
}

- (NSString *)hollowRightNormalImageNameMessageBubbleCustomize {
    NSString *hollowRightNormalImageNameMessageBubbleCustomize = [self imageNameForMessageBubbleCustomizeForPosition:@"HollowRight" normalOrHighlight:@"image_name_normal"];
    return hollowRightNormalImageNameMessageBubbleCustomize;
}

- (NSString *)hollowRightHighlightImageNameMessageBubbleCustomize {
    NSString *hollowRightHighlightImageNameMessageBubbleCustomize = [self imageNameForMessageBubbleCustomizeForPosition:@"HollowRight" normalOrHighlight:@"image_name_highlight"];
    return hollowRightHighlightImageNameMessageBubbleCustomize;
}

- (NSString *)hollowLeftNormalImageNameMessageBubbleCustomize {
    NSString *hollowLeftNormalImageNameMessageBubbleCustomize =  [self imageNameForMessageBubbleCustomizeForPosition:@"HollowLeft" normalOrHighlight:@"image_name_normal"];
    return hollowLeftNormalImageNameMessageBubbleCustomize;
}

- (NSString *)hollowLeftHighlightImageNameMessageBubbleCustomize {
    NSString *hollowLeftHighlightImageNameMessageBubbleCustomize =  [self imageNameForMessageBubbleCustomizeForPosition:@"HollowLeft" normalOrHighlight:@"image_name_highlight"];
    return hollowLeftHighlightImageNameMessageBubbleCustomize;
}


- (UIColor *)defaultThemeColorForKey:(NSString *)key {
    UIColor *defaultThemeColor = [UIColor xyd_colorWithHexString: self.defaultTheme[@"Colors"][key]];
    return defaultThemeColor;
}

- (UIFont *)defaultThemeTextMessageFont {
    CGFloat defaultThemeTextMessageFontSize = [self.defaultTheme[@"Fonts"][@"ConversationView-Message-TextSystemFontSize"] floatValue];
    UIFont *defaultThemeTextMessageFont = [UIFont systemFontOfSize:defaultThemeTextMessageFontSize];
    return defaultThemeTextMessageFont;
}

- (void)setBackgroundImage:(UIImage *)image forConversationId:(NSString *)conversationId scaledToSize:(CGSize)scaledToSize {
    /*
    if (conversationId.length == 0 || !conversationId) {
        return;
    }
    image = [image xyd_resizedImage:scaledToSize interpolationQuality:kCGInterpolationDefault];
    NSData *imageData = (UIImagePNGRepresentation(image) ? UIImagePNGRepresentation(image) : UIImageJPEGRepresentation(image, 1));
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg", [[NSUUID UUID] UUIDString]];
    NSString *imagePath = [XYDChatHelper getPathForConversationBackgroundImage];
    [[NSFileManager defaultManager] createFileAtPath:imagePath contents:imageData attributes:nil];
    if (conversationId.length > 0) {
        NSString *customImageNameKey = [NSString stringWithFormat:@"%@%@_%@", XYDChatCustomConversationViewControllerBackgroundImageNamePrefix, [XYDChatSessionService sharedInstance].clientId, conversationId];
        [[NSUserDefaults standardUserDefaults] setObject:imageName forKey:customImageNameKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:imageName forKey:XYDChatDefaultConversationViewControllerBackgroundImageName];
    }
    NSDictionary *userInfo = @{
                               XYDChatNotificationConversationViewControllerBackgroundImageDidChangedUserInfoConversationIdKey : conversationId,
                               };
    [[NSNotificationCenter defaultCenter] postNotificationName:XYDChatNotificationConversationViewControllerBackgroundImageDidChanged object:userInfo];
     */
}


@end
