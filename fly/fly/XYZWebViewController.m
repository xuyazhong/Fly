//
//  XYZWebViewController.m
//  fly
//
//  Created by xyz on 15-3-19.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "XYZWebViewController.h"
#import "MyTabBarViewController.h"

@interface XYZWebViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
}

@end

@implementation XYZWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configNav];
    [self createToolBarItems];
    [self loadDataWithUrlString:self.kUrlString];
    // Do any additional setup after loading the view.
}
-(void)configNav
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 60, 20)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAcion) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
}
-(void)backAcion
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
-(void)createToolBarItems
{
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(goback)];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(goForward)];
    
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshView)];
    
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    NSArray *mArr = [NSArray arrayWithObjects:spaceItem,item1,spaceItem,item2,spaceItem,item3,spaceItem, nil];
    self.toolbarItems = mArr;
}

//回到上级界面
-(void)goback
{
    [_webView goBack];
}
//前往下级界面
-(void)goForward
{
    [_webView goForward];
}

//刷新界面
-(void)refreshView
{
    [_webView reload];
}


//加载简单的javascript脚本语言
-(void)loadJSString
{
    //获取网页title 标签的值
    //NSString *js1 = @"document.title";
    //获取网址
    NSString *js1 = @"document.location.href";
    
    //stringByEvaluatingJavaScriptFromString webView处理js语句的方法
    NSString *title = [_webView stringByEvaluatingJavaScriptFromString:js1];
    NSLog(@"title:%@",title);
}



//利用UIWebView根据网址加载网页
-(void)loadDataWithUrlString:(NSString *)urlStr
{
    NSLog(@"request:%@",urlStr);
    _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //webView 通过请求对象 请求网页数据
    
    [_webView loadRequest:request];
    _webView.delegate = self;
    [self.view addSubview:_webView];
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

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //是否允许webView加载Request
    //request webView即将加载的请求
    NSLog(@"request:%@",request.URL);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"开始加载网页数据时调用");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"网页请求加载完成");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"加载失败:%@",error.localizedDescription);
}

@end
