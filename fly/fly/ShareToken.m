//
//  ShareToken.m
//  Weico
//
//  Created by xuyazhong on 15/2/18.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "ShareToken.h"
#import "AFNetworking.h"

@implementation ShareToken
{
    BOOL isChecked;
    AVAudioPlayer *_audioPlayer;
}
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

-(void)setToken:(NSString *)token
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"write token%@",token);
    _token = token;
    NSArray *arr = [NSArray arrayWithObject:_token];
    [defaults setObject:arr forKey:@"tk"];
    [defaults synchronize];
}
+(void)setUserInfo:(NSDictionary *)dict
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"write userinfo");
    [defaults setObject:dict forKey:@"userinfo"];
    [defaults synchronize];
}
-(NSDictionary *)readUserDetail
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"userDetail"];
}
+(NSDictionary *)readUserDetail
{
    return [[ShareToken sharedToken] readUserDetail];
}
-(void)setUserDetail:(NSDictionary *)dict
{
    NSLog(@"user Detail begin");
    NSDictionary *mydict = [NSDictionary dictionaryWithObjectsAndKeys:[ShareToken readToken],@"access_token",[dict objectForKey:@"uid"],@"uid", nil];
    NSLog(@"mydict:%@",mydict);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc]init];
    [manager GET:kURLShowMe parameters:mydict success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [userDict setObject:[responseObject objectForKey:@"idstr"] forKey:@"idstr"];
        [userDict setObject:[responseObject objectForKey:@"name"] forKey:@"name"];
        [userDict setObject:[responseObject objectForKey:@"location"] forKey:@"location"];
        [userDict setObject:[responseObject objectForKey:@"description"] forKey:@"description"];
        [userDict setObject:[responseObject objectForKey:@"url"] forKey:@"url"];
        [userDict setObject:[responseObject objectForKey:@"profile_image_url"] forKey:@"profile_image_url"];
        [userDict setObject:[responseObject objectForKey:@"profile_url"] forKey:@"profile_url"];
        [userDict setObject:[responseObject objectForKey:@"followers_count"] forKey:@"followers_count"];
        [userDict setObject:[responseObject objectForKey:@"friends_count"] forKey:@"friends_count"];
        [userDict setObject:[responseObject objectForKey:@"statuses_count"] forKey:@"statuses_count"];
        [userDict setObject:[responseObject objectForKey:@"favourites_count"] forKey:@"favourites_count"];
        [userDict setObject:[responseObject objectForKey:@"domain"] forKey:@"domain"];
        NSLog(@"userDetail:%@",userDict);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSLog(@"write userDetail");
        [defaults setObject:userDict forKey:@"userDetail"];
        [defaults synchronize];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"user Detail write failed");
    }];
}
+(NSDictionary *)readUserInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //NSLog(@"read userinfo");
    NSDictionary *info = [defaults objectForKey:@"userinfo"];
    //NSLog(@"info:%@",info);
    return info;
}
-(void)logout
{
    NSLog(@"logout");
    _token = nil;
}
+(NSString *)readToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [defaults objectForKey:@"tk"];
    NSString *tk = [arr lastObject];
    if (tk)
    {
        return tk;
    }else
        return nil;
}
-(NSString *)tk
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [defaults objectForKey:@"tk"];
    NSString *tk = [arr lastObject];
    _token = tk;
    NSLog(@"read token :%@",_token);
    if (_token)
    {
        return _token;
    }else
        return nil;
}
+(ShareToken *)sharedToken
{
    static ShareToken *token = nil;
    if (token == nil )
    {
        token = [[ShareToken alloc]init];
        token.isBusy = NO;
    }
    return token;
}


+(void)checkin
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"checkin_alarm" ofType:@"caf"];
    [[ShareToken sharedToken] loadAudioWithPath:path];
}
+(void)messageReceive
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"messageReceived" ofType:@"aiff"];
    [[ShareToken sharedToken] loadAudioWithPath:path];
}
+(void)messageSend
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"messageSent" ofType:@"aiff"];
    [[ShareToken sharedToken] loadAudioWithPath:path];
}
+(void)recMsg
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"rec_msg" ofType:@"caf"];
    [[ShareToken sharedToken] loadAudioWithPath:path];
}
+(void)recMsgShort
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"rec_msg_short" ofType:@"caf"];
    [[ShareToken sharedToken] loadAudioWithPath:path];
}
+(void)sendMsg
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"send_msg" ofType:@"caf"];
    [[ShareToken sharedToken] loadAudioWithPath:path];
}
+(void)timeLimit
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"time_limit" ofType:@"caf"];
    [[ShareToken sharedToken] loadAudioWithPath:path];
}
-(void)loadAudioWithPath:(NSString *)audioPath
{
    if (audioPath.length == 0)
    {
        NSLog(@"没有音频资源");
        return;
    }
    //本地的资源路径转化成URL用fileURLWithPath
    NSURL *url = [NSURL fileURLWithPath:audioPath];
    //上一首歌的播放对象存在,销毁掉
    if (_audioPlayer)
    {
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
    _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    //设置代理
    _audioPlayer.delegate = self;
    //准备播放
    [_audioPlayer prepareToPlay];
    //播放
    [_audioPlayer play];
    //    [_audioPlayer pause];//暂停
    //    [_audioPlayer stop];//停止
    
}
//停掉音频播放器
-(void)stopAudioPlayer
{
    if (_audioPlayer)
    {
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
}

@end
