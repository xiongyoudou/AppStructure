//
//  XYDChatLocationController.h
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/15.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYDLocationManager.h"

@protocol XYDChatLocationControllerDelegate <NSObject>

- (void)cancelLocation;
- (void)sendLocation:(CLPlacemark *)placemark;

@end

// 选择地理位置
@interface XYDChatLocationController : UIViewController

@property (weak, nonatomic) id<XYDChatLocationControllerDelegate> delegate;

@end
