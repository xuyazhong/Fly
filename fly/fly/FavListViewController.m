//
//  FavListViewController.m
//  weico
//
//  Created by xyz on 15-2-26.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "FavListViewController.h"


@interface FavListViewController ()

@end

@implementation FavListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentPage = 1;
    currentURL = kURLFavorites;
    self.title = @"我的收藏";

    [self getJSON:1 andUrl:currentURL];
    // Do any additional setup after loading the view.
}
-(void)loadNewData
{
    if (!self.isPost)
    {
        self.isPost = YES;
        NSLog(@"下拉刷新");
        currentPage = 1;
        [_myTableView setContentOffset:CGPointMake(0, 0) animated:YES];
        [self getJSON:currentPage andUrl:currentURL];
        self.isPost = NO;
    }
    
}
-(void)loadMoreData
{
    if (!self.isPost)
    {
        self.isPost = YES;
        currentPage ++;
        [self getJSON:currentPage andUrl:currentURL];
        self.isPost = NO;
    }
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
         NSArray *array = [responseObject objectForKey:@"favorites"];
         for (NSDictionary *status in array)
         {
             NSDictionary *subDict = [status objectForKey:@"status"];
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
    static NSString *myFavCell = @"fav";
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:myFavCell];
    if (cell == nil)
    {
        cell = [[TweetCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:myFavCell];
        cell.leftUtilityButtons = [self leftButtons];
        cell.rightUtilityButtons = [self rightDeleteButtons];
        cell.delegate = self;
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

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *indexpath = [_myTableView indexPathForCell:cell];
    TweetModel *getModel = [_dataArray objectAtIndex:indexpath.row];
    DetailViewController *detail = [[DetailViewController alloc]init];
    switch (index) {
        case 0:
        {
            detail.model = getModel;
            [self presentViewController:detail animated:YES completion:nil];
            break;
        }
        case 1:
        {
            NSIndexPath *cellIndexPath = [_myTableView indexPathForCell:cell];
            TweetModel *_getModel = [_dataArray objectAtIndex:cellIndexPath.row];
            DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"确认删除吗？" contentText:@"确认删除吗？" leftButtonTitle:@"删除" rightButtonTitle:@"取消"];
            [alert show];
            alert.leftBlock = ^()
            {
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[ShareToken readToken],@"access_token",_getModel.tid,@"id", nil];
                [manager POST:kURLFavoritesDestroy parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
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

//            
//            [self deleteFav:getModel];
//            NSIndexPath *cellIndexPath = [_myTableView indexPathForCell:cell];
//            [_dataArray removeObjectAtIndex:cellIndexPath.row];
//            [_myTableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
        default:
            break;
    }
}
-(void)deleteFav:(TweetModel *)getmodel
{
    NSLog(@"getModel:%@",getmodel);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[ShareToken readToken],@"access_token",getmodel.tid,@"id", nil];
    NSLog(@"dict:%@",dict);
    [manager POST:kURLFavoritesDestroy parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"success:%@",responseObject);
         [ShareToken sendMsg];
         [JDStatusBarNotification showWithStatus:@"取消收藏成功" dismissAfter:2 styleName:JDStatusBarStyleSuccess];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"failed:%@",error);
         [JDStatusBarNotification showWithStatus:@"取消收藏失败" dismissAfter:2 styleName:JDStatusBarStyleSuccess];
     }];
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
    return leftUtilityButtons;
}


@end
