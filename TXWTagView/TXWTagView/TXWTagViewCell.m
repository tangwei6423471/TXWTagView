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

#define TAGLABEL_LEFT_X 3
#define TAGLABEL_RIGHT_X 10
#define TAG_ARROW_WIDTH 8

static const CGFloat ktagViewCellSideEdge = 6.0f;
static const CGFloat ktagViewCellCornerSideEdge = 10.0f;

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
        CGFloat imageWidth = 28;
        CGFloat deltaSpace = ktagViewCellCornerSideEdge + ktagViewCellSideEdge;
        CGSize titleSize = [self.tagModel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
        _cachedTagSize = CGSizeMake(imageWidth + deltaSpace + titleSize.width, imageWidth);
    }
    return _cachedTagSize;
}


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


//- (void)setAdaptViewScale:(CGFloat)adaptViewScale
//{
////    _adaptViewScale = adaptViewScale;
//    //更新了adaptScale,字体需要改变，背景拉伸图需要改变，约束需要改变
//    self.titleLabel.font = [UIFont systemFontOfSize:[self getAdaptViewScaleConstant:11.0f]];
//    self.leftBgImage = nil;
//    self.rightBgImage = nil;
//    self.cachedTagSize = CGSizeZero;
//}
//
//- (CGFloat)getAdaptViewScaleConstant:(CGFloat)originalConstant
//{
//    return self.adaptViewScale * originalConstant;
//}

//- (void)configAdjustAnchorPoint
//{
//    CGPoint anchorPoint = CGPointZero;
//    if (self.tagModel.direction == TXWTagViewCellDirectionLeft) {
//        if ([TXWTagViewHelper osVersionIsiOS8]) {
//            anchorPoint = CGPointMake(13 / self.tagWidth, 4 / self.tagHeight);
//        } else {
//            anchorPoint = CGPointMake(13.0f / self.tagWidth, 4.0 / self.tagHeight);
//        }
//    } else {
//        if ([TXWTagViewHelper osVersionIsiOS8]) {
//            anchorPoint = CGPointMake((self.tagWidth - 8) / self.tagWidth, 4 / self.tagHeight);
//        } else {
//            anchorPoint = CGPointMake((self.tagWidth - 8.0f) / self.tagWidth, 4.0f / self.tagHeight);
//        }
//    }
//    self.layer.anchorPoint = anchorPoint;
//}

- (void)adjustViewFrameWithGivenPositionPercentage:(CGPoint)pointPercentage andContainerSize:(CGSize)size
{
    self.frame = CGRectMake(0, 0, self.tagWidth, self.tagHeight);
//    [self configAdjustAnchorPoint];
    CGPoint exactPoint = CGPointMake(pointPercentage.x * size.width, pointPercentage.y * size.height);
    
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

- (void)reversetagViewCellDirection
{
    CGPoint currentCenter = self.center;
    CGFloat offsetLength = self.tagWidth - 21.0f;
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
    
//    [self configAdjustAnchorPoint];
    [self setCenter:newCenter];
    
    [self setNeedsLayout];
}

- (BOOL)checkCanReversetagViewCellDirectionWithContainerSize:(CGSize)size
{
    if (self.tagModel.direction == TXWTagViewCellDirectionLeft) {
        if (self.frame.origin.x <= self.tagWidth / 2) {
            return NO;
        }
        return YES;
    } else {
        if (size.width - self.frame.origin.x - self.tagWidth <= self.tagWidth / 2) {
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
    
    // cell frame
    CGRect cellFrame;
    
    // 类型icon
    CGPoint point = CGPointMake(self.tagViewFrame.size.width*self.tagModel.posX, self.tagViewFrame.size.height*self.tagModel.posY);
    self.tagTypeIV.image = [UIImage imageNamed:@"big_biaoqian_dian"];
    CGRect frame1 = self.tagTypeIV.frame;
    
    // 方向
    CGRect frame2 = self.tagIV.frame;
    CGRect frameLabel = self.tagLabel.frame;
    
    if (self.tagModel.direction == TXWTagViewCellDirectionLeft) {
        
        UIEdgeInsets insets = UIEdgeInsetsMake(4, 5, 4, 12);
        CGFloat textWidth = [self widthByStr:self.tagModel.text]+TAG_ARROW_WIDTH+TAGBG_LABEL_PAD;
        CGFloat residueWidth = point.x-TYPEICON_TAGBG;
        
        if (textWidth>=residueWidth) {
            frame2.size.width = residueWidth;
            frame2.origin = CGPointMake(0, 0);
            cellFrame.origin = CGPointMake(0, point.y-TAG_BG_HEIGHT/2);
            frameLabel.size.width = residueWidth - TAG_ARROW_WIDTH - TAGBG_LABEL_PAD;
        }else{
            frame2.size.width = textWidth;
            frame2.origin = CGPointMake(0, 0);
            cellFrame.origin = CGPointMake(point.x-textWidth-TYPEICON_TAGBG, point.y-TAG_BG_HEIGHT/2);
            frameLabel.size.width = textWidth - TAG_ARROW_WIDTH - TAGBG_LABEL_PAD;
        }
        frameLabel.origin.x = TAGLABEL_LEFT_X;
        UIImage *imageStretch = [self.leftBgImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        self.tagIV.image = imageStretch;
        
        // typeIcon
        frame1.origin = CGPointMake(frame2.size.width, (TAG_BG_HEIGHT-TAG_TYPE_WIDTH)/2);

    } else {
        
        // typeIcon
        frame1.origin = CGPointMake(0, (TAG_BG_HEIGHT-TAG_TYPE_WIDTH)/2);
        
        UIEdgeInsets insets = UIEdgeInsetsMake(4, 12, 4, 5);
        frame2.origin = CGPointMake(TAG_TYPE_WIDTH, 0);
        // cell frame
        cellFrame.origin = CGPointMake(point.x-self.tagTypeIV.frame.size.width/2, point.y-TAG_BG_HEIGHT/2);
        CGFloat textWidth = [self widthByStr:self.tagModel.text]+TAG_ARROW_WIDTH+TAGBG_LABEL_PAD;
        CGFloat residueWidth = CGRectGetMaxX(self.tagViewFrame)-point.x-TYPEICON_TAGBG;
        if (textWidth>=residueWidth) {
            frame2.size.width = residueWidth;
            frameLabel.size.width = residueWidth - TAG_ARROW_WIDTH - TAGBG_LABEL_PAD;
        }else{
            frame2.size.width = textWidth;
            frameLabel.size.width = textWidth - TAG_ARROW_WIDTH - TAGBG_LABEL_PAD;
        }
        frameLabel.origin.x = TAGLABEL_RIGHT_X;
        self.tagIV.image = [self.rightBgImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        
    }
    
    self.tagIV.frame = frame2;
    self.tagLabel.frame = frameLabel;
    self.tagTypeIV.frame = frame1;
    
    // label
    self.tagLabel.text = self.tagModel.text;
    
    cellFrame.size = CGSizeMake(frame2.size.width+TAG_TYPE_WIDTH, TAG_BG_HEIGHT);
    self.frame = cellFrame;

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

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect frame = CGRectInset(self.bounds, -20, -20);
    return CGRectContainsPoint(frame, point) ? self : nil;
}



@end
