//
//  TXWTagView.m
//  TXWTagView
//
//  Created by develop on 15/8/25.
//  Copyright (c) 2015年 develop. All rights reserved.
//

#import "TXWTagView.h"
#import "UIImage+rotate.h"

#define TAGBG_LABEL_PAD 5
#define TYPEICON_TAGBG 8
#define TAG_TYPE_WIDTH 11
#define TAG_BG_WIDTH 26

#define TAGLABEL_LEFT_X 3
#define TAGLABEL_RIGHT_X 10
@interface TXWTagView()<UIGestureRecognizerDelegate>
@property (strong,nonatomic) UIImageView *tagTypeIV;
@property (strong,nonatomic) UIImageView *tagIV;
@property (strong,nonatomic) UILabel *tagLabel;
@property (strong,nonatomic) id model;
@property (assign,nonatomic) BOOL isEdit;// 编辑状态

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
            CGPoint centerPointPercentage = CGPointMake(itemPosition.x / self.bounds.size.width, itemPosition.y / self.bounds.size.height);
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
        centerPoint.x -= tagViewCell.bounds.size.width / 2;
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
        [tagViewCell setCenter:CGPointMake(centerPoint.x, centerPoint.y)];
    } else {
        centerPoint.x += tagViewCell.bounds.size.width / 2;
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
        [tagViewCell setCenter:CGPointMake(centerPoint.x, centerPoint.y)];
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
    if(!CGRectContainsPoint(self.frame, point)){return;}// 点不在区域内，return
    // self.tagPoint = point;
    
    if (self.isShowTagPoint) {
        CGRect frame = self.pointIV.frame;
        frame.origin = CGPointMake(point.x-17/2, point.y-17/2);
        self.pointIV.frame = frame;
        self.pointIV.hidden = NO;
        
    }else{
        
        self.pointIV.hidden = YES;
    }
    self.isShowTagPoint = !self.isShowTagPoint;
    
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
        }
    }else{
        
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






/*




- (instancetype)initWithModel:(id)model frame:(CGRect)frame isEditState:(BOOL)isEdit
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.model = model;
        self.isEdit = isEdit;
        if ([model isKindOfClass:[TXWTextTagModel class]]) {
            [self initByModel:model frame:frame];
        }
    }
    
    return self;
}

- (void)initByModel:(TXWTextTagModel *)model frame:(CGRect)frame
{
    // 类型icon
    CGPoint point = CGPointMake(frame.size.width*model.posX, frame.size.height*model.posY);
    self.tagTypeIV.image = [UIImage imageNamed:@"big_biaoqian_dian"];
    CGRect frame1 = self.tagTypeIV.frame;
    frame1.origin = CGPointMake(point.x-self.tagTypeIV.frame.size.width/2, point.y-self.tagTypeIV.frame.size.width/2);
    self.tagTypeIV.frame = frame1;
    [self addSubview:self.tagTypeIV];
    
    // 标签背景
    
    // 方向
    CGRect frame2 = self.tagIV.frame;
    CGRect frameLabel = self.tagLabel.frame;
    
    if (model.direction) {// right
        UIImage *image = [UIImage imageNamed:@"KK_Filter_btn_black"];
        UIEdgeInsets insets = UIEdgeInsetsMake(4, 12, 4, 5);
        
        
        frame2.origin = CGPointMake(point.x+TYPEICON_TAGBG, point.y-TAG_BG_WIDTH/2);
        CGFloat textWidth = [self widthByStr:model.text]+TAGBG_LABEL_PAD+TAGBG_LABEL_PAD;
        CGFloat residueWidth = CGRectGetMaxX(frame)-point.x-TYPEICON_TAGBG;
        if (textWidth>=residueWidth) {
            frame2.size.width = residueWidth;
            frameLabel.size.width = residueWidth - TAGBG_LABEL_PAD - TAGBG_LABEL_PAD;
        }else{
            frame2.size.width = textWidth;
            frameLabel.size.width = textWidth - TAGBG_LABEL_PAD - TAGBG_LABEL_PAD;
        }
        frameLabel.origin.x = TAGLABEL_RIGHT_X;
        self.tagIV.image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    }else{
        UIImage *image = [UIImage imageNamed:@"KK_Filter_btn_black_left"];
        UIEdgeInsets insets = UIEdgeInsetsMake(4, 5, 4, 12);
        
        CGFloat textWidth = [self widthByStr:model.text]+TAGBG_LABEL_PAD+TAGBG_LABEL_PAD;
        CGFloat residueWidth = point.x-TYPEICON_TAGBG;
        
        if (textWidth>=residueWidth) {
            frame2.size.width = residueWidth;
            frame2.origin = CGPointMake(0, point.y-TAG_BG_WIDTH/2);
            frameLabel.size.width = residueWidth - TAGBG_LABEL_PAD - TAGBG_LABEL_PAD;
        }else{
            frame2.size.width = textWidth;
            frame2.origin = CGPointMake(point.x-textWidth-TYPEICON_TAGBG, point.y-TAG_BG_WIDTH/2);
            frameLabel.size.width = textWidth - TAGBG_LABEL_PAD - TAGBG_LABEL_PAD;
        }
        frameLabel.origin.x = TAGLABEL_LEFT_X;
        UIImage *imageStretch = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        self.tagIV.image = imageStretch;
    }
    
    self.tagIV.frame = frame2;
    self.tagLabel.frame = frameLabel;
    
    // label
    self.tagLabel.text = model.text;
    [self.tagIV addSubview:self.tagLabel];
    [self addSubview:self.tagIV];
}

- (CGFloat)widthByStr:(NSString *)str
{
    CGFloat y = 0;
    if (![str isKindOfClass:[NSNull class]] || [str isEqualToString:@""]) {
        
        CGRect frame1 = [str boundingRectWithSize:CGSizeMake(999, self.tagLabel.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
        y = frame1.size.width;
    }else{
        y = 12;
    }
    
    if (y<28) {
        y=28;
    }
    
    return y;
}

#pragma mark - UIGestureRecognizer
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    TXWTextTagModel *tagModel = self.model;
    NSString *text = tagModel.text;
    [[[UIAlertView alloc]initWithTitle:nil message:text delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
}

#pragma mark - setter
- (UILabel *)tagLabel
{
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 3, 20, 20)];
        _tagLabel.font = [UIFont systemFontOfSize:13];
        _tagLabel.textColor = [UIColor whiteColor];
        _tagLabel.textAlignment = 1;
    }
    return _tagLabel;
}

- (UIImageView *)tagIV
{
    if (!_tagIV) {
        _tagIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"KK_Filter_btn_black"]];
        _tagIV.frame = CGRectMake(0, 0, 20, TAG_BG_WIDTH);
        _tagIV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [_tagIV addGestureRecognizer:tap];
    }
    return _tagIV;
}

- (UIImageView *)tagTypeIV
{
    if (!_tagTypeIV) {
        _tagTypeIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, TAG_TYPE_WIDTH, TAG_TYPE_WIDTH)];
        _tagTypeIV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [_tagTypeIV addGestureRecognizer:tap];
    }
    return _tagTypeIV;
}
@end
 */
