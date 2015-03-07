//
//  DetailRepostCommentCell.h
//  weico
//
//  Created by xyz on 15-3-2.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailRepostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headimg;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *tweetContent;

@end
