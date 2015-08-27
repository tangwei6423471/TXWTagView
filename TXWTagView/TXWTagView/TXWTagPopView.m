//
//  TXWTagPopView.m
//  TXWTagView
//
//  Created by develop on 15/8/25.
//  Copyright (c) 2015年 develop. All rights reserved.
//

#import "TXWTagPopView.h"
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
//        [superView addSubview:self];
        [self initButtonView];
    }
    
    return self;
}

- (void)initButtonView
{

    [self addSubview:self.textButton];
    [self addSubview:self.locationButton];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPopViewAction:)];
//    [self addGestureRecognizer:tap];
}

#pragma mark - UITapGestureRecognizer
- (void)tapPopViewAction:(UIGestureRecognizer *)tap
{
    if (self) {
        self.locationButton.alpha = 1;
        [UIView animateWithDuration:0.10f animations:^{
            CGRect frame = self.locationButton.frame;
            frame.origin.y = 0;
            self.locationButton.frame = frame;
            self.locationButton.alpha = 0;
        }];
        
        self.textButton.alpha = 1;
        [UIView animateWithDuration:0.25f animations:^{
            CGRect frame = self.textButton.frame;
            frame.origin.y = 0;
            self.textButton.frame = frame;
            self.textButton.alpha = 0;
        }];
        
    }

    self.hidden = YES;

}

#pragma mark - setter
- (UIButton *)textButton
{

    if (!_textButton) {
        _textButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _textButton.backgroundColor = [UIColor clearColor];
        _textButton.frame = CGRectMake(MARGIN_BUTTON,0, BUTTON_WIDTH, BUTTON_WIDTH);
        [_textButton setImage:[UIImage imageNamed:@"Filter_icon_brand"] forState:UIControlStateNormal];
        [_textButton addTarget:_delegate action:@selector(didTextTagViewClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _textButton;
}

- (UIButton *)locationButton
{
    
    if (!_locationButton) {
        _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _locationButton.frame = CGRectMake(self.frame.size.width-BUTTON_WIDTH-MARGIN_BUTTON, 0, BUTTON_WIDTH, BUTTON_WIDTH);
        [_locationButton setImage:[UIImage imageNamed:@"Filter_icon_Location"] forState:UIControlStateNormal];
        [_locationButton addTarget:_delegate action:@selector(didLocationTagViewClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _locationButton;
}
@end
