//
//  XYDBaseConversationVCtrl.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/8.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDBaseConversationVCtrl.h"
#import "XYDChatInputBar.h"
#import "NSObject+XYDAssociatedObject.h"

#import "XYDConversationRefreshHeader.h"

static void * const XYDBaseConversationViewControllerRefreshContext = (void*)&XYDBaseConversationViewControllerRefreshContext;
static CGFloat const XYDScrollViewInsetTop = 20.f;

@interface XYDBaseConversationVCtrl ()

@end

@implementation XYDBaseConversationVCtrl

- (void)dealloc {
    _chatBar.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initilzer];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.width.equalTo(self.view);
        make.bottom.equalTo(self.chatBar.mas_top);
    }];
    [self.chatBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.height.mas_greaterThanOrEqualTo(@(kChatBarMinHeight));
    }];
}

- (void)initilzer {
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
    
    //[XYDChatCellRegisterController registerChatMessageCellClassForTableView:self.tableView];
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

#pragma mark - Previte Method


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

@end
