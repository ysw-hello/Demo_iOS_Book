//
//  ViewController.h
//  Ambient Temperature
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

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLEDevice.h"
#import "BLEUtility.h"
#import "Sensors.h"

#import "MySensorTag.h"

@interface ViewController : UIViewController <CBCentralManagerDelegate,CBPeripheralDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnShow;
@property (weak, nonatomic) IBOutlet UILabel *lblTemp;

@property (strong,nonatomic) CBCentralManager *m;
@property (strong,nonatomic) CBPeripheral *peripheral;
@property (strong,nonatomic) NSMutableArray *sensorTags;

@property (strong,nonatomic) MySensorTag * tag;

-(NSMutableDictionary *) makeSensorTagConfiguration;

- (IBAction)showTemp:(id)sender;

@end
