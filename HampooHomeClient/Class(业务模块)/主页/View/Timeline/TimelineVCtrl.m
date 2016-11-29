//
//  TimelineVCtrl.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/29.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "TimelineVCtrl.h"
#import "TimelineModel.h"
#import "TimelineLayout.h"
#import "TimelineCell.h"
#import "YYModel.h"

@interface TimelineVCtrl ()<UITableViewDelegate,UITableViewDataSource,TLCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *layouts;

@end

@implementation TimelineVCtrl

- (instancetype)init {
    self = [super init];
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    _tableView.delaysContentTouches = NO;
    _tableView.canCancelContentTouches = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _layouts = [NSMutableArray new];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.frame = self.view.bounds;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.scrollIndicatorInsets = _tableView.contentInset;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    self.view.backgroundColor = kTLCellBackgroundColor;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i <= 7; i++) {
            NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"weibo_%d.json",i] ofType:@""]];
            TLAPIModel *item = [TLAPIModel yy_modelWithJSON:data];
            for (TLModel *model in item.statuses) {
                TLLayout *layout = [[TLLayout alloc] initWithModel:model];
                //                [layout layout];
                [_layouts addObject:layout];
            }
        }
        
        // 复制一下，让列表长一些，不至于滑两下就到底了
        [_layouts addObjectsFromArray:_layouts];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.title = [NSString stringWithFormat:@"Weibo (loaded:%d)", (int)_layouts.count];
            self.navigationController.view.userInteractionEnabled = YES;
            [_tableView reloadData];
        });
    });

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _layouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"cell";
    TLCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[TLCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.delegate = self;
    }
    [cell setLayout:_layouts[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((TLLayout *)_layouts[indexPath.row]).height;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - TLCellDelegate
// 此处应该用 Router 之类的东西。。。这里只是个Demo，直接全跳网页吧～

/// 点击了 Cell
- (void)cellDidClick:(TLCell *)cell {
    
}


/// 点击了转发内容
- (void)cellDidClickRetweet:(TLCell *)cell {
    
}

/// 点击了 Cell 菜单
- (void)cellDidClickMenu:(TLCell *)cell {
    
}

/// 点击了下方 Tag
- (void)cellDidClickTag:(TLCell *)cell {
//    TLTag *tag = cell.statusView.layout.model.tagStruct.firstObject;
//    NSString *url = tag.tagScheme; // sinaweibo://... 会跳到 Weibo.app 的。。
//    YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
//    vc.title = tag.tagName;
//    [self.navigationController pushViewController:vc animated:YES];
}

/// 点击了关注
- (void)cellDidClickFollow:(TLCell *)cell {
    
}

/// 点击了用户
- (void)cell:(TLCell *)cell didClickUser:(TLUser *)user {
//    if (user.userId == 0) return;
//    NSString *url = [NSString stringWithFormat:@"http://m.weibo.cn/u/%lld",user.userID];
//    YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
//    [self.navigationController pushViewController:vc animated:YES];
}

/// 点击了图片
- (void)cell:(TLCell *)cell didClickImageAtIndex:(NSUInteger)index {
//    UIView *fromView = nil;
//    NSMutableArray *items = [NSMutableArray new];
//    TLModel *model = cell.statusView.layout.model;
//    NSArray<TLPicture *> *pics = model.pics;
//    
//    for (NSUInteger i = 0, max = pics.count; i < max; i++) {
//        UIView *imgView = cell.statusView.picViews[i];
//        TLPicture *pic = pics[i];
//        TLPictureMetadata *meta = pic.largest.badgeType == TLPictureBadgeTypeGIF ? pic.largest : pic.large;
//        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
//        item.thumbView = imgView;
//        item.largeImageURL = meta.url;
//        item.largeImageSize = CGSizeMake(meta.width, meta.height);
//        [items addObject:item];
//        if (i == index) {
//            fromView = imgView;
//        }
//    }
//    
//    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
//    [v presentFromImageView:fromView toContainer:self.navigationController.view animated:YES completion:nil];
}

/// 点击了 Label 的链接
- (void)cell:(TLCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange {
//    NSAttributedString *text = label.textLayout.text;
//    if (textRange.location >= text.length) return;
//    YYTextHighlight *highlight = [text attribute:YYTextHighlightAttributeName atIndex:textRange.location];
//    NSDictionary *info = highlight.userInfo;
//    if (info.count == 0) return;
//    
//    if (info[kTLLinkHrefName]) {
//        NSString *url = info[kTLLinkHrefName];
//        YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
//        [self.navigationController pushViewController:vc animated:YES];
//        return;
//    }
//    
//    if (info[kTLLinkURLName]) {
//        TLURL *url = info[kTLLinkURLName];
//        TLPicture *pic = url.pics.firstObject;
//        if (pic) {
//            // 点击了文本中的 "图片链接"
//            YYTextAttachment *attachment = [label.textLayout.text attribute:YYTextAttachmentAttributeName atIndex:textRange.location];
//            if ([attachment.content isKindOfClass:[UIView class]]) {
//                YYPhotoGroupItem *info = [YYPhotoGroupItem new];
//                info.largeImageURL = pic.large.url;
//                info.largeImageSize = CGSizeMake(pic.large.width, pic.large.height);
//                
//                YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:@[info]];
//                [v presentFromImageView:attachment.content toContainer:self.navigationController.view animated:YES completion:nil];
//            }
//            
//        } else if (url.oriURL.length){
//            YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url.oriURL]];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        return;
//    }
//    
//    if (info[kTLLinkTagName]) {
//        TLTag *tag = info[kTLLinkTagName];
//        NSLog(@"tag:%@",tag.tagScheme);
//        return;
//    }
//    
//    if (info[kTLLinkTopicName]) {
//        TLTopic *topic = info[kTLLinkTopicName];
//        NSString *topicStr = topic.topicTitle;
//        topicStr = [topicStr stringByURLEncode];
//        if (topicStr.length) {
//            NSString *url = [NSString stringWithFormat:@"http://m.weibo.cn/k/%@",topicStr];
//            YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        return;
//    }
//    
//    if (info[kTLLinkAtName]) {
//        NSString *name = info[kTLLinkAtName];
//        name = [name stringByURLEncode];
//        if (name.length) {
//            NSString *url = [NSString stringWithFormat:@"http://m.weibo.cn/n/%@",name];
//            YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        return;
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
