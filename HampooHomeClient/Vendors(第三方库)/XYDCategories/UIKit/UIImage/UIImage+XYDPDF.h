//
//  UIImage+XYDPDF.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/29.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XYDPDF)

+ (UIImage *)imageWithPDF:(id)dataOrPath;
+ (UIImage *)imageWithPDF:(id)dataOrPath size:(CGSize)size;

@end
