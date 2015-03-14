//
//  ParentViewController.m
//  fly
//
//  Created by xyz on 15-3-12.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "ParentViewController.h"

@interface ParentViewController ()

@end

@implementation ParentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentPage = 1;
    _dataArray = [[NSMutableArray alloc]init];
    _groupListArray = [[NSMutableArray alloc]init];
    [self createUI];
    [JDStatusBarNotification addStyleNamed:XYZStyle
                                   prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
                                       style.barColor = [UIColor blackColor];
                                       style.textColor = [UIColor whiteColor];
                                       style.animationType = JDStatusBarAnimationTypeBounce;
                                       style.progressBarColor = style.textColor;
                                       style.progressBarHeight = 5.0;
                                       style.progressBarPosition = JDStatusBarProgressBarPositionTop;
                                       if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                                           style.font = [UIFont fontWithName:@"DINCondensed-Bold" size:12.0];
                                           style.textVerticalPositionAdjustment = 2.0;
                                       } else {
                                           style.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12.0];
                                       }
                                       return style;
                                   }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)createUI
{
    _myTableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.scrollsToTop = YES;
    [self.view addSubview:_myTableView];
    
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 0; i<=72; i++)
    {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"PullToRefresh_%03zd", i]];
        [idleImages addObject:image];
    }
    
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 73; i<=140; i++)
    {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"PullToRefresh_%03zd", i]];
        [refreshingImages addObject:image];
    }
    [_myTableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [_myTableView.gifHeader setImages:idleImages forState:MJRefreshHeaderStateIdle];
    [_myTableView.gifHeader setImages:refreshingImages forState:MJRefreshHeaderStateRefreshing];
    _myTableView.header.updatedTimeHidden = YES;
    _myTableView.header.stateHidden = YES;
    
    [_myTableView addGifFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 隐藏状态
    _myTableView.footer.stateHidden = YES;
    _myTableView.footer.stateHidden = YES;
    _myTableView.gifFooter.refreshingImages = refreshingImages;
    
    UIButton *updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    updateBtn.frame = CGRectMake(0, 0, 30, 30);
    //[updateBtn setBackgroundImage:[UIImage imageNamed:@"mask_timeline_top_icon_2"] forState:UIControlStateNormal];
    [updateBtn setBackgroundImage:[UIImage imageNamed:@"icn_nav_bar_compose_tweet"] forState:UIControlStateNormal];
    [updateBtn addTarget:self action:@selector(updateTweet) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 30, 30);
    //[updateBtn setBackgroundImage:[UIImage imageNamed:@"mask_timeline_top_icon_2"] forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"icn_title_search_default"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:updateBtn];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    NSArray *right = [NSArray arrayWithObjects:item1,item2, nil];
    self.navigationItem.rightBarButtonItems = right;
    //self.navigationItem.rightBarButtonItem = right;
    
}
-(void)searchAction
{
    
}
-(void)loadNewData
{
    NSLog(@"下拉刷新");
    currentPage = 1;
    [_myTableView setContentOffset:CGPointMake(0, 0) animated:YES];
    _myTableView.scrollsToTop = YES;
}
-(void)loadMoreData
{
    currentPage ++;
}
-(void)updateTweet
{
    [[KGModal sharedInstance] updateTweet];
}
-(void)listGroup:(UIButton *)btn
{
    if (btn.selected == YES)
    {
        NSLog(@"select");
        btn.selected = NO;
        groupList.hidden = YES;
        //[self.view bringSubviewToFront:groupList];
    }else
    {
        NSLog(@"normal");
        btn.selected = YES;
        groupList.hidden = NO;
        [self.view bringSubviewToFront:groupList];
    }
}


-(void)loadSuccess
{
    [SVProgressHUD showSuccessWithStatus:@"加载成功"];
}
-(NSString *)flattenHTML:(NSString *)html
{
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];
    while ([theScanner isAtEnd] == NO)
    {
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        [theScanner scanUpToString:@">" intoString:&text] ;
        html = [html stringByReplacingOccurrencesOfString:
                [NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    
    return html;
}
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"详情"];
    
    return rightUtilityButtons;
}
- (NSArray *)rightDeleteButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"详情"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"删除"];
    return rightUtilityButtons;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
                                                icon:[UIImage imageNamed:@"messagescenter_at"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor orangeColor]
                                                icon:[UIImage imageNamed:@"messagescenter_comments"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0]
                                                icon:[UIImage imageNamed:@"more_friendscircle"]];
//    [leftUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithRed:0.55f green:0.27f blue:0.07f alpha:1.0]
//                                                icon:[UIImage imageNamed:@"list.png"]];
    
    return leftUtilityButtons;
}
-(void)addPic:(NSArray *)subArr toView:(UIScrollView *)myview
{
    NSArray *allImages = myview.subviews;
    for (UIView *subImages in allImages)
    {
        if ([subImages isKindOfClass:[ZoomImageView class]])
        {
            [subImages removeFromSuperview];
        }
    }
    for (int i=0; i<subArr.count; i++)
    {
        ZoomImageView *_imageView=[[ZoomImageView alloc] initWithFrame:CGRectMake(85*i, 0, 80, 80)];
        _imageView.contentMode =UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor=[UIColor clearColor];
        NSMutableString *bmiddle = [NSMutableString stringWithString:subArr[i]];
        [_imageView sd_setImageWithURL:[NSURL URLWithString:subArr[i]]];
        [_imageView addZoom:[bmiddle stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"]];
        [myview addSubview:_imageView];
    }
    
}
#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"子类必须重写此方法");
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"parent";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    NSLog(@"子类必须重写此方法");
    return cell;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetModel *model = [_dataArray objectAtIndex:indexPath.row];
    NSInteger count = model.pic_urls.count;
    if (count >0)
    {
        int customHeight = 55+model.size.height+10+80+40+10;
        return customHeight;
    }else if(model.model.size.height>0)
    {
        if (model.model.pic_urls.count>0)
        {
            return 55+model.size.height+10+40+10+model.model.size.height+10+80+20;
        }else
            return 55+model.size.height+10+40+10+model.model.size.height+10;
    }else
    {
        return 55+model.size.height+10+40;
    }
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 1:
            NSLog(@"left utility buttons open");
            break;
        case 2:
            NSLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            NSLog(@"left button 0 was pressed");
            [JDStatusBarNotification showWithStatus:@"转发成功" dismissAfter:2 styleName:JDStatusBarStyleSuccess];
            break;
        case 1:
            NSLog(@"left button 1 was pressed");
            [JDStatusBarNotification showWithStatus:@"收藏成功" dismissAfter:2 styleName:JDStatusBarStyleSuccess];
            break;
        case 2:
            NSLog(@"left button 2 was pressed");
            
            [JDStatusBarNotification showWithStatus:@"评论成功" dismissAfter:2.0 styleName:@"XYZStyle"];
            break;
        case 3:
            [JDStatusBarNotification showWithStatus:@"测试成功" dismissAfter:2 styleName:JDStatusBarStyleSuccess];
            NSLog(@"left btton 3 was pressed");
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            NSLog(@"More button was pressed");
            UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"More more more" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
            [alertTest show];
            
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [_myTableView indexPathForCell:cell];
            
            [_dataArray removeObjectAtIndex:cellIndexPath.row];
            [_myTableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}



@end
