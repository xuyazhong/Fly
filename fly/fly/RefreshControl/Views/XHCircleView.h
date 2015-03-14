//
//  XHCircleView.h
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-6-6.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XHRefreshControlHeader.h"

// 开始画圆圈时的offset
#define kXHRefreshCircleViewHeight 20

@interface XHCircleView : UIView

/**
 *  圆圈开始旋转时的offset （即开始刷新数据时）
 */
@property (nonatomic, assign) CGFloat heightBeginToRefresh;

/**
 *  offset的Y值
 */
@property (nonatomic, assign) CGFloat offsetY;

/**
 *  标识下拉刷新是UIScrollView的子view，还是UIScrollView父view的子view， 默认是scrollView的子View，为XHRefreshViewLayerTypeOnScrollViews
 */
@property (nonatomic, assign) XHRefreshViewLayerType refreshViewLayerType;

/**
 *  旋转的animation
 *
 *  @return animation
 */
+ (CABasicAnimation*)repeatRotateAnimation;

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
