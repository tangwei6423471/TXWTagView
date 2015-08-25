//
//  TXWTagView.h
//  TXWTagView
//
//  Created by develop on 15/8/25.
//  Copyright (c) 2015年 develop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXWTextTagModel.h"

/*
 1.20汉字40字符
 2.最多5个标签
 3.根据点的位置，右边能显示不完。就左边。都显示不完就省略号
 4.移动不能出图片
 5.如果另一个方向width小于当前label width，不能翻转
 */

@interface TXWTagView : UIView
// frame:imageview
- (instancetype)initWithModel:(id)model frame:(CGRect)frame;
@end
