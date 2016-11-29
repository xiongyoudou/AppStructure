//
//  UIView+ConvertFrame.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/29.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ConvertFrame)

- (CGPoint)xyd_convertPoint:(CGPoint)point toViewOrWindow:(UIView *)view;
- (CGPoint)xyd_convertPoint:(CGPoint)point fromViewOrWindow:(UIView *)view;
- (CGRect)xyd_convertRect:(CGRect)rect toViewOrWindow:(UIView *)view;
- (CGRect)xyd_convertRect:(CGRect)rect fromViewOrWindow:(UIView *)view;

@end
