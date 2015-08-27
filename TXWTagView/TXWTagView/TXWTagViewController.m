//
//  TXWTagViewController.m
//  TXWTagView
//
//  Created by develop on 15/8/26.
//  Copyright (c) 2015年 develop. All rights reserved.
//

#import "TXWTagViewController.h"
#import "TXWTagView.h"
#import "TXWTagViewCell.h"
#import "TXWTextTagModel.h"
#import "TXWTagPopView.h"

#define BUTTON_HEIGHT 60
#define BUTTON_WIDTH 60
#define MAX_TAG_COUNT 5
@interface TXWTagViewController ()<TXWTagViewDataSource,TXWTagViewDelegate,TXWTagPopViewDelegate,UIGestureRecognizerDelegate>
@property (strong,nonatomic) TXWTagPopView *tagPopView;
@property (assign,nonatomic) BOOL isShowTagPoint;// 点击那里显示点
@property (strong,nonatomic) UIImageView *pointIV;
@property (strong,nonatomic) UIAlertView *alertView;// debug 弹框输入标签
@property (assign,nonatomic) CGPoint tagPoint;// 存点击的点
@property (strong,nonatomic) NSMutableArray *tagArrs;// 存储标签model
@property (strong,nonatomic) TXWTagView *tagView;
@end

@implementation TXWTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowTagPoint = YES;
    self.tagView.backgroundImageView.image = [UIImage imageNamed:@"demo"];
    self.tagView.userInteractionEnabled = YES;
    [self.view addSubview:self.tagView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapAction:)];
    tap.delegate = self;
    [self.tagView addGestureRecognizer:tap];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouchs = [event allTouches];
    UITouch *touch = [allTouchs anyObject];
    CGPoint point = [touch locationInView:touch.view];
    
    if(!CGRectContainsPoint(self.tagView.frame, point)){return;}// 点不在区域内，return
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

- (void)imageTapAction:(UITapGestureRecognizer *)tap
{
    if (self.isShowTagPoint) {
        
        [self showTagPopView];
    }else{
        [self dismissTagPopView];
    }
}

- (void)showTagPopView
{
    _tagPopView.hidden = NO;
    if (!_tagPopView) {
        CGRect frame;
        frame.size = CGSizeMake(320, 320);
        frame.origin = CGPointMake(0,(self.tagView.bounds.size.height-320)/2);
        self.tagPopView = [[TXWTagPopView alloc]initWithFrame:frame superView:self.tagView];
    }
    _tagPopView.alpha = 1;
    _tagPopView.delegate = self;
    [self.tagView addSubview:_tagPopView];
    
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
    _tagPopView.hidden = YES;
    self.isShowTagPoint = !self.isShowTagPoint;
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
    self.tagView.isShowTagPoint = YES;
    self.tagView.pointIV.hidden = YES;
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
    self.tagView.isShowTagPoint = YES;
    self.tagView.pointIV.hidden = YES;

}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (0 == buttonIndex) {
        [alertView isHidden];
    }else{
        UITextField *nameTF = [alertView textFieldAtIndex:0];
        TXWTextTagModel *tagModel = [TXWTextTagModel new];
        tagModel.text = [nameTF.text isEqualToString:@""]?@"":nameTF.text;
        tagModel.posX = self.tagView.tagPoint.x/self.tagView.frame.size.width;
        tagModel.posY = self.tagView.tagPoint.y/self.tagView.frame.size.height;
        tagModel.direction = 1;
        [self.tagArrs addObject:tagModel];
        [self.tagView reloadData];
//        [self tagLabelShowWithModel:tagModel isEdit:YES];
    }
}

#pragma mark - TXWTagViewDataSource
- (NSInteger)numberOftagViewCellsInTagView:(TXWTagView *)tagView
{
    return self.tagArrs.count;
}

- (UIView<TXWTagViewCellDelegate>*)tagView:(TXWTagView *)tagView tagViewCellAtIndex:(NSInteger)index
{
    TXWTextTagModel *tag = self.tagArrs[index];
    
    TXWTagViewCell *tagViewCell = [[TXWTagViewCell alloc] init];
    tagViewCell.tagModel = tag;
    tagViewCell.tagViewFrame = self.tagView.frame;
//    tagViewCell.titleText = tag.text;
//    tagViewCell.tagViewCellDirection = tag.direction;
//    tagViewCell.centerPointPercentage = CGPointMake(self.tagView.frame.size.width*tag.posX, self.tagView.frame.size.height*tag.posY);
    return tagViewCell;
}

#pragma mark - TXWTagView Delegate
// cell 选中
- (void)tagView:(TXWTagView *)tagView didTappedTagViewCell:(UIView<TXWTagViewCellDelegate> *)tagViewCell atIndex:(NSInteger)index
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除标签" message:@"你确定要删除标签吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = index;
    [alert show];
}

//editMode
- (void)tagView:(TXWTagView *)tagView tagViewCell:(UIView<TXWTagViewCellDelegate> *)tagViewCell didChangedDirection:(TXWTagViewCellDirection)tagViewCellDirection AtIndex:(NSInteger)index
{
    TXWTextTagModel *misc = self.tagArrs[index];
    misc.direction = tagViewCellDirection;
}

// 长按
- (void)tagView:(TXWTagView *)tagView didLongPressedTagViewCell:(UIView<TXWTagViewCellDelegate> *)tagViewCell atIndex:(NSInteger)index
{
    TXWTextTagModel *misc = self.tagArrs[index];
    [tagViewCell reversetagViewCellDirection];
    misc.direction = tagViewCell.tagViewCellDirection;
}

// 移动
- (void)tagView:(TXWTagView *)tagView didMoveTagViewCell:(UIView<TXWTagViewCellDelegate> *)tagViewCell atIndex:(NSInteger)index toNewPositonPercentage:(CGPoint)pointPercentage
{
    TXWTextTagModel *misc = self.tagArrs[index];
    misc.posX = pointPercentage.x/self.tagView.frame.size.width;
    misc.posY = pointPercentage.y/self.tagView.frame.size.height;
}

// 添加
- (void)tagView:(TXWTagView *)tagView addNewTagViewCellTappedAtPosition:(CGPoint)ponit
{
    if (self.tagArrs.count == MAX_TAG_COUNT) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"最多添加5个标签" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
//    self.selectedPoint = ponit;
    
    [self performSegueWithIdentifier:@"showInputTitleVC" sender:self];
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;// 支持多手势
}

#pragma mark - setter
- (UIImageView *)pointIV
{
    
    if (!_pointIV) {
        _pointIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"KK_Filter_hover"]];
        _pointIV.frame= CGRectMake(0, 0, 17, 17);
        [_tagView addSubview:_pointIV];
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

- (TXWTagView *)tagView
{
    if (!_tagView) {
        _tagView = [[TXWTagView alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
        _tagView.dataSource = self;
        _tagView.delegate = self;
    }
    return _tagView;
}

- (NSMutableArray *)tagArrs
{
    if (!_tagArrs) {
        _tagArrs = [NSMutableArray array];
    }
    return _tagArrs;
}

@end
