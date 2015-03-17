//
//  MeCell.m
//  fly
//
//  Created by xuyazhong on 15/3/10.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "MeCell.h"
#import "AFNetworking.h"
#import "DXAlertView.h"

@implementation MeCell
{
    SuccessDeleTweet _successBlock;
    FailedDeleTweet _failBlock;
}
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
    _deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleBtn setFrame:CGRectMake(270, 10, 30, 20)];
    [_deleBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _deleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [headView addSubview:_deleBtn];
    [headView addSubview:_userInfo];
    [headView addSubview:_nickName];
    [headView addSubview:_timeLabel];
    [headView addSubview:_sourceLabel];
    [self.contentView addSubview:headView];
}

-(void)addDeleteCommentSuccess:(SuccessDeleTweet)success failed:(FailedDeleTweet)failed
{
    [_deleBtn addTarget:self action:@selector(deleCommentAlertView) forControlEvents:UIControlEventTouchUpInside];
    _successBlock = success;
    _failBlock = failed;
    NSLog(@"add target!!!");
}
-(void)addDeleteTweetSuccess:(SuccessDeleTweet)success failed:(FailedDeleTweet)failed
{
    [_deleBtn addTarget:self action:@selector(deleAlertView) forControlEvents:UIControlEventTouchUpInside];
    _successBlock = success;
    _failBlock = failed;
    NSLog(@"add target!!!");
}
-(void)deleCommentAlertView
{
    DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"确认删除吗？" contentText:@"确认删除吗？" leftButtonTitle:@"删除" rightButtonTitle:@"取消"];
    [alert show];
    alert.leftBlock = ^()
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[ShareToken readToken],@"access_token",self.model.tid,@"cid", nil];
        [manager POST:kURLCommentDelete parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"删除成功");
             _successBlock(YES);
             NSLog(@"delete success:%@",responseObject);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             _failBlock(NO);
             NSLog(@"删除失败:%@",error);
         }];
        
    };
    alert.rightBlock = ^() {
        NSLog(@"取消");
        _failBlock(NO);
    };
}
-(void)deleAlertView
{
    DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"确认删除吗？" contentText:@"确认删除吗？" leftButtonTitle:@"删除" rightButtonTitle:@"取消"];
    [alert show];
    alert.leftBlock = ^()
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[ShareToken readToken],@"access_token",self.model.tid,@"id", nil];
        [manager POST:kURLTweetDelete parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"删除");
             _successBlock(YES);
             NSLog(@"delete success:%@",responseObject);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"删除失败:%@",error);
         }];
        
    };
    alert.rightBlock = ^() {
        NSLog(@"取消");
        _failBlock(NO);
    };
}

-(void)createTweet
{
    _tweetLabel = [[STTweetLabel alloc]initWithFrame:CGRectMake(10, 70, 300, 80)];
    [self.contentView addSubview:_tweetLabel];
    
}
-(void)createTweetImage
{
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
    
    _retweetLabel = [[STTweetLabel alloc] initWithFrame:CGRectMake(10, 0, 300, 80)];
    [_retweetView addSubview:_retweetLabel];
    
  
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
