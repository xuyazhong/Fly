//
//  TweetCell.h
//  Weico
//
//  Created by xuyazhong on 15/2/19.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TweetCell : UITableViewCell
@property (strong, nonatomic)  UIImageView *userInfo;
@property (strong, nonatomic)  UILabel *nickName;
@property (strong, nonatomic)  UILabel *timeLabel;
@property (strong, nonatomic)  UILabel *sourceLabel;
@property (strong, nonatomic)  UILabel *tweetLabel;
@property (strong, nonatomic)  UIButton *forward;
@property (strong, nonatomic)  UIButton *comment;
@property (strong, nonatomic)  UIButton *like;
//@property (strong, nonatomic)  UIImageView *tweetImage;
@property (strong, nonatomic)  UIView *controlview;
@property (strong, nonatomic)  UIView *retweetView;
@property (strong, nonatomic)  UILabel *retweetLabel;
//@property (strong, nonatomic)  UIImageView *retweetImage;
@property (strong, nonatomic)  UIScrollView *myscrollview;
@property (strong, nonatomic)  UIScrollView *rescrollview;
@property (strong, nonatomic)  UILabel *repostsCount;
@property (strong, nonatomic)  UILabel *commentsCount;


@end
