//
//  XYDEmotionManager.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/9.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDEmotionManager.h"
#import "XYDEmotionHelper.h"

@interface XYDEmotionManager ()

@property (strong, nonatomic) NSMutableArray *commonEmotionArrays; // 普通静态表情
@property (strong, nonatomic) NSMutableArray *recentEmotionArrays; // 常用表情

@end

@implementation XYDEmotionManager

- (instancetype)init{
    if (self = [super init]) {
        _commonEmotionArrays = [NSMutableArray array];
        
        NSArray *faceArray = [NSArray arrayWithContentsOfFile:[XYDEmotionManager defaultCommonEmotionPath]];
        [_commonEmotionArrays addObjectsFromArray:faceArray];
        
        NSArray *recentArrays = [[NSUserDefaults standardUserDefaults] arrayForKey:@"recentFaceArrays"];
        if (recentArrays) {
            _recentEmotionArrays = [NSMutableArray arrayWithArray:recentArrays];
        } else {
            _recentEmotionArrays = [NSMutableArray array];
        }
    }
    return self;
}


#pragma mark - Class Methods

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static id shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}


#pragma mark - Emoji相关表情处理方法

+ (NSArray *)commonEmotions {
    return [[XYDEmotionManager shareInstance] commonEmotionArrays];
}

+ (NSString *)defaultCommonEmotionPath {
    NSBundle *bundle = [XYDEmotionHelper emotionBundle];
    NSString *defaultEmojiFacePath = [bundle pathForResource:@"face" ofType:@"plist"];
    return defaultEmojiFacePath;
}

+ (NSString *)emotionImageNameWithEmotionID:(NSUInteger)faceID {
    NSString *faceImageName = @"";
    if (faceID == 999) {
        faceImageName = @"[删除]";
    }
    for (NSDictionary *faceDict in [[XYDEmotionManager shareInstance] commonEmotionArrays]) {
        if ([faceDict[kEmotionIDKey] integerValue] == faceID) {
            faceImageName = faceDict[kEmotionImageNameKey];
        }
    }
    return faceImageName;
}

+ (UIImage *)emotionImageWithEmotionID:(NSUInteger)faceID {
    NSString *faceImageName = [self emotionImageNameWithEmotionID:faceID];
    UIImage *faceImage = [XYDEmotionHelper getEmotionWithImageName:faceImageName];
    return faceImage;
}

+ (NSString *)emotionNameWithEmotionID:(NSUInteger)faceID{
    if (faceID == 999) {
        return @"[删除]";
    }
    for (NSDictionary *faceDict in [[XYDEmotionManager shareInstance] commonEmotionArrays]) {
        if ([faceDict[kEmotionIDKey] integerValue] == faceID) {
            return faceDict[kEmotionNameKey];
        }
    }
    return @"";
}

+ (void)configEmotionWithMutableAttributedString:(NSMutableAttributedString *)attributeString {
    NSString *text = [attributeString string];
    if (!text.length) {
        //            return [[NSMutableAttributedString alloc] initWithString:@"【此版本暂不支持该格式，请升级至最新版查看】"];
        return;
    }
    //2、通过正则表达式来匹配字符串
    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\/\\u4e00-\\u9fa5]+\\]"; //匹配表情
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regex_emoji options:NSRegularExpressionCaseInsensitive error:&error];
    if (!regex) {
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
    NSArray *matches = [regex matchesInString:text
                                      options:0
                                        range:NSMakeRange(0, text.length)];
    NSUInteger emojiNumbers = matches.count;
    //无表情
    if (emojiNumbers == 0) {
        return;
    }
    
    //3、获取所有的表情以及位置
    //用来存放字典，字典中存储的是图片和图片对应的位置
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:matches.count];
    //根据匹配范围来用图片进行相应的替换
    for(NSTextCheckingResult *match in matches) {
        //获取数组元素中得到range
        NSRange range = [match range];
        //获取原字符串中对应的值
        NSString *subStr = [text substringWithRange:range];
        NSMutableArray *commonEmotionArrays = [[XYDEmotionManager shareInstance] commonEmotionArrays];
        for (NSDictionary *dict in commonEmotionArrays) {
            if ([dict[kEmotionNameKey]  isEqualToString:subStr]) {
                //face[i][@"png"]就是我们要加载的图片
                //新建文字附件来存放我们的图片,iOS7才新加的对象
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                //给附件添加图片
                textAttachment.image = [XYDEmotionHelper getEmotionWithImageName:dict[kEmotionImageNameKey]];
                //调整一下图片的位置,如果你的图片偏上或者偏下，调整一下bounds的y值即可
                textAttachment.bounds = CGRectMake(0, -8, textAttachment.image.size.width, textAttachment.image.size.height);
                //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                //把图片和图片对应的位置存入字典中
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                [imageDic setObject:imageStr forKey:@"image"];
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                //把字典存入数组中
                [imageArray addObject:imageDic];
                break;
            }
        }
    }
    
    //4、从后往前替换，否则会引起位置问题
    for (int i = (int)imageArray.count -1; i >= 0; i--) {
        NSRange range;
        [imageArray[i][@"range"] getValue:&range];
        //进行替换
        [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
    }
}

+ (NSMutableAttributedString *)emotionStrWithString:(NSString *)text {
    if (!text.length) {
        NSString *degradeContent = @"unknownMessage";
        return [[NSMutableAttributedString alloc] initWithString:degradeContent];
    }
    //1、创建一个可变的属性字符串
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    //2、通过正则表达式来匹配字符串
    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\/\\u4e00-\\u9fa5]+\\]"; //匹配表情
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regex_emoji options:NSRegularExpressionCaseInsensitive error:&error];
    if (!regex) {
        NSLog(@"%@", [error localizedDescription]);
        return attributeString;
    }
    NSArray *matches = [regex matchesInString:text
                                      options:0
                                        range:NSMakeRange(0, text.length)];
    NSUInteger emojiNumbers = matches.count;
    //无表情
    if (emojiNumbers == 0) {
        return attributeString;
    }
    
    //3、获取所有的表情以及位置
    //用来存放字典，字典中存储的是图片和图片对应的位置
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:matches.count];
    //根据匹配范围来用图片进行相应的替换
    for(NSTextCheckingResult *match in matches) {
        //获取数组元素中得到range
        NSRange range = [match range];
        //获取原字符串中对应的值
        NSString *subStr = [text substringWithRange:range];
        NSMutableArray *commonEmotionArrays = [[XYDEmotionManager shareInstance] commonEmotionArrays];
        for (NSDictionary *dict in commonEmotionArrays) {
            if ([dict[kEmotionNameKey]  isEqualToString:subStr]) {
                //face[i][@"png"]就是我们要加载的图片
                //新建文字附件来存放我们的图片,iOS7才新加的对象
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                //给附件添加图片
                textAttachment.image = [XYDEmotionHelper getEmotionWithImageName:dict[kEmotionImageNameKey]];
                //调整一下图片的位置,如果你的图片偏上或者偏下，调整一下bounds的y值即可
                textAttachment.bounds = CGRectMake(0, -8, textAttachment.image.size.width, textAttachment.image.size.height);
                //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                //把图片和图片对应的位置存入字典中
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                [imageDic setObject:imageStr forKey:@"image"];
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                //把字典存入数组中
                [imageArray addObject:imageDic];
                break;
            }
        }
    }
    
    //4、从后往前替换，否则会引起位置问题
    for (int i = (int)imageArray.count -1; i >= 0; i--) {
        NSRange range;
        [imageArray[i][@"range"] getValue:&range];
        //进行替换
        [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
    }
    return attributeString;
}

#pragma mark - 最近使用表情相关方法
/**
 *  获取最近使用的表情图片
 *
 */
+ (NSArray *)recentEmotions{
    return [[XYDEmotionManager shareInstance] recentEmotionArrays];
}

+ (BOOL)saveRecentEmotion:(NSDictionary *)recentDict{
    for (NSDictionary *dict in [[XYDEmotionManager shareInstance] recentEmotionArrays]) {
        if ([dict[@"face_id"] integerValue] == [recentDict[@"face_id"] integerValue]) {
            //NSLog(@"已经存在");
            return NO;
        }
    }
    [[[XYDEmotionManager shareInstance] recentEmotionArrays] insertObject:recentDict atIndex:0];
    if ([[XYDEmotionManager shareInstance] recentEmotionArrays].count > 8) {
        [[[XYDEmotionManager shareInstance] recentEmotionArrays] removeLastObject];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[[XYDEmotionManager shareInstance] recentEmotionArrays] forKey:@"recentFaceArrays"];
    return YES;
}

@end
