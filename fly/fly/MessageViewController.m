//
//  MessageViewController.m
//  Weico
//
//  Created by xuyazhong on 15/2/18.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "MessageViewController.h"
#import "CommentVC.h"

@interface MessageViewController ()
{
    UITableView *_myTableView;
    NSMutableArray *_dataArray;
}
@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        _dataArray = [[NSMutableArray alloc]init];
        NSArray *atMe = [[NSArray alloc]initWithObjects:@"@我的", nil];
        NSArray *comment = [[NSArray alloc]initWithObjects:@"评论", nil];
        NSArray *like = [[NSArray alloc]initWithObjects:@"赞", nil];
        [_dataArray addObject:atMe];
        [_dataArray addObject:comment];
        [_dataArray addObject:like];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"消息";
    _myTableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *subArr = [_dataArray objectAtIndex:section];
    return [subArr count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID= @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    NSArray *subArr = [_dataArray objectAtIndex:indexPath.section];
    cell.textLabel.text = [subArr objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
            NSLog(@"@我的");
            break;
        case 1:
            NSLog(@"评论");
            [self comment];
            break;
        case 2:
            NSLog(@"赞");
            break;
        default:
            break;
    }
    
}

-(void)comment
{
    CommentVC *comment = [[CommentVC alloc]init];
    [self.navigationController pushViewController:comment animated:YES];
}
@end
