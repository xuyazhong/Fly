//
//  UserModel.h
//  Weico
//
//  Created by xuyazhong on 15/2/19.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *profile_image_url;
@property (nonatomic,copy) NSString *url;
//粉丝
@property (nonatomic,copy) NSString *followers_count;
//关注
@property (nonatomic,copy) NSString *friends_count;
//微博
@property (nonatomic,copy) NSString *statuses_count;
//收藏
@property (nonatomic,copy) NSString *favourites_count;
@property (nonatomic,copy) NSString *location;
@property (nonatomic,copy) NSString *mydescription;
@property (nonatomic,assign) BOOL following;
//"screen_name": "zaku",
//"province": "11",
//"city": "5",
//"location": "北京 朝阳区",
//"description": "人生五十年，乃如梦如幻；有生斯有死，壮士复何憾。",
//"url": "http://blog.sina.com.cn/zaku",
//"domain": "zaku",
//"gender": "m",
//"followers_count": 1204,
//"friends_count": 447,
//"statuses_count": 2908,
//"favourites_count": 0,
//"created_at": "Fri Aug 28 00:00:00 +0800 2009",
//"following": false,
//"allow_all_act_msg": false,
//"remark": "",
//"geo_enabled": true,
//"verified": false,
//"allow_all_comment": true,
//"avatar_large": "http://tp1.sinaimg.cn/1404376560/180/0/1",
//"verified_reason": "",
//"follow_me": false,
//"online_status": 0,
//"bi_followers_count": 215
@end
