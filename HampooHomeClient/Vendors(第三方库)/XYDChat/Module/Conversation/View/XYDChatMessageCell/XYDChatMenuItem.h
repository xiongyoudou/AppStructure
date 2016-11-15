//
//  XYDChatMenuItem.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/10.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 This subclass adds support for a block-based action on UIMenuItem.
 If you are as annoyed about the missing target/action pattern, you will love this.
 
 If you use XYDChatMenuItem with the classic initWithTitle:selector initializer,
 this will work and be handled just like a UIMenuItem.
 */

@interface XYDChatMenuItem : UIMenuItem


// Initialize XYDChatMenuItem with a block.
- (id)initWithTitle:(NSString *)title block:(void(^)())block;

// Menu Item can be enabled/disabled. (disable simply hides it from the UIMenuController)
@property(nonatomic, assign, getter=isEnabled) BOOL enabled;

// Action block.
@property(nonatomic, copy) void(^block)();


/**
 Installs the menu handler. Needs to be called once per class.
 (A good place is the +load method)
 
 Following methods will be swizzled:
 - canBecomeFirstResponder (if object doesn't already return YES)
 - canPerformAction:withSender:
 - methodSignatureForSelector:
 - forwardInvocation:
 
 The original implementation will be called if the XYDChatMenuItem selector is not detected.
 
 @parm object can be an instance or a class.
 */
+ (void)installMenuHandlerForObject:(id)object;

@end
