//
//  ViewController.m
//  BLECentral
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
    
    // 设置CBCentralManager
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    // 保存接收数据
    _data = [[NSMutableData alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [self.centralManager stopScan];
    
    [self.activityIndicatorView stopAnimating];
    
    NSLog(@"扫描停止");
    
    [super viewWillDisappear:animated];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Central Methods

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state != CBCentralManagerStatePoweredOn) {
        return;
    }
    //开始扫描
    [self scan];
    
}


/** 通过制定的128位的UUID，扫描外设
 */
- (void)scan
{
    [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]
                                                options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    [self.activityIndicatorView startAnimating];
    self.scanLabel.hidden = NO;
    
    NSLog(@"Scanning started");
}

/** 停止扫描
 */
- (void)stop
{
    [self.centralManager stopScan];
    
    [self.activityIndicatorView stopAnimating];
    self.scanLabel.hidden = YES;
    self.textView.text = @"";
    NSLog(@"Scanning stoped");
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    // 过滤信号强度范围
    if (RSSI.integerValue > -15) {
        return;
    }
    if (RSSI.integerValue < -35) {
        return;
    }
    
    NSLog(@"发现外设 %@ at %@", peripheral.name, RSSI);
    
    if (self.discoveredPeripheral != peripheral) {
        self.discoveredPeripheral = peripheral;
        
        NSLog(@"连接外设 %@", peripheral);
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}


- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"连接失败 %@. (%@)", peripheral, [error localizedDescription]);
    [self cleanup];
}


- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"外设已连接");
    
    // Stop scanning
    [self stop];
    
    NSLog(@"扫描停止");
    
    [self.data setLength:0];
    
    peripheral.delegate = self;
    
    [peripheral discoverServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]];
}


/** 服务被发现
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering services: %@", [error localizedDescription]);
        [self cleanup];
        return;
    }
    
    // 发现特征
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]] forService:service];
    }
}


- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error) {
        NSLog(@"发现特征错误: %@", [error localizedDescription]);
        [self cleanup];
        return;
    }
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
            // 预定特征
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"发现特征错误:: %@", [error localizedDescription]);
        return;
    }
    
    NSString *stringFromData = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    
    // 判断是否为数据结束
    if ([stringFromData isEqualToString:@"EOM"]) {
        
        // 显示数据
        [self.textView setText:[[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding]];
        
        // 取消特征预定
        [peripheral setNotifyValue:NO forCharacteristic:characteristic];
        
        // 断开外设
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
    
    // 接收数据追加到data属性中
    [self.data appendData:characteristic.value];
    
    NSLog(@"Received: %@", stringFromData);
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"特征通知状态变化错误: %@", error.localizedDescription);
    }
    
    // 如果没有特征传输过来则退出
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
        return;
    }
    
    // 特征通知已经开始
    if (characteristic.isNotifying) {
        NSLog(@"特征通知已经开始 %@", characteristic);
    }
    // 特征通知已经停止
    else {
        NSLog(@"特征通知已经停止 %@", characteristic);
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
}


- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"外设已经断开");
    self.discoveredPeripheral = nil;
    
    //外设已经断开情况下，重新扫描
    [self scan];
}


/** 清除方法
 */
- (void)cleanup
{
    // 如果没有连接则退出
    if (!self.discoveredPeripheral.isConnected) {
        return;
    }
    
    // 判断是否已经预定了特征
    if (self.discoveredPeripheral.services != nil) {
        for (CBService *service in self.discoveredPeripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
                        if (characteristic.isNotifying) {
                            //停止接收特征通知
                            [self.discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                            //断开与外设连接
                            [self.centralManager cancelPeripheralConnection:self.discoveredPeripheral];
                            return;
                        }
                    }
                }
            }
        }
    }
    
    //断开与外设连接
    [self.centralManager cancelPeripheralConnection:self.discoveredPeripheral];
}


@end
