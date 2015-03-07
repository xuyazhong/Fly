//
//  CommentViewController.m
//  weico
//
//  Created by xuyazhong on 15/3/2.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "CommentViewController.h"
#import "AFNetworking.h"
#import "ShareToken.h"
#import "RepostViewController.h"

@interface CommentViewController ()
{
    UITextField *tweet;
}
@end

@implementation CommentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)createUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *repostBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    repostBtn.frame = CGRectMake(0, 0, 80, 20);
    [repostBtn setTitle:@"评论" forState:UIControlStateNormal];
    [repostBtn addTarget:self action:@selector(repostAction) forControlEvents:UIControlEventTouchUpInside];
    [repostBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:repostBtn];
    self.navigationItem.rightBarButtonItem = right;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 80, 20);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = left;
    
    
    tweet = [[UITextField alloc]initWithFrame:CGRectMake(0,0, 320, 150)];
    [tweet becomeFirstResponder];
    tweet.delegate = self;
    [self.view addSubview:tweet];
    
}
-(void)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)repostAction
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[ShareToken readToken],@"access_token",_model.tid,@"id",tweet.text,@"comment", nil];
    [manager POST:kURLCreateComment parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"success:%@",responseObject);
         [self dismissViewControllerAnimated:YES completion:nil];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"failed:%@",error.localizedDescription);
     }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - textfieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (tweet.text.length>0)
    {
        NSLog(@"ok");
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tweet becomeFirstResponder];
    return YES;
}

@end
