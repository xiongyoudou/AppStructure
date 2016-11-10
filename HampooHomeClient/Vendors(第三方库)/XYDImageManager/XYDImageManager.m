//
//  LCCKImageManager.m
//  Kuber
//
//  v0.8.0 Created by Kuber on 16/3/30.
//  Copyright © 2016年 Huaxu Technology. All rights reserved.
//

#import "XYDImageManager.h"
#import "NSMutableDictionary+XYDWeakReference.h"

@interface XYDImageManager()

@property (nonatomic, strong) NSMutableDictionary *imageBuff;

@end

@implementation XYDImageManager

+ (instancetype)defaultManager {
    static XYDImageManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (UIImage *)getImageWithName:(NSString *)name {
    UIImage *storeImage = [self getImageWithName:name inBundle:[NSBundle mainBundle]];
    return storeImage;
}

- (UIImage *)getImageWithName:(NSString *)name inBundle:(NSBundle *)bundle {
    UIImage *image = [self.imageBuff xyd_weak_getObjectForKey:name];
    if(image) {
        return image;
    }
    NSString *res = name.stringByDeletingPathExtension;
    NSString *ext = name.pathExtension;
    NSString *path = nil;
    CGFloat scale = 1;
    // If no extension, guess by system supported (same as UIImage).
    NSArray *exts = ext.length > 0 ? @[ext] : @[@"", @"png", @"jpeg", @"jpg", @"gif", @"webp", @"apng"];
    NSArray *scales = [MyTool getScaleArray];
    for (int s = 0; s < scales.count; s++) {
        scale = ((NSNumber *)scales[s]).floatValue;
        NSString *scaledName = [self appendingScale:scale onStr:res];
        for (NSString *e in exts) {
            path = [bundle pathForResource:scaledName ofType:e];
            if (path) break;
        }
        if (path) break;
    }
    if (path.length == 0) return nil;
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data.length == 0) return nil;
    UIImage *storeImage = [[UIImage alloc] initWithData:data scale:scale];
    [self.imageBuff xyd_weak_setObject:storeImage forKey:name];
    return storeImage;
}

- (NSString *)appendingScale:(CGFloat)scale onStr:(NSString *)str {
    if (fabs(scale - 1) <= __FLT_EPSILON__ || str.length == 0 || [str hasSuffix:@"/"]) return str.copy;
    return [str stringByAppendingFormat:@"@%@x", @(scale)];
}

- (NSMutableDictionary *)imageBuff {
    if(!_imageBuff) {
        _imageBuff = [NSMutableDictionary dictionary];
    }
    return _imageBuff;
}

@end
