//
//  LocationViewController.m
//  fly
//
//  Created by xyz on 15-3-8.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController ()
{
    MAMapView *_mapView;
    NSMutableArray *_dataArray;
    UITableView *mytableView;
    CLLocationManager *_location;
    BOOL isFirst;
    CGFloat lat,lon;
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
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationController.navigationItem.leftBarButtonItem = backItem;
    _dataArray = [[NSMutableArray alloc]init];
    
    _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 64, [DeviceManager currentScreenSize].width, 250)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 250, [DeviceManager currentScreenSize].width, [DeviceManager currentScreenSize].height-250-64)];
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
-(void)addtomap
{
    
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
        isFirst = NO;
    }
    
    //CLLocationCoordinate2D lc2d = (CLLocationCoordinate2D)locations[0];
    
}
#pragma mark - tableview delegate 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *LocationCell = @"location";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LocationCell];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:LocationCell];
    }
    
    return cell;
}
@end
