//
//  UserProfileViewController.m
//  fly
//
//  Created by xyz on 15-3-16.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "UserProfileViewController.h"
#import "RKCardView.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"


#define BUFFERX 20 //distance from side to the card (higher makes thinner card)
#define BUFFERY 40 //distance from top to the card (higher makes shorter card)
@interface UserProfileViewController ()

@end

@implementation UserProfileViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = YES;
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    
    RKCardView *cardView = [[RKCardView alloc]initWithFrame:CGRectMake(BUFFERX, BUFFERY, self.view.frame.size.width-2*BUFFERX, self.view.frame.size.height-2*BUFFERY)];
    //背景
    cardView.coverImageView.image = [UIImage imageNamed:@"page_cover_default_background@2x.jpg"];
    [self.view addSubview:cardView];
    NSString *myuid = [NSString stringWithFormat:@"%@",self.uid];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[ShareToken readToken],@"access_token",myuid,@"uid", nil];
    
    NSLog(@"access_token=%@&uid=%@",[ShareToken readToken],myuid);
    [manager GET:kURLShowMe parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        //NSLog(@"res:%@",responseObject);
        //头像
        [cardView.profileImageView sd_setImageWithURL:[NSURL URLWithString:[responseObject objectForKey:@"avatar_hd"]]];
        cardView.titleLabel.text = [responseObject objectForKey:@"name"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"failed:%@",error.localizedDescription);
    }];


    [self.view addSubview:cardView];
    // Do any additional setup after loading the view.
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

@end
