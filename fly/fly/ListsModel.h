//
//  ListsModel.h
//  Weico
//
//  Created by xuyazhong on 15/2/18.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListsModel : NSObject

@property (nonatomic,copy) NSString *lid;
@property (nonatomic,copy) NSString *idstr;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *mode;
@property (nonatomic,copy) NSString *visible;
@property (nonatomic,copy) NSString *like_count;
@property (nonatomic,copy) NSString *member_count;
@property (nonatomic,copy) NSString *ldescription;
@property (nonatomic,copy) NSString *tags;
@property (nonatomic,copy) NSString *profile_image_url;
@property (nonatomic,copy) NSString *user;
@property (nonatomic,copy) NSString *created_at;


@end
