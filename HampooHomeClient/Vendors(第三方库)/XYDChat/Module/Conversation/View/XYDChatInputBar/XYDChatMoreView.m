//
//  XYDChatMoreView.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/8.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatMoreView.h"
@class XYDInputViewPlugin;

#define kLCCKTopLineBackgroundColor [UIColor colorWithRed:184/255.0f green:184/255.0f blue:184/255.0f alpha:1.0f]


@interface XYDChatMoreView ()<UIScrollViewDelegate>

@property (copy, nonatomic) NSArray *titles;
@property (copy, nonatomic) NSArray *images;

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray<XYDInputViewPlugin *> *itemViews;

@property (assign, nonatomic) CGSize itemSize;
@property (nonatomic, copy) NSArray<Class> *sortedInputViewPluginArray;
@property (nonatomic, strong) UIColor *messageInputViewMorePanelBackgroundColor;

@end

@implementation XYDChatMoreView


@end
