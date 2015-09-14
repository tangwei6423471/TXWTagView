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
#import "TXWShowPicViewController.h"
#import "TXWTextTagModel.h"
#import "TXWTagTextViewController.h"

#define MAX_TAG_COUNT 5

@interface TXWTagViewController ()<TXWTagViewDataSource,TXWTagViewDelegate>

@property (strong,nonatomic) UIAlertView *alertView;// debug 弹框输入标签
@property (strong,nonatomic) NSMutableArray *tagArrs;// 存储标签model
@property (strong,nonatomic) TXWTagView *tagView;
@property (nonatomic ,strong) NSNumber *tagType;
@end

@implementation TXWTagViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"标签";
    UIImage *image = [UIImage imageNamed:@"demo"];

    _tagView = [[TXWTagView alloc]initWithFrame:self.view.frame];
    _tagView.dataSource = self;
    _tagView.delegate = self;
    self.tagView.backImage = image;
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


#pragma mark - TXWTagPopViewDelegate
- (void)didTextTagViewClickedType:(NSNumber *)tagType
{
    if (self.tagArrs.count>=MAX_TAG_COUNT) {
        [[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"最多可添加%d条标签",MAX_TAG_COUNT] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
    }else{
        self.tagType = tagType;
        TXWTagTextViewController *vc = [[TXWTagTextViewController alloc]init];
        vc.callback = ^(NSString *tagText){
            TXWTextTagModel *tagModel = [TXWTextTagModel new];
            tagModel.text = tagText;
            tagModel.posX = self.tagView.tagPoint.x/self.tagView.frame.size.width;
            tagModel.posY = self.tagView.tagPoint.y/self.tagView.frame.size.height;
            tagModel.tagType = [_tagType integerValue];
            if (tagModel.posX>0.5) {
                tagModel.direction = 0;
            }else{
                tagModel.direction = 1;
            }
            
            [self.tagArrs addObject:tagModel];
            [self.tagView reloadData];
            [self.tagView makeTagItemsAnimated];
        };
        vc.isPeopleTagType = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (void)didPeopleTagViewClickedType:(NSNumber *)tagType
{
    if (self.tagArrs.count>=MAX_TAG_COUNT) {
        [[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"最多可添加%d条标签",MAX_TAG_COUNT] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
    }else{
        self.tagType = tagType;
        TXWTagTextViewController *vc = [[TXWTagTextViewController alloc]init];
        vc.callback = ^(NSString *tagText){
            TXWTextTagModel *tagModel = [TXWTextTagModel new];
            tagModel.text = tagText;
            tagModel.posX = self.tagView.tagPoint.x/self.tagView.frame.size.width;
            tagModel.posY = self.tagView.tagPoint.y/self.tagView.frame.size.height;
            tagModel.tagType = [_tagType integerValue];
            if (tagModel.posX>0.5) {
                tagModel.direction = 0;
            }else{
                tagModel.direction = 1;
            }
            
            [self.tagArrs addObject:tagModel];
            [self.tagView reloadData];
            [self.tagView makeTagItemsAnimated];
        };

        vc.isPeopleTagType = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
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
            tagModel.tagType = [_tagType integerValue];
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
    tagViewCell.tagText = tag.text;
    tagViewCell.tagType = [NSNumber numberWithInt:tag.tagType];

//    tagViewCell.tagViewFrame = self.tagView.frame;
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
    //    if (self.tagView.isShowTagPoint) {
    //        [self showTagPopView];
    //        self.tagView.pointIV.hidden = NO;
    //    }else{
    //        [self dismissTagPopView];
    //        self.tagView.pointIV.hidden = YES;
    //    }
    
    //    self.selectedPoint = ponit;
    //    [self performSegueWithIdentifier:@"showInputTitleVC" sender:self];


}

#pragma mark - setter

- (UIAlertView *)alertView{
    if (!_alertView) {
        _alertView = [[UIAlertView alloc]initWithTitle:@"添加标签"message:@"请为新标签输入名称"delegate:self cancelButtonTitle:@"取消"otherButtonTitles:@"确定", nil];
        _alertView.tag = 999;
        // 设置AlertView样式
        _alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        
    }
    return _alertView;
}


- (NSMutableArray *)tagArrs
{
    if (!_tagArrs) {
        _tagArrs = [NSMutableArray array];
    }
    return _tagArrs;
}

@end
