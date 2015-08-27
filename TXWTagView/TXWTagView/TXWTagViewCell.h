//
//  TXWTagViewCell.h
//  TXWTagView
//
//  Created by develop on 15/8/26.
//  Copyright (c) 2015年 develop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXWTagView.h"
#import "TXWTextTagModel.h"

@interface TXWTagViewCell : UIView<TXWTagViewCellDelegate>
@property (strong,nonatomic) TXWTextTagModel *tagModel;// 传值
@property (assign,nonatomic) CGRect tagViewFrame;
- (instancetype)init;
@end
