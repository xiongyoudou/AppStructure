//
//  XYDChatTextFullscreenVCtrl.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/17.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XYDChatMessage;

typedef void (^XYDChatRemoveFromWindowHandler)(void);

@interface XYDChatTextFullscreenVCtrl : UIViewController

- (instancetype)initWithText:(NSString *)text;
- (void)setRemoveFromWindowHandler:(XYDChatRemoveFromWindowHandler)removeFromWindowHandler;

@end
