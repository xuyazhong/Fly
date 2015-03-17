//
//  LocationViewController.m
//  fly
//
//  Created by xyz on 15-3-8.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "LocationViewController.h"
#import "AFNetworking.h"
#import "POIModel.h"
#import "POICell.h"

@interface LocationViewController ()
{
    MKMapView *_mapView;
    NSMutableArray *_dataArray;
    UITableView *mytableView;
    CLLocationManager *_location;
    BOOL isFirst;
    CGFloat lat,lon;
    SelectBlock _block;
    notSelectBlock _noLocation;
}
@end

@implementation LocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的位置";
    isFirst = YES;
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(0, 0, 60, 20)];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    
    
    UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [deleBtn setFrame:CGRectMake(0, 0, 60, 20)];
    [deleBtn addTarget:self action:@selector(deleBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *deleItem = [[UIBarButtonItem alloc]initWithCustomView:deleBtn];
    self.navigationItem.rightBarButtonItem = deleItem;
    
    _dataArray = [[NSMutableArray alloc]init];
    
    _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 64, [DeviceManager currentScreenSize].width, 250)];
    _mapView.delegate = self;
    CLLocationCoordinate2D lc2d = CLLocationCoordinate2DMake(39.896304, 116.410103);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion region = MKCoordinateRegionMake(lc2d, span);
    [_mapView setRegion:region animated:YES];
    [self.view addSubview:_mapView];
    
    mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 250, [DeviceManager currentScreenSize].width, [DeviceManager currentScreenSize].height-250)];
    mytableView.delegate = self;
    mytableView.dataSource = self;
    [self.view addSubview:mytableView];
    
    
    
    _location = [[CLLocationManager alloc]init];
    _location.distanceFilter = kCLLocationAccuracyBest;
    _location.delegate = self;
    [_location startUpdatingLocation];
    [_location requestAlwaysAuthorization];
    // Do any additional setup after loading the view.
}
-(void)deleBtnAction
{
    lat = 0;
    lon = 0;
    _noLocation(@"no location");
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)getAddress
{
    NSString *_lat = [NSString stringWithFormat:@"%f",lat];
    NSString *_long = [NSString stringWithFormat:@"%f",lon];
    
    NSDictionary *poiDict = [NSDictionary dictionaryWithObjectsAndKeys:[ShareToken readToken],@"access_token",_lat,@"lat",_long,@"long", nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:kURLPOIS parameters:poiDict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSArray *pois = [responseObject objectForKey:@"pois"];
         for (NSDictionary *subDict in pois)
         {
             POIModel *model = [[POIModel alloc]init];
             model.title = [subDict objectForKey:@"title"];
             model.poi_street_address = [subDict objectForKey:@"poi_street_address"];
             model.lon = [subDict objectForKey:@"lon"];
             model.lat = [subDict objectForKey:@"lat"];
             model.checkin_user_num = [subDict objectForKey:@"checkin_user_num"];
             [_dataArray addObject:model];
         }
         [mytableView reloadData];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"error:%@",error);
     }];
}
-(void)addtomap
{
    CLGeocoder *geo = [[CLGeocoder alloc]init];
    CLLocation *getLocation = [[CLLocation alloc]initWithLatitude:lat longitude:lon];
    [geo reverseGeocodeLocation:getLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (placemarks.count)
        {
            CLPlacemark *mark = [placemarks firstObject];
            MKPointAnnotation *mypoint = [[MKPointAnnotation alloc]init];
            mypoint.coordinate = CLLocationCoordinate2DMake(lat, lon);
            mypoint.title = [mark.addressDictionary objectForKey:@"Name"];
            mypoint.subtitle = [mark.addressDictionary objectForKey:@"Street"];
            
            MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
            MKCoordinateRegion region = MKCoordinateRegionMake(mypoint.coordinate, span);
            [_mapView setRegion:region animated:YES];
            [_mapView addAnnotation:mypoint];
            [_mapView selectAnnotation:mypoint animated:YES];
            NSLog(@"lat:%f,long:%f",lat,lon);

        }
    }];
    
    
}
-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)requestLocation:(SelectBlock)block failed:(notSelectBlock)noLocation
{
    _block = block;
    _noLocation = noLocation;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - cll
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    if (isFirst)
    {
        lat = location.coordinate.latitude;
        lon = location.coordinate.longitude;
        [self addtomap];
        [self getAddress];
        isFirst = NO;
    }
    
    //CLLocationCoordinate2D lc2d = (CLLocationCoordinate2D)locations[0];
    
}
/*
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *pinName = @"pin";
    MKAnnotationView *mypin = [mapView dequeueReusableAnnotationViewWithIdentifier:pinName];
    if (mypin == nil)
    {
        mypin = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:pinName];
    }
    mypin.canShowCallout = YES;

    return mypin;
}
 */
#pragma mark - tableview delegate 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    POIModel *model = [_dataArray objectAtIndex:indexPath.row];
    NSString *_lat = [NSString stringWithFormat:@"%@",model.lat];
    NSString *_long = [NSString stringWithFormat:@"%@",model.lon];
    
    NSDictionary *poiDict = [NSDictionary dictionaryWithObjectsAndKeys:_lat,@"lat",_long,@"long", nil];
    _block(poiDict);
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *LocationCell = @"location";
    POICell *cell = [tableView dequeueReusableCellWithIdentifier:LocationCell];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"POICell" owner:nil options:nil] lastObject];
    }
    POIModel *model = [_dataArray objectAtIndex:indexPath.row];
    cell.title.text = model.title;
    NSString *checkin = [NSString stringWithFormat:@"%@",model.checkin_user_num];
    NSString *str = [NSString stringWithFormat:@"%@ 人去过 · %@",checkin,model.poi_street_address];
    cell.address.text = str;
    return cell;
}
@end
