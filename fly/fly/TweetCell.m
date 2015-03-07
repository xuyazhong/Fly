//
//  TweetCell.m
//  Weico
//
//  Created by xuyazhong on 15/2/19.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "TweetCell.h"
#import "DeviceManager.h"

@implementation TweetCell

- (void)awakeFromNib
{
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createUI];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)createUI
{
    [self createUserInfo];
    [self createTweet];
    [self createTweetImage];
    [self createRetweet];
    [self createButton];
}
-(void)createUserInfo
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 75)];
    _userInfo = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
    _nickName = [[UILabel alloc]initWithFrame:CGRectMake(70, 10,200, 20)];
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 35, 120, 10)];
    _sourceLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 35, 120, 10)];
    [headView addSubview:_userInfo];
    [headView addSubview:_nickName];
    [headView addSubview:_timeLabel];
    [headView addSubview:_sourceLabel];
    [self.contentView addSubview:headView];
}
-(void)createTweet
{
    _tweetLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 300, 80)];
    [self.contentView addSubview:_tweetLabel];
    
}
-(void)createTweetImage
{
//    _tweetImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 150, 80, 80)];
//    [self.contentView addSubview:_tweetImage];
    
    _myscrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 150, 300, 80)];
    _myscrollview.showsVerticalScrollIndicator = NO;
    _myscrollview.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:_myscrollview];
}

-(void)createRetweet
{
    _retweetView = [[UIView alloc]initWithFrame:CGRectMake(0, 230, 320, 160)];
    _retweetView.backgroundColor = [UIColor colorWithRed:155/255.0f green:155/255.0f blue:155/255.0f alpha:0.1];
    //_retweetView.backgroundColor = [UIColor grayColor];
    //_retweetView.alpha = 0.5;
    
    _retweetLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 80)];
    [_retweetView addSubview:_retweetLabel];
    
    //_retweetImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 80, 80, 80)];
    //[_retweetView addSubview:_retweetImage];
    
    _rescrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 80, 300, 80)];
    _rescrollview.showsVerticalScrollIndicator = NO;
    _rescrollview.showsHorizontalScrollIndicator = NO;
    [_retweetView addSubview:_rescrollview];
    [self.contentView addSubview:_retweetView];
}
-(void)createButton
{
    _controlview = [[UIView alloc] initWithFrame:CGRectMake(10, 390, [DeviceManager currentScreenSize].width-20, 40)];
    _controlview.userInteractionEnabled = YES;
    [self.contentView addSubview:_controlview];
    
    UIImageView *repostImageview = [[UIImageView alloc] initWithFrame:CGRectMake([DeviceManager currentScreenSize].width-100, 10, 10, 10)];
    [repostImageview setImage:[UIImage imageNamed:@"t_repost"]];
    [_controlview addSubview:repostImageview];
    
    _repostsCount = [[UILabel alloc] initWithFrame:CGRectMake([DeviceManager currentScreenSize].width-90, 5,50, 20)];
    [_controlview addSubview:_repostsCount];
    
    UIImageView *commentImageview = [[UIImageView alloc]initWithFrame:CGRectMake([DeviceManager currentScreenSize].width-60, 10, 10, 10)];
    [commentImageview setImage:[UIImage imageNamed:@"t_comments"]];
    [_controlview addSubview:commentImageview];
    
    _commentsCount = [[UILabel alloc] initWithFrame:CGRectMake([DeviceManager currentScreenSize].width-50, 5,50, 20)];
    [_controlview addSubview:_commentsCount];
    
    
    //    _forward = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    _forward.frame = CGRectMake(0, 0, 100, 30);
    //    [_forward setTitle:@"转发" forState:UIControlStateNormal];
    //    [_forward addTarget:self action:@selector(repostAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [_controlview addSubview:_forward];
//    
//    _comment = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    _comment.frame = CGRectMake(100, 0, 100, 30);
//    [_comment setTitle:@"评论" forState:UIControlStateNormal];
//    [_comment addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
//    [_controlview addSubview:_comment];
//    
//    _like = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    _like.frame = CGRectMake(200, 0, 100, 30);
//    [_like setTitle:@"赞" forState:UIControlStateNormal];
//    [_like addTarget:self action:@selector(favAction:) forControlEvents:UIControlEventTouchUpInside ];
//    [_controlview addSubview:_like];
//    
    
}
-(void)repostAction:(UIButton *)btn
{
    NSLog(@"repost!!");
    //Repost *repost = [[Repost alloc]init];
    
}
-(void)commentAction:(UIButton *)btn
{
    NSLog(@"comment!!");
}
-(void)favAction:(UIButton *)btn
{
    NSLog(@"fav!!");
}

@end
