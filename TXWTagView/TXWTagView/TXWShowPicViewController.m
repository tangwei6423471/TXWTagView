//
//  TXWShowPicViewController.m
//  TXWTagView
//
//  Created by develop on 15/8/31.
//  Copyright (c) 2015年 develop. All rights reserved.
//

#import "TXWShowPicViewController.h"
#import "TXWTagView.h"
#import "TXWTagViewCell.h"
#import "TXWTextTagModel.h"

@interface TXWShowPicViewController ()<TXWTagViewDataSource,TXWTagViewDelegate>
@property (strong,nonatomic) TXWTagView *tagView;
@end

@implementation TXWShowPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"标签";
    self.navigationController.navigationBar.translucent = YES;
    _tagView = [[TXWTagView alloc]initWithFrame:self.view.frame];
    _tagView.dataSource = self;
    _tagView.delegate = self;
    _tagView.viewMode = TXWTagViewModePreview;
    self.tagView.backImage = self.bgImage;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tagView.userInteractionEnabled = YES;
    [self.view addSubview:self.tagView];
    [self.tagView reloadData];
    [self.tagView makeTagItemsAnimated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TXWTagViewDataSource
- (NSInteger)numberOftagViewCellsInTagView:(TXWTagView *)tagView
{
    NSLog(@"numberOftagViewCells = %d ",self.tags.count);
    return self.tags.count;
}

- (UIView<TXWTagViewCellDelegate>*)tagView:(TXWTagView *)tagView tagViewCellAtIndex:(NSInteger)index
{
    TXWTextTagModel *tag = self.tags[index];
    
    TXWTagViewCell *tagViewCell = [[TXWTagViewCell alloc] init];
    tagViewCell.tagText = tag.text;
    tagViewCell.tagType = [NSNumber numberWithInt:tag.tagType];
    tagViewCell.tagViewCellDirection = tag.direction;
    tagViewCell.tagViewFrame = self.tagView.frame;
    tagViewCell.centerPointPercentage = CGPointMake(tag.posX, tag.posY);
    return tagViewCell;
}

#pragma mark - TXWTagView Delegate
// cell 选中
- (void)tagView:(TXWTagView *)tagView didTappedtagViewCell:(UIView<TXWTagViewCellDelegate> *)tagViewCell atIndex:(NSInteger)index
{
    
    
}

//editMode
- (void)tagView:(TXWTagView *)tagView tagViewCell:(UIView<TXWTagViewCellDelegate> *)tagViewCell didChangedDirection:(TXWTagViewCellDirection)tagViewCellDirection AtIndex:(NSInteger)index
{
    TXWTextTagModel *misc = self.tags[index];
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
    TXWTextTagModel *misc = self.tags[index];
    misc.posX = pointPercentage.x;
    misc.posY = pointPercentage.y;
}

#pragma mark - setter


@end
