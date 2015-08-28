//
//  TXWTagView.m
//  TXWTagView
//
//  Created by develop on 15/8/25.
//  Copyright (c) 2015年 develop. All rights reserved.
//

#import "TXWTagView.h"
#import "UIImage+rotate.h"

@interface TXWTagView()<UIGestureRecognizerDelegate>
@property (strong,nonatomic) UIImageView *tagTypeIV;
@property (strong,nonatomic) UIImageView *tagIV;
@property (strong,nonatomic) UILabel *tagLabel;
@property (strong,nonatomic) id model;
@property (assign,nonatomic) BOOL isEdit;// 编辑状态
@property (assign,nonatomic) CGFloat offsetX;
@property (assign,nonatomic) CGFloat offsetY;

@property (strong, nonatomic) UIView *tagsContainer;

@end
@implementation TXWTagView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInitialize];
    }
    return self;
}

- (void)commonInitialize
{
    // Initialization code
    self.isShowTagPoint = YES;
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.frame];
    self.backgroundImageView.userInteractionEnabled = YES;
    [self addSubview:self.backgroundImageView];
//    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.bottom.equalTo(self);
//    }];
    self.tagsContainer = [[UIView alloc]initWithFrame:self.frame];
    self.tagsContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.clipsToBounds = YES;
    self.tagsContainer.backgroundColor = [UIColor clearColor];
    self.tagsContainer.userInteractionEnabled = YES;
    [self addSubview:self.tagsContainer];
//    [self.tagsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.bottom.equalTo(self);
//    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGroundViewDidTapped:)];
    tap.delegate = self;
    [self.backgroundImageView addGestureRecognizer:tap];
    
    self.disableTagArea = CGRectZero;
}

#pragma mark - Tags Relation Methods

- (void)reloadData
{
    NSAssert(self.dataSource, @"You should set tagView's dataSource!");
    
    //remove old tags
    [self.tagsContainer.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [(UIView *)obj removeFromSuperview];
    }];
    
    NSInteger tagCount = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOftagViewCellsInTagView:)]) {
        tagCount = [self.dataSource numberOftagViewCellsInTagView:self];
    }
    
    if ([self.dataSource respondsToSelector:@selector(tagView:tagViewCellAtIndex:)]) {
        for (NSInteger i = 0; i < tagCount; i ++) {
            UIView<TXWTagViewCellDelegate> *tagViewCell = [self.dataSource tagView:self tagViewCellAtIndex:i];
            tagViewCell.containerCountIndex = i;
//            tagViewCell.adaptViewScale = self.bounds.size.width / 320.0f;
            
            //编辑模式独有事件
            if (self.viewMode == TXWTagViewModeEdit) {
                //长按事件
                UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tagViewCellLongPressed:)];
                [tagViewCell addGestureRecognizer:longPressGesture];
                
                //拖动事件
                UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tagViewCellDidDraged:)];
                [tagViewCell addGestureRecognizer:panGesture];
            }
            
            //点击事件
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagViewCellTapped:)];
            [tagViewCell addGestureRecognizer:tapGesture];
            
            [tagViewCell adjustViewFrameWithGivenPositionPercentage:tagViewCell.centerPointPercentage andContainerSize:self.bounds.size];
            
            //编辑模式独有事件
            if (self.viewMode == TXWTagViewModeEdit) {
                
                //编辑模式下位置有可能改变
                if ([self.delegate respondsToSelector:@selector(tagView:didMovetagViewCell:atIndex:toNewPositonPercentage:)]) {
                    CGPoint itemPosition = tagViewCell.layer.position;
                    CGPoint centerPointPercentage = CGPointMake(itemPosition.x / self.bounds.size.width, itemPosition.y / self.bounds.size.height);
                    [self.delegate tagView:self didMovetagViewCell:tagViewCell atIndex:tagViewCell.containerCountIndex toNewPositonPercentage:centerPointPercentage];
                }
            }
            
            tagViewCell.exclusiveTouch = YES;
            [self.tagsContainer addSubview:tagViewCell];
        }
    }
}

#pragma mark - TagsContainer Show & Hide

- (void)showTagItems
{
    NSAssert(self.viewMode == TXWTagViewModePreview, @"You can only call this method in Preview mode");
    
    if ([self.delegate respondsToSelector:@selector(tagViewCellsWillShowInTagView:)]) {
        [self.delegate tagViewCellsWillShowInTagView:self];
    }
    [UIView animateWithDuration:0.15f animations:^{
        self.tagsContainer.alpha = self.tagsContainer.hidden ? 1: 0;
        self.tagsContainer.hidden = !self.tagsContainer.hidden;
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(tagViewCellsDidShowInTagView:)]) {
            [self.delegate tagViewCellsDidShowInTagView:self];
        }
    }];
}

- (void)hideTagItems
{
    NSAssert(self.viewMode == TXWTagViewModePreview, @"You can only call this method in Preview mode");
    
    if ([self.delegate respondsToSelector:@selector(tagViewCellsWillHideInTagView:)]) {
        [self.delegate tagViewCellsWillHideInTagView:self];
    }
    [UIView animateWithDuration:0.15f animations:^{
        self.tagsContainer.alpha = self.tagsContainer.hidden ? 1: 0;
    } completion:^(BOOL finished) {
        self.tagsContainer.hidden = !self.tagsContainer.hidden;
        if ([self.delegate respondsToSelector:@selector(tagViewCellsDidHideInTagView:)]) {
            [self.delegate tagViewCellsDidHideInTagView:self];
        }
    }];
}

- (void)makeTagItemsAnimated
{
    [self.tagsContainer.subviews enumerateObjectsUsingBlock:^(UIView<TXWTagViewCellDelegate> *item, NSUInteger idx, BOOL *stop) {
        [item runAnimation];
    }];
}

#pragma mark - Gesture CallBack Methods

- (void)backGroundViewDidTapped:(UIGestureRecognizer *)recognizer
{
    if (self.viewMode == TXWTagViewModePreview) {
        [self showTagItems];
    }else {
    
    }
}

- (void)tagViewCellTapped:(UIGestureRecognizer *)gestureRecognizer
{
    UIView<TXWTagViewCellDelegate> *tagViewCell = (UIView<TXWTagViewCellDelegate> *)gestureRecognizer.view;
    if ([self.delegate respondsToSelector:@selector(tagView:didTappedtagViewCell:atIndex:)]) {
        [self.delegate tagView:self didTappedtagViewCell:tagViewCell atIndex:tagViewCell.containerCountIndex];
    }
}

- (void)tagViewCellLongPressed:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView<TXWTagViewCellDelegate> *tagViewCell = (UIView<TXWTagViewCellDelegate> *)gestureRecognizer.view;
        if ([self.delegate respondsToSelector:@selector(tagView:didLongPressedtagViewCell:atIndex:)]) {
            [self.delegate tagView:self didLongPressedtagViewCell:tagViewCell atIndex:tagViewCell.containerCountIndex];
        }
    }
}

- (void)tagViewCellDidDraged:(UIGestureRecognizer *)gestureRecognizer
{

    UIView<TXWTagViewCellDelegate> *tagViewCell = (UIView<TXWTagViewCellDelegate> *)gestureRecognizer.view;
    CGPoint centerPoint = [gestureRecognizer locationInView:self.tagsContainer];
    
    
    CGRect containerBounds = self.tagsContainer.bounds;
    
    void (^reportDelegateSavePosition)() = ^ {
        if ([self.delegate respondsToSelector:@selector(tagView:didMovetagViewCell:atIndex:toNewPositonPercentage:)]) {
            
            CGPoint itemPosition = tagViewCell.layer.position;
            CGPoint centerPointPercentage = CGPointMake((itemPosition.x) / self.bounds.size.width, (itemPosition.y ) / self.bounds.size.height);
            [self.delegate tagView:self didMovetagViewCell:tagViewCell atIndex:tagViewCell.containerCountIndex toNewPositonPercentage:centerPointPercentage];
        }
    };
    
    //判断不可放置tag区域
    if (CGRectContainsPoint(self.disableTagArea, centerPoint)) {
        reportDelegateSavePosition();
        return;
    }
    
    //判断纵向是否超出边界
    CGFloat tagViewTopHeight = tagViewCell.bounds.size.height * tagViewCell.layer.anchorPoint.y;
    CGFloat tagViewBottomHeight = tagViewCell.bounds.size.height - tagViewTopHeight;
    if (centerPoint.y - tagViewTopHeight < containerBounds.origin.y || centerPoint.y + tagViewBottomHeight > containerBounds.origin.y + containerBounds.size.height) {
        reportDelegateSavePosition();
        return;
    }
    
    //判断横向是否超出边界
    CGFloat tagViewLeftWidth = tagViewCell.bounds.size.width * tagViewCell.layer.anchorPoint.x;
    CGFloat tagViewRightWidth = tagViewCell.bounds.size.width - tagViewLeftWidth;
    
    if (tagViewCell.tagViewCellDirection == TXWTagViewCellDirectionLeft) {
        if (centerPoint.x - tagViewLeftWidth < containerBounds.origin.x || centerPoint.x + tagViewRightWidth > containerBounds.origin.x + containerBounds.size.width) {
            if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
                if ([tagViewCell checkCanReversetagViewCellDirectionWithContainerSize:self.bounds.size])
                {
                    [tagViewCell reversetagViewCellDirection];
                    if ([self.delegate respondsToSelector:@selector(tagView:tagViewCell:didChangedDirection:AtIndex:)]) {
                        [self.delegate tagView:self tagViewCell:tagViewCell didChangedDirection:tagViewCell.tagViewCellDirection AtIndex:tagViewCell.containerCountIndex];
                    }
                }
            }
            reportDelegateSavePosition();
            return;
        }
    } else {
        if (centerPoint.x - tagViewLeftWidth < containerBounds.origin.x || centerPoint.x + tagViewRightWidth > containerBounds.origin.x + containerBounds.size.width) {
            if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
                if ([tagViewCell checkCanReversetagViewCellDirectionWithContainerSize:self.bounds.size])
                {
                    [tagViewCell reversetagViewCellDirection];
                    if ([self.delegate respondsToSelector:@selector(tagView:tagViewCell:didChangedDirection:AtIndex:)]) {
                        [self.delegate tagView:self tagViewCell:tagViewCell didChangedDirection:tagViewCell.tagViewCellDirection AtIndex:tagViewCell.containerCountIndex];
                    }
                }
            }
            reportDelegateSavePosition();
            return;
        }
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        reportDelegateSavePosition();
    }
    
    [tagViewCell setNeedsLayout];
    [tagViewCell setNeedsUpdateConstraints];

}

#pragma mark - UIGestureRecognize Delegate Methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (self.backgroundImageView == touch.view) {
        return YES;
    }
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSLog(@"touchesBegan %@",NSStringFromClass([touch.view class]));
    
    CGPoint point = [touch locationInView:touch.view];
    self.tagPoint = point;
    if(!CGRectContainsPoint(self.frame, point)){return;}// 点不在区域内，return
    // self.tagPoint = point;
    
    if (touch.view == self.tagsContainer) {
        if (self.viewMode == TXWTagViewModePreview) {
            [self hideTagItems];
        } else if (self.viewMode == TXWTagViewModeEdit) {
            if ([self.delegate respondsToSelector:@selector(tagView:addNewtagViewCellTappedAtPosition:)]) {
                CGPoint position = [touch locationInView:self.tagsContainer];
                if (!CGRectContainsPoint(self.disableTagArea, position)) {
                    [self.delegate tagView:self addNewtagViewCellTappedAtPosition:position];
                }
            }
            if (self.isShowTagPoint) {
                CGRect frame = self.pointIV.frame;
                frame.origin = CGPointMake(point.x-17/2, point.y-17/2);
                self.pointIV.frame = frame;
                self.pointIV.hidden = NO;
                
            }else{
                
                self.pointIV.hidden = YES;
            }
            self.isShowTagPoint = !self.isShowTagPoint;
        }
    }else if ([touch.view conformsToProtocol:@protocol(TXWTagViewCellDelegate)]){
    }else{
        if ([self.delegate respondsToSelector:@selector(tagView:addNewtagViewCellTappedAtPosition:)]) {
            CGPoint position = [touch locationInView:self.tagsContainer];
            if (!CGRectContainsPoint(self.disableTagArea, position)) {
                [self.delegate tagView:self addNewtagViewCellTappedAtPosition:position];
            }
        }
        if (self.isShowTagPoint) {
            CGRect frame = self.pointIV.frame;
            frame.origin = CGPointMake(point.x-17/2, point.y-17/2);
            self.pointIV.frame = frame;
            self.pointIV.hidden = NO;
            
        }else{
            
            self.pointIV.hidden = YES;
        }
        self.isShowTagPoint = !self.isShowTagPoint;
    }
    
}

#pragma mark - setter
- (UIImageView *)pointIV
{
    
    if (!_pointIV) {
        _pointIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"KK_Filter_hover"]];
        _pointIV.frame= CGRectMake(0, 0, 17, 17);
        [self addSubview:_pointIV];
    }
    return _pointIV;
}

@end

