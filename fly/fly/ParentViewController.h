//
//  ParentViewController.h
//  fly
//
//  Created by xyz on 15-3-12.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "SWTableViewCell.h"
#import "AFNetworking.h"
#import "ShareToken.h"
#import "TweetModel.h"
#import "TweetCell.h"
#import "UIImageView+WebCache.h"
#import "ListsModel.h"
#import "UpdateTweetVC.h"
#import "RepostViewController.h"
#import "DetailViewController.h"
#import "XYZImageView.h"
#import "MyTabBarViewController.h"
#import "KGModal.h"
#import "ZoomImageView.h"
#import "UIButton+WebCache.h"
#import "MeCell.h"

@interface ParentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>
{
    UITableView *_myTableView;
    NSMutableArray *_dataArray;
    NSMutableArray *_groupListArray;
    int currentPage;
    NSString *currentGroupId;
    NSString *currentUrl;
    UIScrollView *groupList;
    UIButton *titleBtn;
    NSString *currentURL;
}
-(void)addPic:(NSArray *)subArr toView:(UIScrollView *)myview;
-(NSArray *)leftButtons;
-(NSArray *)rightButtons;
-(NSString *)flattenHTML:(NSString *)html;
@end
