//
//  TXWTagView.h
//  TXWTagView
//
//  Created by develop on 15/8/25.
//  Copyright (c) 2015年 develop. All rights reserved.
//

#import <UIKit/UIKit.h>


/*
 1.20汉字40字符
 2.最多5个标签
 3.根据点的位置，右边能显示不完。就左边。都显示不完就省略号
 4.移动不能出图片
 5.如果另一个方向width小于当前label width，不能翻转
 */
#pragma mark - typedef
typedef NS_ENUM(NSInteger, TXWTagViewMode) {
    TXWTagViewModeEdit = 0, // 编辑：移动，删除，改变方向
    TXWTagViewModePreview = 1,// 预览：点击跳转，标签查找。。
};

typedef NS_ENUM(NSInteger, TXWTagViewCellDirection) {
    TXWTagViewCellDirectionLeft = 0,
    TXWTagViewCellDirectionRight = 1,
};

#pragma mark - TXWTagViewCellDelegate
// TagView上的tag视图需要实现的方法
@protocol TXWTagViewCellDelegate <NSObject>

//锚点所在位置的百分比

@property (assign, nonatomic) CGPoint centerPointPercentage;
@property (assign, nonatomic, readonly) CGSize tagSize;
@property (assign, nonatomic, readonly) CGFloat tagWidth;
@property (assign, nonatomic, readonly) CGFloat tagHeight;
@property (assign, nonatomic) TXWTagViewCellDirection tagViewCellDirection;
@property (assign, nonatomic) NSInteger containerCountIndex;// 计数
// alvin 20150913 解放 model
@property (nonatomic ,strong) NSString *tagText;
@property (nonatomic ,strong) NSNumber *tagType;
@property (nonatomic ,strong) NSString *dataKey;
@property (nonatomic ,strong) NSString *tagId;



/**
 *  根据指定的x，y百分比值，以及给定容器的size，计算tag的显示位置，这里设置layer.position即可，这里要保证view的frame已经存在，并且layer.anchorPoint已经被正确设置。PS:方法中应该实现，如果指定的位置放不下tag的处理方案，转向还是移动。
 *
 *  @param pointPercentage x,y坐标的百分比
 *  @param size            容器的size
 */
- (void)adjustViewFrameWithGivenPositionPercentage:(CGPoint)pointPercentage andContainerSize:(CGSize)size;
// 是否可以转向
- (BOOL)checkCanReversetagViewCellDirectionWithContainerSize:(CGSize)size;

//反转tag方向
- (void)reversetagViewCellDirection;
@optional
/**
 *  播放tag动画
 */
- (void)runAnimation;

@end

#pragma mark - TXWTagViewDataSource
@class TXWTagView;
@protocol TXWTagViewDataSource <NSObject>

- (NSInteger)numberOftagViewCellsInTagView:(TXWTagView *)tagView;
- (UIView<TXWTagViewCellDelegate> *)tagView:(TXWTagView *)tagView tagViewCellAtIndex:(NSInteger)index;

@end

#pragma mark - TXWTagViewDelegate
@protocol TXWTagViewDelegate <NSObject>

@optional
- (void)tagView:(TXWTagView *)tagView didTappedtagViewCell:(UIView<TXWTagViewCellDelegate> *)tagViewCell atIndex:(NSInteger)index;

//editMode
- (void)tagView:(TXWTagView *)tagView tagViewCell:(UIView<TXWTagViewCellDelegate> *)tagViewCell didChangedDirection:(TXWTagViewCellDirection)tagViewCellDirection AtIndex:(NSInteger)index;
- (void)tagView:(TXWTagView *)tagView didLongPressedtagViewCell:(UIView<TXWTagViewCellDelegate> *)tagViewCell atIndex:(NSInteger)index;
- (void)tagView:(TXWTagView *)tagView didMovetagViewCell:(UIView<TXWTagViewCellDelegate> *)tagViewCell atIndex:(NSInteger)index toNewPositonPercentage:(CGPoint)pointPercentage;
- (void)tagView:(TXWTagView *)tagView addNewtagViewCellTappedAtPosition:(CGPoint)ponit;

- (void)tagViewCellsWillShowInTagView:(TXWTagView *)tagView;
- (void)tagViewCellsDidShowInTagView:(TXWTagView *)tagView;
- (void)tagViewCellsWillHideInTagView:(TXWTagView *)tagView;
- (void)tagViewCellsDidHideInTagView:(TXWTagView *)tagView;

- (void)didTextTagViewClickedType:(NSNumber *)tagType;
- (void)didLocationTagViewClickedType:(NSNumber *)tagType;
- (void)didPeopleTagViewClickedType:(NSNumber *)tagType;
- (void)tapTagPopView;

@end

#pragma mark - TXWTagView

@interface TXWTagView : UIView
@property (strong, nonatomic) UIImageView *backgroundImageView;

// 更换了模式，必须调用reloadData才能生效
@property (assign, nonatomic) IBInspectable NSInteger viewMode;
@property (assign,nonatomic) BOOL isShowTagPoint;// 点击那里显示点
@property (strong,nonatomic) UIImageView *pointIV;// 点击标示的点图
@property (assign,nonatomic) CGPoint tagPoint;// tag位置
@property (weak, nonatomic)  id<TXWTagViewDataSource> dataSource;
@property (weak, nonatomic)  id<TXWTagViewDelegate> delegate;
@property (nonatomic, strong) UIImage *backImage;// setter 方法，设置frame

/**
 *  编辑模式，不允许打tag的区域，这里只是表示tagViewItem的锚点不能进入的区域，并不表示整个tagViewCell不能进入的区域。默认为CGRectZero.
 */
@property (assign, nonatomic) CGRect disableTagArea;

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithImageFrame:(CGRect)frame offsexY:(CGFloat)offsetY;
- (instancetype)initWithFrame:(CGRect)frame Image:(UIImage *)image;
// 会废弃以前的tagViewCell,从dataSouse重新获取
- (void)reloadData;

//非编辑模式下启用
- (void)hideTagItems;// 隐藏
- (void)showTagItems;// 显示
/**
 *  播放动画
 */
- (void)makeTagItemsAnimated;


@end
