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
#import "TXWShowPicViewController.h"

#define kTagViewAspectRatio (320/230.0) // 宽高比
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
@property (nonatomic ,assign) NSInteger *tagType;
@end

@implementation TXWTagViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"标签";
    self.isShowTagPoint = YES;
    UIImage *image = [UIImage imageNamed:@"demo"];

    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    _tagView = [[TXWTagView alloc]initWithImageFrame:frame offsexY:64.0f];
    _tagView.dataSource = self;
    _tagView.delegate = self;
    self.tagView.backgroundImageView.image = image;
    self.tagView.userInteractionEnabled = YES;
    [self.view addSubview:_tagView];
    [self initUIBarButtonItem];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - private method

- (void)initUIBarButtonItem
{
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"big_biaoqian_didian"] style:UIBarButtonItemStylePlain target:self action:@selector(showThePic:)];
    self.navigationItem.rightBarButtonItem = item0;
}

- (void)showThePic:(UIBarButtonItem *)sender
{
    TXWShowPicViewController *showVc = [TXWShowPicViewController new];
    showVc.tags = self.tagArrs;
    showVc.bgImage = [UIImage imageNamed:@"demo"];
    NSLog(@"showVc.tagArrs = %d",showVc.tags.count);
    [self.navigationController pushViewController:showVc animated:YES];

}
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSSet *allTouchs = [event allTouches];
//    UITouch *touch = [allTouchs anyObject];
//    CGPoint point = [touch locationInView:touch.view];
//    
//    if(!CGRectContainsPoint(self.tagView.frame, point)){return;}// 点不在区域内，return
//    self.tagPoint = point;
//    
//    if (self.isShowTagPoint) {
//        CGRect frame = self.pointIV.frame;
//        frame.origin = CGPointMake(point.x-17/2, point.y-17/2);
//        self.pointIV.frame = frame;
//        self.pointIV.hidden = NO;
//        
//    }else{
//        
//        self.pointIV.hidden = YES;
//    }
//    
//}

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
    _tagPopView.hidden = NO;
    if (!_tagPopView) {
        CGRect frame;
        frame.size = CGSizeMake(320, 320/kTagViewAspectRatio);
        frame.origin = CGPointMake(0,0);
        self.tagPopView = [[TXWTagPopView alloc]initWithFrame:frame superView:self.tagView];
        self.tagPopView.center = self.tagView.center;
    }
    _tagPopView.alpha = 1;
    _tagPopView.delegate = self;
    [self.view addSubview:_tagPopView];
    
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
    self.tagType = 0;
    [self dismissTagPopView];
    self.tagView.isShowTagPoint = YES;
    self.tagView.pointIV.hidden = YES;
}

- (void)didPeopleTagViewClicked
{
    if (self.tagArrs.count>=MAX_TAG_COUNT) {
        [[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"最多可添加%d条标签",MAX_TAG_COUNT] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
    }else{
        [self.alertView show];
    }
    self.tagType = (NSInteger *)1;
    [self dismissTagPopView];
    self.tagView.isShowTagPoint = YES;
    self.tagView.pointIV.hidden = YES;

}

- (void)tapTagPopView
{
    [self dismissTagPopView];
    self.tagView.isShowTagPoint = YES;
    self.tagView.pointIV.hidden = YES;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 999) {
        if (0 == buttonIndex) {
            [alertView isHidden];
        }else{
            UITextField *nameTF = [alertView textFieldAtIndex:0];
            TXWTextTagModel *tagModel = [TXWTextTagModel new];
            tagModel.text = [nameTF.text isEqualToString:@""]?@"":nameTF.text;
            tagModel.posX = self.tagView.tagPoint.x/self.tagView.frame.size.width;
            tagModel.posY = self.tagView.tagPoint.y/self.tagView.frame.size.height;
            tagModel.tagType = (int)self.tagType;
            if (tagModel.posX>0.5) {
                tagModel.direction = 0;
            }else{
                tagModel.direction = 1;
            }
            
            [self.tagArrs addObject:tagModel];
            [self.tagView reloadData];
            [self.tagView makeTagItemsAnimated];
        }
    }else if (alertView.tag == 1000){
        [alertView isHidden];
    }else{
        if (0 == buttonIndex) {
            [alertView isHidden];
        }else{
            [self.tagArrs removeObjectAtIndex:alertView.tag];
            [self.tagView reloadData];
            [self.tagView makeTagItemsAnimated];
        }
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
    tagViewCell.tagViewCellDirection = tag.direction;
    tagViewCell.centerPointPercentage = CGPointMake(tag.posX, tag.posY);
    return tagViewCell;
}

#pragma mark - TXWTagView Delegate
// cell 选中
- (void)tagView:(TXWTagView *)tagView didTappedtagViewCell:(UIView<TXWTagViewCellDelegate> *)tagViewCell atIndex:(NSInteger)index
{
    if ([tagViewCell checkCanReversetagViewCellDirectionWithContainerSize:self.tagView.frame.size]) {
        TXWTextTagModel *misc = self.tagArrs[index];
        [tagViewCell reversetagViewCellDirection];
        misc.direction = tagViewCell.tagViewCellDirection;
        [self.tagView reloadData];
        [self.tagView makeTagItemsAnimated];
    }
   
}

// editMode
- (void)tagView:(TXWTagView *)tagView tagViewCell:(UIView<TXWTagViewCellDelegate> *)tagViewCell didChangedDirection:(TXWTagViewCellDirection)tagViewCellDirection AtIndex:(NSInteger)index
{
    TXWTextTagModel *misc = self.tagArrs[index];
    misc.direction = tagViewCellDirection;
}

// 长按
- (void)tagView:(TXWTagView *)tagView didLongPressedtagViewCell:(UIView<TXWTagViewCellDelegate> *)tagViewCell atIndex:(NSInteger)index
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除标签" message:@"你确定要删除标签吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = index;
    [alert show];
}

// 移动
- (void)tagView:(TXWTagView *)tagView didMovetagViewCell:(UIView<TXWTagViewCellDelegate> *)tagViewCell atIndex:(NSInteger)index toNewPositonPercentage:(CGPoint)pointPercentage
{
    TXWTextTagModel *misc = self.tagArrs[index];
    misc.posX = pointPercentage.x;
    misc.posY = pointPercentage.y;
}

// 添加
- (void)tagView:(TXWTagView *)tagView addNewtagViewCellTappedAtPosition:(CGPoint)ponit
{
    if (self.tagArrs.count == MAX_TAG_COUNT) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"最多添加5个标签" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (self.tagView.isShowTagPoint) {
        [self showTagPopView];
        self.tagView.pointIV.hidden = NO;
    }else{
        [self dismissTagPopView];
        self.tagView.pointIV.hidden = YES;
    }

//    self.selectedPoint = ponit;
//    [self performSegueWithIdentifier:@"showInputTitleVC" sender:self];
}


#pragma mark - UIGestureRecognizerDelegate
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    return YES;// 支持多手势
//}

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
        _alertView.tag = 999;
        // 设置AlertView样式
        _alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        
    }
    return _alertView;
}

//- (TXWTagView *)tagView
//{
//    if (!_tagView) {
//        _tagView = [[TXWTagView alloc]initWithFrame:CGRectMake(0, 64, 320, 320)];
//        _tagView.dataSource = self;
//        _tagView.delegate = self;
//    }
//    return _tagView;
//}

- (NSMutableArray *)tagArrs
{
    if (!_tagArrs) {
        _tagArrs = [NSMutableArray array];
    }
    return _tagArrs;
}

@end
