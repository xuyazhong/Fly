//
//  UserProfileViewController.h
//  fly
//
//  Created by xyz on 15-3-16.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileViewController : UIViewController

@property (nonatomic)UIImageView *profileImageView;
@property (nonatomic)UIImageView *coverImageView;
@property (nonatomic)UILabel *titleLabel;
@property (nonatomic,copy)NSString *uid;

@end
