//
//  SearchViewController.h
//  Weico
//
//  Created by xuyazhong on 15/2/18.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INSSearchBar.h"

@interface SearchViewController :UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) INSSearchBar *searchBarWithDelegate;
@property (nonatomic, assign) BOOL isSearch;

@end
