//
//  DeviceManager.m
//  NewsProject
//
//  Created by xyz on 15-2-25.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "DeviceManager.h"

@implementation DeviceManager

//获取屏幕的大小
+(CGSize)currentScreenSize
{
    return [UIScreen mainScreen].bounds.size;
}
//获取操作系统的版本号
+(CGFloat)currentVersion
{
    NSString *version = [UIDevice currentDevice].systemVersion;
    return [version floatValue];
}
//获取设备的型号
+(NSString *)currentModel
{
    return [UIDevice currentDevice].model;
}

@end
