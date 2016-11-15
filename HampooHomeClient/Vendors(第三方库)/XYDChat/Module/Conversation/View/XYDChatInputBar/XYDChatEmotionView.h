//
//  XYDChatEmotionView.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/8.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XYDShowEmotionViewType) {
    XYDShowCommonEmotion = 0,     // 显示静态图片表情
    XYDShowRecentEmotion,          // 显示最近发送的表情
    XYDShowGifEmotion,             // 显示gif图片表情
    XYDShowEmojiEmotion,           // 显示Emoji表情
};

#define kTopLineBackgroundColor [UIColor colorWithRed:184/255.0f green:184/255.0f blue:184/255.0f alpha:1.0f]

@protocol XYDChatFaceViewDelegate <NSObject>

- (void)emotionViewSendEmotion:(NSString *)faceName;

@end

@interface XYDChatEmotionView : UIView

@property (weak, nonatomic) id<XYDChatFaceViewDelegate> delegate;
@property (assign, nonatomic) XYDShowEmotionViewType emotionViewType;

@end
