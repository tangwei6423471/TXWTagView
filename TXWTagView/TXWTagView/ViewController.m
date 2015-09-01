//
//  ViewController.m
//  TXWTagView
//
//  Created by develop on 15/8/24.
//  Copyright (c) 2015年 develop. All rights reserved.
//

#import "ViewController.h"
#import "TXWTagPopView.h"
#import "TXWTextTagModel.h"
#import "TXWTagView.h"

#define BUTTON_HEIGHT 60
#define BUTTON_WIDTH 60
#define MAX_TAG_COUNT 5
@interface ViewController ()<UIGestureRecognizerDelegate,TXWTagPopViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageVIew;
@property (strong,nonatomic) TXWTagPopView *tagPopView;
@property (assign,nonatomic) BOOL isShowTagPoint;// 点击那里显示点
@property (strong,nonatomic) UIImageView *pointIV;
@property (strong,nonatomic) UIAlertView *alertView;// debug 弹框输入标签
@property (assign,nonatomic) CGPoint tagPoint;// 存点击的点
@property (strong,nonatomic) NSMutableArray *tagArrs;// 存储标签model
@property (strong,nonatomic) TXWTagView *tagView;
@end

@implementation ViewController

#pragma mark - cycle life
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.tagArrs = [NSMutableArray arrayWithCapacity:MAX_TAG_COUNT];
//    self.isShowTagPoint = YES;
//    self.imageVIew.image = [UIImage imageNamed:@"demo"];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapAction:)];
//    tap.delegate = self;
//    self.imageVIew.userInteractionEnabled = YES;
//    [self.imageVIew addGestureRecognizer:tap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - private method

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouchs = [event allTouches];
    UITouch *touch = [allTouchs anyObject];
    CGPoint point = [touch locationInView:touch.view];
    
    if(!CGRectContainsPoint(self.imageVIew.frame, point)){return;}// 点不在区域内，return
    self.tagPoint = point;
    
    if (self.isShowTagPoint) {
        CGRect frame = self.pointIV.frame;
        frame.origin = CGPointMake(point.x-17/2, point.y-17/2);
        self.pointIV.frame = frame;
        self.pointIV.hidden = NO;
        
    }else{
    
        self.pointIV.hidden = YES;
    }
    
}

//- (void)imageTapAction:(UITapGestureRecognizer *)tap
//{
//    if (self.isShowTagPoint) {
//
//        [self showTagPopView];
//    }else{
//        [self dismissTagPopView];
//    }
//}

- (void)showTagPopView
{
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
    self.isShowTagPoint = !self.isShowTagPoint;

}

- (void)dismissTagPopView
{
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
    self.isShowTagPoint = !self.isShowTagPoint;

}

- (void)tagLabelShowWithModel:(id)model isEdit:(BOOL)isEdit
{
//    self.tagView = [[TXWTagView alloc]initWithModel:model frame:self.imageVIew.frame isEditState:YES];
    NSLog(@"标签frame = %@,imageview = %@",NSStringFromCGRect(self.tagView.frame),NSStringFromCGRect(self.imageVIew.frame));
    [self.imageVIew addSubview:self.tagView];
}

#pragma mark - TXWTagPopViewDelegate
- (void)didTextTagViewClicked
{
    if (self.tagArrs.count>=MAX_TAG_COUNT) {
        [[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"最多可添加%d条标签",MAX_TAG_COUNT] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
    }else{
        [self.alertView show];
    }
    //
    [self dismissTagPopView];
    self.pointIV.hidden = YES;
}

- (void)didLocationTagViewClicked
{
    if (self.tagArrs.count>=MAX_TAG_COUNT) {
        [[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"最多可添加%d条标签",MAX_TAG_COUNT] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
    }else{
        [self.alertView show];
    }
    //
    [self dismissTagPopView];
    self.pointIV.hidden = YES;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (0 == buttonIndex) {
        [alertView isHidden];
    }else{
        UITextField *nameTF = [alertView textFieldAtIndex:0];
        TXWTextTagModel *tagModel = [TXWTextTagModel new];
        tagModel.text = [nameTF.text isEqualToString:@""]?@"":nameTF.text;
        tagModel.posX = self.tagPoint.x/self.imageVIew.frame.size.width;
        tagModel.posY = self.tagPoint.y/self.imageVIew.frame.size.height;
        tagModel.direction = 0;
        [self.tagArrs addObject:tagModel];
        
        [self tagLabelShowWithModel:tagModel isEdit:YES];
    }
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

- (UIAlertView *)alertView{
    if (!_alertView) {
        _alertView = [[UIAlertView alloc]initWithTitle:@"添加标签"message:@"请为新标签输入名称"delegate:self cancelButtonTitle:@"取消"otherButtonTitles:@"确定", nil];
        // 设置AlertView样式
        _alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        
    }
    return _alertView;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;// 支持多手势
}

*/
@end
