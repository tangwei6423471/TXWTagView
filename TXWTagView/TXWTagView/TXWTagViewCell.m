//
//  TXWTagViewCell.m
//  TXWTagView
//
//  Created by develop on 15/8/26.
//  Copyright (c) 2015年 develop. All rights reserved.
//

#import "TXWTagViewCell.h"
#import "TXWTagViewHelper.h"

#define TAGBG_LABEL_PAD 5 // label pad
#define TYPEICON_TAGBG 8 // icon,tagBg padding
#define TAG_TYPE_WIDTH 11
#define TAG_BG_HEIGHT 26

#define TAGTYPEICON_TAGBGIV_PADDING 5 // 类型图标和标签背景间距
#define TAGLABEL_LEFT_X 3
#define TAGLABEL_RIGHT_X 10
#define TAG_ARROW_WIDTH 8


@interface TXWTagViewCell ()

//@property (strong, nonatomic) UILabel *titleLabel;
//@property (strong, nonatomic) UIImageView *tagImageView;
//@property (strong, nonatomic) UIImageView *titleBgImageView;
@property (strong, nonatomic) UIImage *leftBgImage;
@property (strong, nonatomic) UIImage *rightBgImage;

@property (strong,nonatomic) UIImageView *tagTypeIV;
@property (strong,nonatomic) UIImageView *tagIV;
@property (strong,nonatomic) UILabel *tagLabel;

@property (assign, nonatomic) CGSize cachedTagSize;

@end

@implementation TXWTagViewCell

- (instancetype)init
{
    if (self = [self initWithFrame:CGRectZero]) {
        [self initialize];
    }
    return self;
}

// UI init
- (void)initialize
{
    [self addSubview:self.tagTypeIV];
    [self.tagIV addSubview:self.tagLabel];
    [self addSubview:self.tagIV];
}

#pragma mark - Setters/Getters
- (UIImage *)leftBgImage
{
    if (nil == _leftBgImage) {
        _leftBgImage = [[UIImage imageNamed:[TXWTagViewHelper tagLeftBgImageName]] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 5, 4, 12) resizingMode:UIImageResizingModeStretch];
    }
    return _leftBgImage;
}

- (UIImage *)rightBgImage
{
    if (nil == _rightBgImage) {
        _rightBgImage = [[UIImage imageNamed:[TXWTagViewHelper tagRightBgImageName]] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 12, 4, 5) resizingMode:UIImageResizingModeStretch];
    }
    return _rightBgImage;
}

- (CGSize)cachedTagSize
{
    if (CGSizeEqualToSize(_cachedTagSize, CGSizeZero)) {

        _cachedTagSize = CGSizeMake([self widthByStr:self.tagModel.text]+TAG_ARROW_WIDTH+TAGBG_LABEL_PAD+TAG_TYPE_WIDTH+TAGTYPEICON_TAGBGIV_PADDING, TAG_BG_HEIGHT);
        
    }
    return _cachedTagSize;
}


- (UILabel *)tagLabel
{
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 3, 20, 20)];
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
        _tagIV.frame = CGRectMake(0, 0, 20, TAG_BG_HEIGHT);
        _tagIV.userInteractionEnabled = YES;
    }
    return _tagIV;
}

- (UIImageView *)tagTypeIV
{
    if (!_tagTypeIV) {
        _tagTypeIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, TAG_TYPE_WIDTH, TAG_TYPE_WIDTH)];
        _tagTypeIV.userInteractionEnabled = YES;

    }
    return _tagTypeIV;
}

#pragma mark - public method

@synthesize centerPointPercentage = _centerPointPercentage;
@synthesize containerCountIndex = _containerCountIndex;
@synthesize tagViewCellDirection = _tagViewCellDirection;

- (CGSize)tagSize
{
    return self.cachedTagSize;
}

- (CGFloat)tagWidth
{
    return self.tagSize.width;
}

- (CGFloat)tagHeight
{
    return self.tagSize.height;
}

- (void)setTagViewCellDirection:(TXWTagViewCellDirection)tagViewCellDirection
{
    _tagViewCellDirection = tagViewCellDirection;
}

// alvin 判断边界问题
- (void)adjustViewFrameWithGivenPositionPercentage:(CGPoint)pointPercentage andContainerSize:(CGSize)size
{
//    self.frame = CGRectMake(0, 0, self.tagWidth, self.tagHeight);
//
//    CGPoint exactPoint = CGPointMake(pointPercentage.x * size.width, pointPercentage.y * size.height);// 中心点
////    CGRect cellFrame = CGRectMake(exactPoint.x, exactPoint.y, self.tagWidth, self.tagHeight);
//    //左边标签超出边界
//    if (exactPoint.x - self.tagWidth * self.layer.anchorPoint.x < 0) {
//        exactPoint.x = self.tagWidth * self.layer.anchorPoint.x;
//    }
//    //右边标签超出边界
//    if (exactPoint.x + self.tagWidth * (1 - self.layer.anchorPoint.x) > size.width) {
//        exactPoint.x = size.width - self.tagWidth * (1 - self.layer.anchorPoint.x);
//    }
//    //上边标签超出边界
//    if (exactPoint.y - self.tagHeight * self.layer.anchorPoint.y < 0) {
//        exactPoint.y = self.tagHeight * self.layer.anchorPoint.y;
//    }
//    //下边标签超出边界
//    if (exactPoint.y + self.tagHeight * (1 - self.layer.anchorPoint.y) > size.height) {
//        exactPoint.y = size.height - self.tagHeight * (1 - self.layer.anchorPoint.y);
//    }
    
    // 需要根据方向判断
    // 解决方法是 位移还是转向
    
//    if (self.tagModel.direction == TXWTagViewCellDirectionLeft) {
//        exactPoint.x -= self.tagWidth/2;
//        //左边标签超出边界
//        if (exactPoint.x - self.tagWidth < 0) {
//            exactPoint.x = self.tagWidth;
//        }
//        //右边标签超出边界
//        if (exactPoint.x > size.width) {
//            exactPoint.x = size.width;
//        }
//    }else{
//        exactPoint.x += self.tagWidth/2;
//        //左边标签超出边界
//        if (exactPoint.x < 0) {
//            exactPoint.x = 0;
//        }
//        //右边标签超出边界
//        if (exactPoint.x + self.tagWidth > size.width) {
//            exactPoint.x = size.width - self.tagWidth;
//        }
//    }
//
//    
//    //上边标签超出边界
//    if (exactPoint.y - self.tagHeight / 2 < 0) {
//        exactPoint.y = self.tagHeight / 2;
//    }
//    //下边标签超出边界
//    if (exactPoint.y + self.tagHeight/2 > size.height) {
//        exactPoint.y = size.height - self.tagHeight/2;
//    }
    
//    self.layer.position = exactPoint;
//    self.frame = cellFrame;
    
    self.frame = CGRectMake(0, 0, self.tagWidth, self.tagHeight);
//    CGPoint exactPoint = CGPointMake(pointPercentage.x * size.width-self.tagWidth/2, pointPercentage.y * size.height);
    CGPoint exactPoint = CGPointMake(self.tagModel.posX * size.width-self.tagWidth/2, self.tagModel.posY * size.height);
    
    //左边标签超出边界
    if (exactPoint.x - self.tagWidth * self.layer.anchorPoint.x < 0) {
        exactPoint.x = self.tagWidth * self.layer.anchorPoint.x;
    }
    //右边标签超出边界
    if (exactPoint.x + self.tagWidth * (1 - self.layer.anchorPoint.x) > size.width) {
        exactPoint.x = size.width - self.tagWidth * (1 - self.layer.anchorPoint.x);
    }
    //上边标签超出边界
    if (exactPoint.y - self.tagHeight * self.layer.anchorPoint.y < 0) {
        exactPoint.y = self.tagHeight * self.layer.anchorPoint.y;
    }
    //下边标签超出边界
    if (exactPoint.y + self.tagHeight * (1 - self.layer.anchorPoint.y) > size.height) {
        exactPoint.y = size.height - self.tagHeight * (1 - self.layer.anchorPoint.y);
    }
    
    self.layer.position = exactPoint;

}


// 改变方向
- (void)reversetagViewCellDirection
{
    CGPoint currentCenter = self.center;
    CGFloat offsetLength = self.tagWidth - 11.0f;// 类型图片宽度
    CGPoint newCenter = currentCenter;
    if (self.tagModel.direction == TXWTagViewCellDirectionLeft) {
        self.tagViewCellDirection = TXWTagViewCellDirectionRight;
        newCenter.x += offsetLength;
    } else {
        self.tagViewCellDirection = TXWTagViewCellDirectionLeft;
        newCenter.x -= offsetLength;
    }
    
    //iOS7下 AutoLayout的bug，开始计算出的tagWidth尺寸不对，所以需要重新计算下
    if (![TXWTagViewHelper osVersionIsiOS8]) {
        self.frame = CGRectMake(0, 0, self.tagWidth, self.tagHeight);
    }

    [self setCenter:newCenter];
    [self setNeedsLayout];
}

// 是否可以改变方向
- (BOOL)checkCanReversetagViewCellDirectionWithContainerSize:(CGSize)size
{
    if (self.tagModel.direction == TXWTagViewCellDirectionRight) {
        if (self.frame.origin.x < self.tagWidth-TAG_TYPE_WIDTH/2) {
            return NO;
        }
        return YES;
    } else {
        if (size.width - self.frame.origin.x - self.tagWidth < self.tagWidth-TAG_TYPE_WIDTH/2) {
            return NO;
        }
        return YES;
    }
}

- (void)runAnimation
{
//    //设置旋转点 根据资源图片计算得出
//    CGPoint newAnchorPoint = CGPointMake(0.61, 0.19);
//    self.tagImageView.layer.anchorPoint = newAnchorPoint;
//    //移动到正确的位置
//    CGSize imageViewSize = CGSizeMake(self.tagHeight, self.tagHeight);
//    self.tagImageView.transform = CGAffineTransformMakeTranslation((newAnchorPoint.x - 0.5) * imageViewSize.width, (newAnchorPoint.y - 0.5) * imageViewSize.height);
//    
//    //关键帧动画
//    CALayer *layer = self.tagImageView.layer;
//    CAKeyframeAnimation *animation;
//    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
//    animation.duration = 1.0f;
//    animation.cumulative = YES;
//    animation.repeatCount = INFINITY;
//    animation.values = @[
//                         @(0.0f),
//                         @(-M_PI / 5),
//                         @(-M_PI / 3),
//                         @(-M_PI / 5),
//                         @(0.0f)
//                         ];
//    animation.timingFunctions = @[
//                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
//                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
//                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
//                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]
//                                  ];
//    animation.removedOnCompletion = NO;
//    animation.fillMode = kCAFillModeForwards;
//    
//    [layer addAnimation:animation forKey:@"tagViewCellRotate"];
}

#pragma mark - Override Methods

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.tagLabel.text = self.tagModel.text;
    CGRect TagBgImageViewframe = self.tagIV.frame;
    CGRect TagTypeImageViewframe = self.tagTypeIV.frame;
    CGRect TagLabelframe = self.tagLabel.frame;
    
    self.tagTypeIV.image = [UIImage imageNamed:@"big_biaoqian_dian"];
    
    if (self.tagModel.direction == TXWTagViewCellDirectionLeft) {

        TagBgImageViewframe = CGRectMake(0, 0, self.tagWidth-TAG_TYPE_WIDTH-TAGTYPEICON_TAGBGIV_PADDING, TAG_BG_HEIGHT);
        TagLabelframe.origin.x = TAGLABEL_LEFT_X;
        TagLabelframe.size.width = self.tagWidth-TAG_TYPE_WIDTH-TAG_ARROW_WIDTH-TAGBG_LABEL_PAD-TAGTYPEICON_TAGBGIV_PADDING;
        self.tagIV.image = [self.leftBgImage resizableImageWithCapInsets:UIEdgeInsetsMake(4, 5, 4, 12) resizingMode:UIImageResizingModeStretch];
        TagTypeImageViewframe.origin = CGPointMake(self.tagWidth-TAG_TYPE_WIDTH, (TAG_BG_HEIGHT-TAG_TYPE_WIDTH)/2);
        
    }else{
        
        TagBgImageViewframe = CGRectMake(TAG_TYPE_WIDTH+TAGTYPEICON_TAGBGIV_PADDING, 0, self.tagWidth-TAG_TYPE_WIDTH-TAGTYPEICON_TAGBGIV_PADDING, TAG_BG_HEIGHT);
        TagLabelframe.origin.x = TAGLABEL_RIGHT_X;
        TagLabelframe.size.width = self.tagWidth-TAG_TYPE_WIDTH-TAG_ARROW_WIDTH-TAGBG_LABEL_PAD-TAGTYPEICON_TAGBGIV_PADDING;
        self.tagIV.image = [self.rightBgImage resizableImageWithCapInsets:UIEdgeInsetsMake(4, 12, 4, 5) resizingMode:UIImageResizingModeStretch];
        TagTypeImageViewframe.origin = CGPointMake(0, (TAG_BG_HEIGHT-TAG_TYPE_WIDTH)/2);

    }
    
    self.tagIV.frame = TagBgImageViewframe;
    self.tagLabel.frame = TagLabelframe;
    self.tagTypeIV.frame = TagTypeImageViewframe;

}

#pragma mark - private method
- (CGFloat)widthByStr:(NSString *)str
{
    CGFloat y = 0;
    if (![str isKindOfClass:[NSNull class]] || [str isEqualToString:@""]) {
        
        CGRect frame1 = [str boundingRectWithSize:CGSizeMake(999, self.tagLabel.frame.size.height)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]}context:nil];
        y = frame1.size.width;
    }else{
        y = 12;
    }
    
    if (y<28) {
        y=28;
    }
    
    return y;
}

// 点击区域
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect frame = CGRectInset(self.bounds, -2, -2);
    return CGRectContainsPoint(frame, point) ? self : nil;
}



@end
