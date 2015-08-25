//
//  APLocationModel.h
//  HiPhotoFramework
//
//  Created by JerryChui on 5/28/15.
//  Copyright (c) 2015 Appsoon. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

/*
 "imgKey": 5,
 "locationY": 12.5,
 "posX": 30.5,
 "posY": 450,
 "locationX": 50,
 "ID": 5,
 "text": "????",
 "direction": 1
 */

@interface APLocationModel : NSObject

@property (nonatomic, assign) NSInteger imgKey;

@property (nonatomic, assign) CGFloat posX;

@property (nonatomic, assign) CGFloat posY;

@property (nonatomic, assign) CGFloat locationX;

@property (nonatomic, assign) CGFloat locationY;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) NSInteger direction;

@property (nonatomic, copy) NSString* text;


@end
