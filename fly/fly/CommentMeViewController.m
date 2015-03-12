//
//  CommentMeViewController.m
//  weico
//
//  Created by xyz on 15-2-26.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "CommentMeViewController.h"


@interface CommentMeViewController ()
{
    UIScrollView *groupList;
    NSMutableArray *groupArray;
    NSMutableArray *groupUrl;
}
@end

@implementation CommentMeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentPage = 1;
    currentURL = kURLCommentToMe;
    _dataArray = [[NSMutableArray alloc]init];
    
    self.title = @"评论";

    _myTableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
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
    
    
    
    [self getJSON:1 andUrl:currentURL];
    [self createNav];
    // Do any additional setup after loading the view.
}
-(void)loadNewData
{
    NSLog(@"下拉刷新");
    currentPage = 1;
    [_myTableView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self getJSON:currentPage andUrl:currentURL];
}
-(void)loadMoreData
{
    currentPage ++;
    [self getJSON:currentPage andUrl:currentURL];
}
-(void)createNav
{
    titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleBtn setFrame:CGRectMake(0, 0, 80, 64)];
    [titleBtn setTitle:@"收到的评论" forState:UIControlStateNormal];
    [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(listGroup:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
    
    
    groupArray = [[NSMutableArray alloc]initWithObjects:@"收到的评论",@"发出的评论", nil];
    groupUrl = [[NSMutableArray alloc]initWithObjects:kURLCommentToMe,kURLCommentByMe, nil];
    groupList = [[UIScrollView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-100, 64, 200, 40*groupArray.count)];
    groupList.backgroundColor = [UIColor blackColor];
    groupList.alpha = 0.8;
    groupList.hidden = YES;
    for (int i=0;i<groupArray.count;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setFrame:CGRectMake(5, 5+30*i, 190, 40)];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.tag = 90 + i;
        [btn addTarget:self action:@selector(selectGroup:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:groupArray[i] forState:UIControlStateNormal];
        [groupList addSubview:btn];
        [groupList setContentSize:CGSizeMake(0, 5+30*i+30)];
    }
    [self.view addSubview:groupList];
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
    NSInteger index = btn.tag - 90;
    
    [titleBtn setTitle:groupArray[index] forState:UIControlStateNormal];
    for (int i=0; i<groupArray.count; i++)
    {
        UIButton *myBtn = (UIButton *)[self.view viewWithTag:90+i];
        myBtn.selected = NO;
    }
    btn.selected = YES;
    titleBtn.selected = NO;
    groupList.hidden = YES;
    currentURL = groupUrl[index];
    currentPage=1;
    [self getJSON:currentPage andUrl:currentURL];
}
-(void)getJSON:(int)page andUrl:(NSString *)url
{
    NSDictionary *dict;
    dict = [NSDictionary dictionaryWithObjectsAndKeys:[ShareToken readToken],@"access_token",[NSString stringWithFormat:@"%d",page],@"page", nil];
    //NSLog(@"dict:%@",dict);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (page == 1)
         {
             [_dataArray removeAllObjects];
         }
         NSArray *array = [responseObject objectForKey:@"comments"];
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
             
             NSDictionary *retweeted = [subDict objectForKey:@"reply_comment"];
             if (retweeted== nil)
             {
                 retweeted = [subDict objectForKey:@"status"];
             }
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
         NSLog(@"error:%@",error.localizedDescription);
     }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    TweetModel *model = [_dataArray objectAtIndex:indexPath.row];
    [[KGModal sharedInstance] replyTweet:model];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCommentCell = @"comment";
    MeCell *cell = [tableView dequeueReusableCellWithIdentifier:myCommentCell];
    if (cell == nil)
    {
        cell = [[MeCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:myCommentCell];
    }
    cell.isDestroy = YES;
    
    //[cell addDeleDestroy];
    TweetModel *model = [_dataArray objectAtIndex:indexPath.row];
    //NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[ShareToken readToken],@"access_token",model.tid,@"cid", nil];
    //[cell addDeleAddTarget:self Action:@selector(deleDestroy:) pram:dict isTweet:NO];
    cell.model = model;
    [cell addDeleteCommentSuccess:^(BOOL result)
    {
        if (result == YES)
        {
            NSLog(@"delete this tweet");
            [_dataArray removeObjectAtIndex:indexPath.row];
            [_myTableView reloadData];
        }else
        {
            NSLog(@"delefailed");
        }
    } failed:^(BOOL ret)
    {
        if (ret)
        {
            NSLog(@"不删除");
        }
    }];

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
    cell.controlview.hidden = YES;
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
-(void)deleDestroy
{
    DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"确定删除评论?" contentText:nil leftButtonTitle:@"删除" rightButtonTitle:@"取消"];
    [alert show];
    alert.leftBlock = ^()
    {
        NSLog(@"left button clicked");
    };
    alert.rightBlock = ^() {
        NSLog(@"right button clicked");
    };
}





@end
