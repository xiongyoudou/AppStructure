//
//  XYDChatInputViewPluginConvBackground.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/15.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatInputViewPluginConvBackground.h"
#import "XYDConversationVCtrl.h"
#import "XYDChatHelper.h"

@interface XYDChatInputViewPluginConvBackground ()

@property (nonatomic, copy) XYDChatObjResultBlock sendCustomMessageHandler;
@property (nonatomic, copy) UIImagePickerController *pickerController;

@end

@implementation XYDChatInputViewPluginConvBackground
@synthesize inputViewRef = _inputViewRef;
@synthesize sendCustomMessageHandler = _sendCustomMessageHandler;


#pragma mark -
#pragma mark - XYDChatInputViewPluginSubclassing Method

+ (void)load {
    [self registerCustomInputViewPlugin];
}

+ (XYDChatInputViewPluginType)classPluginType {
    return XYDChatInputViewPluginTypeConverBackground;
}

#pragma mark -
#pragma mark - XYDChatInputViewPluginDelegate Method

/*!
 * 插件图标
 */
- (UIImage *)pluginIconImage {
    return [self imageInBundlePathForImageName:@"chat_bar_icons_pic"];
}

/*!
 * 插件名称
 */
- (NSString *)pluginTitle {
    return @"改背景";
}

/*!
 * 插件对应的 view，会被加载到 inputView 上
 */
- (UIView *)pluginContentView {
    return nil;
}

- (void)pluginDidClicked {
    [super pluginDidClicked];
    //显示相册
    [self.conversationViewController presentViewController:self.pickerController animated:YES completion:nil];
}

- (XYDChatObjResultBlock)sendCustomMessageHandler {
    if (_sendCustomMessageHandler) {
        return _sendCustomMessageHandler;
    }
    XYDChatObjResultBlock sendCustomMessageHandler = ^(id object, NSError *error) {
        [self.conversationViewController dismissViewControllerAnimated:YES completion:nil];
        if (object) {
            UIImage *image = (UIImage *)object;
            //            [self.conversationViewController sendImageMessage:image];
            [[XYDChatKit sharedInstance] setBackgroundImage:image forConversationId:self.conversationViewController.conversationId scaledToSize:self.conversationViewController.view.frame.size];
        } else {
//            XYDChatLog(@"%@", error.description);
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
