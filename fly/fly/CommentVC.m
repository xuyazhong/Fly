//
//  CommentVC.m
//  weico
//
//  Created by xuyazhong on 15/2/23.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "CommentVC.h"
#import "AFNetworking.h"
#import "ShareToken.h"

@interface CommentVC ()
{
    NSString *currentURL;
    UIButton *titleBtn;
    ShareToken *token;
    int currentPage;
    UIView *groupList;
    UITableView *mytableView;
    NSMutableArray *_dataArray;
    NSArray *urlArr;
}
@end

@implementation CommentVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    token = [ShareToken sharedToken];
    currentPage = 1;
    [self createUI];
    // Do any additional setup after loading the view.
}
-(void)createUI
{
    mytableView  = [[UITableView alloc]initWithFrame:self.view.bounds];
    mytableView.delegate = self;
    mytableView.dataSource = self;
    [self.view addSubview:mytableView];
    
    titleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    titleBtn.frame = CGRectMake(0, 0, 100, 40);
    [titleBtn setTitle:@"所有评论" forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(titleBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
    
    NSArray *commentArr = [NSArray arrayWithObjects:@"所有评论",@"关注的人",@"我发出的", nil];
    groupList = [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-100, 64, 200, 120)];
    groupList.backgroundColor = [UIColor blackColor];
    groupList.alpha = 0.8;
    groupList.hidden = YES;
    for (int i=0; i<commentArr.count; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setFrame:CGRectMake(5, 5+30*i, 190, 40)];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.tag = 80 + i;
        [btn addTarget:self action:@selector(selectGroup:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setTitle:commentArr[i] forState:UIControlStateNormal];
        [groupList addSubview:btn];
        [self.view addSubview:groupList];
    }
    
    
}

-(void)getJSONWithURL:(NSString *)url andPage:(int)page
{
    NSDictionary *dict;
    dict = [NSDictionary dictionaryWithObjectsAndKeys:token.token,@"access_token", nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"success!%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"error:%@",error.localizedDescription);
    }];
    NSLog(@"token:%@",token.token);
}
-(void)titleBtnClickAction:(UIButton *)btn
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
    [titleBtn setTitle:btn.titleLabel.text forState:UIControlStateNormal];
    //self.navigationItem.titleView = btn;
    for (int i=0; i<_dataArray.count; i++)
    {
        UIButton *myBtn = (UIButton *)[self.view viewWithTag:50+i];
        myBtn.selected = NO;
    }
    btn.selected = YES;
    titleBtn.selected = NO;
    groupList.hidden = YES;
    currentPage=1;
    //currentURL = ;
    [self getJSONWithURL:urlArr[btn.tag-80] andPage:currentPage];
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
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellName = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    return cell;
}

@end
