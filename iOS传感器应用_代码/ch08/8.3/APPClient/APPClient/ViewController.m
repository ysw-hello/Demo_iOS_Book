//
//  ViewController.m
//  APPClient
//
//  Created by 关东升 on 12-9-24.
//  本书网站：http://www.iosbook1.com
//  智捷iOS课堂：http://www.51work6.com
//  智捷iOS课堂在线课堂：http://v.51work6.com
//  智捷iOS课堂新浪微博：http://weibo.com/u/3215753973
//  作者微博：http://weibo.com/516inc
//  官方csdn博客：http://blog.csdn.net/tonny_guan
//  QQ：1575716557 邮箱：jylong06@163.com
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    
    NSUUID* uuid = [[NSUUID alloc] initWithUUIDString:kUUID];
    _region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:kID];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [_locationManager stopMonitoringForRegion:_region];
    [_locationManager stopRangingBeaconsInRegion:_region];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)onClickMonitoring:(id)sender {
    [_locationManager startMonitoringForRegion:_region];
}


- (IBAction)rangValue:(id)sender {
    UISwitch* swc = (UISwitch* )sender;
    if (swc.isOn) {
        [_locationManager startRangingBeaconsInRegion:_region];
    } else {
        [_locationManager stopRangingBeaconsInRegion:_region];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    if(state == CLRegionStateInside) {
        notification.alertBody = @"你在围栏内";
    } else if(state == CLRegionStateOutside) {
        notification.alertBody = @"你在围栏外";
    } else {
        return;
    }
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"你进入围栏";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"你退出围栏";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSArray *unknownBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityUnknown]];
    if([unknownBeacons count])
        _lblRanging.text = @"未检测到";
    
    NSArray *immediateBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityImmediate]];
    if([immediateBeacons count])
        _lblRanging.text = @"最接近";
    
    NSArray *nearBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityNear]];
    if([nearBeacons count])
        _lblRanging.text = @"近距离";
    
    NSArray *farBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityFar]];
    if([farBeacons count])
       _lblRanging.text = @"远距离";
}


@end
