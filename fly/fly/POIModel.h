//
//  POIModel.h
//  fly
//
//  Created by xyz on 15-3-9.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POIModel : NSObject

@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *poi_street_address;
@property(nonatomic,copy) NSString *lon;
@property(nonatomic,copy) NSString *lat;
@property(nonatomic,copy) NSString *checkin_user_num;

/*
 : "B2094654D06EABFD499A",
 : "宝盛里小区",
 address: "北京市海淀区清河桥向东1公里",
 : "116.36895",
 : "40.03603",
 category: "47",
 city: "0010",
 province: "11",
 country: "80086",
 url: "http:data.house.sina.com.cnbj191",
 phone: "010-62908894,010-62900057",
 postcode: "100000",
 weibo_id: "0",
 icon: "http://u1.sinaimg.cn/upload/lbs/poi/icon/88/47.png",
 categorys: "44 47",
 category_name: "住宅区",
 map: "http://maps.google.cn/maps/api/staticmap?center=40.03603,116.36895&zoom=15&size=120x120&maptype=roadmap&markers=40.03603,116.36895&sensor=true",
 poi_pic: "http://ww2.sinaimg.cn/large/4e704b16jw1epvzh0rk1rj205k05kdfz.jpg",
 pintu: 1,
 : "北京市,海淀区,黑泉路",
 checkin_user_num: "1634",
 herenow_user_num: "28",
 selected: 0,
 icon_show: [ ],
 enterprise: 0,
 checkin_num: 6264,
 tip_num: 0,
 photo_num: 3027,
 todo_num: 0,
 distance: 218,
 trend: "",
 sale: 0
 */
@end
