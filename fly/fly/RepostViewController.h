//
//  RepostViewController.h
//  weico
//
//  Created by xuyazhong on 15/2/25.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetModel.h"

@interface RepostViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic,strong) TweetModel *model;

@end
