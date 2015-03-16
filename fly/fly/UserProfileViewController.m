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


#define BUFFERX 20 //distance from side to the card (higher makes thinner card)
#define BUFFERY 40 //distance from top to the card (higher makes shorter card)

#define CORNER_RATIO 0.015
#define CP_RATIO 0.38
#define PP_RATIO 0.247
#define PP_X_RATIO 0.03
#define PP_Y_RATIO 0.213
#define PP_BUFF 3
#define LABEL_Y_RATIO .012


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
    
    NSLog(@"access_token=%@&uid=%@",[ShareToken readToken],myuid);
    [manager GET:kURLShowMe parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        //NSLog(@"res:%@",responseObject);
        //头像
        [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:[responseObject objectForKey:@"avatar_hd"]]];
        self.titleLabel.text = [responseObject objectForKey:@"name"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"failed:%@",error.localizedDescription);
    }];


    // Do any additional setup after loading the view.
}
-(void)createUI
{
    CGFloat height = self.view.frame.size.height;
    CGFloat width = self.view.frame.size.width;
    self.coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height * 0.4)];
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
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(width/2-50/2-15, 155, 80, 20)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.coverImageView addSubview:self.titleLabel];
    [self.view addSubview:self.coverImageView];
   
    
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
