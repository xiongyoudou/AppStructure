//
//  XYDBaseConversationVCtrl.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/8.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDBaseConversationVCtrl.h"
#import "XYDChatInputBar.h"
#import "XYDChatStatusView.h"
#import "NSObject+XYDAssociatedObject.h"

#import "XYDConversationRefreshHeader.h"
#import "XYDChatHelper.h"
#import "XYDChatSessionService.h"
#import "XYDChatUIService.h"
#import "XYDChatErrorUtil.h"

static void * const XYDBaseConversationViewControllerRefreshContext = (void*)&XYDBaseConversationViewControllerRefreshContext;
static CGFloat const XYDScrollViewInsetTop = 20.f;

@interface XYDBaseConversationVCtrl ()<XYDChatStatusViewDelegate>

@end

@implementation XYDBaseConversationVCtrl

- (void)dealloc {
    _chatBar.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initilzer];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.and.left.and.width.equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(64);
        make.left.and.width.equalTo(self.view);
        
        // 注意，此处明确定义了tableview和底部栏的位置关系。
        //所以在做底部栏弹出等动画时，不需要重新定义约束，因为tableview和
        //底部栏约束确定了，底部栏高度增加，从而肯定会伴随着tableview高度减小
        //（因为tableview与顶部父视图约束也是确定的）
        make.bottom.equalTo(self.chatBar.mas_top);
    }];
    [self.chatBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.height.mas_greaterThanOrEqualTo(@(kChatBarMinHeight));
    }];
}

- (void)initilzer {
    self.tableView.backgroundColor = COLOR(235, 235, 235, 1.0);
    self.shouldLoadMoreMessagesScrollToTop = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // KVO注册监听
    [self addObserver:self forKeyPath:@"loadingMoreMessage" options:NSKeyValueObservingOptionNew context:XYDBaseConversationViewControllerRefreshContext];
    __unsafe_unretained typeof(self) weakSelf = self;
//     注入dealloc时执行的具体操作
    [self xyd_executeAtDealloc:^{
        [weakSelf removeObserver:weakSelf forKeyPath:@"loadingMoreMessage"];
    }];
    // 注册messageCell
    [XYDChatHelper registerChatMessageCellClassForTableView:self.tableView];
    __weak __typeof(self) weakSelf_ = self;
    self.tableView.mj_header = [XYDConversationRefreshHeader headerWithRefreshingBlock:^{
        if (weakSelf_.shouldLoadMoreMessagesScrollToTop && !weakSelf_.loadingMoreMessage) {
            // 进入刷新状态后会自动调用这个block
            [weakSelf_ loadMoreMessagesScrollTotop];
        } else {
            [weakSelf_.tableView.mj_header endRefreshing];
        }
    }];
}

#pragma mark - Scroll Message TableView Helper Method

- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom {
    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:bottom];
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
}

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    insets.top = XYDScrollViewInsetTop;
    insets.bottom = bottom;
    return insets;
}

- (void)setShouldLoadMoreMessagesScrollToTop:(BOOL)shouldLoadMoreMessagesScrollToTop {
    _shouldLoadMoreMessagesScrollToTop = shouldLoadMoreMessagesScrollToTop;
    
}

// KVO监听执行
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if(context != XYDBaseConversationViewControllerRefreshContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if(context == XYDBaseConversationViewControllerRefreshContext) {
        //if ([keyPath isEqualToString:@"loadingMoreMessage"]) {
        id newKey = change[NSKeyValueChangeNewKey];
        BOOL boolValue = [newKey boolValue];
        if (!boolValue) {
            [self.tableView.mj_header endRefreshing];
            if (!_shouldLoadMoreMessagesScrollToTop) {
                self.tableView.mj_header = nil;
            }
        }
    }
}

// 父类这里什么也不做，此方法必须由子类重载
- (void)loadMoreMessagesScrollTotop {
    // This enforces implementing this method in subclasses
    [self doesNotRecognizeSelector:_cmd];
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    if (!self.allowScrollToBottom) {
        return;
    }
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    if (rows > 0) {
        dispatch_block_t scrollBottomBlock = ^ {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                                  atScrollPosition:UITableViewScrollPositionBottom
                                          animated:animated];
        };
        if (animated) {
            //when use `estimatedRowHeight` and `scrollToRowAtIndexPath` at the same time, there are some issue.
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                scrollBottomBlock();
            });
        } else {
            scrollBottomBlock();
        }
        
    }
}

#pragma mark -
#pragma mark - Previte Method

#pragma mark - statusView
- (void)statusViewClicked:(id)sender {
    [[XYDChatSessionService sharedInstance] reconnectForViewController:self callback:nil];
}

- (void)applicationDidBecomeActive:(NSNotification*)note {
    self.checkSessionStatus = YES;
}

- (void)applicationWillResignActive:(NSNotification*)note {
    self.checkSessionStatus = NO;
}

#pragma mark -
#pragma mark - alert

- (void)alert:(NSString *)message {
    XYDChatShowNotificationBlock showNotificationBlock = [XYDChatUIService sharedInstance].showNotificationBlock;
    !showNotificationBlock ?: showNotificationBlock(self, message, nil, XYDChatMessageNotificationTypeError);
}

- (BOOL)alertWithConversationError:(NSError *)error {
    if (error) {
        if (error.code == kXYDChatErrorConnectionLost) {
            [self alert:@"未能连接聊天服务"];
        } else if ([error.domain isEqualToString:NSURLErrorDomain]) {
            [self alert:@"网络连接发生错误"];
        } else {
            [self alert:[NSString stringWithFormat:@"%@", error]];
        }
        return YES;
    }
    return NO;
}

- (BOOL)filterConversationError:(NSError *)error {
    return [self alertWithConversationError:error] == NO;
}

#pragma mark -
#pragma mark - Getters

- (XYDChatInputBar *)chatBar {
    if (!_chatBar) {
        XYDChatInputBar *chatBar = [[XYDChatInputBar alloc] init];
        [self.view addSubview:(_chatBar = chatBar)];
        [self.view bringSubviewToFront:_chatBar];
    }
    return _chatBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [MyTool createTableViewWithStyle:UITableViewStylePlain onCtrl:self];
    }
    return _tableView;
}

- (XYDChatStatusView *)clientStatusView {
    if (_clientStatusView== nil) {
        _clientStatusView = [[XYDChatStatusView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, XYDChatStatusViewHight)];
        _clientStatusView.delegate = self;
    }
    return _clientStatusView;
}


@end
