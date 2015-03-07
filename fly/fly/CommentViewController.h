//
//  CommentViewController.h
//  weico
//
//  Created by xuyazhong on 15/3/2.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetModel.h"

@interface CommentViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic,strong) TweetModel *model;

@end
