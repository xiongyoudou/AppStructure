//
//  XYDChatHelper.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/9.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatKit.h"
#import "XYDChatHelper.h"
#import "XYDImageManager.h"
#import "NSBundle+XYDExtionsion.h"
#import "XYDChatSettingService.h"
#import "XYDChatSystemMessageCell.h"

@implementation XYDChatHelper

// 表情资源bundle
+ (NSBundle *)emotionBundle {
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Emoji" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:bundlePath];
    });
    return bundle;
}

// 图片bundle
+ (NSBundle *)imageBundle {
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"ChatKeyboard" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:bundlePath];
    });
    return bundle;
}

+ (UIImage *)getEmotionWithImageName:(NSString *)imageName {
    if (imageName.length == 0) return nil;
    if ([imageName hasSuffix:@"/"]) return nil;
    NSBundle *bundle = [self emotionBundle];
    XYDImageManager *manager = [XYDImageManager defaultManager];
    UIImage *image = [manager getImageWithName:imageName
                                      inBundle:bundle];
    if (!image) {
        //`-getImageWithName` not work for image in Access Asset Catalog
        image = [UIImage imageNamed:imageName];
    }
    return image;
}

+ (UIImage *)getImageWithNamed:(NSString *)imageName bundleName:(NSString *)bundleName bundleForClass:(Class)aClass {
    if (imageName.length == 0) return nil;
    if ([imageName hasSuffix:@"/"]) return nil;
    NSBundle *bundle = [NSBundle xyd_bundleForName:bundleName class:aClass];
    XYDImageManager *manager = [XYDImageManager defaultManager];
    UIImage *image = [manager getImageWithName:imageName
                                      inBundle:bundle];
    if (!image) {
        //`-getImageWithName` not work for image in Access Asset Catalog
        image = [UIImage imageNamed:imageName];
    }
    return image;
}


+ (NSString *)getCustomizedBundlePathForBundleName:(NSString *)bundleName {
    NSString *customizedBundlePathComponent = [NSString stringWithFormat:@"CustomizedChatKit.%@.bundle", bundleName];
    NSString *customizedBundlePath =[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:customizedBundlePathComponent];
    return customizedBundlePath;
}

+ (NSBundle *)getBundleForName:(NSString *)bundleName class:(Class)aClass {
    NSString *customizedBundlePath = [self getCustomizedBundlePathForBundleName:bundleName];
    NSBundle *customizedBundle = [NSBundle bundleWithPath:customizedBundlePath];
    if (customizedBundle) {
        return customizedBundle;
    }
    NSString *bundlePath = [NSBundle xyd_bundlePathForBundleName:bundleName class:aClass];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    return bundle;
}

+ (NSString *)getPathForConversationBackgroundImage {
    /*
    NSString *path = [NSString stringWithFormat:@"%@/APP/%@/User/%@/Conversation/%@/Background/", [NSFileManager xyd_documentsPath], [XYDChatKit sharedInstance].appId,[XYDChatSessionService sharedInstance].clientId, [XYDConversationService sharedInstance].currentConversation.conversationId];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            XYDChatLog(@"File Create Failed: %@", path);
        }
    }
    return [path stringByAppendingString:self];
     */
    return nil;
}

+ (UIImageView *)messageVoiceAnimationImageViewWithBubbleMessageType:(XYDChatMessageOwnerType)owner {
    UIImageView *messageVoiceAniamtionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    NSString *imageSepatorName;
    switch (owner) {
        case XYDChatMessageOwnerTypeSelf:
            imageSepatorName = @"Sender";
            break;
        case XYDChatMessageOwnerTypeOther:
            imageSepatorName = @"Receiver";
            break;
        default:
            break;
    }
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:4];
    for (NSInteger i = 0; i < 4; i ++) {
        NSString *imageName = [imageSepatorName stringByAppendingFormat:@"VoiceNodePlaying00%ld", (long)i];
        UIImage *image = [self imageInBundleForImageName:imageName];
        if (image)
            [images addObject:image];
    }
    
    messageVoiceAniamtionImageView.image = ({
        NSString *imageName = [imageSepatorName stringByAppendingString:@"VoiceNodePlaying"];
        UIImage *image = [self imageInBundleForImageName:imageName];
        image;});
    messageVoiceAniamtionImageView.animationImages = images;
    messageVoiceAniamtionImageView.animationDuration = 1.0;
    [messageVoiceAniamtionImageView stopAnimating];
    return messageVoiceAniamtionImageView;
}

+ (UIImage *)imageInBundleForImageName:(NSString *)imageName {
    UIImage *image = [self getImageWithNamed:imageName bundleName:@"MessageBubble" bundleForClass:[self class]];
    return  image;
}

+ (UIImage *)bubbleImageViewForType:(XYDChatMessageOwnerType)owner
                        messageType:(XYDChatMessageMediaType)messageMediaType
                      isHighlighted:(BOOL)isHighlighted {
    BOOL isCustomMessage = NO;
    NSString *messageTypeString = @"message_";
    switch (messageMediaType) {
        case XYDChatMessageMediaTypeImage:
        case XYDChatMessageMediaTypeLocation:
            messageTypeString = [messageTypeString stringByAppendingString:@"hollow_"];
            break;
        default:
            break;
    }
    UIEdgeInsets bubbleImageCapInsets = UIEdgeInsetsZero;
    switch (owner) {
        case XYDChatMessageOwnerTypeSelf: {
            // 发送
            switch (messageMediaType) {
                case XYDChatMessageMediaTypeImage:
                case XYDChatMessageMediaTypeLocation:
                    bubbleImageCapInsets = [XYDChatSettingService sharedInstance].rightHollowCapMessageBubbleCustomize;
                    break;
                default:
                    bubbleImageCapInsets = [XYDChatSettingService sharedInstance].rightCapMessageBubbleCustomize;
                    break;
            }
            messageTypeString = [messageTypeString stringByAppendingString:@"sender_"];
            break;
        }
        case XYDChatMessageOwnerTypeOther: {
            // 接收
            switch (messageMediaType) {
                case XYDChatMessageMediaTypeImage:
                case XYDChatMessageMediaTypeLocation:
                    bubbleImageCapInsets = [XYDChatSettingService sharedInstance].leftHollowCapMessageBubbleCustomize;
                    break;
                default:
                    bubbleImageCapInsets = [XYDChatSettingService sharedInstance].leftCapMessageBubbleCustomize;
                    break;
            }
            messageTypeString = [messageTypeString stringByAppendingString:@"receiver_"];
            break;
        }
        case XYDChatMessageOwnerTypeSystem:
            break;
        case XYDChatMessageOwnerTypeUnknown:
            isCustomMessage = YES;
            break;
    }
    if (isCustomMessage) {
        return nil;
    }
    messageTypeString = [messageTypeString stringByAppendingString:@"background_"];
    if (isHighlighted) {
        messageTypeString = [messageTypeString stringByAppendingString:@"highlight"];
    } else {
        messageTypeString = [messageTypeString stringByAppendingString:@"normal"];
    }
    UIImage *bublleImage = [XYDChatHelper getImageWithNamed:messageTypeString bundleName:@"MessageBubble" bundleForClass:[self class]];
    return STRETCH_IMAGE(bublleImage, bubbleImageCapInsets);
}

- (NSString *)pathForConversationBackgroundImageWithStr:(NSString *)str {
//    NSString *path = [NSString stringWithFormat:@"%@/APP/%@/User/%@/Conversation/%@/Background/", [NSFileManager XYDChat_documentsPath], [XYDChatKit sharedInstance].appId,[XYDChatSessionService sharedInstance].clientId, [XYDConversationService sharedInstance].currentConversation.conversationId];
    NSString *path = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
//            XYDChatLog(@"File Create Failed: %@", path);
        }
    }
    return [path stringByAppendingString:str];
}

#pragma mark - 注册messageCell
+ (void)registerChatMessageCellClassForTableView:(UITableView *)tableView {
    [XYDChatChatMessageCellMediaTypeDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull mediaType, Class _Nonnull aClass, BOOL * _Nonnull stop) {
        if (mediaType.intValue != XYDChatMessageMediaTypeSystem) {
            [self registerMessageCellClass:aClass ForTableView:tableView];
        }
    }];
    [self registerSystemMessageCellClassForTableView:tableView];
}

+ (void)registerMessageCellClass:(Class)messageCellClass ForTableView:(UITableView *)tableView  {
    NSString *messageCellClassString = NSStringFromClass(messageCellClass);
    UINib *nib = [UINib nibWithNibName:messageCellClassString bundle:nil];
    if([[NSBundle mainBundle] pathForResource:messageCellClassString ofType:@"nib"] != nil) {
        [tableView registerNib:nib forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, XYDChatCellIdentifierOwnerSelf, XYDChatCellIdentifierGroup]];
        [tableView registerNib:nib forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, XYDChatCellIdentifierOwnerSelf, XYDChatCellIdentifierSingle]];
        [tableView registerNib:nib forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, XYDChatCellIdentifierOwnerOther, XYDChatCellIdentifierGroup]];
        [tableView registerNib:nib forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, XYDChatCellIdentifierOwnerOther , XYDChatCellIdentifierSingle]];
    } else {
        [tableView registerClass:messageCellClass forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, XYDChatCellIdentifierOwnerSelf, XYDChatCellIdentifierGroup]];
        [tableView registerClass:messageCellClass forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, XYDChatCellIdentifierOwnerSelf, XYDChatCellIdentifierSingle]];
        [tableView registerClass:messageCellClass forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, XYDChatCellIdentifierOwnerOther, XYDChatCellIdentifierGroup]];
        [tableView registerClass:messageCellClass forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, XYDChatCellIdentifierOwnerOther , XYDChatCellIdentifierSingle]];
    }
}

// 因为系统消息不分自己发送，还是别人发送，是不具有发送人信息的！
+ (void)registerSystemMessageCellClassForTableView:(UITableView *)tableView {
    [tableView registerClass:[XYDChatSystemMessageCell class] forCellReuseIdentifier:@"XYDChatSystemMessageCell_XYDChatCellIdentifierOwnerSystem_XYDChatCellIdentifierSingle"];
    [tableView registerClass:[XYDChatSystemMessageCell class] forCellReuseIdentifier:@"XYDChatSystemMessageCell_XYDChatCellIdentifierOwnerSystem_XYDChatCellIdentifierGroup"];
}

@end
