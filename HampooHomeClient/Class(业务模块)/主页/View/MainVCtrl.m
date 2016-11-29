//
//  MainVCtrl.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/8.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "MainVCtrl.h"
#import "XYDConversationVCtrl.h"
#import "XYDChatInputViewPluginTakePhoto.h"
#import "XYDChatInputViewPluginPickImage.h"
#import "XYDChatInputViewPluginLocation.h"

#import "TimelineVCtrl.h"

@interface MainVCtrl ()

@end

@implementation MainVCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

// 聊天界面
- (IBAction)clickBtn:(id)sender {
    XYDConversationVCtrl *ctrl = [[XYDConversationVCtrl alloc]initWithPeerId:@"ddd"];
    [self.navigationController pushViewController:ctrl animated:YES];
    
    static BOOL isAdd = NO;
    if (!isAdd) {
        [XYDChatInputViewPluginTakePhoto registerSubclass];
        [XYDChatInputViewPluginPickImage registerSubclass];
        [XYDChatInputViewPluginLocation registerSubclass];
        isAdd = YES;
    }
}

// 动态界面
- (IBAction)clickBtn2:(id)sender {
    TimelineVCtrl *ctrl = [TimelineVCtrl new];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
