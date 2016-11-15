//
//  XYDChatInputViewPluginChange.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/15.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatInputViewPluginChange.h"
#import "XYDConversationVCtrl.h"
#import "XYDChatHelper.h"
#import "RedpacketViewControl.h"

@interface XYDChatInputViewPluginChange ()

/**
 *  发红包的控制器
 */
@property (nonatomic, strong) RedpacketViewControl *redpacketControl;

@end

@implementation XYDChatInputViewPluginChange
@synthesize inputViewRef = _inputViewRef;


+ (void)load {
    [self registerSubclass];
}

+ (XYDChatInputViewPluginType)classPluginType {
    return 4;
}

#pragma mark -
#pragma mark - XYDChatInputViewPluginDelegate Method

/*!
 * 插件图标
 */
- (UIImage *)pluginIconImage {
    return [self imageInBundlePathForImageName:@"redpacket_changeMoney"];
}

/*!
 * 插件名称
 */
- (NSString *)pluginTitle {
    return @"零钱";
}

/*!
 * 插件对应的 view，会被加载到 inputView 上
 */
- (UIView *)pluginContentView {
    return nil;
}

- (void)pluginDidClicked {
    self.redpacketControl = [[RedpacketViewControl alloc] init];
    self.redpacketControl.conversationController = self.conversationViewController;
    [self.redpacketControl presentChangeMoneyViewController];
}

#pragma mark -
#pragma mark - Private Methods

- (UIImage *)imageInBundlePathForImageName:(NSString *)imageName {
    UIImage *image = [XYDChatHelper getImageWithNamed:imageName bundleName:@"RedpacketCellResource" bundleForClass:[self class]];
    return image;
}

@end
