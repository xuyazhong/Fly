//
//  UserProfileViewController.h
//  fly
//
//  Created by xyz on 15-3-16.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "TweetModel.h"



@interface UserProfileViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate>

@property (nonatomic,strong)UIImageView *profileImageView;
@property (nonatomic,strong)UIImageView *coverImageView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *followCount;
@property (nonatomic,strong)UILabel *fansCount;
@property (nonatomic,strong)UILabel *profile;
@property (nonatomic,strong)UIButton *followBtn;
@property (nonatomic,assign) BOOL isFollow;
@property (nonatomic,copy)NSString *uid;

@end
