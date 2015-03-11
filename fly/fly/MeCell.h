//
//  MeCell.h
//  fly
//
//  Created by xuyazhong on 15/3/10.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

#import "TweetModel.h"

typedef void(^SuccessDeleTweet)(BOOL result);
typedef void(^FailedDeleTweet)(BOOL ret);

@interface MeCell : SWTableViewCell<SWTableViewCellDelegate>

@property (strong, nonatomic)  UIImageView *userInfo;
@property (nonatomic,copy) NSString *tid;
@property (nonatomic,assign) BOOL isDelete;
@property (nonatomic,assign) BOOL isDestroy;
@property (nonatomic,assign) BOOL isSuccess;
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
@property (strong,nonatomic)  UIButton *deleBtn;
@property (nonatomic,strong) TweetModel *model;


-(void)addDeleteCommentSuccess:(SuccessDeleTweet)success failed:(FailedDeleTweet)failed;
-(void)addDeleteTweetSuccess:(SuccessDeleTweet)success failed:(FailedDeleTweet)failed;

@end
