//
//  XYDChatEmotionView.m
//  HampooHomeClient
//
//  Created by xiongyoudou on 2016/11/8.
//  Copyright © 2016年 xiongyoudou. All rights reserved.
//

#import "XYDChatEmotionView.h"
#import "XYDChatSwipeView.h"
#import "XYDEmotionPageView.h"
#import "XYDChatHelper.h"
#import "XYDEmotionManager.h"

@interface XYDChatEmotionView ()<UIScrollViewDelegate,XYDChatSwipeViewDelegate,XYDChatSwipeViewDataSource,XYDEmotionPageViewDelegate>

@property (nonatomic, strong) XYDChatSwipeView *swipeView;
@property (strong, nonatomic) UIPageControl *pageControl;

@property (strong, nonatomic) UIView *bottomView;
@property (weak, nonatomic) UIButton *sendButton;

@property (weak, nonatomic) UIButton *recentButton /**< 显示最近表情的button */;
@property (weak, nonatomic) UIButton *emojiButton /**< 显示emoji表情Button */;

@property (assign, nonatomic) NSUInteger columnPerRow; /**< 每行显示的表情数量,6,6plus可能相应多显示  默认emoji5s显示7个 最近表情显示4个  gif表情显示4个 */
@property (assign, nonatomic) NSUInteger maxRows; /**< 每页显示的行数 默认emoji3行  最近表情2行  gif表情2行 */
@property (nonatomic, assign ,readonly) NSUInteger itemsPerPage;
@property (nonatomic, assign) NSUInteger pageCount;

@property (nonatomic, strong) NSMutableArray *faceArray;

@end

@implementation XYDChatEmotionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

#pragma mark - XYDChatSwipeViewDelegate & XYDChatSwipeViewDataSource

- (UIView *)swipeView:(XYDChatSwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    XYDEmotionPageView *facePageView = (XYDEmotionPageView *)view;
    if (!view) {
        facePageView = [[XYDEmotionPageView alloc] initWithFrame:swipeView.frame];
    }
    [facePageView setColumnsPerRow:self.columnPerRow];
    if ((index + 1) * self.itemsPerPage  >= self.faceArray.count) {
        [facePageView setDatas:[self.faceArray subarrayWithRange:NSMakeRange(index * self.itemsPerPage, self.faceArray.count - index * self.itemsPerPage)]];
    } else {
        [facePageView setDatas:[self.faceArray subarrayWithRange:NSMakeRange(index * self.itemsPerPage, self.itemsPerPage)]];
    }
    facePageView.delegate = self;
    return facePageView;
}

- (NSInteger)numberOfItemsInXYDChatSwipeView:(XYDChatSwipeView *)swipeView {
    return self.pageCount ;
}

- (void)swipeViewCurrentItemIndexDidChange:(XYDChatSwipeView *)swipeView {
    self.pageControl.currentPage = swipeView.currentPage;
}

#pragma mark - XYDChatFacePageViewDelegate

- (void)selectedEmotionImageWithEmotionID:(NSUInteger)faceID {
    NSString *faceName = [XYDEmotionManager emotionNameWithEmotionID:faceID];
    if (faceID != 999) {
        [XYDEmotionManager saveRecentEmotion:@{
                                          @"emotion_id" : [NSString stringWithFormat:@"%ld",faceID],
                                          @"emotion_name" : faceName
                                          }
         ];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(emotionViewSendEmotion:)]) {
        [self.delegate emotionViewSendEmotion:faceName];
    }
}

#pragma mark - Private Methods
- (void)setupConstraints {
    //    [super updateConstraints];
    [self.swipeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-40);
        make.top.mas_equalTo(self);
    }];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.mas_equalTo(self);
        make.bottom.mas_equalTo(self.swipeView.mas_bottom);
        make.height.mas_equalTo(10);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.bottom.mas_equalTo(self);
        make.height.mas_equalTo(40);
    }];
}

- (void)setup{
    UIImageView *topLine = [[UIImageView alloc] init];//WithFrame:CGRectMake(0, 0, self.frame.size.width - 70, 1.0f)];
    topLine.backgroundColor = kTopLineBackgroundColor;
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.width.mas_equalTo(self);
        make.height.mas_equalTo(.5f);
    }];
    
    [self addSubview:self.swipeView];
    [self addSubview:self.pageControl];
    [self addSubview:self.bottomView];
    self.faceArray = [NSMutableArray array];
    self.emotionViewType = XYDShowCommonEmotion;
    [self setupFaceView];
    self.userInteractionEnabled = YES;
    [self setupConstraints];
}

- (void)setupFaceView {
    [self.faceArray removeAllObjects];
    if (self.emotionViewType == XYDShowCommonEmotion) {
        [self setupEmojiFaces];
    } else if (self.emotionViewType == XYDShowRecentEmotion){
        [self setupRecentFaces];
    }
    [self.swipeView reloadData];
    
}

/**
 *  初始化最近使用的表情数组
 */
- (void)setupRecentFaces{
    self.maxRows = 2;
    self.columnPerRow = 4;
    self.pageCount = 1;
    [self.faceArray removeAllObjects];
    [self.faceArray addObjectsFromArray:[XYDEmotionManager recentEmotions]];
}

/**
 *  初始化所有的emoji表情数组,添加删除按钮
 */
- (void)setupEmojiFaces{
    CGFloat width = [UIApplication sharedApplication].keyWindow.frame.size.width;
    CGFloat height = [UIApplication sharedApplication].keyWindow.frame.size.height;
    
    self.maxRows =  height > 480 ? 3 : 4;
    self.columnPerRow = width > 320 ? 8 : 7;
    
    //计算每一页最多显示多少个表情  - 1(删除按钮)
    NSInteger pageItemCount = self.itemsPerPage - 1;
    [self.faceArray addObjectsFromArray:[XYDEmotionManager commonEmotions]];
    //获取所有的face表情dict包含face_id,face_name两个key-value
    NSMutableArray *allFaces = [NSMutableArray arrayWithArray:[XYDEmotionManager commonEmotions]];
    
    //计算页数
    self.pageCount = [allFaces count] % pageItemCount == 0 ? [allFaces count] / pageItemCount : ([allFaces count] / pageItemCount) + 1;
    
    //配置pageControl的页数
    self.pageControl.numberOfPages = self.pageCount;
    
    //循环,给每一页末尾加上一个delete图片,如果是最后一页直接在最后一个加上delete图片
    for (int i = 0; i < self.pageCount; i++) {
        if (self.pageCount - 1 == i) {
            [self.faceArray addObject:@{
                                        @"emotion_id" : @"999",
                                        @"emotion_name" : @"删除"
                                        }];
        } else {
            [self.faceArray insertObject:@{
                                           @"emotion_id" : @"999",
                                           @"emotion_name" : @"删除"
                                           }
                                 atIndex:(i + 1) * pageItemCount + i];
        }
    }
}

- (void)sendAction:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(emotionViewSendEmotion:)]) {
        [self.delegate emotionViewSendEmotion:@"发送"];
    }
}

- (void)changeFaceType:(UIButton *)button {
    self.emotionViewType = button.tag;
    [self setupFaceView];
}

#pragma mark - Setters

- (void)setFaceViewType:(XYDShowEmotionViewType)faceViewType {
    if (_emotionViewType != faceViewType) {
        _emotionViewType = faceViewType;
        self.emojiButton.selected = _emotionViewType == XYDShowCommonEmotion;
        self.recentButton.selected = _emotionViewType == XYDShowRecentEmotion;
    }
}

#pragma mark - Getters

- (XYDChatSwipeView *)swipeView {
    if (!_swipeView) {
        _swipeView = [[XYDChatSwipeView alloc] init];
        _swipeView.delegate = self;
        _swipeView.dataSource = self;
    }
    return _swipeView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
        _pageControl.hidesForSinglePage = YES;
    }
    return _pageControl;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];//WithFrame:CGRectMake(0, self.frame.size.height - 40,
        UIImageView *topLine = [[UIImageView alloc] init];//WithFrame:CGRectMake(0, 0, self.frame.size.width - 70, 1.0f)];
        topLine.backgroundColor = kTopLineBackgroundColor;
        [_bottomView addSubview:topLine];
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.mas_equalTo(_bottomView);
            make.height.mas_equalTo(.5f);
            make.width.mas_equalTo(_bottomView).offset(-70);
        }];
        UIButton *sendButton = [[UIButton alloc] init];//WithFrame:CGRectMake(self.frame.size.width - 70, 0, 70, 40)];
        sendButton.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:70.0f/255.0f blue:1.0f alpha:1.0f];
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:self.sendButton = sendButton];
        [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.and.right.mas_equalTo(_bottomView);
            make.left.mas_equalTo(_bottomView.mas_right).offset(-70);
        }];
        UIButton *recentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [recentButton setBackgroundImage:[self imageInBundlePathForImageName:@"chat_bar_recent_normal"] forState:UIControlStateNormal];
        [recentButton setBackgroundImage:[self imageInBundlePathForImageName:@"chat_bar_recent_highlight"] forState:UIControlStateHighlighted];
        [recentButton setBackgroundImage:[self imageInBundlePathForImageName:@"chat_bar_recent_highlight"] forState:UIControlStateSelected];
        recentButton.tag = XYDShowRecentEmotion;
        [recentButton addTarget:self action:@selector(changeFaceType:) forControlEvents:UIControlEventTouchUpInside];
        [recentButton sizeToFit];
        UIButton *emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [emojiButton setBackgroundImage:[self imageInBundlePathForImageName:@"chat_bar_emoji_normal"] forState:UIControlStateNormal];
        [emojiButton setBackgroundImage:[self imageInBundlePathForImageName:@"chat_bar_emoji_highlight"] forState:UIControlStateHighlighted];
        [emojiButton setBackgroundImage:[self imageInBundlePathForImageName:@"chat_bar_emoji_highlight"] forState:UIControlStateSelected];
        emojiButton.tag = XYDShowCommonEmotion;
        [emojiButton addTarget:self action:@selector(changeFaceType:) forControlEvents:UIControlEventTouchUpInside];
        [emojiButton sizeToFit];
        emojiButton.selected = YES;
    }
    return _bottomView;
}

/**
 *  每一页显示的表情数量 = M每行数量*N行
 */
- (NSUInteger)itemsPerPage {
    return self.maxRows * self.columnPerRow;
}

- (UIImage *)imageInBundlePathForImageName:(NSString *)imageName {
    return   ({
        NSBundle *bundle = [XYDChatHelper imageBundle];
        UIImage *image = [[XYDImageManager defaultManager]getImageWithName:imageName inBundle:bundle];
        image;});
}


@end
