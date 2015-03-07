//
//  DeviceManager.h
//  NewsProject
//
//  Created by xyz on 15-2-25.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import <Foundation/Foundation.h>


//暴露跟设备操作相关的方法
@interface DeviceManager : NSObject

//为了使用方便,一些频繁调用的方法可以写成类方法
//获取屏幕的大小
+(CGSize)currentScreenSize;
//获取操作系统的版本号
+(CGFloat)currentVersion;
//获取设备的型号
+(NSString *)currentModel;



@end
