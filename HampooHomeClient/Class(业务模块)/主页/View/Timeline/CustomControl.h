//
//  CustomControl.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/29.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomGestureRecognizer.h"

@interface CustomControl : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) void (^touchBlock)(CustomControl *view, CustomGestureRecognizerState state, NSSet *touches, UIEvent *event);
@property (nonatomic, copy) void (^longPressBlock)(CustomControl *view, CGPoint point);

@end
