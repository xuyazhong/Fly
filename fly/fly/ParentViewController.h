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
    int currentPage;
    NSString *currentGroupId;
    NSString *currentUrl;
    UIScrollView *groupList;
    UIButton *titleBtn;
    NSString *currentURL;
    NSMutableArray *_groupListArray;
    NSMutableArray *_dataArray;
    UITableView *_myTableView;
    int currentMaxDisplayedCell;
    int currentMaxDisplayedSection;
}

@property (strong, nonatomic) NSNumber* cellZoomXScaleFactor;

/**  @property cellZoomYScaleFactor
 *   @brief The Y Zoom Factor
 *   How much to scale to y axis of the cell before it is animated back to normal size. 1 is normal size. >1 is bigger, <1 is smaller. **/
@property (strong, nonatomic) NSNumber* cellZoomYScaleFactor;

/**  @property cellZoomInitialAlpha
 *   @brief The inital Alpha value of the cell
 *   The initial alpha value of the cell when it starts animation. For example if you set this to be 0 then the cell will begin completely transparent, and will fade into view as well as zooming. Value between 0 and 1. **/
@property (strong, nonatomic) NSNumber* cellZoomInitialAlpha;

/**  @property cellZoomAnimationDuration
 *   @brief The Animation Duration
 *   The duration of the animation effect, in seconds. **/
@property (strong, nonatomic) NSNumber* cellZoomAnimationDuration;

/*
 Resets the view counter. The animation effect doesnt repeat when you've already seen a cell once, for example if you scroll down past cell #5, then scroll back to the top and down again, the animation won't repeat as you scroll back down past #5. This is by design to make only "new" cells animate as they appear. Call this method to reset the count of which cells have been seen (e.g when you call reload on the table's data)
 */
-(void)resetViewedCells;

@property (nonatomic,assign) BOOL isPost;
-(void)addPic:(NSArray *)subArr toView:(UIScrollView *)myview;
-(NSArray *)leftButtons;
-(NSArray *)rightButtons;
-(NSString *)flattenHTML:(NSString *)html;
-(NSArray *)rightDeleteButtons;
-(void)addFav:(TweetModel *)getmodel;
@end
