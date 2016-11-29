//
//  TLStatusLayout.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/29.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimelineModel.h"
#import "YYText.h"
#import "UIColor+XYDHEX.h"

#define UIColorHex(_hex_)   [UIColor xyd_colorWithHexString:((__bridge NSString *)CFSTR(#_hex_))]

// 宽高
#define kTLCellTopMargin 8      // cell 顶部灰色留白
#define kTLCellTitleHeight 36   // cell 标题高度 (例如"仅自己可见")
#define kTLCellPadding 12       // cell 内边距
#define kTLCellPaddingText 10   // cell 文本与其他元素间留白
#define kTLCellPaddingPic 4     // cell 多张图片中间留白
#define kTLCellProfileHeight 56 // cell 名片高度
#define kTLCellCardHeight 70    // cell card 视图高度
#define kTLCellNamePaddingLeft 14 // cell 名字和 avatar 之间留白
#define kTLCellContentWidth (kScreenWidth - 2 * kTLCellPadding) // cell 内容宽度
#define kTLCellNameWidth (kScreenWidth - 110) // cell 名字最宽限制

#define kTLCellTagPadding 8         // tag 上下留白
#define kTLCellTagNormalHeight 16   // 一般 tag 高度
#define kTLCellTagPlaceHeight 24    // 地理位置 tag 高度

#define kTLCellToolbarBottomMargin 2 // cell 下方灰色留白

// 字体 应该做成动态的，这里只是 Demo，临时写死了。
#define kTLCellNameFontSize 16      // 名字字体大小
#define kTLCellSourceFontSize 12    // 来源字体大小
#define kTLCellTextFontSize 17      // 文本字体大小
#define kTLCellTextFontRetweetSize 16 // 转发字体大小
#define kTLCellCardTitleFontSize 16 // 卡片标题文本字体大小
#define kTLCellCardDescFontSize 12 // 卡片描述文本字体大小
#define kTLCellTitlebarFontSize 14 // 标题栏字体大小

// 颜色
#define kTLCellNameNormalColor UIColorHex(333333) // 名字颜色
#define kTLCellNameOrangeColor UIColorHex(f26220) // 橙名颜色 (VIP)
#define kTLCellTimeNormalColor UIColorHex(828282) // 时间颜色
#define kTLCellTimeOrangeColor UIColorHex(f28824) // 橙色时间 (最新刷出)

#define kTLCellTextNormalColor UIColorHex(333333) // 一般文本色
#define kTLCellTextSubTitleColor UIColorHex(5d5d5d) // 次要文本色
#define kTLCellTextHighlightColor UIColorHex(527ead) // Link 文本色
#define kTLCellTextHighlightBackgroundColor UIColorHex(bfdffe) // Link 点击背景色

#define kTLCellBackgroundColor UIColorHex(f2f2f2)    // Cell背景灰色
#define kTLCellHighlightColor UIColorHex(f0f0f0)     // Cell高亮时灰色
#define kTLCellInnerViewColor UIColorHex(f7f7f7)   // Cell内部卡片灰色
#define kTLCellInnerViewHighlightColor  UIColorHex(f0f0f0) // Cell内部卡片高亮时灰色
#define kTLCellLineColor [UIColor colorWithWhite:0.000 alpha:0.09] //线条颜色

#define kTLLinkHrefName @"href" //NSString
#define kTLLinkURLName @"url" //TLURL
#define kTLLinkTagName @"tag" //TLTag
#define kTLLinkTopicName @"topic" //TLTopic
#define kTLLinkAtName @"at" //NSString

/// 最下方Tag类型，也是随便写的，微博可能有更多类型同时存在等情况
typedef NS_ENUM(NSUInteger, TLTagType) {
    TLTagTypeNone = 0, ///< 没Tag
    TLTagTypeNormal,   ///< 文本
    TLTagTypePlace,    ///< 地点
};

/**
 一个 Cell 的布局。
 布局排版应该在后台线程完成。
 */
@interface TLLayout : NSObject

- (instancetype)initWithModel:(TLModel *)model;
- (void)layout; ///< 计算布局
- (void)updateDate; ///< 更新时间字符串

// 以下是数据
@property (nonatomic, strong) TLModel *model;


//以下是布局结果

// 顶部留白
@property (nonatomic, assign) CGFloat marginTop; //顶部灰色留白

// 标题栏
@property (nonatomic, assign) CGFloat titleHeight; //标题栏高度，0为没标题栏
@property (nonatomic, strong) YYTextLayout *titleTextLayout; // 标题栏

// 个人资料
@property (nonatomic, assign) CGFloat profileHeight; //个人资料高度(包括留白)
@property (nonatomic, strong) YYTextLayout *nameTextLayout; // 名字
@property (nonatomic, strong) YYTextLayout *sourceTextLayout; //时间/来源

// 文本
@property (nonatomic, assign) CGFloat textHeight; //文本高度(包括下方留白)
@property (nonatomic, strong) YYTextLayout *textLayout; //文本

// 图片
@property (nonatomic, assign) CGFloat picHeight; //图片高度，0为没图片
@property (nonatomic, assign) CGSize picSize;

// Tag
@property (nonatomic, assign) CGFloat tagHeight; //Tip高度，0为没tip
@property (nonatomic, assign) TLTagType tagType;
@property (nonatomic, strong) YYTextLayout *tagTextLayout; //最下方tag

// 下边留白
@property (nonatomic, assign) CGFloat marginBottom; //下边留白

// 总高度
@property (nonatomic, assign) CGFloat height;



/*
 
 用户信息  status.user
 文本      status.text
 图片      status.pics
 转发      status.retweetedStatus
 文本       status.retweetedStatus.user + status.retweetedStatus.text
 图片       status.retweetedStatus.pics
 卡片       status.retweetedStatus.pageInfo
 卡片      status.pageInfo
 Tip       status.tagStruct
 
 1.根据 urlStruct 中每个 URL.shortURL 来匹配文本，将其替换为图标+友好描述
 2.根据 topicStruct 中每个 Topic.topicTitle 来匹配文本，标记为话题
 2.匹配 @用户名
 4.匹配 [表情]
 
 一条里，图片|转发|卡片不能同时存在，优先级是 转发->图片->卡片
 如果不是转发，则显示Tip
 
 
 文本
 文本 图片/卡片
 文本 Tip
 文本 图片/卡片 Tip
 
 文本 转发[文本]  /Tip
 文本 转发[文本 图片] /Tip
 文本 转发[文本 卡片] /Tip
 
 话题                                 #爸爸去哪儿#
 电影 TL_card_small_movie       #冰雪奇缘[电影]#
 图书 TL_card_small_book        #纸牌屋[图书]#
 音乐 TL_card_small_music       #Let It Go[音乐]#
 地点 TL_card_small_location    #理想国际大厦[地点]#
 股票 TL_icon_stock             #腾讯控股 kh00700[股票]#
 */

@end

/**
 文本 Line 位置修改
 将每行文本的高度和位置固定下来，不受中英文/Emoji字体的 ascent/descent 影响
 */
@interface TLTextLinePositionModifier : NSObject <YYTextLinePositionModifier>
@property (nonatomic, strong) UIFont *font; // 基准字体 (例如 Heiti SC/PingFang SC)
@property (nonatomic, assign) CGFloat paddingTop; //文本顶部留白
@property (nonatomic, assign) CGFloat paddingBottom; //文本底部留白
@property (nonatomic, assign) CGFloat lineHeightMultiple; //行距倍数
- (CGFloat)heightForLineCount:(NSUInteger)lineCount;


@end
