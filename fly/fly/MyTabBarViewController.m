//
//  MyTabBarViewController.m
//  Weico
//
//  Created by xuyazhong on 15/2/18.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "MyTabBarViewController.h"
#import "HomeViewController.h"
#import "AtMeViewController.h"
#import "CommentMeViewController.h"
#import "FavListViewController.h"
#import "MeViewController.h"
#import "DeviceManager.h"
#import "ShareToken.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "KGModal.h"
#import "AppDelegate.h"

@interface MyTabBarViewController ()
{
    NSString *currentHeadImage;
    UIImageView *head;
    UILabel *selectLabel;
    CGFloat btnWidth;
    UIImageView  *customTabBar;
}
@end

@implementation MyTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {

    }
    return self;
}
-(void)setViewHidden
{
    customTabBar.hidden = YES;
}
-(void)setviewShow
{
    customTabBar.hidden = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getJSON];
    
    [self createUI];
    // Do any additional setup after loading the view.
}
-(void)getJSON
{
    NSDictionary *info = [ShareToken readUserInfo];
    NSString *uid = [info objectForKey:@"uid"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[ShareToken readToken],@"access_token",uid,@"uid", nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:kURLShowMe parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        //NSLog(@"success:%@",responseObject);
        currentHeadImage = [responseObject objectForKey:@"profile_image_url"];
        [head sd_setImageWithURL:[NSURL URLWithString:currentHeadImage]];
        //[headBtn sd_setImageWithURL:[NSURL URLWithString:currentHeadImage] forState:UIControlStateNormal];
        NSLog(@"head:%@",currentHeadImage);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"failed:%@",error.localizedDescription);
    }];
}
-(void)createUI
{
    FavListViewController *view1 = [[FavListViewController alloc]init];
    UINavigationController *nvc1 = [[UINavigationController alloc]initWithRootViewController:view1];
    
    CommentMeViewController *view2 = [[CommentMeViewController alloc]init];
    UINavigationController *nvc2 = [[UINavigationController alloc]initWithRootViewController:view2];
    
    HomeViewController *view3 = [[HomeViewController alloc]init];
    UINavigationController *nvc3 = [[UINavigationController alloc]initWithRootViewController:view3];
    
    AtMeViewController *view4 = [[AtMeViewController alloc]init];
    UINavigationController *nvc4 = [[UINavigationController alloc]initWithRootViewController:view4];
    
    MeViewController *view5 = [[MeViewController alloc]init];
    UINavigationController *nvc5 = [[UINavigationController alloc]initWithRootViewController:view5];
    

    
    NSArray *array = [NSArray arrayWithObjects:nvc1,nvc2,nvc3,nvc4,nvc5, nil];
    self.viewControllers = array;

    [self customTabBar];
}
-(void)customTabBar
{
    self.tabBar.hidden = YES;
    CGFloat tabBarViewY = self.view.frame.size.height - 49 ;
    
    customTabBar = [[UIImageView alloc]initWithFrame:CGRectMake(0, tabBarViewY, self.view.bounds.size.width, 49)];
    customTabBar.userInteractionEnabled = YES;
    customTabBar.image = [UIImage imageNamed:@"myTabBar"];
    customTabBar.tintColor = [UIColor orangeColor];
    
    NSArray *norArr = [NSArray arrayWithObjects:@"tab_favlist_selected",@"tab_user_comments_selected",@"tab_user_home_groups_selected",@"tab_user_at_selected",@"corner_circle", nil];
    
    //NSArray *selArr = [NSArray arrayWithObjects:@"home_tab_icon_1_selected",@"home_tab_icon_2_selected",@"home_tab_icon_3_selected",@"home_tab_icon_4_selected", nil];
    btnWidth = [DeviceManager currentScreenSize].width/norArr.count;
    for (int i=0; i<norArr.count; i++)
    {
        if (i==4)
        {
            head = [[UIImageView alloc]initWithFrame:CGRectMake(10+btnWidth*i, 0, 45, 45)];
            [customTabBar addSubview:head];
            
            UIImageView *headBtn = [[UIImageView alloc]initWithFrame:CGRectMake(10+btnWidth*i, 0, 45, 45)];
//            [headBtn setBackgroundImage:[UIImage imageNamed:norArr[i]] forState:UIControlStateNormal];
            [headBtn setImage:[UIImage imageNamed:norArr[i]]];
            headBtn.tag = 500+i;
            headBtn.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [headBtn addGestureRecognizer:tap];
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction)];
            [headBtn addGestureRecognizer:longPress];
            
            [customTabBar addSubview:headBtn];
        }
        else
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(10+btnWidth*i, 0, 45, 45);
            //btn.tintColor = [UIColor orangeColor];
            btn.tag = 500+i;
            if (i==2)
            {
                btn.selected = YES;
                selectLabel = [[UILabel alloc]initWithFrame:CGRectMake(btnWidth*i+btnWidth/2, 45, 5, 5)];
                selectLabel.backgroundColor = [UIColor orangeColor];
                [customTabBar addSubview:selectLabel];
            }
            [btn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:norArr[i]] forState:UIControlStateNormal];
            [customTabBar addSubview:btn];
        }

        
    }
    [self.view addSubview:customTabBar];
    self.selectedIndex = 2;

}
-(void)longPressAction
{
    [[KGModal sharedInstance] updateTweet];
    //[[KGModal sharedInstance] updateTweet];
}
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    for (int i=0; i<4; i++)
    {
        UIButton *mybtn = (UIButton *)[self.view viewWithTag:500+i];
        mybtn.selected = NO;
    }
    UIImageView *img = (UIImageView *)tap.view;
    
    self.selectedIndex = 4;
    CGRect frame = selectLabel.frame;
    frame.origin.x = img.frame.origin.x+btnWidth/2-10;
    selectLabel.frame = frame;
}
-(void)btnClickAction:(UIButton *)btn
{
    for (int i=0; i<4; i++)
    {
        UIButton *mybtn = (UIButton *)[self.view viewWithTag:500+i];
        mybtn.selected = NO;
    }
    btn.selected = YES;
    self.selectedIndex = btn.tag-500;
    CGRect frame = selectLabel.frame;
    frame.origin.x = btn.frame.origin.x+btnWidth/2-10;
    selectLabel.frame = frame;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
