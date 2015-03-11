//
//  TableMenuCell.h
//  TableViewCellMenu
//
//  Created by shan xu on 14-4-2.
//  Copyright (c) 2014年 夏至. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetModel.h"

@class TableMenuCell;

@protocol menuActionDelegate <NSObject>

- (void)tableMenuDidShowInCell:(TableMenuCell *)cell;
- (void)tableMenuWillShowInCell:(TableMenuCell *)cell;
- (void)tableMenuDidHideInCell:(TableMenuCell *)cell;
- (void)tableMenuWillHideInCell:(TableMenuCell *)cell;
- (void)deleteCell:(TableMenuCell *)cell;

- (void)menuChooseIndex:(NSInteger)cellIndexNum menuIndexNum:(NSInteger)menuIndexNum;
@end

typedef void(^SuccessDeleTweet)(BOOL result);
typedef void(^FailedDeleTweet)(BOOL ret);

@interface TableMenuCell : UITableViewCell<UIGestureRecognizerDelegate>

@property (strong, nonatomic)  UIImageView *userInfo;
@property (nonatomic,copy) NSString *tid;
@property (nonatomic,assign) BOOL isDelete;
@property (nonatomic,assign) BOOL isDestroy;
@property (nonatomic,assign) BOOL isSuccess;
@property (strong, nonatomic)  UILabel *nickName;
@property (strong, nonatomic)  UILabel *timeLabel;
@property (strong, nonatomic)  UILabel *sourceLabel;
@property (strong, nonatomic)  UILabel *tweetLabel;
@property (strong, nonatomic)  UIButton *forward;
@property (strong, nonatomic)  UIButton *comment;
@property (strong, nonatomic)  UIButton *like;
//@property (strong, nonatomic)  UIImageView *tweetImage;
@property (strong, nonatomic)  UIView *controlview;
@property (strong, nonatomic)  UIView *retweetView;
@property (strong, nonatomic)  UILabel *retweetLabel;
//@property (strong, nonatomic)  UIImageView *retweetImage;
@property (strong, nonatomic)  UIScrollView *myscrollview;
@property (strong, nonatomic)  UIScrollView *rescrollview;
@property (strong, nonatomic)  UILabel *repostsCount;
@property (strong, nonatomic)  UILabel *commentsCount;
@property (strong,nonatomic)  UIButton *deleBtn;
@property (nonatomic,strong) TweetModel *model;


-(void)addDeleteCommentSuccess:(SuccessDeleTweet)success failed:(FailedDeleTweet)failed;
-(void)addDeleteTweetSuccess:(SuccessDeleTweet)success failed:(FailedDeleTweet)failed;
@property (nonatomic, strong) UIView *cellView;
@property (nonatomic, assign) float startX;
@property (nonatomic, assign) float cellX;
@property (nonatomic, assign) id<menuActionDelegate>menuActionDelegate;
@property (nonatomic, strong) NSIndexPath *indexpathNum;
@property (nonatomic, assign) NSInteger menuCount;
@property (nonatomic, strong) UIView *menuView;
@property (assign, nonatomic) BOOL menuViewHidden;


-(void)configWithData:(NSIndexPath *)indexPath menuData:(NSArray *)menuData cellFrame:(CGRect)cellFrame;
- (void)setMenuHidden:(BOOL)hidden animated:(BOOL)animated completionHandler:(void (^)(void))completionHandler;
@end
