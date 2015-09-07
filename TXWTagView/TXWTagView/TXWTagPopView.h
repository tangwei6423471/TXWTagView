//
//  TXWTagPopView.h
//  TXWTagView
//
//  Created by develop on 15/8/25.
//  Copyright (c) 2015年 develop. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TXWTagPopViewDelegate;
@interface TXWTagPopView : UIView
@property (nonatomic,strong) UIButton *textButton;
@property (nonatomic,strong) UIButton *locationButton;
@property (nonatomic,weak) id<TXWTagPopViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView *)superView;
@end

@protocol TXWTagPopViewDelegate <NSObject>

@optional
- (void)didTextTagViewClicked;
- (void)didLocationTagViewClicked;
- (void)tapTagPopView;
@end