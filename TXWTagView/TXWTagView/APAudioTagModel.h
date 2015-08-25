//
//  APAudioTagModel.h
//  HiPhotoFramework
//
//  Created by JerryChui on 5/28/15.
//  Copyright (c) 2015 Appsoon. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

/*
 "imgKey": 5,
 "posX": 100,
 "posY": 200,
 "ID": 5,
 "audioPath": "dsafdsafdsafdsafa",
 "direction": 0
 */

@interface APAudioTagModel : NSObject

@property (nonatomic, assign) NSInteger imgKey;

@property (nonatomic, assign) CGFloat posX;

@property (nonatomic, assign) CGFloat posY;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) NSInteger direction;

@property (nonatomic, copy) NSString* audioPath;


@end
