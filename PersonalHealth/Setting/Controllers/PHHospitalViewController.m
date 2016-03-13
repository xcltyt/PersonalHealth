//
//  PHHospitalViewController.m
//  PersonalHealth
//
//  Created by lifan on 16/3/4.
//  Copyright © 2016年 PHTeam. All rights reserved.
//

#import "PHHospitalViewController.h"
#import "TLCityPickerController.h"
#import "PHHospitalData.h"
#import "PHHospitalCell.h"

#import <CoreLocation/CoreLocation.h>


@interface PHHospitalViewController ()<TLCityPickerDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PHHospitalData *hospitalData;
@property (nonatomic, strong) NSString * localCityName;

@end

@implementation PHHospitalViewController

#pragma mark - Life Cycle
-(void)viewDidAppear:(BOOL)animated
{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    [self configNavigitionItem];
    [self configLoadManger];
    [self configSubviewsConstraints];
}
#pragma  loadDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    //转换坐标为地理位置
    self.title=@"定位成功，查询中...";
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    [clGeoCoder reverseGeocodeLocation:location completionHandler: ^(NSArray *placemarks,NSError *error)
     {
         for (CLPlacemark *placeMark in placemarks)
         {
             NSDictionary *addressDic=placeMark.addressDictionary;
             NSString *city=[addressDic objectForKey:@"City"];
             self.localCityName=city;
             self.title=city;
             [self.hospitalData dataWithCityName:city tableView:self.tableView];

             NSLog(@"%@",city);
         }
         if (error)
         {
             self.title=@"您所在的区域不对，请手动查找";
             UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"定位区域失败,请手动查找" preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction * action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
             [alert addAction:action];
             [self presentViewController:alert animated:YES completion:nil];
         }
     }];
    //如果不需要实时定位，使用完即使关闭定位服务
    [_locationManager stopUpdatingLocation];
}
#pragma mark - TLCityPickerDelegate

- (void)cityPickerController:(TLCityPickerController *)cityPickerViewController didSelectCity:(TLCity *)city
{
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
        //根据城市名获取该城市的医院数据
        self.localCityName=city.cityName;
        self.title=self.localCityName;
        [self.hospitalData dataWithCityName:city.cityName tableView:self.tableView];
        //重载列表
        [self.tableView reloadData];
    }];
}

- (void)cityPickerControllerDidCancel:(TLCityPickerController *)cityPickerViewController
{
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Private Method

-(void)configLoadManger
{
    [self.locationManager startUpdatingLocation];

    if (![CLLocationManager locationServicesEnabled])
    {
        NSLog(@"定位服务尚未打开");
        return;
    }
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined)
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    self.title=@"定位中，请稍后...";
}

- (void)configSubviewsConstraints {
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(StatusBarH + NAVH, 0, 0, 0);
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(edgeInsets);
    }];
}

- (void)configNavigitionItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择城市" style:UIBarButtonItemStylePlain target:self action:@selector(cityPicker)];
}

- (void)cityPicker {
    TLCityPickerController *cityPickerVC = [[TLCityPickerController alloc] init];
    [cityPickerVC setDelegate:self];
    
    cityPickerVC.locationCityID = @"1400010000";
    cityPickerVC.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:^{
        
    }];
}

#pragma mark - Setter & Getter
-(CLLocationManager *)locationManager
{
    if (_locationManager==nil)
    {
        _locationManager=[[CLLocationManager alloc]init];
        //设置代理
        self.locationManager.delegate=self;
        //设置定位精度
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=10.0;//十米定位一次
        self.locationManager.distanceFilter=distance;

        //启动跟踪定位
    }
    return _locationManager;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PHHospitalCell class]) bundle:nil] forCellReuseIdentifier:hospitalCellID];
        _tableView.delegate = (id)self.hospitalData;
        _tableView.dataSource = (id)self.hospitalData;
    }
    return _tableView;
}

- (PHHospitalData *)hospitalData {
    if (!_hospitalData) {
        _hospitalData = [[PHHospitalData alloc] init];
    }
    return _hospitalData;
}


@end
