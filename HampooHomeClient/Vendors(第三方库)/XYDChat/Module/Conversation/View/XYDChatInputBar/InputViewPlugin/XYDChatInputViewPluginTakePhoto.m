//
//  XYDChatInputViewPluginTakePhoto.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/15.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatInputViewPluginTakePhoto.h"
#import "XYDConversationVCtrl.h"
#import "XYDChatHelper.h"
#import "XYDChatUIService.h"

@interface XYDChatInputViewPluginTakePhoto ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, copy) XYDChatObjResultBlock sendCustomMessageHandler;
@property (nonatomic, copy) UIImagePickerController *pickerController;

@end

@implementation XYDChatInputViewPluginTakePhoto
@synthesize inputViewRef = _inputViewRef;
@synthesize sendCustomMessageHandler = _sendCustomMessageHandler;

#pragma mark -
#pragma mark - XYDChatInputViewPluginSubclassing Method

+ (XYDChatInputViewPluginType)classPluginType {
    return XYDChatInputViewPluginTypeTakePhoto;
}

#pragma mark -
#pragma mark - XYDChatInputViewPluginDelegate Method

/*!
 * 插件图标
 */
- (UIImage *)pluginIconImage {
    return [self imageInBundlePathForImageName:@"chat_bar_icons_camera"];
}

/*!
 * 插件名称
 */
- (NSString *)pluginTitle {
    return @"拍摄";
}

/*!
 * 插件对应的 view，会被加载到 inputView 上
 */
- (UIView *)pluginContentView {
    return nil;
}

- (void)dealloc {
    self.inputViewRef = nil;
}

- (void)pluginDidClicked {
    [super pluginDidClicked];
    //显示拍照
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        XYDChatShowNotificationBlock showNotificationBlock = [XYDChatUIService sharedInstance].showNotificationBlock;
//        id<UIApplicationDelegate> delegate = ((id<UIApplicationDelegate>)[[UIApplication sharedApplication] delegate]);
//        UIWindow *window = delegate.window;
//        !showNotificationBlock ?: showNotificationBlock(window.rootViewController, @"您的设备不支持拍照", @"请尝试在设置中开启拍照权限", XYDChatMessageNotificationTypeError);
        return;
    }
    [self.conversationViewController presentViewController:self.pickerController animated:YES completion:nil];
}

- (XYDChatObjResultBlock)sendCustomMessageHandler {
    if (_sendCustomMessageHandler) {
        return _sendCustomMessageHandler;
    }
    XYDChatObjResultBlock sendCustomMessageHandler = ^(id object, NSError *error) {
        [self.conversationViewController dismissViewControllerAnimated:YES completion:nil];
        UIImage *image = (UIImage *)object;
        if (object) {
            [self.conversationViewController sendImageMessage:image];
        }
        _sendCustomMessageHandler = nil;
    };
    _sendCustomMessageHandler = sendCustomMessageHandler;
    return sendCustomMessageHandler;
}

#pragma mark -
#pragma mark - Private Methods

- (UIImagePickerController *)pickerController {
    if (_pickerController) {
        return _pickerController;
    }
    _pickerController = [[UIImagePickerController alloc] init];
    _pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    _pickerController.delegate = self;
    return _pickerController;
}

- (UIImage *)imageInBundlePathForImageName:(NSString *)imageName {
    UIImage *image = [XYDChatHelper getImageWithNamed:imageName bundleName:@"ChatKeyboard" bundleForClass:[self class]];
    return image;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    !self.sendCustomMessageHandler ?: self.sendCustomMessageHandler(image, nil);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSInteger code = 0;
    NSString *errorReasonText = @"cancel image picker without result";
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
