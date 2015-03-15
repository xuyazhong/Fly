//
//  DetailViewController.h
//  weico
//
//  Created by xyz on 15-3-1.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetModel.h"

@interface DetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIViewController *vc1;
@property (nonatomic,strong) UIViewController *vc2;
@property (nonatomic,strong) UIViewController *vc3;
@property (nonatomic,strong) NSMutableArray *data1;
@property (nonatomic,strong) NSMutableArray *data2;
@property (nonatomic,strong) NSMutableArray *data3;
@property (nonatomic,strong) TweetModel *model;

@end
