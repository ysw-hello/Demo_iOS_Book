//
//  ViewController.m
//  BeaconDevice
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
    
    _peripheralManager= [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}


- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSLog(@"外设状态变化");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)valueChanged:(id)sender {
    
    UISwitch* swc = (UISwitch* )sender;
    
    if (swc.isOn) {
        
        NSUUID* uuid = [[NSUUID alloc] initWithUUIDString:kUUID];
          
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:kID];
        
        NSDictionary *peripheralData = [region peripheralDataWithMeasuredPower:kPower];
        
        if(peripheralData) {
            [_peripheralManager startAdvertising:peripheralData];
        }
    } else {
        [_peripheralManager stopAdvertising];
    }
}



@end
