//
//  APOpenTagView.h
//  HiPhotoFramework
//
//  Created by JerryChui on 5/29/15.
//  Copyright (c) 2015 Appsoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APImgModel;

@class APTextTagModel;

@class APAudioTagModel;

@class APLocationModel;



@protocol APOpenTagViewDelegate <NSObject>

@optional
/*
 文本标签点击
 */
- (void)didTextTagViewClicked:(APTextTagModel *)textTagModel;
/*
 语音标签点击
 */
- (void)didAudioTagViewClicked:(APAudioTagModel *)audioTagModel;
/*
 地理标签点击
 */
- (void)didLocationTagViewClicked:(APLocationModel *)locationModel;

@end


@interface APOpenTagView : UIView


@property (strong, nonatomic) APImgModel *imgModel;

@property (strong, nonatomic) APTextTagModel *textTagModel;

@property (strong, nonatomic) APAudioTagModel *audioTagModel;

@property (strong, nonatomic) APLocationModel *locationTagModel;

@property (weak, nonatomic) id<APOpenTagViewDelegate> delegate;



@end








