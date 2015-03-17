//
//  UserProfileViewController.m
//  fly
//
//  Created by xyz on 15-3-16.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "UserProfileViewController.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
//#import "MeCell.h"
#import "DetailViewController.h"
#import "MJRefresh.h"
#import "ZoomImageView.h"
#import "TweetCell.h"


@interface UserProfileViewController ()
{
    NSMutableArray *_dataArray;
    NSInteger currentPage;
    UITableView *_myTableView;
}
@end

@implementation UserProfileViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    currentPage = 1;
    _dataArray = [[NSMutableArray alloc]init];
    [self createUI];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = YES;
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.000];
    // 透明度
    self.navigationController.navigationBar.alpha = 0.50;
    // 设置为半透明
    self.navigationController.navigationBar.translucent = YES;
    
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.5];
    
    
    NSString *myuid = [NSString stringWithFormat:@"%@",self.uid];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[ShareToken readToken],@"access_token",myuid,@"uid", nil];
    [SVProgressHUD showWithStatus:@"正在加载数据..."];
    NSLog(@"access_token=%@&uid=%@",[ShareToken readToken],myuid);
    [manager GET:kURLShowMe parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        //NSLog(@"res:%@",responseObject);
        //头像
        [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:[responseObject objectForKey:@"avatar_hd"]]];
        self.titleLabel.text = [responseObject objectForKey:@"name"];
        self.isFollow = [[responseObject objectForKey:@"following"] boolValue];
        if (self.isFollow)
        {
            NSLog(@"已关注");
            [self.followBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        }else
        {
            NSLog(@"未关注");
            [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];
        }
        BOOL isVerified = [[responseObject objectForKey:@"verified"] boolValue];
        if (isVerified)
        {
            NSLog(@"已认证");
            self.profile.text = [NSString stringWithFormat:@"简介:%@",[responseObject objectForKey:@"ability_tags"]];
            NSDictionary *_dict = [NSDictionary dictionaryWithObjectsAndKeys:[ShareToken readToken],@"access_token",myuid,@"uids", nil];
            [[AFHTTPRequestOperationManager manager]GET:kURLFansFollows parameters:_dict success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                NSLog(@"respose:%@",responseObject);
                NSDictionary *resInfo = [responseObject firstObject];
                self.fansCount.text = [NSString stringWithFormat:@"%@",[resInfo objectForKey:@"followers_count"]];
                self.followCount.text = [NSString stringWithFormat:@"%@",[resInfo objectForKey:@"friends_count"]];
                [SVProgressHUD dismiss];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error)
            {
                [SVProgressHUD showErrorWithStatus:@"网络超时"];
            }];
        }else
        {
            NSLog(@"未认证");
            self.fansCount.text = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"followers_count"]];
            self.followCount.text = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"friends_count"]];
            self.profile.text = [NSString stringWithFormat:@"简介:%@",[responseObject objectForKey:@"description"]];
            [SVProgressHUD dismiss];
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [SVProgressHUD showErrorWithStatus:@"网络超时"];
        NSLog(@"failed:%@",error.localizedDescription);
    }];

    [self getJSON:1 andUrl:kURLPhotos];
    // Do any additional setup after loading the view.
}
-(void)createUI
{
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    CGFloat width = self.view.frame.size.width;
    self.coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, 205)];
    //背景
    self.coverImageView.image = [UIImage imageNamed:@"page_cover_default_background@2x.jpg"];
    self.coverImageView.userInteractionEnabled = YES;
    
    self.profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width/2-60/2, 90, 60.0, 60.0)];

    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2;
    self.profileImageView.layer.masksToBounds = YES;
    [self.profileImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.profileImageView setClipsToBounds:YES];
    self.profileImageView.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.profileImageView.layer.shadowOffset = CGSizeMake(4.0, 4.0);
    self.profileImageView.layer.shadowOpacity = 0.5;
    self.profileImageView.layer.shadowRadius = 2.0;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.layer.borderWidth = 2.0f;
    
    [self.profileImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    
    [self.coverImageView addSubview:self.profileImageView];
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(width/2-80, 155, 160, 20)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.coverImageView addSubview:self.titleLabel];
    
    UILabel *follow = [[UILabel alloc]initWithFrame:CGRectMake(width/2-80, 185, 40, 20)];
    follow.text = @"关注";
    follow.font = [UIFont systemFontOfSize:14];
    follow.textColor = [UIColor whiteColor];
    [self.coverImageView addSubview:follow];
    
    self.followCount = [[UILabel alloc]initWithFrame:CGRectMake(width/2-40, 185, 40, 20)];
    self.followCount.textColor = [UIColor whiteColor];
    self.followCount.font = [UIFont systemFontOfSize:14];
    [self.coverImageView addSubview:self.followCount];
    
    UILabel *fans = [[UILabel alloc]initWithFrame:CGRectMake(width/2+10, 185, 40, 20)];
    fans.text = @"粉丝";
    fans.font = [UIFont systemFontOfSize:14];
    fans.textColor = [UIColor whiteColor];
    [self.coverImageView addSubview:fans];
    
    self.fansCount = [[UILabel alloc]initWithFrame:CGRectMake(width/2+40, 185, 80, 20)];
    self.fansCount.textColor = [UIColor whiteColor];
    self.fansCount.font = [UIFont systemFontOfSize:14];
    [self.coverImageView addSubview:self.fansCount];
    
    self.followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.followBtn setFrame:CGRectMake(width/2+50, 90+15, 60, 30)];
    self.followBtn.backgroundColor = [UIColor clearColor];
    [self.followBtn setTitle:@"取消关注" forState:UIControlStateNormal];
    self.followBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.followBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.followBtn.layer setMasksToBounds:YES];
    [self.followBtn.layer setCornerRadius:3];
    [self.followBtn.layer setBorderWidth:1.0];
    [self.followBtn addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.followBtn.layer setBorderColor:[UIColor redColor].CGColor];
    [self.coverImageView addSubview:self.followBtn];
    
    /*
    self.profile = [[UILabel alloc]initWithFrame:CGRectMake(10, 210, self.view.bounds.size.width-20, 10)];
    self.profile.textAlignment = NSTextAlignmentCenter;
    self.profile.font = [UIFont systemFontOfSize:12];
    self.profile.textColor = [UIColor blackColor];
    [self.view addSubview:self.profile];
     */
    [self.view addSubview:self.coverImageView];
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 210, self.view.bounds.size.width, self.view.bounds.size.height-49-210)];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    //_myTableView.tableHeaderView = self.coverImageView;
    
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
    
    [self.view addSubview:_myTableView];
   
    
}
-(void)followAction:(UIButton *)btn
{
    NSString *url;
    if (self.isFollow)
    {
        //取消关注
        url = kURLDestoryFriendShips;
    }else
    {
        //关注
        url = kURLCreateFriendShips;
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",self.uid],@"uid",[ShareToken readToken],@"access_token", nil];
    AFHTTPRequestOperationManager *getFollows = [AFHTTPRequestOperationManager manager];
    [getFollows POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        self.isFollow = !self.isFollow;
        if (self.isFollow)
        {
            NSLog(@"关注成功");
            [SVProgressHUD showSuccessWithStatus:@"关注成功"];
            [self.followBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        }else
        {
            NSLog(@"取消关注成功");
            [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
            [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        if (self.isFollow)
        {
            NSLog(@"关注失败");
            [SVProgressHUD showErrorWithStatus:@"关注失败"];
        }else
        {
            NSLog(@"取消关注失败");
            [SVProgressHUD showErrorWithStatus:@"取消关注失败"];
        }
    }];
}
-(void)loadNewData
{
    NSLog(@"下拉刷新");
    currentPage = 1;
    //[_myTableView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self getJSON:currentPage andUrl:kURLPhotos];
}
-(void)loadMoreData
{
    NSLog(@"上拉加载");
    currentPage ++;
    [self getJSON:currentPage andUrl:kURLPhotos];
}
-(void)getJSON:(int)page andUrl:(NSString *)url
{
    NSLog(@"加载微博");
    //?access_token=xxxxx&uid=1704116960&count=10
    NSDictionary *photoDict = [NSDictionary dictionaryWithObjectsAndKeys:[ShareToken readToken],@"access_token",[NSString stringWithFormat:@"%d",page],@"page",self.uid,@"uid",@"10",@"count", nil];
    NSLog(@"dict:%@",photoDict);
    
    AFHTTPRequestOperationManager *photomanager = [AFHTTPRequestOperationManager manager];
    photomanager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [photomanager GET:kURLPhotos parameters:photoDict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"test:%@",photoDict);
         //NSLog(@"photoManager:%@",responseObject);
         if ( page == 1 )
         {
             [_dataArray removeAllObjects];
         }
         NSArray *array = [responseObject objectForKey:@"statuses"];
         //NSLog(@"array:%@",array);
         for (NSDictionary *subDict in array)
         {
             TweetModel *model = [[TweetModel alloc]init];
             /*
              计算时间
              */
             //设置时间
             NSDateFormatter *iosDateFormater=[[NSDateFormatter alloc]init];
             iosDateFormater.dateFormat=@"EEE MMM d HH:mm:ss Z yyyy";
             
             //必须设置，否则无法解析
             iosDateFormater.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
             NSDate *date=[iosDateFormater dateFromString:[subDict objectForKey:@"created_at"]];
             
             //目的格式
             NSDateFormatter *resultFormatter=[[NSDateFormatter alloc]init];
             [resultFormatter setDateFormat:@"MM月dd日 HH:mm"];
             
             model.created_at = [resultFormatter stringFromDate:date];
             
             //model.created_at = [subDict objectForKey:@"created_at"];
             model.tid = [subDict objectForKey:@"id"];
             model.mid = [subDict objectForKey:@"mid"];
             model.idstr = [subDict objectForKey:@"idstr"];
             model.text = [subDict objectForKey:@"text"];
             //model.source = [subDict objectForKey:@"source"];
             model.source = [self flattenHTML:[subDict objectForKey:@"source"]];
             model.rid = [subDict objectForKey:@"rid"];
             model.reposts_count = [subDict objectForKey:@"reposts_count"];
             model.comments_count = [subDict objectForKey:@"comments_count"];
             NSArray *picArr = [subDict objectForKey:@"pic_ids"];
             NSMutableArray *picUrlArray = [[NSMutableArray alloc]init];
             NSMutableArray *bmiddleUrlArray = [[NSMutableArray alloc]init];
             for (NSString *subpic in picArr)
             {
                 NSLog(@"picarr:%@",picArr);
                 //thumbnail_pic : "http://ww2.sinaimg.cn/thumbnail/6592c2e0jw1efvk9qb5m5j20qo0f0mxw.jpg"
                 //bmiddle_pic : "http://ww2.sinaimg.cn/bmiddle/6592c2e0jw1efvk9qb5m5j20qo0f0mxw.jpg"
//                 [NSString stringWithFormat:@"http://ww2.sinaimg.cn/thumbnail/%@.jpg",subpic];
                 [picUrlArray addObject:[NSString stringWithFormat:@"http://ww2.sinaimg.cn/thumbnail/%@.jpg",subpic]];
                 [bmiddleUrlArray addObject:[NSString stringWithFormat:@"http://ww2.sinaimg.cn/bmiddle/%@.jpg",subpic]];
             }
             model.pic_urls = picUrlArray;
             model.bmiddle_urls = bmiddleUrlArray;
             NSLog(@"pic_url:%@",picUrlArray);
             NSLog(@"bmiddel_urls:%@",bmiddleUrlArray);
             //model.thumbnail_pic = [subDict objectForKey:@"thumbnail_pic"];
             NSDictionary *userDict = [subDict objectForKey:@"user"];
             UserModel *user = [[UserModel alloc]init];
             user.name = [userDict objectForKey:@"name"];
             user.uid = [userDict objectForKey:@"id"];
             user.profile_image_url = [userDict objectForKey:@"profile_image_url"];
             model.user = user;
             NSDictionary *retweeted = [subDict objectForKey:@"retweeted_status"];
             TweetModel *retweetModel = [[TweetModel alloc]init];
             if (retweeted)
             {
                 retweetModel.tid = [retweeted objectForKey:@"id"];
                 retweetModel.mid = [retweeted objectForKey:@"mid"];
                 retweetModel.idstr = [retweeted objectForKey:@"idstr"];
                 retweetModel.source = [self flattenHTML:[retweeted objectForKey:@"source"]];
                 retweetModel.rid = [retweeted objectForKey:@"rid"];
                 NSArray *retweetPicArr = [retweeted objectForKey:@"pic_urls"];
                 NSMutableArray *retweetUrlArray = [[NSMutableArray alloc]init];
                 for (NSDictionary *retPicDict in retweetPicArr)
                 {
                     [retweetUrlArray addObject:[retPicDict objectForKey:@"thumbnail_pic"]];
                 }
                 retweetModel.pic_urls = retweetUrlArray;
                 retweetModel.thumbnail_pic = [subDict objectForKey:@"thumbnail_pic"];
                 NSDictionary *retuserDict = [retweeted objectForKey:@"user"];
                 UserModel *retuser = [[UserModel alloc]init];
                 retuser.name = [retuserDict objectForKey:@"name"];
                 retuser.uid = [retuserDict objectForKey:@"id"];
                 retuser.profile_image_url = [retuserDict objectForKey:@"profile_image_url"];
                 retweetModel.user = retuser;
                 retweetModel.text =[NSString stringWithFormat:@"@%@:%@",retuser.name,[retweeted objectForKey:@"text"]];
             }
             retweetModel.size = [retweetModel currentSize];
             model.model = retweetModel;
             //计算好字符串的size,将值提前存到数据模型中
             model.size = [model currentSize];
             [_dataArray addObject:model];
         }
         NSLog(@"dataArray:%@",_dataArray);
         //NSLog(@"success:%@",responseObject);
         
         [_myTableView reloadData];
         
         [_myTableView.header endRefreshing];
         [_myTableView.footer endRefreshing];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"加载微博error:%@",error.localizedDescription);
     }];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
        //_imageView.contentMode =UIViewContentModeScaleAspectFit;
        //_imageView.backgroundColor=[UIColor redColor];
        NSMutableString *bmiddle = [NSMutableString stringWithString:subArr[i]];
        [_imageView sd_setImageWithURL:[NSURL URLWithString:subArr[i]]];
        [_imageView addZoom:[bmiddle stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"]];
        [myview addSubview:_imageView];
    }
    
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detail = [[DetailViewController alloc]init];
    TweetModel *model = [_dataArray objectAtIndex:indexPath.row];
    detail.model = model;
    [self presentViewController:detail animated:YES completion:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    static NSString *myCellID = @"me";
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellID];
    cell.isDelete = YES;
    if (cell == nil)
    {
        cell = [[TweetCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:myCellID];
        cell.leftUtilityButtons = [self leftButtons];
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
    }
    
    
    TweetModel *model = [_dataArray objectAtIndex:indexPath.row];
    [cell.userInfo sd_setImageWithURL:[NSURL URLWithString:model.user.profile_image_url]];
    
    cell.tweetLabel.text = model.text;
    //cell.tweetLabel.font = [UIFont systemFontOfSize:16];
    //cell.tweetLabel.lineBreakMode = NSLineBreakByCharWrapping;
    //cell.tweetLabel.numberOfLines = 0;
    cell.tweetLabel.frame = CGRectMake(10, 70, model.size.width, model.size.height);
    
    cell.nickName.text = model.user.name;
    cell.timeLabel.text = model.created_at;
    cell.timeLabel.font = [UIFont systemFontOfSize:12];
    cell.sourceLabel.text = [NSString stringWithFormat:@"来自%@",model.source];
    cell.sourceLabel.font = [UIFont systemFontOfSize:12];
    //NSLog(@"comment:%@&&repost:%@",model.comments_count,model.reposts_count);
    cell.commentsCount.font = [UIFont systemFontOfSize:10];
    cell.repostsCount.font = [UIFont systemFontOfSize:10];
    [cell.commentsCount setText:[NSString stringWithFormat:@"%@",model.comments_count]];
    [cell.repostsCount setText:[NSString stringWithFormat:@"%@",model.reposts_count]];
    
    
    if (model.pic_urls.count>0)
    {
        cell.retweetView.hidden = YES;
        cell.rescrollview.hidden = YES;
        cell.myscrollview.hidden = NO;
        cell.myscrollview.frame = CGRectMake(10, 55+model.size.height+10+10, 300, 80);
        [self addPic:model.pic_urls toView:cell.myscrollview];
        cell.myscrollview.contentSize = CGSizeMake(85*model.pic_urls.count+85, 0);
        [cell.controlview setFrame:CGRectMake(0, 55+model.size.height+10+90, 320, 160)];
    }else if(model.model.size.height>0)
    {
        cell.myscrollview.hidden = YES;
        cell.retweetView.hidden = NO;
        cell.retweetLabel.hidden = NO;
        cell.retweetLabel.text = model.model.text;
//        cell.retweetLabel.font = [UIFont systemFontOfSize:16];
//        cell.retweetLabel.lineBreakMode = NSLineBreakByCharWrapping;
//        cell.retweetLabel.numberOfLines = 0;
        //cell.retweetLabel.frame = CGRectMake(10, 70, model.size.width, model.size.height);
        //        cell.retweetLabel.frame = CGRectMake(10, 0, model.model.size.width, model.model.size.height);
        
        if (model.model.pic_urls.count>0)
        {
            
            cell.rescrollview.hidden = NO;
            
            cell.retweetView.frame = CGRectMake(0, 55+model.size.height+10+10,320,10+model.model.size.height+10+10+80);
            
            cell.retweetLabel.frame = CGRectMake(10, 0, model.model.size.width, model.model.size.height);
            
            cell.rescrollview.frame = CGRectMake(10, model.model.size.height+10, 300, 80);
            
            [self addPic:model.model.pic_urls toView:cell.rescrollview];
            cell.rescrollview.contentSize = CGSizeMake(85*model.model.pic_urls.count+85, 0);
            
            [cell.controlview setFrame:CGRectMake(10, 55+model.size.height+10+10+model.model.size.height+110, 300, 40)];
        }else
        {
            cell.rescrollview.hidden = YES;
            cell.retweetView.frame = CGRectMake(0, 55+model.size.height+10+10,320,model.model.size.height+10);
            cell.retweetLabel.frame = CGRectMake(10, 0, model.model.size.width, model.model.size.height);
            [cell.controlview setFrame:CGRectMake(10, 55+model.size.height+10+10+model.model.size.height+10, 300, 40)];
        }
    }else
    {
        cell.retweetLabel.hidden = YES;
        cell.retweetView.hidden = YES;
        cell.myscrollview.hidden = YES;
        cell.rescrollview.hidden = YES;
        [cell.controlview setFrame:CGRectMake(10, 55+model.size.height+10+10, 300, 40)];
    }
    
    
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
            TweetModel *_getModel = [_dataArray objectAtIndex:cellIndexPath.row];
            DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"确认删除吗？" contentText:@"确认删除吗？" leftButtonTitle:@"删除" rightButtonTitle:@"取消"];
            [alert show];
            alert.leftBlock = ^()
            {
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[ShareToken readToken],@"access_token",_getModel.tid,@"id", nil];
                [manager POST:kURLTweetDelete parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
                 {
                     NSLog(@"delete success:%@",responseObject);
                     [_dataArray removeObjectAtIndex:cellIndexPath.row];
                     [_myTableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error)
                 {
                     NSLog(@"删除失败:%@",error);
                 }];
                
            };
            alert.rightBlock = ^() {
                NSLog(@"取消");
            };
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
