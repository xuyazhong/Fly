//
//  TableMenuCell.m
//  TableViewCellMenu
//
//  Created by shan xu on 14-4-2.
//  Copyright (c) 2014年 夏至. All rights reserved.
//

#import "TableMenuCell.h"
#import "AFNetworking.h"
#import "DXAlertView.h"

@interface TableMenuCell ()
{
    SuccessDeleTweet _successBlock;
    FailedDeleTweet _failBlock;
}
//@property (assign, nonatomic, getter = isMenuViewHidden) BOOL menuViewHidden;
@end

#define ISIOS7 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7)

@implementation TableMenuCell
@synthesize cellView;
@synthesize startX;
@synthesize cellX;
@synthesize menuActionDelegate;
@synthesize indexpathNum;
@synthesize menuCount;
@synthesize menuView;
@synthesize menuViewHidden;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        menuCount = 0;
        
        self.cellView = [[UIView alloc] init];
        self.cellView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.cellView];
        
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cellPanGes:)];
        panGes.delegate = self;
        panGes.delaysTouchesBegan = YES;
        panGes.cancelsTouchesInView = NO;
        [self addGestureRecognizer:panGes];
        
    }
    return self;
}
-(void)createUI
{
    [self createUserInfo];
    [self createTweet];
    [self createTweetImage];
    [self createRetweet];
    [self createButton];
}
-(void)createUserInfo
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 75)];
    _userInfo = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
    _nickName = [[UILabel alloc]initWithFrame:CGRectMake(70, 10,200, 20)];
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 35, 120, 10)];
    _sourceLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 35, 120, 10)];
    _deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleBtn setFrame:CGRectMake(270, 10, 30, 20)];
    [_deleBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _deleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [headView addSubview:_deleBtn];
    [headView addSubview:_userInfo];
    [headView addSubview:_nickName];
    [headView addSubview:_timeLabel];
    [headView addSubview:_sourceLabel];
    [self.cellView addSubview:headView];
}

-(void)addDeleteCommentSuccess:(SuccessDeleTweet)success failed:(FailedDeleTweet)failed
{
    [_deleBtn addTarget:self action:@selector(deleCommentAlertView) forControlEvents:UIControlEventTouchUpInside];
    _successBlock = success;
    _failBlock = failed;
    NSLog(@"add target!!!");
}
-(void)addDeleteTweetSuccess:(SuccessDeleTweet)success failed:(FailedDeleTweet)failed
{
    [_deleBtn addTarget:self action:@selector(deleAlertView) forControlEvents:UIControlEventTouchUpInside];
    _successBlock = success;
    _failBlock = failed;
    NSLog(@"add target!!!");
}
-(void)deleCommentAlertView
{
    DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"确认删除吗？" contentText:@"确认删除吗？" leftButtonTitle:@"删除" rightButtonTitle:@"取消"];
    [alert show];
    alert.leftBlock = ^()
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[ShareToken readToken],@"access_token",self.model.tid,@"cid", nil];
        [manager POST:kURLCommentDelete parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"删除成功");
             _successBlock(YES);
             NSLog(@"delete success:%@",responseObject);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             _failBlock(NO);
             NSLog(@"删除失败:%@",error);
         }];
        
    };
    alert.rightBlock = ^() {
        NSLog(@"取消");
        _failBlock(NO);
    };
}
-(void)deleAlertView
{
    DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"确认删除吗？" contentText:@"确认删除吗？" leftButtonTitle:@"删除" rightButtonTitle:@"取消"];
    [alert show];
    alert.leftBlock = ^()
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[ShareToken readToken],@"access_token",self.model.tid,@"id", nil];
        [manager POST:kURLTweetDelete parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"删除");
             _successBlock(YES);
             NSLog(@"delete success:%@",responseObject);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"删除失败:%@",error);
         }];
        
    };
    alert.rightBlock = ^() {
        NSLog(@"取消");
        _failBlock(NO);
    };
}

-(void)createTweet
{
    _tweetLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 300, 80)];
    [self.cellView addSubview:_tweetLabel];
    
}
-(void)createTweetImage
{
    _myscrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 150, 300, 80)];
    _myscrollview.showsVerticalScrollIndicator = NO;
    _myscrollview.showsHorizontalScrollIndicator = NO;
    [self.cellView addSubview:_myscrollview];
}

-(void)createRetweet
{
    _retweetView = [[UIView alloc]initWithFrame:CGRectMake(0, 230, 320, 160)];
    _retweetView.backgroundColor = [UIColor colorWithRed:155/255.0f green:155/255.0f blue:155/255.0f alpha:0.1];
    //_retweetView.backgroundColor = [UIColor grayColor];
    //_retweetView.alpha = 0.5;
    
    _retweetLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 80)];
    [_retweetView addSubview:_retweetLabel];
    
    
    _rescrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 80, 300, 80)];
    _rescrollview.showsVerticalScrollIndicator = NO;
    _rescrollview.showsHorizontalScrollIndicator = NO;
    [_retweetView addSubview:_rescrollview];
    [self.cellView addSubview:_retweetView];
}
-(void)createButton
{
    _controlview = [[UIView alloc] initWithFrame:CGRectMake(10, 390, [DeviceManager currentScreenSize].width-20, 40)];
    _controlview.userInteractionEnabled = YES;
    [self.cellView addSubview:_controlview];
    
    UIImageView *repostImageview = [[UIImageView alloc] initWithFrame:CGRectMake([DeviceManager currentScreenSize].width-100, 10, 10, 10)];
    [repostImageview setImage:[UIImage imageNamed:@"t_repost"]];
    [_controlview addSubview:repostImageview];
    
    _repostsCount = [[UILabel alloc] initWithFrame:CGRectMake([DeviceManager currentScreenSize].width-90, 5,50, 20)];
    [_controlview addSubview:_repostsCount];
    
    UIImageView *commentImageview = [[UIImageView alloc]initWithFrame:CGRectMake([DeviceManager currentScreenSize].width-60, 10, 10, 10)];
    [commentImageview setImage:[UIImage imageNamed:@"t_comments"]];
    [_controlview addSubview:commentImageview];
    
    _commentsCount = [[UILabel alloc] initWithFrame:CGRectMake([DeviceManager currentScreenSize].width-50, 5,50, 20)];
    [_controlview addSubview:_commentsCount];
    
}
-(void)configWithData:(NSIndexPath *)indexPath menuData:(NSArray *)menuData cellFrame:(CGRect)cellFrame
{
    indexpathNum = indexPath;
    if (self.cellView)
    {
        [self.cellView removeFromSuperview];
        self.cellView = nil;
    }
    self.cellView = [[UIView alloc] init];
    [self createUI];
    [self.contentView addSubview:self.cellView];
    
    
    menuView = [[UIView alloc] init];
    menuView.frame = CGRectMake(320 - 80*[menuData count], 0, 80*[menuData count], cellFrame.size.height);
    menuView.backgroundColor = [UIColor clearColor];
    [self.contentView insertSubview:menuView belowSubview:self.cellView];
//    [self.contentView insertSubview:menuView aboveSubview:self.cellView];
    
    self.menuViewHidden = YES;

    for (int i = 0; i < menuCount; i++) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
        bgView.frame = CGRectMake(80*i, 0, 80, cellFrame.size.height);
        [menuView addSubview:bgView];
        
        UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        menuBtn.tag = i;
        [menuBtn addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        menuBtn.frame = CGRectMake((80 - 40)/2, (cellFrame.size.height - 40)/2, 40, 40);
        [menuBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[[menuData objectAtIndex:i] objectForKey:@"stateNormal"]]] forState:UIControlStateNormal];
        [menuBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[[menuData objectAtIndex:i] objectForKey:@"stateHighLight"]]] forState:UIControlStateHighlighted];
        [bgView addSubview:menuBtn];
    }
}
-(void)menuBtnClick:(id)sender{
    UIButton *btn = sender;
    if (btn.tag == 2) {
        self.menuViewHidden = YES;
        [menuActionDelegate deleteCell:self];
    }
    [self.menuActionDelegate menuChooseIndex:indexpathNum.row menuIndexNum:btn.tag];
    
//    UITableViewCell *cell;
//    if (ISIOS7) {
//        cell = (UITableViewCell *)btn.superview.superview;
//    }else{
//        cell = (UITableViewCell *)btn.superview;
//    }
}

-(void)cellPanGes:(UIPanGestureRecognizer *)panGes{
    if (self.selected) {
        [self setSelected:NO animated:NO];
    }
    CGPoint pointer = [panGes locationInView:self.contentView];
    if (panGes.state == UIGestureRecognizerStateBegan) {
        self.menuViewHidden = NO;
        startX = pointer.x;
        cellX = self.cellView.frame.origin.x;
    }else if (panGes.state == UIGestureRecognizerStateChanged){
        self.menuViewHidden = NO;
        [menuActionDelegate tableMenuWillShowInCell:self];
    }else if (panGes.state == UIGestureRecognizerStateEnded){
        [self cellReset:pointer.x - startX];
        return;
    }else if (panGes.state == UIGestureRecognizerStateCancelled){
        [self cellReset:pointer.x - startX];
        return;
    }
    [self cellViewMoveToX:cellX + pointer.x - startX];
}

-(void)cellReset:(float)moveX{
    if (cellX <= -80*menuCount) {
        if (moveX <= 0) {
            return;
        }else if(moveX > 20){
            [UIView animateWithDuration:0.2 animations:^{
                [self initCellFrame:0];
            } completion:^(BOOL finished) {
                self.menuViewHidden = YES;
                [self.menuActionDelegate tableMenuDidHideInCell:self];
            }];
        }else if (moveX <= 20){
            [UIView animateWithDuration:0.2 animations:^{
                [self initCellFrame:-menuCount*80];
            } completion:^(BOOL finished) {
                self.menuViewHidden = NO;
                [self.menuActionDelegate tableMenuDidShowInCell:self];
            }];
        }
    }else{
        if (moveX >= 0) {
            return;
        }else if(moveX < -20){
            [UIView animateWithDuration:0.2 animations:^{
                [self initCellFrame:-menuCount*80];
            } completion:^(BOOL finished) {
                self.menuViewHidden = NO;
                [self.menuActionDelegate tableMenuDidShowInCell:self];
            }];
        }else if (moveX >= -20){
            [UIView animateWithDuration:0.2 animations:^{
                [self initCellFrame:0];
            } completion:^(BOOL finished) {
                self.menuViewHidden = YES;
                [self.menuActionDelegate tableMenuDidShowInCell:self];
            }];
        }
    }
}
-(void)cellViewMoveToX:(float)x{
    if (x <= -(menuCount*80+20)) {
        x = -(menuCount*80+20);
    }else if (x >= 50){
        x = 50;
    }
    self.cellView.frame = CGRectMake(x, 0, 320, 80);
    if (x == -(menuCount*80+20)) {
        [UIView animateWithDuration:0.2 animations:^{
            [self initCellFrame:-menuCount*80];
        } completion:^(BOOL finished) {
            self.menuViewHidden = NO;
            [self.menuActionDelegate tableMenuDidShowInCell:self];
        }];
    }
    if (x == 50) {
        [UIView animateWithDuration:0.2 animations:^{
            [self initCellFrame:0];
        } completion:^(BOOL finished) {
            self.menuViewHidden = YES;
            [self.menuActionDelegate tableMenuDidHideInCell:self];
        }];
    }
}
- (void)initCellFrame:(float)x{
    CGRect frame = self.cellView.frame;
    frame.origin.x = x;
    
    self.cellView.frame = frame;
}
#pragma mark * UIPanGestureRecognizer delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    NSString *str = [NSString stringWithUTF8String:object_getClassName(gestureRecognizer)];
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
        return fabs(translation.x) > fabs(translation.y);
    }
    return YES;
}

- (void)setMenuHidden:(BOOL)hidden animated:(BOOL)animated completionHandler:(void (^)(void))completionHandler{
    if (self.selected) {
        [self setSelected:NO animated:NO];
    }
    if (hidden) {
        CGRect frame = self.cellView.frame;
        if (frame.origin.x != 0) {
            [UIView animateWithDuration:0.2 animations:^{
                [self initCellFrame:0];
            } completion:^(BOOL finished) {
                self.menuViewHidden = YES;
                [self.menuActionDelegate tableMenuDidHideInCell:self];
                if (completionHandler) {
                    completionHandler();
                }
            }];
        }
    }
}
- (void)setMenuViewHidden:(BOOL)Hidden{
    menuViewHidden = Hidden;
    
    if (Hidden) {
        self.menuView.hidden = YES;
    }else{
        self.menuView.hidden = NO;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    if (self.menuViewHidden) {
        self.menuView.hidden = YES;
        [super setHighlighted:highlighted animated:animated];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.menuViewHidden) {
        self.menuView.hidden = YES;
        [super setSelected:selected animated:animated];
    }
}

@end
