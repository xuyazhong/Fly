//
//  ShareToken.h
//  Weico
//
//  Created by xuyazhong on 15/2/18.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface ShareToken : NSObject<AVAudioPlayerDelegate>

@property (nonatomic,copy) NSString *token;
@property (nonatomic,assign) BOOL isBusy;
-(void)setToken:(NSString *)token;
-(NSString *)tk;
+(NSString *)readToken;
+(NSDictionary *)readUserDetail;
-(void)logout;
-(void)setUserDetail:(NSDictionary *)dict;
+(ShareToken *)sharedToken;
+(void)setUserInfo:(NSDictionary *)dict;
+(NSDictionary *)readUserInfo;

+(void)checkin;
+(void)messageReceive;
+(void)messageSend;
+(void)recMsg;
+(void)recMsgShort;
+(void)sendMsg;
+(void)timeLimit;

@end
