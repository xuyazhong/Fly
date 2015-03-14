//
//  XHLoadMoreView.h
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-6-6.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kXHLoadMoreViewHeight 50

@interface XHLoadMoreView : UIView

/**
 *  加载更多的按钮
 */
@property (nonatomic, strong) UIButton *loadMoreButton;

/**
 *  当外部需要自定义加载更多的按钮时，需要通过该方法进行覆盖原本的按钮
 *
 *  @param customLoadMoreButton 目标自定义加载更多按钮
 */
- (void)setupCustomLoadMoreButton:(UIButton *)customLoadMoreButton;

/**
 *  开始加载
 */
- (void)startLoading;

/**
 *  结束加载
 */
- (void)endLoading;

/**
 *  设置手动加载更多的UI
 */
- (void)configuraManualStateWithMessage:(NSString *)message;

/**
 *  当外部加载更多数据的时候，发现没有数据了，可以进行设置一些提示字眼
 *
 *  @param message 被显示的目标文本
 */
- (void)configuraNothingMoreWithMessage:(NSString *)message;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
