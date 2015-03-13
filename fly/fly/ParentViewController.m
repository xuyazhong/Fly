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
    updateBtn.frame = CGRectMake(0, 0, 40, 40);
    //[updateBtn setBackgroundImage:[UIImage imageNamed:@"mask_timeline_top_icon_2"] forState:UIControlStateNormal];
    [updateBtn setBackgroundImage:[UIImage imageNamed:@"tab_send"] forState:UIControlStateNormal];
    [updateBtn addTarget:self action:@selector(updateTweet) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:updateBtn];
    self.navigationItem.rightBarButtonItem = right;
    
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
                                                title:@"More"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
                                                icon:[UIImage imageNamed:@"check.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:1.0]
                                                icon:[UIImage imageNamed:@"clock.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0]
                                                icon:[UIImage imageNamed:@"cross.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.55f green:0.27f blue:0.07f alpha:1.0]
                                                icon:[UIImage imageNamed:@"list.png"]];
    
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



@end
