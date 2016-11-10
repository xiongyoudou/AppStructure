//
//  XYDEmotionPageView.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/8.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XYDEmotionPageViewDelegate <NSObject>

- (void)selectedEmotionImageWithEmotionID:(NSUInteger)emotionID;

@end

// 用以显示某一页上的表情视图
@interface XYDEmotionPageView : UIView

@property (nonatomic, assign) NSUInteger columnsPerRow;
@property (nonatomic, copy) NSArray *datas;
@property (nonatomic, weak) id<XYDEmotionPageViewDelegate> delegate;

@end
