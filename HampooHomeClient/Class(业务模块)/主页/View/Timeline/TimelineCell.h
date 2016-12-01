//
//  TLCell.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/29.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimelineLayout.h"

@class TLCell;
@protocol TLCellDelegate;

@interface TLTitleView : UIView
@property (nonatomic, strong) YYLabel *titleLabel;
@property (nonatomic, strong) UIButton *arrowButton;
@property (nonatomic, weak) TLCell *cell;
@end

@interface TLProfileView : UIView
@property (nonatomic, strong) UIImageView *avatarView; ///< 头像
@property (nonatomic, strong) UIImageView *avatarBadgeView; ///< 徽章
@property (nonatomic, strong) YYLabel *nameLabel;
@property (nonatomic, strong) YYLabel *sourceLabel;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIButton *arrowButton;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, weak) TLCell *cell;
@end


@interface TLView : UIView
@property (nonatomic, strong) UIView *contentView;              // 容器
@property (nonatomic, strong) TLTitleView *titleView;     // 标题栏
@property (nonatomic, strong) TLProfileView *profileView; // 用户资料
@property (nonatomic, strong) YYLabel *textLabel;               // 文本
@property (nonatomic, strong) NSArray<UIView *> *picViews;      // 图片
@property (nonatomic, strong) UIImageView *vipBackgroundView;   // VIP 自定义背景
@property (nonatomic, strong) UIButton *menuButton;             // 菜单按钮
@property (nonatomic, strong) UIButton *followButton;           // 关注按钮

@property (nonatomic, strong) TLLayout *layout;
@property (nonatomic, weak) TLCell *cell;
@end

@protocol TLCellDelegate;

@interface TLCell : UITableViewCell
@property (nonatomic, weak) id<TLCellDelegate> delegate;
@property (nonatomic, strong) TLView *statusView;
- (void)setLayout:(TLLayout *)layout;
@end

@protocol TLCellDelegate <NSObject>
@optional
/// 点击了 Cell
- (void)cellDidClick:(TLCell *)cell;
/// 点击了Cell菜单
- (void)cellDidClickMenu:(TLCell *)cell;
/// 点击了下方 Tag
- (void)cellDidClickTag:(TLCell *)cell;
/// 点击了用户
- (void)cell:(TLCell *)cell didClickUser:(TLUser *)user;
/// 点击了图片
- (void)cell:(TLCell *)cell didClickImageAtIndex:(NSUInteger)index;
/// 点击了 Label 的链接
- (void)cell:(TLCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange;
@end
