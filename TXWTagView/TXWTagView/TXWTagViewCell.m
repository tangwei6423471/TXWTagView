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
#define TAG_TYPE_WIDTH 12
#define TAG_BG_HEIGHT 26

#define TAGTYPEICON_TAGBGIV_PADDING 5 // 类型图标和标签背景间距
#define TAGLABEL_LEFT_X 3
#define TAGLABEL_RIGHT_X 10
#define TAG_ARROW_WIDTH 8
#define TAG_MIN_WIDTH 28

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

// animation
@property (nonatomic,strong) CALayer *imageLayer;
@property (nonatomic,strong) CALayer *pulsingLayer;
@property (nonatomic,strong) CALayer *pulsingLayer1;

@property (nonatomic,strong) CAAnimationGroup *iconGroup;
@property (nonatomic,strong) CAAnimationGroup *pulsingGroup;
@property (nonatomic,strong) CAAnimationGroup *pulsingGroup1;

@end

@implementation TXWTagViewCell

@synthesize centerPointPercentage = _centerPointPercentage;
@synthesize containerCountIndex = _containerCountIndex;
@synthesize tagViewCellDirection = _tagViewCellDirection;
@synthesize tagId = _tagId;
@synthesize tagText = _tagText;
@synthesize tagType = _tagType;
@synthesize dataKey = _dataKey;

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

        _cachedTagSize = CGSizeMake([self widthByStr:self.tagText]+TAG_ARROW_WIDTH+TAGBG_LABEL_PAD+TAG_TYPE_WIDTH+TAGTYPEICON_TAGBGIV_PADDING, TAG_BG_HEIGHT);
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

// alvin 判断边界问题,设置cell的frame
- (void)adjustViewFrameWithGivenPositionPercentage:(CGPoint)pointPercentage andContainerSize:(CGSize)size
{
    self.frame = CGRectMake(0, 0, self.tagWidth, self.tagHeight);
    // 把传过来的点转换计算成center点
    CGPoint exactPoint;
    if (self.tagViewCellDirection == TXWTagViewCellDirectionLeft) {
        exactPoint = CGPointMake(self.centerPointPercentage.x * size.width-self.tagWidth/2+TAG_TYPE_WIDTH/2, self.centerPointPercentage.y * size.height);
    }else{
        exactPoint = CGPointMake(self.centerPointPercentage.x * size.width+self.tagWidth/2-TAG_TYPE_WIDTH/2, self.centerPointPercentage.y * size.height);
    }
    
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
    CGFloat offsetLength = self.tagWidth - TAG_TYPE_WIDTH;// 类型图片宽度
    CGPoint newCenter = currentCenter;
    if (self.tagViewCellDirection == TXWTagViewCellDirectionLeft) {
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
    if (self.tagViewCellDirection == TXWTagViewCellDirectionRight) {
        if (self.frame.origin.x < self.tagWidth-TAG_TYPE_WIDTH) {
            return NO;
        }
        return YES;
    } else {
        if (size.width - self.frame.origin.x - self.tagWidth < self.tagWidth-TAG_TYPE_WIDTH) {
            return NO;
        }
        return YES;
    }
}

- (void)runAnimation
{
    switch ([self.tagType intValue]) {
        case 0:
            self.tagTypeIV.image = [UIImage imageNamed:[TXWTagViewHelper tagIconImageNameTypeNomal]];
            break;
        case 1:
            self.tagTypeIV.image = [UIImage imageNamed:[TXWTagViewHelper tagIconImageNameTypePeople]];
            break;
        case 2:
            self.tagTypeIV.image = [UIImage imageNamed:[TXWTagViewHelper tagIconImageNameTypeLocation]];
            break;
        default:
            break;
    }

    // icon 放大缩小
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @1;
    animation.toValue = @0.8;
    animation.duration = 0.2;
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation1.fromValue = @0.8;
    animation1.toValue = @1.2;
    animation1.duration = 0.4;
    animation1.beginTime = animation.duration;
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation2.fromValue = @1.2;
    animation2.toValue = @1;
    animation2.duration = 0.2;
    animation2.beginTime = animation.duration + animation1.duration;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = animation.duration + animation1.duration + animation2.duration + 0.1;
    animationGroup.repeatCount = 0;
    animationGroup.delegate = self; // 动画开始结束方法
    animationGroup.animations = @[animation,animation1,animation2];
    [animationGroup setValue:@"icon" forKey:@"animationName"];
    self.iconGroup = animationGroup;
    
    self.pulsingLayer = [self addPulsingLayer];
    [self.layer addSublayer:self.pulsingLayer];
    
    self.pulsingLayer1 = [self addPulsingLayer];
    [self.layer addSublayer: self.pulsingLayer1];
    
    self.pulsingGroup = [self addPulsingAnimationGroup:1];
    [self.pulsingGroup setValue:@"pulse" forKey:@"animationName"];
    
    self.pulsingGroup1 = [self addPulsingAnimationGroup:0.8];
    [self.pulsingGroup1 setValue:@"pulse1" forKey:@"animationName"];
    
    CALayer *imageLayer = [CALayer layer];
    if (self.tagViewCellDirection == TXWTagViewCellDirectionRight) {
        imageLayer.frame = CGRectMake(0, (self.frame.size.height - TAG_TYPE_WIDTH) / 2, TAG_TYPE_WIDTH , TAG_TYPE_WIDTH);
    }else{
        imageLayer.frame = CGRectMake((self.frame.size.width - TAG_TYPE_WIDTH), (self.frame.size.height - TAG_TYPE_WIDTH) / 2, TAG_TYPE_WIDTH , TAG_TYPE_WIDTH);
    }

    imageLayer.contents = (__bridge id)(self.tagTypeIV.image.CGImage);
    [self.layer addSublayer:imageLayer];
    self.imageLayer = imageLayer;
    
    [imageLayer addAnimation:animationGroup forKey:@"icon"];
}

-(CALayer *)addPulsingLayer
{
    CALayer *pulsingLayer = [CALayer layer];
    pulsingLayer.bounds = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
    if (self.tagViewCellDirection == TXWTagViewCellDirectionLeft) {
        pulsingLayer.position = CGPointMake(self.frame.size.width-TAG_TYPE_WIDTH/2, self.bounds.size.height/2);
    }else {
        pulsingLayer.position = CGPointMake(TAG_TYPE_WIDTH/2, self.bounds.size.height/2);
    }
    
    pulsingLayer.contentsScale = [UIScreen mainScreen].scale;
    pulsingLayer.backgroundColor = [UIColor blackColor].CGColor;
    pulsingLayer.cornerRadius = self.frame.size.height/2;
    pulsingLayer.opacity = 0;
    return pulsingLayer;
}

-(CAAnimationGroup *)addPulsingAnimationGroup:(CFTimeInterval)duration
{
    CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    animation3.fromValue = @0.0;
    animation3.toValue = @1.0;
    animation3.duration = duration;
    
    CAKeyframeAnimation *animation4 = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    animation4.duration =duration ;
    animation4.values = @[@0.8, @0.45, @0];
    animation4.keyTimes = @[@0, @0.2, @1];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration =  duration;
    animationGroup.repeatCount = 0;
    animationGroup.delegate = self;// 动画开始结束方法
    animationGroup.animations = @[animation3,animation4];
    
    return animationGroup;
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)animation
{

    NSString *animationName = [animation valueForKey:@"animationName"];
    if ([animationName  isEqualToString:@"pulse"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * self.pulsingGroup.duration  * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.pulsingLayer1 addAnimation:self.pulsingGroup1 forKey:@"pulse1"];
        });
    }
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished
{
    if (finished) {
        NSString *animationName = [animation valueForKey:@"animationName"];
        
        if ([animationName isEqualToString:@"icon"]) {
            [self.imageLayer removeAnimationForKey:@"icon"];
            [self.pulsingLayer addAnimation:self.pulsingGroup forKey:@"pulse"];
        }else if ([animationName isEqualToString:@"pulse"]){
            [self.pulsingLayer removeAnimationForKey:@"pulse"];
        }else if ([animationName isEqualToString:@"pulse1"]){
            [self.pulsingLayer1 removeAnimationForKey:@"pulse1"];
            [self.imageLayer addAnimation:self.iconGroup forKey:@"icon"];
        }
    }
}

#pragma mark - Override Methods

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.tagLabel.text = self.tagText;
    CGRect TagBgImageViewframe = self.tagIV.frame;
    CGRect TagTypeImageViewframe = self.tagTypeIV.frame;
    CGRect TagLabelframe = self.tagLabel.frame;
    
    if (self.tagViewCellDirection == TXWTagViewCellDirectionLeft) {

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
    
    if (y<TAG_MIN_WIDTH) {
        y=TAG_MIN_WIDTH;
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
