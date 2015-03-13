//
//  HomeViewController.m
//  Weico
//
//  Created by xuyazhong on 15/2/18.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "HomeViewController.h"
#import "AFNetworking.h"
#import "ShareToken.h"
#import "TweetModel.h"
#import "TweetCell.h"
#import "UIImageView+WebCache.h"
#import "ListsModel.h"
#import "UpdateTweetVC.h"
#import "RepostViewController.h"
#import "DetailViewController.h"
#import "XYZImageView.h"
#import "MyTabBarViewController.h"
#import "KGModal.h"
#import "ZoomImageView.h"
#import "SendTweetViewController.h"
#import "SLPagingViewController.h"


@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"首页";
    currentUrl = kURLHomeLine;
    
    UIButton *updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    updateBtn.frame = CGRectMake(0, 0, 40, 40);
    [updateBtn setBackgroundImage:[UIImage imageNamed:@"tab_send"] forState:UIControlStateNormal];
    [updateBtn addTarget:self action:@selector(updateTweet) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:updateBtn];
    self.navigationItem.rightBarButtonItem = right;
    [self getJSON:currentPage andUrl:currentUrl andGroupID:currentGroupId];
    
    // Do any additional setup after loading the view.
}


-(void)loadNewData
{
    NSLog(@"下拉刷新");
    currentPage = 1;
    [_myTableView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self getJSON:currentPage andUrl:currentUrl andGroupID:currentGroupId];
    _myTableView.scrollsToTop = YES;
}
-(void)loadMoreData
{
    currentPage ++;
    [self getJSON:currentPage andUrl:currentUrl andGroupID:currentGroupId];
}
-(void)createNav
{
    titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleBtn setFrame:CGRectMake(0, 0, 80, 64)];
    [titleBtn setTitle:@"首页" forState:UIControlStateNormal];
    [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(listGroup:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
//    self.navigationController.navigationItem.titleView = titleBtn;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[ShareToken sharedToken],@"access_token", nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:kURLGroupLists parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        groupList = [[UIScrollView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-100, 64, 200, 300)];
        groupList.backgroundColor = [UIColor blackColor];
        groupList.alpha = 0.8;
        groupList.hidden = YES;
        NSArray *array = [responseObject objectForKey:@"lists"];
        int i=0;
        for (NSDictionary *subDict  in array)
        {
            ListsModel *model = [[ListsModel alloc]init];
            model.name = [subDict objectForKey:@"name"];
            model.idstr = [subDict objectForKey:@"idstr"];
            //NSLog(@"%@",[subDict objectForKey:@"name"]);
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [btn setFrame:CGRectMake(5, 5+30*i, 190, 40)];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.tag = 50 + i;
            [btn addTarget:self action:@selector(selectGroup:) forControlEvents:UIControlEventTouchUpInside];

            [btn setTitle:[subDict objectForKey:@"name"] forState:UIControlStateNormal];
            [groupList addSubview:btn];
            [groupList setContentSize:CGSizeMake(0, 5+30*i+30)];
            [_groupListArray addObject:model];
            i++;
        }
        [self.view addSubview:groupList];

        //NSLog(@"group list success:%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"group list error:%@",error.localizedDescription);
    }];
}
-(void)updateTweet
{
    SendTweetViewController *send = [[SendTweetViewController alloc]init];
    __weak HomeViewController *weakSelf = self;
    [weakSelf addChildViewController:send];
    [weakSelf.view addSubview:send.view];
    [send didMoveToParentViewController:weakSelf];
    NSLog(@"ok");
    //[[KGModal sharedInstance] updateTweet];
    //UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 250)];
    //[[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
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
-(void)selectGroup:(UIButton *)btn
{
    ListsModel *model = [_groupListArray objectAtIndex:btn.tag-50];
    NSLog(@"name:%@",model.name);
    //NSLog(@"id:%@",model.idstr);
    //btn.titleLabel.text
    [titleBtn setTitle:model.name forState:UIControlStateNormal];
    //self.navigationItem.titleView = btn;
    for (int i=0; i<_dataArray.count; i++)
    {
        UIButton *myBtn = (UIButton *)[self.view viewWithTag:50+i];
        myBtn.selected = NO;
    }
    btn.selected = YES;
    titleBtn.selected = NO;
    groupList.hidden = YES;
    currentGroupId = model.idstr;
    currentPage=1;
    currentUrl = kURLGroup;
    [self getJSON:currentPage andUrl:currentUrl andGroupID:currentGroupId];

}

-(void)getJSON:(int)page andUrl:(NSString *)url andGroupID:(NSString *)groupid
{
    [SVProgressHUD showWithStatus:@"正在加载数据..."];
    NSDictionary *dict;
    if (groupid != nil)
    {
        dict = [NSDictionary dictionaryWithObjectsAndKeys:[ShareToken readToken],@"access_token",groupid,@"list_id",[NSString stringWithFormat:@"%d",page],@"page", nil];

    }else
    {
        dict = [NSDictionary dictionaryWithObjectsAndKeys:[ShareToken readToken],@"access_token",[NSString stringWithFormat:@"%d",page],@"page", nil];
    }
    NSLog(@"dict:%@",dict);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if (page == 1)
        {
            [_dataArray removeAllObjects];
        }
        NSArray *array = [responseObject objectForKey:@"statuses"];
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
            NSArray *picArr = [subDict objectForKey:@"pic_urls"];
            NSMutableArray *picUrlArray = [[NSMutableArray alloc]init];
            NSMutableArray *bmiddleUrlArray = [[NSMutableArray alloc]init];
            for (NSDictionary *picDict in picArr)
            {
                [picUrlArray addObject:[picDict objectForKey:@"thumbnail_pic"]];
                NSString  *bmiddle_pic = [picDict objectForKey:@"thumbnail_pic"];
                [bmiddleUrlArray addObject:[bmiddle_pic stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"]];
            }
            model.pic_urls = picUrlArray;
            model.bmiddle_urls = bmiddleUrlArray;
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
        

        NSLog(@"开始加载");
        [_myTableView.header endRefreshing];
        [_myTableView.footer endRefreshing];
        [SVProgressHUD dismiss];
        [self performSelector:@selector(loadSuccess) withObject:nil afterDelay:0.3f];
        if (page==1)
        {
            NSIndexPath *ip=[NSIndexPath indexPathForRow:0 inSection:0];
            [_myTableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionNone];
            //[_myTableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"加载失败");
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        NSLog(@"error:%@",error.localizedDescription);
    }];
    
}
-(void)loadSuccess
{
    [SVProgressHUD showSuccessWithStatus:@"加载成功"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    DetailViewController *detail = [[DetailViewController alloc]init];
    TweetModel *model = [_dataArray objectAtIndex:indexPath.row];
    detail.model = model;
    [self presentViewController:detail animated:YES completion:nil];
     */
    UIColor *orange = [UIColor colorWithRed:255/255
                                      green:69.0/255
                                       blue:0.0/255
                                      alpha:1.0];
    
    UIColor *gray = [UIColor colorWithRed:.84
                                    green:.84
                                     blue:.84
                                    alpha:1.0];
    
    UIButton *repostBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [repostBtn setTitle:@"转发" forState:UIControlStateNormal];
    repostBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [repostBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [repostBtn setFrame:CGRectMake(0, 0, 60, 30)];
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    commentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [commentBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [commentBtn setFrame:CGRectMake(0, 0, 60, 30)];


    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"关闭" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [cancelBtn setFrame:CGRectMake(0, 0, 60, 30)];

    // Make views for the navigation bar

    
    SLPagingViewController *pageViewController = [[SLPagingViewController alloc] initWithNavBarItems:@[repostBtn,commentBtn,cancelBtn]
                                                                                    navBarBackground:[UIColor whiteColor]
                                                                                               views:@[[self viewWithBackground:orange], [self viewWithBackground:[UIColor yellowColor]], [self viewWithBackground:gray]]
                                                                                     showPageControl:NO];
    // Tinder Like
    pageViewController.pagingViewMoving = ^(NSArray *subviews){
        int i = 0;
        for(UIButton *v in subviews){
            UIColor *c = gray;
            if(v.frame.origin.x > 45
               && v.frame.origin.x < 145)
                // Left part
                c = [self gradient:v.frame.origin.x
                               top:46
                            bottom:144
                              init:orange
                              goal:gray];
            else if(v.frame.origin.x > 145
                    && v.frame.origin.x < 245)
                // Right part
                c = [self gradient:v.frame.origin.x
                               top:146
                            bottom:244
                              init:gray
                              goal:orange];
            else if(v.frame.origin.x == 145)
                c = orange;
            v.tintColor= c;
            i++;
        }
    };
    
    UINavigationController *nvc  = [[UINavigationController alloc] initWithRootViewController:pageViewController];
    [self presentViewController:nvc animated:YES completion:^{
        
    }];
}
-(UIColor *)gradient:(double)percent top:(double)topX bottom:(double)bottomX init:(UIColor*)init goal:(UIColor*)goal{
    double t = (percent - bottomX) / (topX - bottomX);
    
    t = MAX(0.0, MIN(t, 1.0));
    
    const CGFloat *cgInit = CGColorGetComponents(init.CGColor);
    const CGFloat *cgGoal = CGColorGetComponents(goal.CGColor);
    
    double r = cgInit[0] + t * (cgGoal[0] - cgInit[0]);
    double g = cgInit[1] + t * (cgGoal[1] - cgInit[1]);
    double b = cgInit[2] + t * (cgGoal[2] - cgInit[2]);
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

-(UIView*)viewWithBackground:(UIColor *)color{
    UIView *v = [UIView new];
    v.backgroundColor = color;
    return v;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"custom";
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[TweetCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    TweetModel *model = [_dataArray objectAtIndex:indexPath.row];
    [cell.userInfo sd_setImageWithURL:[NSURL URLWithString:model.user.profile_image_url]];
    
    cell.tweetLabel.text = model.text;
    cell.tweetLabel.font = [UIFont systemFontOfSize:16];
    cell.tweetLabel.lineBreakMode = NSLineBreakByCharWrapping;
    cell.tweetLabel.numberOfLines = 0;
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

//    cell.retweetView.hidden = YES;
//    //cell.retweetLabel.hidden = YES;
//    cell.myscrollview.hidden = YES;
//    //cell.rescrollview.hidden = YES;
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
        cell.retweetLabel.font = [UIFont systemFontOfSize:16];
        cell.retweetLabel.lineBreakMode = NSLineBreakByCharWrapping;
        cell.retweetLabel.numberOfLines = 0;
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









@end
