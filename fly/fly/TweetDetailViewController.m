//
//  TweetDetailViewController.m
//  fly
//
//  Created by xyz on 15-3-14.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "TweetDetailViewController.h"

@interface TweetDetailViewController ()
{
    NSMutableArray *_dataArray1;
    NSMutableArray *_dataArray2;
    NSMutableArray *_dataArray3;
}
@end

@implementation TweetDetailViewController
#pragma mark - DataSource

- (void)loadDataSource {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *dataSource = [[NSMutableArray alloc] init];
        
        NSMutableArray *indexPaths;
        if (self.requestCurrentPage) {
            
            switch (self.requestCurrentPage)
            {
                case 0:
                    dataSource = _dataArray1;
                    break;
                case 1:
                    dataSource = _dataArray2;
                    break;
                case 2:
                    dataSource = _dataArray3;
                    break;
                default:
                    break;
            }
            indexPaths = [[NSMutableArray alloc] initWithCapacity:dataSource.count];
            [dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:self.dataSource.count + idx inSection:0]];
            }];
        }
        sleep(1.5);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.requestCurrentPage) {
                [self.dataSource addObjectsFromArray:dataSource];
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                [self endLoadMoreRefreshing];
            } else {
                self.dataSource = dataSource;
                [self.tableView reloadData];
                [self endPullDownRefreshing];
            }
        });
    });
}

#pragma mark - Life Cycle

- (void)didAppear
{
    [self startPullDownRefreshing];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.refreshViewType = XHPullDownRefreshViewTypeActivityIndicator;
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startPullDownRefreshing];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.showPushDetail)
    {
        CGRect tableViewFrame = self.tableView.frame;
        tableViewFrame.size.height -= 64;
        self.tableView.frame = tableViewFrame;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"currentpage:%d",self.requestCurrentPage);
    
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.numberOfLines = 0;
    }
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_avator%ld", (indexPath.row % 3)]];
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TweetDetailViewController *detailTableViewController = [[[self class] alloc] init];
    detailTableViewController.showPushDetail = YES;
    detailTableViewController.title = @"Detail";
    [self.navigationController pushViewController:detailTableViewController animated:YES];
}

@end
