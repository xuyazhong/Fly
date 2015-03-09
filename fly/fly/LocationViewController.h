//
//  LocationViewController.h
//  fly
//
//  Created by xyz on 15-3-8.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
//#import <MAMapKit/MAMapKit.h>

typedef void(^SelectBlock)(NSDictionary *latlong);
typedef void(^notSelectBlock)(NSString *noLocation);
@interface LocationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,MKMapViewDelegate>

-(void)requestLocation:(SelectBlock)block failed:(notSelectBlock)noLocation;

@end
