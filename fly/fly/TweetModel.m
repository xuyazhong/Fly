//
//  TweetModel.m
//  Weico
//
//  Created by xuyazhong on 15/2/18.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "TweetModel.h"

@implementation TweetModel


-(CGSize)currentSize
{
    //计算字符串的方法
    
    //UIDevice设备相关的类，里面带有设备名称、型号、操作系统版本号等信息。
    CGSize size;
    //iOS7之后
    NSDictionary *mydict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil];
        size = [_text boundingRectWithSize:CGSizeMake(280, 999) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:mydict context:nil].size;

    
    return size;
}


@end
