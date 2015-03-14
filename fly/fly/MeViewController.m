//
//  MeViewController.m
//  Weico
//
//  Created by xuyazhong on 15/2/18.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "MeViewController.h"
//#import "UIImageView+WebCache.h"
//#import "UIButton+WebCache.h"
//#import "AFNetworking.h"
//#import "TweetModel.h"
//#import "DetailViewController.h"
//#import "MeCell.h"
//#import "XYZImageView.h"
//#import "MeCell.h"
//#import "UIButton+WebCache.h"
//#import "MeCell.h"


@interface MeViewController ()
{
    
}
@end

@implementation MeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentPage = 1;
    currentURL = kURLUserTimeLine;
    self.title = @"我";
    [self getJSON:1 andUrl:currentURL];
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
    NSLog(@"上拉加载");
    currentPage ++;
    [self getJSON:currentPage andUrl:currentURL];
}
-(void)getJSON:(int)page andUrl:(NSString *)url
{
    NSDictionary *dict;
    dict = [NSDictionary dictionaryWithObjectsAndKeys:[ShareToken readToken],@"access_token",[NSString stringWithFormat:@"%d",page],@"page",@"uid",[[ShareToken readUserInfo] objectForKey:@"uid"], nil];
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
             model.source = [super flattenHTML:[subDict objectForKey:@"source"]];
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
    static NSString *myCellID = @"me";
    MeCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellID];
    cell.isDelete = YES;
    if (cell == nil)
    {
        cell = [[MeCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:myCellID];
        cell.leftUtilityButtons = [self leftButtons];
        cell.rightUtilityButtons = [self rightDeleteButtons];
        cell.delegate = self;
    }

    
    TweetModel *model = [_dataArray objectAtIndex:indexPath.row];
    cell.tid = model.tid;
    cell.model = model;
    [cell addDeleteTweetSuccess:^(BOOL result) {
        if (result)
        {
            NSLog(@"删除成功");
            [_dataArray removeObjectAtIndex:indexPath.row];
            [_myTableView reloadData];
        }
        else{
            NSLog(@"删除失败");
        }
    } failed:^(BOOL ret)
    {
        NSLog(@"取消删除");
    }];
    //[cell addDelete];
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
