//
//  TXWTagViewCell.h
//  TXWTagView
//
//  Created by develop on 15/8/26.
//  Copyright (c) 2015年 develop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXWTagView.h"


@interface TXWTagViewCell : UIView<TXWTagViewCellDelegate>

@property (assign,nonatomic) CGRect tagViewFrame;
- (instancetype)init;
@end
