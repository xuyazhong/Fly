//
//  ZoomImageView.h
//  FormosaWeibo
//
//  Created by Joey on 2014/1/13.
//  Copyright (c) 2014年 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>
@class THProgressView;
@interface ZoomImageView : UIImageView<NSURLConnectionDataDelegate>
{
@private
    UIImageView *_fullImageView;
    UIScrollView *_coverView;
    THProgressView *_progressView;
    
    NSMutableData *_data;//接收數據
    double           _length;  //加載圖片的大小
    
    UIButton *_saveButton;
}

@property(nonatomic,copy)NSString *urlString;

-(void)addZoom:(NSString *)urlString;

@end
