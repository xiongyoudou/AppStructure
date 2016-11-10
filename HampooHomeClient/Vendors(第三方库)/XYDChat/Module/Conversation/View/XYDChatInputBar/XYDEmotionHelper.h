//
//  XYDEmotionHelper.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/9.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYDImageManager.h"

@interface XYDEmotionHelper : NSObject

+ (NSBundle *)emotionBundle;
+ (UIImage *)getEmotionWithImageName:(NSString *)imageName;

@end
