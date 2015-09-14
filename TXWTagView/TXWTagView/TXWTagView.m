//
//  TXWTagView.m
//  TXWTagView
//
//  Created by develop on 15/8/25.
//  Copyright (c) 2015年 develop. All rights reserved.
//

#import "TXWTagView.h"
#import "TXWTagPopView.h"

#define TAG_TYPE_WIDTH 12
#define TAG_POINT_IMAGEVIEW_W_H 17
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width

// popview animal
#define BUTTON_HEIGHT 60
#define BUTTON_WIDTH 60
#define MARGIN_BUTTON 50

@interface TXWTagView()<UIGestureRecognizerDelegate,TXWTagPopViewDelegate>
@property (strong,nonatomic) UIImageView *tagTypeIV;
@property (strong,nonatomic) UIImageView *tagIV;
@property (strong,nonatomic) UILabel *tagLabel;
@property (strong,nonatomic) id model;
@property (assign,nonatomic) BOOL isEdit;// 编辑状态
@property (assign,nonatomic) CGFloat offsetX;
@property (assign,nonatomic) CGFloat offsetY;

@property (strong, nonatomic) UIView *tagsContainer;
// 201509130615
@property (nonatomic, assign) CGRect superFrame;// 保存父frame
@property (nonatomic, assign) CGPoint popViewPoint;//popView的point
@property (strong,nonatomic) TXWTagPopView *tagPopView;
@end
@implementation TXWTagView

- (instancetype)initWithFrame:(CGRect)frame
{
    CGRect superFrame = frame;
    superFrame.origin.x = 0;
    superFrame.origin.y = 0;
    self.superFrame = superFrame;
    self = [super initWithFrame:superFrame];
    if (self) {
        [self commonInitialize];
    }
    return self;
}

// 不规则图片
- (instancetype)initWithImageFrame:(CGRect)frame offsexY:(CGFloat)offsetY
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        CGFloat ImageAspectRatio = frame.size.width/frame.size.height;
//        CGRect frame = CGRectMake(0, offsetY, kScreenWidth, kScreenWidth);
//        if (ImageAspectRatio == kTagViewAspectRatio) {
//            
//            frame.size.width = kScreenWidth;
//            frame.size.height = kScreenWidth/ImageAspectRatio;
//            
//        }else if (ImageAspectRatio > kTagViewAspectRatio){
//            frame.origin.x = 0;
//            frame.origin.y += (kScreenWidth/kTagViewAspectRatio - kScreenWidth/ImageAspectRatio)/2;
//            frame.size.width = kScreenWidth;
//            frame.size.height = kScreenWidth/ImageAspectRatio;
//        }else{
//            frame.origin.x += (kScreenWidth-(kScreenWidth/kTagViewAspectRatio*ImageAspectRatio))/2;
//            frame.size.height = kScreenWidth/kTagViewAspectRatio;
//            frame.size.width = kScreenWidth/kTagViewAspectRatio*ImageAspectRatio;
//        }
//        self.frame = frame;
//        
//        [self commonInitialize];
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
    NSLog(@"tagView.bounds = %@",NSStringFromCGRect(self.bounds));
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];// 不能用frame
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.backgroundImageView.userInteractionEnabled = YES;
    [self addSubview:self.backgroundImageView];

    self.tagsContainer = [[UIView alloc]initWithFrame:self.bounds];// 不能用frame
    self.tagsContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.clipsToBounds = YES;
    self.tagsContainer.backgroundColor = [UIColor clearColor];
    self.tagsContainer.userInteractionEnabled = YES;
    [self addSubview:self.tagsContainer];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGroundViewDidTapped:)];
    tap.delegate = self;
    [self.backgroundImageView addGestureRecognizer:tap];
    
    self.disableTagArea = CGRectMake(0, 0, 0, 0);
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
            
            // 编辑模式独有事件
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

                    CGPoint centerPointPercentage;
                    if (tagViewCell.tagViewCellDirection == TXWTagViewCellDirectionLeft) {
                        centerPointPercentage = CGPointMake((itemPosition.x+tagViewCell.tagWidth/2-TAG_TYPE_WIDTH/2)/self.bounds.size.width, itemPosition.y / self.bounds.size.height);
                    }else{
                        centerPointPercentage = CGPointMake((itemPosition.x-tagViewCell.tagWidth/2+TAG_TYPE_WIDTH/2)/self.bounds.size.width, itemPosition.y / self.bounds.size.height);
                    }

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
            
            CGPoint itemPosition = tagViewCell.layer.position; // center
            CGPoint centerPointPercentage;// center转换成鼠标点击的点
            if (tagViewCell.tagViewCellDirection == TXWTagViewCellDirectionLeft) {
                centerPointPercentage = CGPointMake((itemPosition.x+tagViewCell.tagWidth/2-TAG_TYPE_WIDTH/2)/self.bounds.size.width, itemPosition.y / self.bounds.size.height);
            }else{
                centerPointPercentage = CGPointMake((itemPosition.x-tagViewCell.tagWidth/2+TAG_TYPE_WIDTH/2)/self.bounds.size.width, itemPosition.y / self.bounds.size.height);
            }

            [self.delegate tagView:self didMovetagViewCell:tagViewCell atIndex:tagViewCell.containerCountIndex toNewPositonPercentage:centerPointPercentage];
        }
    };

    // 判断不可放置tag区域
    if (CGRectContainsPoint(self.disableTagArea, centerPoint)) {
        reportDelegateSavePosition();
        return;
    }
    
    // 判断纵向是否超出边界
    CGFloat tagViewTopHeight = tagViewCell.bounds.size.height * tagViewCell.layer.anchorPoint.y;
    CGFloat tagViewBottomHeight = tagViewCell.bounds.size.height - tagViewTopHeight;
    if (centerPoint.y - self.offsetY - tagViewTopHeight < containerBounds.origin.y) {
        centerPoint.y = containerBounds.origin.y + self.offsetY + tagViewTopHeight;
        reportDelegateSavePosition();
        return;
    }
    if (centerPoint.y - self.offsetY + tagViewBottomHeight > containerBounds.origin.y + containerBounds.size.height) {
        centerPoint.y  = containerBounds.origin.y + containerBounds.size.height + self.offsetY - tagViewBottomHeight;
        reportDelegateSavePosition();
        return;
    }
    
    // 判断横向是否超出边界
    CGFloat tagViewLeftWidth = tagViewCell.bounds.size.width * tagViewCell.layer.anchorPoint.x;
    CGFloat tagViewRightWidth = tagViewCell.bounds.size.width - tagViewLeftWidth;
    
    if (tagViewCell.tagViewCellDirection == TXWTagViewCellDirectionLeft) {
//        centerPoint.x -= tagViewCell.bounds.size.width / 2;
//        if (centerPoint.x-self.offsetX - tagViewLeftWidth < containerBounds.origin.x || centerPoint.x-self.offsetX + tagViewRightWidth > containerBounds.origin.x + containerBounds.size.width) {
//            if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
//                if ([tagViewCell checkCanReversetagViewCellDirectionWithContainerSize:self.bounds.size])
//                {
//                    [tagViewCell reversetagViewCellDirection];
//                    if ([self.delegate respondsToSelector:@selector(tagView:tagViewCell:didChangedDirection:AtIndex:)]) {
//                        [self.delegate tagView:self tagViewCell:tagViewCell didChangedDirection:tagViewCell.tagViewCellDirection AtIndex:tagViewCell.containerCountIndex];
//                    }
//                }
//            }
//            reportDelegateSavePosition();
//            return;
//        }
        if (centerPoint.x-self.offsetX + tagViewRightWidth > containerBounds.origin.x + containerBounds.size.width) {

            centerPoint.x = containerBounds.origin.x + containerBounds.size.width + self.offsetX - tagViewRightWidth;
            reportDelegateSavePosition();
            return;
        }
        if (centerPoint.x-self.offsetX - tagViewLeftWidth < containerBounds.origin.x ) {
            
            centerPoint.x = tagViewLeftWidth + containerBounds.origin.x + self.offsetX;
            reportDelegateSavePosition();
            return;
        }
        [tagViewCell setCenter:CGPointMake(centerPoint.x-self.offsetX, centerPoint.y-self.offsetY)];
    } else {
//        centerPoint.x += tagViewCell.bounds.size.width / 2;// 偏移量一直不对，因为这个
//        if (centerPoint.x - tagViewLeftWidth < containerBounds.origin.x || centerPoint.x + tagViewRightWidth > containerBounds.origin.x + containerBounds.size.width) {
//            if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
//                if ([tagViewCell checkCanReversetagViewCellDirectionWithContainerSize:self.bounds.size])
//                {
//                    [tagViewCell reversetagViewCellDirection];
//                    if ([self.delegate respondsToSelector:@selector(tagView:tagViewCell:didChangedDirection:AtIndex:)]) {
//                        [self.delegate tagView:self tagViewCell:tagViewCell didChangedDirection:tagViewCell.tagViewCellDirection AtIndex:tagViewCell.containerCountIndex];
//                    }
//                }
//            }
//            reportDelegateSavePosition();
//            return;
//        }
        if (centerPoint.x - self.offsetX - tagViewLeftWidth < containerBounds.origin.x) {

            centerPoint.x = containerBounds.origin.x + tagViewLeftWidth + self.offsetX;
            reportDelegateSavePosition();
            return;
        }
        if (centerPoint.x - self.offsetX + tagViewRightWidth > containerBounds.origin.x + containerBounds.size.width) {

            centerPoint.x = containerBounds.origin.x + containerBounds.size.width + self.offsetX - tagViewRightWidth;
            reportDelegateSavePosition();
            return;
        }
        [tagViewCell setCenter:CGPointMake(centerPoint.x-self.offsetX, centerPoint.y-self.offsetY)];
    }

    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        reportDelegateSavePosition();
    }
    
    [tagViewCell setNeedsLayout];
    
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
    NSLog(@"touchesBegan %@ " ,NSStringFromClass([touch.view class]));
    
    CGPoint point = [touch locationInView:touch.view];
    self.tagPoint = point;
    if(!CGRectContainsPoint(self.bounds, point)){
        return; // self.frame bug
    }// 点不在区域内，return
    
    if (touch.view == self.tagsContainer) {
        if (self.viewMode == TXWTagViewModePreview) {
            [self hideTagItems];
        } else if (self.viewMode == TXWTagViewModeEdit) {
            
            CGPoint position = [touch locationInView:self.tagsContainer];
            if (CGRectContainsPoint(self.disableTagArea, position)) {
                return;
            }

            if ([self.delegate respondsToSelector:@selector(tagView:addNewtagViewCellTappedAtPosition:)]) {
                
                [self.delegate tagView:self addNewtagViewCellTappedAtPosition:position];
            }
            if (self.isShowTagPoint) {
                CGRect frame = self.pointIV.frame;
                frame.origin = CGPointMake(point.x-TAG_POINT_IMAGEVIEW_W_H/2, point.y-TAG_POINT_IMAGEVIEW_W_H/2);
                self.pointIV.frame = frame;
                self.pointIV.hidden = NO;
                [self showTagPopView];
            }else{

                self.pointIV.hidden = YES;
            }
            self.isShowTagPoint = !self.isShowTagPoint;
        }
    }else if ([touch.view conformsToProtocol:@protocol(TXWTagViewCellDelegate)]){
        if (self.viewMode == TXWTagViewModeEdit) {
            CGRect tagViewCellFrame = touch.view.frame;// 计算偏移量。手势坐标和center坐标偏差计算，拖动的时候修正
            self.offsetX = point.x-tagViewCellFrame.size.width/2;
            self.offsetY = point.y-tagViewCellFrame.size.height/2;
        }else{
            // 点击cell method
        }
        

    }else{
        if (self.viewMode == TXWTagViewModeEdit) {
            if ([self.delegate respondsToSelector:@selector(tagView:addNewtagViewCellTappedAtPosition:)]) {
                CGPoint position = [touch locationInView:self.tagsContainer];
                if (!CGRectContainsPoint(self.disableTagArea, position)) {
                    [self.delegate tagView:self addNewtagViewCellTappedAtPosition:position];
                }
            }
            if (self.isShowTagPoint) {
                CGRect frame = self.pointIV.frame;
                frame.origin = CGPointMake(point.x-TAG_POINT_IMAGEVIEW_W_H/2, point.y-TAG_POINT_IMAGEVIEW_W_H/2);
                self.pointIV.frame = frame;
                self.pointIV.hidden = NO;
                [self showTagPopView];
            }else{

                self.pointIV.hidden = YES;
            }
            self.isShowTagPoint = !self.isShowTagPoint;
        }else {
        
        }
        
    }
    
}

#pragma mark - TXWTagPopViewDelegate
- (void)showTagPopView
{
    _tagPopView.hidden = NO;
    if (!_tagPopView) {
        CGRect frame;
        frame.size = self.superFrame.size;
        frame.origin = _popViewPoint;
        _tagPopView = [[TXWTagPopView alloc]initWithFrame:frame superView:self];
        _tagPopView.center = self.center;
        
        CGRect locationButtonFrame = _tagPopView.locationButton.frame;
        locationButtonFrame.origin.y = _popViewPoint.y;
        _tagPopView.locationButton.frame = locationButtonFrame;
        CGRect textButtonFrame = _tagPopView.textButton.frame;
        textButtonFrame.origin.y = _popViewPoint.y;
        _tagPopView.textButton.frame = textButtonFrame;
    }
    _tagPopView.alpha = 1;
    _tagPopView.delegate = self;
    [self addSubview:_tagPopView];
    
    _tagPopView.locationButton.alpha = 0;
    [UIView animateWithDuration:0.25f animations:^{
        CGRect locationButtonFrame = _tagPopView.locationButton.frame;
        locationButtonFrame.origin.y = (self.frame.size.height-BUTTON_WIDTH)/2;
        _tagPopView.locationButton.frame = locationButtonFrame;
        _tagPopView.locationButton.alpha = 1;
    }];
    
    _tagPopView.textButton.alpha = 0;
    [UIView animateWithDuration:0.10f animations:^{
        CGRect textButtonFrame = _tagPopView.textButton.frame;
        textButtonFrame.origin.y = (self.frame.size.height-BUTTON_WIDTH)/2;
        _tagPopView.textButton.frame = textButtonFrame;
        _tagPopView.textButton.alpha = 1;
    }];

}

- (void)dismissTagPopView
{
    if (_tagPopView) {
        _tagPopView.locationButton.alpha = 1;
        [UIView animateWithDuration:0.10f animations:^{
            CGRect frame1 = _tagPopView.locationButton.frame;
            frame1.origin.y = _popViewPoint.y;
            _tagPopView.locationButton.frame = frame1;
            _tagPopView.locationButton.alpha = 0;
        }];
        
        _tagPopView.textButton.alpha = 1;
        [UIView animateWithDuration:0.35f animations:^{
            CGRect frame = _tagPopView.textButton.frame;
            frame.origin.y = _popViewPoint.y;
            _tagPopView.textButton.frame = frame;
            _tagPopView.textButton.alpha = 0;
            _tagPopView.hidden = YES;
        }];
        
//        [UIView animateWithDuration:0.1 delay:0.35 options:UIViewAnimationOptionTransitionNone animations:^{
//            
//        } completion:^(BOOL finished) {
//            _tagPopView.hidden = YES;
//        }];
    }
}

- (void)didTextTagViewClicked
{
    [self dismissTagPopView];
    self.isShowTagPoint = YES;
    self.pointIV.hidden = YES;
    if (_delegate!=nil && [_delegate respondsToSelector:@selector(didTextTagViewClickedType:)]) {
        [_delegate didTextTagViewClickedType:[NSNumber numberWithInt:0]];
    }
}

- (void)didPeopleTagViewClicked
{
    [self dismissTagPopView];
    self.isShowTagPoint = YES;
    self.pointIV.hidden = YES;
    if (_delegate!=nil && [_delegate respondsToSelector:@selector(didPeopleTagViewClickedType:)]) {
        [_delegate didPeopleTagViewClickedType:[NSNumber numberWithInt:1]];
    }
}

- (void)tapTagPopView
{
    [self dismissTagPopView];
    self.isShowTagPoint = YES;
    self.pointIV.hidden = YES;
}

#pragma mark - setter、getter
- (UIImageView *)pointIV
{
    if (!_pointIV) {
        _pointIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"KK_Filter_hover"]];
        _pointIV.frame= CGRectMake(0, 0, TAG_POINT_IMAGEVIEW_W_H, TAG_POINT_IMAGEVIEW_W_H);
        [self addSubview:_pointIV];
    }
    return _pointIV;
}

- (void)setBackImage:(UIImage *)backImage
{
    _backImage = backImage;
    
    CGFloat TagViewAspectRatio = self.superFrame.size.width/self.superFrame.size.height;
    CGFloat ImageAspectRatio = backImage.size.width/backImage.size.height;
    CGFloat kWidth = self.superFrame.size.width;
    CGRect frame = self.superFrame;
    if (ImageAspectRatio == TagViewAspectRatio) {
        
        frame.size.width = kWidth;
        frame.size.height = kWidth/ImageAspectRatio;
        _popViewPoint = frame.origin;
        
    }else if (ImageAspectRatio > TagViewAspectRatio){

        frame.origin.y += (kWidth/TagViewAspectRatio - kWidth/ImageAspectRatio)/2;
        frame.size.width = kWidth;
        frame.size.height = kWidth/ImageAspectRatio;
        
        _popViewPoint.x = frame.origin.x;
        _popViewPoint.y = -frame.origin.y;
    }else{
        frame.origin.x += (kWidth-(kWidth/TagViewAspectRatio*ImageAspectRatio))/2;
        frame.size.height = kWidth/TagViewAspectRatio;
        frame.size.width = kWidth/TagViewAspectRatio*ImageAspectRatio;
        
        _popViewPoint.x = -frame.origin.x;
        _popViewPoint.y = frame.origin.y;
    }
    [self setFrame:frame];
    [self commonInitialize];
    self.backgroundImageView.image = backImage;
}
@end

