//
//  APImgModel.h
//  HiPhotoFramework
//
//  Created by JerryChui on 5/30/15.
//  Copyright (c) 2015 Appsoon. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 "id": 5,
 "imgID": "20150529194153DAGDGUGKUNODWYUDILUJFGWIFW",
 "imgPath": "http://localhost:8080/HiPhotoServer//upload/20150529194153DAGDGUGKUNODWYUDILUJFGWIFW.jpg"
 */
@interface APImgModel : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString* imgID;

@property (nonatomic, copy) NSString* imgPath;

@end
