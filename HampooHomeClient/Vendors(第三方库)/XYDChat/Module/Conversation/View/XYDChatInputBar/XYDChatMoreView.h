//
//  XYDChatMoreView.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/8.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYDChatConstant.h"

static CGFloat const kFunctionViewHeight = 210.0f;
@class XYDChatInputBar;

@interface XYDChatMoreView : UIView

@property (assign, nonatomic) NSUInteger numberPerLine;
@property (assign, nonatomic) UIEdgeInsets edgeInsets;
@property (weak, nonatomic) XYDChatInputBar *inputViewRef;

@end
