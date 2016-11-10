//
//  XYDEmotionHelper.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/9.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDEmotionHelper.h"
#import "XYDImageManager.h"

@implementation XYDEmotionHelper

// 表情资源bundle
+ (NSBundle *)emotionBundle {
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"EmoticonWeibo" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:bundlePath];
    });
    return bundle;
}

+ (UIImage *)getEmotionWithImageName:(NSString *)imageName {
    if (imageName.length == 0) return nil;
    if ([imageName hasSuffix:@"/"]) return nil;
    NSBundle *bundle = [self emotionBundle];
    XYDImageManager *manager = [XYDImageManager defaultManager];
    UIImage *image = [manager getImageWithName:imageName
                                      inBundle:bundle];
    if (!image) {
        //`-getImageWithName` not work for image in Access Asset Catalog
        image = [UIImage imageNamed:imageName];
    }
    return image;
}

@end
