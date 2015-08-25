//
//  ViewController.m
//  TXWTagView
//
//  Created by develop on 15/8/24.
//  Copyright (c) 2015年 develop. All rights reserved.
//

#import "ViewController.h"
#import "TXWTagPopView.h"
#define BUTTON_HEIGHT 60
#define BUTTON_WIDTH 60
@interface ViewController ()<UIGestureRecognizerDelegate,TXWTagPopViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageVIew;
@property (strong,nonatomic) TXWTagPopView *tagPopView;
@property (assign,nonatomic) BOOL isShowTagPoint;// 点击那里显示点
@property (strong,nonatomic) UIImageView *pointIV;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isShowTagPoint = YES;
    self.imageVIew.image = [UIImage imageNamed:@"demo"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapAction:)];
    self.imageVIew.userInteractionEnabled = YES;
    [self.imageVIew addGestureRecognizer:tap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    NSSet *allTouchs = [event allTouches];
    UITouch *touch = [allTouchs anyObject];
    CGPoint point = [touch locationInView:touch.view];
    
    if(!CGRectContainsPoint(self.imageVIew.frame, point)){return;}// 点不在区域内，return
    
    if (self.isShowTagPoint) {
        CGRect frame = self.pointIV.frame;
        frame.origin = CGPointMake(point.x-17/2, point.y-17/2);
        self.pointIV.frame = frame;
        self.pointIV.hidden = NO;
        
    }else{
    
        self.pointIV.hidden = YES;
    }
    
}

- (void)imageTapAction:(UITapGestureRecognizer *)tap
{
    
    if (self.isShowTagPoint) {

        if (!_tagPopView) {
            CGRect frame;
            frame.size = CGSizeMake(320, 320);
            frame.origin = CGPointMake(0,(self.imageVIew.bounds.size.height-320)/2);
            self.tagPopView = [[TXWTagPopView alloc]initWithFrame:frame superView:self.imageVIew];
        }
        _tagPopView.alpha = 1;
        _tagPopView.delegate = self;
        [self.imageVIew addSubview:_tagPopView];
        
        _tagPopView.locationButton.alpha = 0;
        [UIView animateWithDuration:0.25f animations:^{
            CGRect frame = _tagPopView.locationButton.frame;
            frame.origin.y = (_tagPopView.frame.size.height-BUTTON_WIDTH)/2;
            _tagPopView.locationButton.frame = frame;
            _tagPopView.locationButton.alpha = 1;
        }];
        
        _tagPopView.textButton.alpha = 0;
        [UIView animateWithDuration:0.10f animations:^{
            CGRect frame = _tagPopView.textButton.frame;
            frame.origin.y = (_tagPopView.frame.size.height-BUTTON_WIDTH)/2;
            _tagPopView.textButton.frame = frame;
            _tagPopView.textButton.alpha = 1;
        }];

    }else{
        if (_tagPopView) {
            _tagPopView.locationButton.alpha = 1;
            [UIView animateWithDuration:0.10f animations:^{
                CGRect frame = _tagPopView.locationButton.frame;
                frame.origin.y = 0;
                _tagPopView.locationButton.frame = frame;
                _tagPopView.locationButton.alpha = 0;
            }];
            
            _tagPopView.textButton.alpha = 1;
            [UIView animateWithDuration:0.25f animations:^{
                CGRect frame = _tagPopView.textButton.frame;
                frame.origin.y = 0;
                _tagPopView.textButton.frame = frame;
                _tagPopView.textButton.alpha = 0;
            }];

        }
        
    }
    
    self.isShowTagPoint = !self.isShowTagPoint;
    
}

#pragma mark - TXWTagPopViewDelegate
- (void)didTextTagViewClicked
{

}

- (void)didLocationTagViewClicked
{

}

#pragma mark - setter
- (UIImageView *)pointIV
{

    if (!_pointIV) {
        _pointIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"KK_Filter_hover"]];
        _pointIV.frame= CGRectMake(0, 0, 17, 17);
        [_imageVIew addSubview:_pointIV];
    }
    return _pointIV;
}

@end
