//
//  APTextTagModel.h
//  HiPhotoFramework
//
//  Created by JerryChui on 5/28/15.
//  Copyright (c) 2015 Appsoon. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kTagNomal,
    kTagLocation,
    kTagPeople,
} TagType;

/*
 
 "imgKey": 5,
 "posX": 10,
 "posY": 20,
 "ID": 5,
 "text": "????",
 "direction": 1
 */

@interface TXWTextTagModel : NSObject

@property (nonatomic, assign) NSInteger imgKey;

@property (nonatomic, assign) CGFloat posX;

@property (nonatomic, assign) CGFloat posY;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) NSInteger direction;// left0,right1

@property (nonatomic, copy) NSString* text;

@property (nonatomic,assign) NSInteger tagType;// 根据type显示icon

@end
