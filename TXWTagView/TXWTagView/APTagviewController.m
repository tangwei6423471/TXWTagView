//
//  APTagviewController.m
//  HiPhotoSample
//
//  Created by JerryChui on 4/27/15. Email:strawcrop@qq.com
//  Copyright (c) 2015 Appsoon. All rights reserved.
//

#import "APTagviewController.h"

#import "APTextTagModel.h"

#import "APAudioTagModel.h"

#import "APLocationModel.h"

#import "MJExtension.h"


@interface APTagviewController ()

@end

@implementation APTagviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //提交上传按钮
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(postBtnClicked)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

//上传按钮点击方法
- (void)postBtnClicked{

    if (self.textTagModelArray.count > 0 || self.audioTagModelArray.count > 0 || self.locationTagModelArray.count ) {
        [self sendPhoto:@"http://182.92.104.143:8080/HiPhotoServer/mobile/upLoadPhotos.htm"  prams:nil];
    }else{
        [MBProgressHUD showText:@"请至少添加一种标签"];
    }
    
}
/*
*上传方法
*/
- (void)sendPhoto:(NSString *)url prams:(NSMutableDictionary *) param{
    //loading
    [MBProgressHUD loading];
    
    //1.文本标签
    NSString *textTagJson = @"";
    if (self.textTagModelArray.count > 0) {
        NSArray *arryData = [APTextTagModel keyValuesArrayWithObjectArray:self.textTagModelArray];
        NSError *errorl;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arryData options:NSJSONWritingPrettyPrinted error:&errorl];
        textTagJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    //2.语音标签
    NSString *audioTagJson = @"";
    if (self.audioTagModelArray.count > 0) {
        NSArray *arryData = [APAudioTagModel keyValuesArrayWithObjectArray:self.audioTagModelArray];
        NSError *errorl;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arryData options:NSJSONWritingPrettyPrinted error:&errorl];
        audioTagJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    //3.地理标签
    NSString *locationTagJson = @"";
    if (self.locationTagModelArray.count > 0) {
        NSArray *arryData = [APLocationModel keyValuesArrayWithObjectArray:self.locationTagModelArray];
        NSError *errorl;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arryData options:NSJSONWritingPrettyPrinted error:&errorl];
        locationTagJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    /*=======================图片====================*/
    //1.随机图片名参数
    int NUMBER_OF_CHARS = 26;
    char data[NUMBER_OF_CHARS];
    for (int x=0;x<NUMBER_OF_CHARS;data[x++] = (char)('A' + (arc4random_uniform(26))));
    NSString *randomStr = [[NSString alloc] initWithBytes:data length:NUMBER_OF_CHARS encoding:NSUTF8StringEncoding];
    //2.日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *dataStr = [formatter stringFromDate:[NSDate date]];
    //3.imgid
    NSString *imgId = [NSString stringWithFormat:@"%@%@", dataStr,randomStr];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", imgId];
    // 4.封装文件参数
    NSMutableArray *formDataArray = [NSMutableArray array];
    
    // 5.封装图片文件参数
    APFormData *formData = [[APFormData alloc] init];
    UIImage *image = self.hiPhotoImage;
    formData.data = UIImageJPEGRepresentation(image, 0.5);
    formData.name = @"image";
    formData.mimeType = @"image/jpeg";
    formData.filename = fileName;
    [formDataArray addObject:formData];
    /*=====================音频======================*/
    //封装Audio
    for (NSString *voicePath in self.fileArray) {
        NSString *audioDateStr = [formatter stringFromDate:[NSDate date]];
        NSString *audioFilename = [NSString stringWithFormat:@"%@.amr", audioDateStr];
        NSData *audata = [NSData dataWithContentsOfFile:voicePath];
        if (audata != nil) {
            APFormData *audioData = [[APFormData alloc] init];
            audioData.data = audata;
            audioData.name = @"audio";
            audioData.mimeType = @"audio/amr";
            audioData.filename = audioFilename;
            [formDataArray addObject:audioData];
        }
        
    }
    //参数
    params[@"imgID"] = imgId;
    params[@"textTag"] = textTagJson;
    params[@"audioTag"] = audioTagJson;
    params[@"locationTag"] = locationTagJson;
    if (param.count) {
        [params addEntriesFromDictionary:param];
    }
    
    //    NSLog(@"textTagJson:%@",textTagJson);
    //网路请求 @"http://182.92.104.143:8080/HiPhotoServer/mobile/upLoadPhotos.htm"
    [APHttpTool postWithURL:url params:params formDataArray:formDataArray success:^(id json) {
        
        
        [MBProgressHUD hideHUD];
        if ([self.delegate respondsToSelector:@selector(didPostSuceed:)]) {
            [self.delegate didPostSuceed:self];
            NSLog(@"发布成功");
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        if ([self.delegate respondsToSelector:@selector(didPostFaild:)]) {
            [self.delegate didPostFaild:self];
        }
        NSLog(@"error:%@",error);
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
