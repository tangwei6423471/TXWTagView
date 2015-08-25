//
//  APMakerViewController.h
//  HiPhotoFramework
//
//  Created by JerryChui on 4/27/15. Email:strawcrop@qq.com
//  Copyright (c) 2015 Appsoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APMakerViewController;

@protocol APMakerViewControllerDelegate <NSObject>

@optional

- (void)didPostSuceed:(APMakerViewController *) makerViewController;

- (void)didPostFaild:(APMakerViewController *) makerViewController;



@end

@interface APMakerViewController : UIViewController

/*
 *标签的代理方法 delegate
 */

@property (assign, nonatomic) id<APMakerViewControllerDelegate> delegate;


/*
 *需要标记的图片
 *parms hiPhotoImage 需要编辑的图片
 */
@property (strong, nonatomic) UIImage *hiPhotoImage;


/*
 *发布图片的方法
 *
 *url=ip+port 你自己服务器的IP
 *
 *param 附加的参数以key－value形式 
 * NSMutableDictionary *params = [NSMutableDictionary dictionary];
 * params[@"username"] = @"userkeydlsaf;dslkafd";
 * 没有就传nil
 */

- (void)uploadTagImagesWithURL:(NSString *)url prams:(NSMutableDictionary *) param;

/*
 *关闭
 *
 */
- (void)dismiss;

/**
 *  @brief  存储 文本标签Model 数组
 *  @since 1.1
 */
@property (strong, nonatomic) NSMutableArray *textTagModelArray;

/**
 *  @brief  存储 语音标签Model 数组
 *  @since 1.1
 */
@property (strong, nonatomic) NSMutableArray *audioTagModelArray;

/**
 *  @brief  存储 地理位置标签Model 数组
 *  @since 1.1
 */
@property (strong, nonatomic) NSMutableArray *locationTagModelArray;


/**
 *  @brief  存储 语音文件 数组
 *  语音文件数组和语音标签 顺序相同
 *  @since 1.1
 */
@property (strong, nonatomic) NSMutableArray *fileArray;


@end
