//
//  ZoomImageView.m
//  FormosaWeibo
//
//  Created by Joey on 2014/1/13.
//  Copyright (c) 2014年 Joey. All rights reserved.
//

#import "ZoomImageView.h"
#import "UIImageView+WebCache.h"

@implementation ZoomImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}



-(void)addZoom:(NSString *)urlString
{
    self.urlString = urlString;
    
    self.userInteractionEnabled = YES;
    
    //添加放大圖片的點擊手勢
    UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomInAction)];
    [self addGestureRecognizer:tap];
    
    
}
-(void)_initView
{
    
    if (_coverView == nil) {
        _coverView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _coverView.backgroundColor = [UIColor blackColor];
        //縮小圖片的手勢
          UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomOutAction)];
        [_coverView addGestureRecognizer:tap];
      
        [self.window addSubview:_coverView];
    }
    
    if (_fullImageView == nil) {
        _fullImageView = [[UIImageView alloc] initWithImage:self.image];
        //等比例縮放
        _fullImageView.contentMode = UIViewContentModeScaleAspectFit;
        _fullImageView.userInteractionEnabled = YES;
        [_coverView addSubview:_fullImageView];
    }


    CGRect frame = [self convertRect:self.bounds toView:self.window];
    _fullImageView.frame = frame;

}
//放大圖片
-(void)zoomInAction
{
    [self _initView];
    //設UIScrollView 背景為透明
    _coverView.backgroundColor = [UIColor clearColor];
    //隱藏statusBar
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    //動畫效果
    [UIView animateWithDuration:0.3f animations:^{
        _fullImageView.frame = [UIScreen mainScreen].bounds;
       
    }completion:^(BOOL finished)
    {
      _coverView.backgroundColor = [UIColor blackColor];
        _saveButton.hidden = NO;
    }];
    

    
    [_fullImageView sd_setImageWithURL:[NSURL URLWithString:self.urlString]];
    
    
}

//縮小圖片
-(void)zoomOutAction
{
    //顯示statusBar
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    //設UIScrollView 背景為透明
    _coverView.backgroundColor = [UIColor clearColor];
    //隱藏saveButton
    _saveButton.hidden = YES;
    //動畫效果
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = [self convertRect:self.bounds toView:self.window];
        _fullImageView.frame = frame;
        
        
        
    }completion:^(BOOL finished)
    {
        [_coverView removeFromSuperview];
        
        
        
        //釋放_coverView
        _coverView = nil;//安全釋放 設為nil
        
        _fullImageView =nil;
        
        _progressView =nil;
        _saveButton = nil;
        
        
    
    }];

}

//----------saveAction----------------
-(void)saveAction
{
   
}
//圖片保存至相簿調用的方法 一定要實現的方法
//存檔完成會調用 ,失敗也會
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
}




@end
