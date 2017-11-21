//
//  ViewController.m
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

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.m = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    
    self.sensorTags = [[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)showTemp:(id)sender {
    
    CBPeripheral *p = [self.sensorTags lastObject];
    
    BLEDevice *d = [[BLEDevice alloc]init];
    
    d.p = p;
    d.manager = self.m;
    d.setupData = [self makeSensorTagConfiguration];
    
    self.tag = [[MySensorTag alloc] initWithSensorTag:d];
    
    [self.tag addObserver:self forKeyPath:@"tempValue" options:NSKeyValueObservingOptionNew context:NULL];
    
}

#pragma mark - CBCentralManager delegate

-(void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state != CBCentralManagerStatePoweredOn) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"BLE not supported !"
                            message:[NSString stringWithFormat:@"CoreBluetooth return state: %ld",(long)central.state]
                        delegate:self cancelButtonTitle:@"OK"
                        otherButtonTitles:nil];
        [alertView show];
    }
    else {
        [central scanForPeripheralsWithServices:nil options:nil];
    }
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSLog(@"Found a BLE Device : %@",peripheral);
    
    self.peripheral = peripheral;
    
    self.peripheral.delegate = self;
    [central connectPeripheral:peripheral options:nil];
    
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [peripheral discoverServices:nil];
}

#pragma  mark - CBPeripheral delegate

-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    
    NSLog(@"Services scanned !");
    [self.m cancelPeripheralConnection:peripheral];
    for (CBService *s in peripheral.services) {
        NSLog(@"Service found : %@",s.UUID);
        if ([s.UUID isEqual:[CBUUID UUIDWithString:@"f000aa00-0451-4000-b000-000000000000"]])  {
            NSLog(@"This is a SensorTag !");
            self.btnShow.enabled = YES;
            if (![self.sensorTags containsObject:peripheral]) {
                [self.sensorTags addObject:peripheral];
            }
        }
    }
}

-(void) peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didUpdateNotificationStateForCharacteristic %@ error = %@",characteristic,error);
}

-(void) peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didWriteValueForCharacteristic %@ error = %@",characteristic,error);
}


#pragma mark - SensorTag configuration
-(NSMutableDictionary *) makeSensorTagConfiguration {
    NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
    // First we set ambient temperature
    [d setValue:@"1" forKey:@"Ambient temperature active"];
    // Then we set IR temperature
    [d setValue:@"1" forKey:@"IR temperature active"];
    // Append the UUID to make it easy for app
    [d setValue:@"f000aa00-0451-4000-b000-000000000000"  forKey:@"IR temperature service UUID"];
    [d setValue:@"f000aa01-0451-4000-b000-000000000000" forKey:@"IR temperature data UUID"];
    [d setValue:@"f000aa02-0451-4000-b000-000000000000"  forKey:@"IR temperature config UUID"];
    // Then we setup the accelerometer
    [d setValue:@"1" forKey:@"Accelerometer active"];
    [d setValue:@"500" forKey:@"Accelerometer period"];
    [d setValue:@"f000aa10-0451-4000-b000-000000000000"  forKey:@"Accelerometer service UUID"];
    [d setValue:@"f000aa11-0451-4000-b000-000000000000"  forKey:@"Accelerometer data UUID"];
    [d setValue:@"f000aa12-0451-4000-b000-000000000000"  forKey:@"Accelerometer config UUID"];
    [d setValue:@"f000aa13-0451-4000-b000-000000000000"  forKey:@"Accelerometer period UUID"];
    
    //Then we setup the rH sensor
    [d setValue:@"1" forKey:@"Humidity active"];
    [d setValue:@"f000aa20-0451-4000-b000-000000000000"   forKey:@"Humidity service UUID"];
    [d setValue:@"f000aa21-0451-4000-b000-000000000000" forKey:@"Humidity data UUID"];
    [d setValue:@"f000aa22-0451-4000-b000-000000000000" forKey:@"Humidity config UUID"];
    
    //Then we setup the magnetometer
    [d setValue:@"1" forKey:@"Magnetometer active"];
    [d setValue:@"500" forKey:@"Magnetometer period"];
    [d setValue:@"f000aa30-0451-4000-b000-000000000000" forKey:@"Magnetometer service UUID"];
    [d setValue:@"f000aa31-0451-4000-b000-000000000000" forKey:@"Magnetometer data UUID"];
    [d setValue:@"f000aa32-0451-4000-b000-000000000000" forKey:@"Magnetometer config UUID"];
    [d setValue:@"f000aa33-0451-4000-b000-000000000000" forKey:@"Magnetometer period UUID"];
    
    //Then we setup the barometric sensor
    [d setValue:@"1" forKey:@"Barometer active"];
    [d setValue:@"f000aa40-0451-4000-b000-000000000000" forKey:@"Barometer service UUID"];
    [d setValue:@"f000aa41-0451-4000-b000-000000000000" forKey:@"Barometer data UUID"];
    [d setValue:@"f000aa42-0451-4000-b000-000000000000" forKey:@"Barometer config UUID"];
    [d setValue:@"f000aa43-0451-4000-b000-000000000000" forKey:@"Barometer calibration UUID"];
    
    [d setValue:@"1" forKey:@"Gyroscope active"];
    [d setValue:@"f000aa50-0451-4000-b000-000000000000" forKey:@"Gyroscope service UUID"];
    [d setValue:@"f000aa51-0451-4000-b000-000000000000" forKey:@"Gyroscope data UUID"];
    [d setValue:@"f000aa52-0451-4000-b000-000000000000" forKey:@"Gyroscope config UUID"];
    
    NSLog(@"%@",d);
    
    return d;
}

#pragma mark - 观察MySensorTag中温度变化
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object
                        change:(NSDictionary*)change context:(void*)context
{
    float value = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
    NSString* s = [NSString stringWithFormat:@"环境温度：   %.1f°C",value];

    self.lblTemp.text = s;
}


@end
