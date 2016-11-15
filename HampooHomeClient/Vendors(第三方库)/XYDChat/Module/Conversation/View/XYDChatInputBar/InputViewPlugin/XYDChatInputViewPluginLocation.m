//
//  XYDChatInputViewPluginLocation.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/15.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatInputViewPluginLocation.h"
#import "XYDConversationVCtrl.h"
#import "XYDChatHelper.h"
#import "XYDChatLocationController.h"

@interface XYDChatInputViewPluginLocation ()

@property (nonatomic, strong) XYDChatLocationController *locationController;

@end

@implementation XYDChatInputViewPluginLocation
@synthesize inputViewRef = _inputViewRef;
@synthesize sendCustomMessageHandler = _sendCustomMessageHandler;

#pragma mark -
#pragma mark - XYDChatInputViewPluginSubclassing Method

+ (XYDChatInputViewPluginType)classPluginType {
    return XYDChatInputViewPluginTypeLocation;
}

#pragma mark -
#pragma mark - XYDChatInputViewPluginDelegate Method

/*!
 * 插件图标
 */
- (UIImage *)pluginIconImage {
    return [self imageInBundlePathForImageName:@"chat_bar_icons_location"];
}

/*!
 * 插件名称
 */
- (NSString *)pluginTitle {
    return @"位置";
}

/*!
 * 插件对应的 view，会被加载到 inputView 上
 */
- (UIView *)pluginContentView {
    return nil;
}

/**
 *  lazy load locationController
 *
 *  @return XYDChatLocationController
 */
- (XYDChatLocationController *)locationController {
    if (_locationController == nil) {
        XYDChatLocationController *locationController = [[XYDChatLocationController alloc] init];
        locationController.delegate = self;
        _locationController = locationController;
    }
    return _locationController;
}

- (void)pluginDidClicked {
    [super pluginDidClicked];
    //显示地理位置
    UINavigationController *locationNav = [[UINavigationController alloc] initWithRootViewController:self.locationController];
    [self.conversationViewController presentViewController:locationNav animated:YES completion:nil];
}

- (XYDChatObjResultBlock)sendCustomMessageHandler {
    if (_sendCustomMessageHandler) {
        return _sendCustomMessageHandler;
    }
    XYDChatObjResultBlock sendCustomMessageHandler = ^(id object, NSError *error) {
        [self.conversationViewController dismissViewControllerAnimated:YES completion:nil];
        if (object) {
            CLPlacemark *placemark = (CLPlacemark *)object;
            [self.conversationViewController sendLocationMessageWithLocationCoordinate:placemark.location.coordinate locatioTitle:placemark.name];
        }
        _sendCustomMessageHandler = nil;
    };
    _sendCustomMessageHandler = sendCustomMessageHandler;
    return sendCustomMessageHandler;
}

#pragma mark -
#pragma mark - Private Methods

- (UIImage *)imageInBundlePathForImageName:(NSString *)imageName {
    UIImage *image = [XYDChatHelper getImageWithNamed:imageName bundleName:@"ChatKeyboard" bundleForClass:[self class]];
    return image;
}

#pragma mark - XYDChatLocationControllerDelegate

- (void)sendLocation:(CLPlacemark *)placemark {
    !self.sendCustomMessageHandler ?: self.sendCustomMessageHandler(placemark, nil);
}

- (void)cancelLocation {
    NSInteger code = 0;
    NSString *errorReasonText = @"cancel location without result";
    NSDictionary *errorInfo = @{
                                @"code":@(code),
                                NSLocalizedDescriptionKey : errorReasonText,
                                };
    NSError *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                         code:code
                                     userInfo:errorInfo];
    !self.sendCustomMessageHandler ?: self.sendCustomMessageHandler(nil, error);
}


@end
