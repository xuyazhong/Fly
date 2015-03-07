//
//  UpdateTweetVC.m
//  Weico
//
//  Created by xuyazhong on 15/2/20.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "UpdateTweetVC.h"
#import "AFNetworking.h"
#import "ShareToken.h"


@interface UpdateTweetVC ()
{
    UITextField *tweet;
    ShareToken *mytoken;
}
@end

@implementation UpdateTweetVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    mytoken = [ShareToken sharedToken];
    self.accessibilityElementsHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame = CGRectMake(0, 0, 60, 40);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:cancelBtn];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = left;
    
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendBtn.frame = CGRectMake(0, 0, 60, 40);
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:cancelBtn];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem = right;
    self.automaticallyAdjustsScrollViewInsets = NO;

    tweet = [[UITextField alloc]initWithFrame:CGRectMake(0,0, 320, 150)];
    [tweet becomeFirstResponder];
    tweet.delegate = self;
    [self.view addSubview:tweet];
    
    
    // Do any additional setup after loading the view.
}
-(void)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)sendAction
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:tweet.text,@"status",mytoken.token,@"access_token", nil];
    [manager POST:kURLupdate parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        //NSLog(@"success:%@",responseObject);
        [self dismissViewControllerAnimated:YES completion:nil];
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
