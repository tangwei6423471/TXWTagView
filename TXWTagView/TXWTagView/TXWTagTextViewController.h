//
//  TXWTagTextViewController.h
//  qgzh
//
//  Created by niko on 15/9/12.
//  Copyright (c) 2015年 jiaodaocun. All rights reserved.
//

#import "BaseViewController.h"

@interface TXWTagTextViewController : BaseViewController
@property (nonatomic, assign) BOOL isPeopleTagType;
@property (nonatomic ,strong) void (^callback)(NSString *tagText);
@end
