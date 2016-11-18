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

@interface MainVCtrl ()

@end

@implementation MainVCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
