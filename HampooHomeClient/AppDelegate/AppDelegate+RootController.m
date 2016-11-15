//
//  HHAppDelegate+RootController.m
//  HomeHome
//
//  Created by Victor on 16/3/4.
//  Copyright © 2016年 Victor. All rights reserved.
//

#import "AppDelegate+RootController.h"
#import "AppDelegate+AppService.h"

#import "XYDTabBarControllerConfig.h"
#import "IntroductionVCtrl.h"

@implementation AppDelegate (RootController)

/**
 *  window实例
 */
- (void)setAppWindows {
    _isFirstInstall = NO;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
}

/**
 *  根视图
 */
- (void)setRootViewController{
    if (_isFirstInstall) {
        [self createIntroViewCtrl];
    }else {
        [self checkBlacklist];
        [self setTabbarController];
    }
}

/**
 *  tabbar实例
 */
- (void)setTabbarController {
    XYDTabBarControllerConfig *tabBarControllerConfig = [[XYDTabBarControllerConfig alloc] init];
    [self.window setRootViewController:tabBarControllerConfig.tabBarController];
}

#pragma mark - 一般首次登陆程序需要执行的操作
/**
 *  创建引导视图
 */
- (void)createIntroViewCtrl {
    IntroductionVCtrl *introVCtrl = [IntroductionVCtrl new];
    WEAKSELF
    introVCtrl.didIntroFinishBlock = ^{
        _isFirstInstall = NO;
        [weakSelf setRootViewController];
    };
    self.window.rootViewController = introVCtrl;
}


@end
