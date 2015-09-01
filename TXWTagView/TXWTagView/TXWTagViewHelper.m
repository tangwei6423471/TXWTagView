//
//  TXWTagViewHelper.m
//  TXWTagView
//
//  Created by develop on 15/8/26.
//  Copyright (c) 2015年 develop. All rights reserved.
//

#import "TXWTagViewHelper.h"

@implementation TXWTagViewHelper
+ (BOOL)osVersionIsiOS8 {
    static int systemMajorVersion = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString* version = [[UIDevice currentDevice] systemVersion];
        systemMajorVersion = [[version componentsSeparatedByString:@"."][0] intValue];
    });
    return systemMajorVersion >= 8;
}

+ (NSString *)tagIconImageNameTypeNomal
{
    return @"big_biaoqian_dian";
}
+ (NSString *)tagIconImageNameTypeLocation
{
    return @"big_biaoqian_didian";
}
+ (NSString *)tagIconImageNameTypePeople
{
    return @"big_biaoqian_ren";
}

+ (NSString *)tagLeftBgImageName {
    return @"tagViewBg_left";
}

+ (NSString *)tagRightBgImageName {
    return @"tagViewBg_right";
}

+ (NSString *)tagPopViewButtonImageTypeNomal
{
    return @"Filter_icon_brand";
}
+ (NSString *)tagPopViewButtonImageTypePeople
{
    return @"KK_Brand_Tag_point_black";
}
+ (NSString *)tagPopViewButtonImageTypeLocation
{
    return @"Filter_icon_Location";
}
@end
