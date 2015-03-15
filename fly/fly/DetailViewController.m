//
//  DetailViewController.m
//  weico
//
//  Created by xyz on 15-3-1.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "DetailViewController.h"
#import "DeviceManager.h"
#import "TweetCell.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "ShareToken.h"
#import "DetailCommentCell.h"
#import "DetailRepostCell.h"
#import "UIImageView+WebCache.h"
#import "KGModal.h"
#import "ZoomImageView.h"



@interface DetailViewController ()
{
    NSMutableArray *_dataArray;
    NSMutableArray *currentArray;
    UILabel *selectedLabel;
    UIScrollView *myscrollview;
    UITableView *mytableview1;
    UITableView *mytableview2;
    UITableView *mytableview3;
    CGFloat _repostBtnX;
    CGFloat _commentBtnX;
    CGFloat _tweetBtnX;
}
@end

@implementation DetailViewController
- (id)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"begin");
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _dataArray = [[NSMutableArray alloc]init];
    _data1 = [[NSMutableArray alloc]init];
    _data2 = [[NSMutableArray alloc]init];
    _data3 = [[NSMutableArray alloc]initWithObjects:_model, nil];
    [_dataArray addObject:_data1];
    [_dataArray addObject:_data2];
    [_dataArray addObject:_data3];
    
    
    
    
    // Make views for the navigation bar

    
    myscrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0,104,[DeviceManager currentScreenSize].width, [DeviceManager currentScreenSize].height-114)];
    myscrollview.contentSize = CGSizeMake(320*3, 0);
    myscrollview.contentOffset = CGPointMake(320, 0);
    myscrollview.pagingEnabled = YES;
    mytableview1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [DeviceManager currentScreenSize].width, [DeviceManager currentScreenSize].height-104)];
    mytableview1.delegate = self;
    mytableview1.dataSource = self;
    mytableview1.tag = 201;
    mytableview2 = [[UITableView alloc]initWithFrame:CGRectMake(320, 0, [DeviceManager currentScreenSize].width, [DeviceManager currentScreenSize].height-104)];
    mytableview2.delegate = self;
    mytableview2.dataSource = self;
    mytableview2.tag = 202;
    mytableview3 = [[UITableView alloc]initWithFrame:CGRectMake(640, 0, [DeviceManager currentScreenSize].width, [DeviceManager currentScreenSize].height-104)];
    mytableview3.delegate = self;
    mytableview3.dataSource = self;
    mytableview3.tag = 203;
    [myscrollview addSubview:mytableview1];
    [myscrollview addSubview:mytableview2];
    [myscrollview addSubview:mytableview3];
    myscrollview.delegate = self;
    [self.view addSubview:myscrollview];
    
    [self addHeaderWithFrame:CGRectMake(0,64 , [DeviceManager currentScreenSize].width, 40)];
    [self addFooterWithFrame:CGRectMake(0, [DeviceManager currentScreenSize].height-40,[DeviceManager currentScreenSize].width, 40)];
    // Do any additional setup after loading the view.
    [self loadTableView1];
    [self loadTableView2];
    [self loadTableView3];
    


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
-(void)loadTableView1
{
    if (_data1.count==0)
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:[ShareToken readToken],@"access_token",_model.tid,@"id", nil];
        NSLog(@"dict:%@",dict);
        [manager GET:kURLRepostList parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             NSArray *subArr = [responseObject objectForKey:@"reposts"];
             //NSLog(@"reposts subArr:%@",subArr);
             for (NSDictionary *subDict in subArr)
             {
                 TweetModel *model = [[TweetModel alloc]init];
                 model.tid = [subDict objectForKey:@"id"];
                 model.text = [subDict objectForKey:@"text"];
                 model.created_at = [self getTime:[subDict objectForKey:@"created_at"]];
                 NSDictionary *userDict = [subDict objectForKey:@"user"];
                 UserModel *user = [[UserModel alloc]init];
                 user.name = [userDict objectForKey:@"name"];
                 user.uid = [userDict objectForKey:@"id"];
                 user.profile_image_url = [userDict objectForKey:@"profile_image_url"];
                 model.user = user;
                 [_data1 addObject:model];
             }
             NSLog(@"_data1:%@",_data1);
             //[myJSON setDictionary:responseObject];
             [mytableview1 reloadData];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"failed:%@",error.localizedDescription);
         }];
        
    }
    
    [mytableview1 reloadData];
    
}
-(void)loadTableView2
{
    if (_data2.count==0)
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:[ShareToken readToken],@"access_token",_model.tid,@"id", nil];
        NSLog(@"dict:%@",dict);
        [manager GET:kURLCommentShow parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSArray *subArr = [responseObject objectForKey:@"comments"];
             //NSLog(@"comment subArr:%@",subArr);
             for (NSDictionary *subDict in subArr)
             {
                 TweetModel *model = [[TweetModel alloc]init];
                 model.tid = [subDict objectForKey:@"id"];
                 model.text = [subDict objectForKey:@"text"];

                 model.created_at = [self getTime:[subDict objectForKey:@"created_at"]];
                 NSDictionary *userDict = [subDict objectForKey:@"user"];
                 UserModel *user = [[UserModel alloc]init];
                 user.name = [userDict objectForKey:@"name"];
                 user.uid = [userDict objectForKey:@"id"];
                 user.profile_image_url = [userDict objectForKey:@"profile_image_url"];
                 model.user = user;
                 [_data2 addObject:model];
             }
             NSLog(@"_data2:%@",_data2);
             [mytableview2 reloadData];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"failed:%@",error.localizedDescription);
         }];
        //[self getJSONWithURLString:kURLCommentShow andArray:_data2];
        //NSLog(@"comment json:%@",myJSON);
        
    }
    
    [mytableview2 reloadData];
}
-(NSString *)getTime:(NSString *)createTime
{
    /*
     计算时间
     */
    //设置时间
    NSDateFormatter *iosDateFormater=[[NSDateFormatter alloc]init];
    iosDateFormater.dateFormat=@"EEE MMM d HH:mm:ss Z yyyy";
    
    //必须设置，否则无法解析
    iosDateFormater.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    NSDate *date=[iosDateFormater dateFromString:createTime];
    
    //目的格式
    NSDateFormatter *resultFormatter=[[NSDateFormatter alloc]init];
    [resultFormatter setDateFormat:@"HH:mm"];
    
    return [resultFormatter stringFromDate:date];
}
-(void)loadTableView3
{
    [mytableview3 reloadData];
}
-(void)getJSONWithURLString:(NSString *)url andArray:(NSMutableArray *)arr
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:[ShareToken readToken],@"access_token",_model.tid,@"id", nil];
    NSLog(@"dict:%@",dict);
    [manager GET:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"success:%@",responseObject);
        //myJSON = responseObject;
        
        //[myJSON setDictionary:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"failed:%@",error.localizedDescription);
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
-(void)addHeaderWithFrame:(CGRect)frame
{
    UIView *headerView = [[UIView alloc]initWithFrame:frame];
    headerView.backgroundColor = [UIColor whiteColor];
    CGFloat btnWidth = (frame.size.width-20)/3;
    //NSLog(@"btnwidth:%f",btnWidth);
    UILabel *repostCount = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, 40, 13)];
    repostCount.text = [NSString stringWithFormat:@"%@",_model.reposts_count];
    repostCount.textAlignment = NSTextAlignmentCenter;
    repostCount.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:repostCount];
    UIButton *repostBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [repostBtn setTitle:@"转发" forState:UIControlStateNormal];
    [repostBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [repostBtn setFrame:CGRectMake(10, 16, 40, 13)];
    _repostBtnX = 10;
    [repostBtn addTarget:self action:@selector(switchList:) forControlEvents:UIControlEventTouchUpInside];
    repostBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    repostBtn.tag = 101;
    [headerView addSubview:repostBtn];
    
    UILabel *commentCount = [[UILabel alloc]initWithFrame:CGRectMake(10+btnWidth, 3, 40, 13)];
    commentCount.text = [NSString stringWithFormat:@"%@",_model.comments_count];
    commentCount.textAlignment = NSTextAlignmentCenter;
    commentCount.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:commentCount];
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    [commentBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [commentBtn setFrame:CGRectMake(10+btnWidth, 16, 40, 13)];
    _commentBtnX = 10+btnWidth;
    [commentBtn addTarget:self action:@selector(switchList:) forControlEvents:UIControlEventTouchUpInside];
    commentBtn.titleLabel.font = [UIFont systemFontOfSize:13];;
    commentBtn.tag = 102;
    [headerView addSubview:commentBtn];
    
    selectedLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+btnWidth, 37, 40, 3)];
    selectedLabel.backgroundColor = [UIColor orangeColor];
    
    [headerView addSubview:selectedLabel];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10+btnWidth+btnWidth, 3, 40, 13)];
    label.text = @"查看";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:label];
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [detailBtn setTitle:@"微博" forState:UIControlStateNormal];
    detailBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [detailBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [detailBtn setFrame:CGRectMake(10+btnWidth+btnWidth, 16, 40, 13)];
    _tweetBtnX = 10+btnWidth+btnWidth;
    [detailBtn addTarget:self action:@selector(switchList:) forControlEvents:UIControlEventTouchUpInside];
    detailBtn.tag = 103;
    [headerView addSubview:detailBtn];
    [self.view addSubview:headerView];
    
}
-(void)switchList:(UIButton *)btn
{
    CGRect frame = selectedLabel.frame;
    frame.origin.x = btn.frame.origin.x;
    selectedLabel.frame = frame;
    CGPoint point ;
    //[currentArray setArray:[_dataArray objectAtIndex:btn.tag-101]];
    if (frame.origin.x/100>2)
    {
        point = CGPointMake(640, 0);
    }else if(frame.origin.x/100>1)
    {
        point = CGPointMake(320, 0);
    }else
    {
        point = CGPointMake(0, 0);
    }
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    myscrollview.contentOffset = point;
    [UIView commitAnimations];
    
}
-(void)addLabelWithFrameX:(CGFloat)x toView:(UIView *)view
{
    CGRect frame = CGRectMake(x, 5, 2, 20);
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.backgroundColor = [UIColor orangeColor];
    [view addSubview:label];
}
-(void)addFooterWithFrame:(CGRect)frame
{
    
    UIView *footerView = [[UIView alloc]initWithFrame:frame];
    footerView.backgroundColor = [UIColor whiteColor];
    CGFloat btnWidth = 60;
    
    UIButton *repostBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [repostBtn setTitle:@"转发" forState:UIControlStateNormal];
    repostBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [repostBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [repostBtn setFrame:CGRectMake(10, 5, btnWidth, 20)];
    [repostBtn addTarget:self action:@selector(repostAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:repostBtn];
    
    [self addLabelWithFrameX:70 toView:footerView];
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    commentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [commentBtn addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    [commentBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [commentBtn setFrame:CGRectMake(10+btnWidth+2, 5, btnWidth, 20)];
    [footerView addSubview:commentBtn];
    [self addLabelWithFrameX:132 toView:footerView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"关闭" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [cancelBtn setFrame:CGRectMake(10+btnWidth+btnWidth+4, 5, btnWidth, 20)];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:cancelBtn];
    [self.view addSubview:footerView];
}
-(void)repostAction
{
    [[KGModal sharedInstance] repostTweet:_model];
//    RepostViewController *repost = [[RepostViewController alloc]init];
//    repost.model = _model;
//    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:repost];
//    [self presentViewController:nvc animated:YES completion:nil];
}
-(void)commentAction
{
    [[KGModal sharedInstance] commentTweet:_model];
//    CommentViewController *comment = [[CommentViewController alloc]init];
//    comment.model = _model;
//    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:comment];
//    [self presentViewController:nvc animated:YES completion:nil];
}
-(void)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 201)
    {
        NSLog(@"table1:%d",[_data1 count]);
        return [_data1 count];
    }else if (tableView.tag == 202)
    {
        NSLog(@"table2:%d",[_data2 count]);
        return [_data2 count];
    }else if (tableView.tag == 203)
    {
        return 1;
    }else
        return 0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"mytableviewtag:%d",tableView.tag);
    if (tableView.tag == 201)
    {
        static NSString *cellID = @"repost";
        NSLog(@"转发");
        DetailRepostCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"DetailRepostCell" owner:nil options:nil] lastObject];
        }
        if (_data1.count>0)
        {
            TweetModel *model = [_data1 objectAtIndex:indexPath.row];
            [cell.headimg sd_setImageWithURL:[NSURL URLWithString:model.user.profile_image_url]];
            cell.nickname.text = model.user.name;
            cell.tweetContent.text = model.text;
            cell.createTime.text = model.created_at;
        }
        
        return cell;
    }else if (tableView.tag == 202)
    {
        static NSString *cellID2 = @"comment";
        NSLog(@"评论");
        DetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"DetailCommentCell" owner:nil options:nil] lastObject];
        }
        if (_data2.count>0)
        {
            TweetModel *model = [_data2 objectAtIndex:indexPath.row];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.user.profile_image_url]];
            cell.nickname.text = model.text;
            cell.createTime.text = model.created_at;
            cell.tweetContent.text = model.text;
        }
        
        return cell;
    }else if(tableView.tag == 203)
    {
        NSLog(@"微博");
        
        return [self getMytableView3:mytableview3];
    }
    else
    {
        NSLog(@"nil return");
        return nil;
    }
    
    
}
-(UITableViewCell *)getMytableView3:(UITableView *)tableView
{
    static NSString *cellID3 = @"custom";
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID3];
    if (cell == nil)
    {
        cell = [[TweetCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID3];
    }
    TweetModel *model = [self model];
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
    NSLog(@"comment:%@&&repost:%@",model.comments_count,model.reposts_count);
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
        //cell.imageView.hidden = YES;
        cell.retweetView.hidden = NO;
        cell.retweetLabel.hidden = NO;
        cell.retweetLabel.text = model.model.text;
        NSLog(@"text:%@",model.model.text);
        cell.retweetLabel.font = [UIFont systemFontOfSize:16];
        cell.retweetLabel.lineBreakMode = NSLineBreakByCharWrapping;
        cell.retweetLabel.numberOfLines = 0;
        
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
    TweetModel *model;
    if (tableView.tag == 201)
    {
        model = [_data1 objectAtIndex:indexPath.row];
    }else if (tableView.tag == 202)
    {
        model = [_data2 objectAtIndex:indexPath.row];
    }else if (tableView.tag == 203)
    {
         model = [self model];
    }
    
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
    
        return 0;
    /*
    
     */
}
//-(void)addPic:(NSArray *)subArr toView:(UIScrollView *)myview
//{
//    for (int i=0; i<subArr.count; i++)
//    {
//        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(85*i, 0, 80, 80)];
//        [image sd_setImageWithURL:[NSURL URLWithString:subArr[i]]];
//        [myview addSubview:image];
//    }
//}
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
        //UIViewContentModeScaleAspectFit 顯示圖片的原始比例,自適應
        _imageView.contentMode =UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor=[UIColor clearColor];
        NSMutableString *bmiddle = [NSMutableString stringWithString:subArr[i]];
        [_imageView sd_setImageWithURL:[NSURL URLWithString:subArr[i]]];
        [_imageView addZoom:[bmiddle stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"]];
        [myview addSubview:_imageView];
    }
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGRect frame = selectedLabel.frame;
    
    
    CGPoint point = scrollView.contentOffset;
    if (point.x==0)
    {
        frame.origin.x = _repostBtnX;
    }
    if (point.x==320)
    {
        frame.origin.x = _commentBtnX;
    }
    if (point.x==640)
    {
        frame.origin.x = _tweetBtnX;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    selectedLabel.frame = frame;
    [UIView commitAnimations];
    
}



@end
