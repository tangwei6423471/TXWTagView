//
//  TXWTagViewHelper.h
//  TXWTagView
//
//  Created by develop on 15/8/26.
//  Copyright (c) 2015年 develop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 *  图片资源集中修改设置的地方，便于修改
 */
@interface TXWTagViewHelper : NSObject
+ (BOOL)osVersionIsiOS8;
+ (NSString *)tagIconImageNameTypeNomal;
+ (NSString *)tagIconImageNameTypeLocation;
+ (NSString *)tagIconImageNameTypePeople;
+ (NSString *)tagLeftBgImageName;
+ (NSString *)tagRightBgImageName;
+ (NSString *)tagPopViewButtonImageTypeNomal;
+ (NSString *)tagPopViewButtonImageTypePeople;
+ (NSString *)tagPopViewButtonImageTypeLocation;
@end
