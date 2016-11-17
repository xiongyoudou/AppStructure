//
//  XYDConversationNaviTitleView.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/17.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XYDConversation;


@interface XYDConversationNaviTitleView : UIView

@property (nonatomic, assign) BOOL showRemindMuteImageView;
- (instancetype)initWithConversation:(XYDConversation *)conversation navigationController:(UINavigationController *)navigationController;

@end
