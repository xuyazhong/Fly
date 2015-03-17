//
//  SearchViewController.m
//  Weico
//
//  Created by xuyazhong on 15/2/18.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "SearchViewController.h"
#import "AFNetworking.h"
#import "SearchModel.h"
#import "UserProfileViewController.h"

@interface SearchViewController ()<INSSearchBarDelegate>
{
    UITableView *mytableview;
    NSMutableArray *_dataArray;
    NSMutableArray *_searchArray;
    NSMutableArray *_currentArray;
}
@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initializationz
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    _searchArray = [[NSMutableArray alloc]init];
    _currentArray = [[NSMutableArray alloc]init];
    self.isSearch = NO;
    self.navigationController.navigationBarHidden = YES;
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    self.searchBarWithDelegate = [[INSSearchBar alloc] initWithFrame:CGRectMake(20.0, 22.0, 44.0, 34.0)];
    self.searchBarWithDelegate.delegate = self;

    myView.backgroundColor = [UIColor orangeColor];
//    myView.backgroundColor = [UIColor colorWithRed:0.000 green:0.418 blue:0.673 alpha:1.000];
    [myView addSubview:self.searchBarWithDelegate];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setFrame:CGRectMake(self.view.bounds.size.width-45, 30, 40, 20)];
    [myView addSubview:backBtn];
    [self.view addSubview:myView];
    
    mytableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    mytableview.delegate = self;
    mytableview.dataSource = self;
    [self.view addSubview:mytableview];
    //[self.view addSubview:self.searchBarWithDelegate];
    // Do any additional setup after loading the view.
}
-(void)backAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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

#pragma mark - search bar delegate

- (CGRect)destinationFrameForSearchBar:(INSSearchBar *)searchBar
{
    return CGRectMake(20.0, 22.0, CGRectGetWidth(self.view.bounds) - 80.0, 34.0);
}

- (void)searchBar:(INSSearchBar *)searchBar willStartTransitioningToState:(INSSearchBarState)destinationState
{
    NSLog(@"willStartTransitioningToState");
    // Do whatever you deem necessary.
}

- (void)searchBar:(INSSearchBar *)searchBar didEndTransitioningFromState:(INSSearchBarState)previousState
{
    // Do whatever you deem necessary.
    NSLog(@"didEndTransitioningFromState");
}

- (void)searchBarDidTapReturn:(INSSearchBar *)searchBar
{
    NSLog(@"搜索");
    if (!self.isSearch)
    {
        self.isSearch = YES;
        NSLog(@"searchBarDidTapReturn");
        NSString *str = searchBar.searchField.text;
        NSLog(@"str:%@",str);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[ShareToken readToken],@"access_token",str,@"q", nil];
        NSLog(@"dict:%@",dict);
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager GET:kURLSearchUser parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             if (_dataArray.count > 0)
             {
                 [_dataArray removeAllObjects];
             }
             NSLog(@"success:%@",responseObject);
             for (NSDictionary *subDict in responseObject)
             {
                 SearchModel *model = [[SearchModel alloc]init];
                 model.screen_name = [subDict objectForKey:@"screen_name"];
                 model.uid = [subDict objectForKey:@"uid"];
                 model.followers_count = [subDict objectForKey:@"followers_count"];
                 [_dataArray addObject:model];
             }
             [_currentArray setArray:_dataArray];
             [mytableview reloadData];
             self.isSearch = NO;
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"failed:%@",error.localizedDescription);
             self.isSearch = NO;
         }];
        //self.isSearch = NO;
    }else
    {
        NSLog(@"正在搜索");
    }
    
    // Do whatever you deem necessary.
    // Access the text from the search bar like searchBar.searchField.text
}

- (void)searchBarTextDidChange:(INSSearchBar *)searchBar
{
    NSLog(@"联想");
    NSLog(@"searchBarTextDidChange");
    NSString *str = searchBar.searchField.text;
    if (str.length == 0)
    {
        [_currentArray removeAllObjects];
    }
    NSLog(@"str:%@",str);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[ShareToken readToken],@"access_token",str,@"q", nil];
    NSLog(@"dict:%@",dict);
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:kURLSearchUser parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (_searchArray.count>0)
         {
             [_searchArray removeAllObjects];
         }
         NSLog(@"success:%@",responseObject);
         for (NSDictionary *subDict in responseObject)
         {
             SearchModel *model = [[SearchModel alloc]init];
             model.screen_name = [subDict objectForKey:@"screen_name"];
             model.uid = [subDict objectForKey:@"uid"];
             model.followers_count = [subDict objectForKey:@"followers_count"];
             [_searchArray addObject:model];
         }
         [_currentArray setArray:_searchArray];
         [mytableview reloadData];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"failed:%@",error.localizedDescription);
     }];
    // Do whatever you deem necessary.
    // Access the text from the search bar like searchBar.searchField.text
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_currentArray count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *searchCellName = @"cellNickName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCellName];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:searchCellName];
    }
    SearchModel *model = [_currentArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.screen_name;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchModel *model = [_currentArray objectAtIndex:indexPath.row];
    UserProfileViewController *user = [[UserProfileViewController alloc]init];
    user.uid = model.uid;
    [self.navigationController pushViewController:user animated:YES];
}
@end
