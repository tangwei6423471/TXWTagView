//
//  TXWTagView.m
//  TXWTagView
//
//  Created by develop on 15/8/25.
//  Copyright (c) 2015年 develop. All rights reserved.
//

#import "TXWTagView.h"

#define BG_LABEL_PAD 5
#define TAG_TYPE 11
@interface TXWTagView()
@property (strong,nonatomic) UIImageView *tagTypeIV;
@property (strong,nonatomic) UIImageView *tagIV;
@property (strong,nonatomic) UILabel *tagLabel;
@end
@implementation TXWTagView

- (instancetype)initWithModel:(id)model frame:(CGRect)frame
{
    self = [super init];
    if (self) {
        if ([model isKindOfClass:[TXWTextTagModel class]]) {
            [self initByModel:model frame:frame];
        }
    }
    
    return self;
}

- (void)initByModel:(TXWTextTagModel *)model frame:(CGRect)frame
{
    CGPoint point = CGPointMake(frame.size.width*model.posX, frame.size.height*model.posY);
    self.tagTypeIV.image = [UIImage imageNamed:@"big_biaoqian_dian"];
    CGRect frame1 = self.tagTypeIV.frame;
    frame1.origin = point;
    self.tagTypeIV.frame = frame1;
    [self addSubview:self.tagTypeIV];
}

- (CGFloat)widthByStr:(NSString *)str
{
    CGFloat y = 0;
    if (![str isKindOfClass:[NSNull class]] || [str isEqualToString:@""]) {
        
        CGRect frame1 = [str boundingRectWithSize:CGSizeMake(999, self.tagLabel.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
        y = frame1.size.width;
    }else{
        y = 5;
    }
    
    return y;
}

#pragma mark - UIGestureRecognizer
- (void)tapAction:(UITapGestureRecognizer *)tap
{

}

#pragma mark - setter
- (UILabel *)tagLabel
{
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    }
    return _tagLabel;
}

- (UIImageView *)tagIV
{
    if (!_tagIV) {
        _tagIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"KK_Filter_btn_black"]];
        _tagIV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [_tagIV addGestureRecognizer:tap];
    }
    return _tagIV;
}

- (UIImageView *)tagTypeIV
{
    if (!_tagTypeIV) {
        _tagTypeIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 11, 11)];
        _tagTypeIV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [_tagTypeIV addGestureRecognizer:tap];
    }
    return _tagTypeIV;
}
@end
