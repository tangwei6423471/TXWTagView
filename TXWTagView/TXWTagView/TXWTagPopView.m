//
//  TXWTagPopView.m
//  TXWTagView
//
//  Created by develop on 15/8/25.
//  Copyright (c) 2015年 develop. All rights reserved.
//

#import "TXWTagPopView.h"
#import "TXWTagViewHelper.h"
#define BUTTON_HEIGHT 60
#define BUTTON_WIDTH 60
#define MARGIN_BUTTON 50
@interface TXWTagPopView()

@end

@implementation TXWTagPopView

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView *)superView
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initButtonView];
    }
    
    return self;
}

- (void)initButtonView
{
    [self addSubview:self.textButton];
    [self addSubview:self.locationButton];
    self.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPopViewAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}

#pragma mark - UITapGestureRecognizer
- (void)tapPopViewAction:(UIGestureRecognizer *)tap
{
//    if (self) {
//        self.locationButton.alpha = 1;
//        [UIView animateWithDuration:0.10f animations:^{
//            CGRect frame = self.locationButton.frame;
//            frame.origin.y = 0;
//            self.locationButton.frame = frame;
//            self.locationButton.alpha = 0;
//        }];
//        
//        self.textButton.alpha = 1;
//        [UIView animateWithDuration:0.25f animations:^{
//            CGRect frame = self.textButton.frame;
//            frame.origin.y = 0;
//            self.textButton.frame = frame;
//            self.textButton.alpha = 0;
//        }];
//        
//    }
//
//    self.hidden = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(tapTagPopView)]) {
        [_delegate tapTagPopView];
    }

}

#pragma mark - setter
- (UIButton *)textButton
{
    if (!_textButton) {
        _textButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _textButton.backgroundColor = [UIColor clearColor];
        _textButton.frame = CGRectMake(MARGIN_BUTTON,0, BUTTON_WIDTH, BUTTON_WIDTH);
        [_textButton setImage:[UIImage imageNamed:[TXWTagViewHelper tagPopViewButtonImageTypeNomal]] forState:UIControlStateNormal];
        [_textButton addTarget:_delegate action:@selector(didTextTagViewClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _textButton;
}

- (UIButton *)locationButton
{
    if (!_locationButton) {
        _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _locationButton.frame = CGRectMake(self.frame.size.width-BUTTON_WIDTH-MARGIN_BUTTON, 0, BUTTON_WIDTH, BUTTON_WIDTH);
        [_locationButton setImage:[UIImage imageNamed:[TXWTagViewHelper tagPopViewButtonImageTypePeople]] forState:UIControlStateNormal];
        [_locationButton addTarget:_delegate action:@selector(didPeopleTagViewClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _locationButton;
}
@end
