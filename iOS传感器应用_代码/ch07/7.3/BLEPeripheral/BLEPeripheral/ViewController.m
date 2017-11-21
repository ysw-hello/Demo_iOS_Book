//
//  ViewController.m
//  BLEPeripheral
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
    
    //设置CBPeripheralManager
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self.peripheralManager stopAdvertising];
    [super viewWillDisappear:animated];
}

#pragma mark - Peripheral Methods

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
        return;
    }
    
    NSLog(@"BLE打开");
    
    // 初始化特征
    self.transferCharacteristic = [[CBMutableCharacteristic alloc]
                                        initWithType:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]
                                                properties:CBCharacteristicPropertyNotify
                                                value:nil
                                                permissions:CBAttributePermissionsReadable];
    
    // 初始化服务
    CBMutableService *transferService = [[CBMutableService alloc]
                                         initWithType:[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]
                                                                       primary:YES];
    
    // 添加特征到服务
    transferService.characteristics = @[self.transferCharacteristic];
    
    // 发布服务与特征
    [self.peripheralManager addService:transferService];
}


- (void)peripheralManager:(CBPeripheralManager *)peripheral
            didAddService:(CBService *)service
                    error:(NSError *)error {
    
    NSLog( @"添加服务" );
    
    if (error) {
        NSLog(@"添加服务失败: %@", [error localizedDescription]);
    }
    
}

- (IBAction)valueChanged:(id)sender {
    
    UISwitch* advertisingSwitch = (UISwitch*)sender;
    
    if (advertisingSwitch.on) {
        // 开始广播
        [self.peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]] }];
    }
    else {
        [self.peripheralManager stopAdvertising];
    }
}



- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"中心已经预定了特征");
    
    self.dataToSend = [self.textView.text dataUsingEncoding:NSUTF8StringEncoding];
    
    self.sendDataIndex = 0;
    
    [self sendData];
}


- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic {
    NSLog(@"中心没有从特征预定");
}


- (void)sendData {
    //发送数据结束标识
    static BOOL sendingEOM = NO;
    
    if (sendingEOM) {
        BOOL didSend = [self.peripheralManager updateValue:[@"EOM" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
        if (didSend) {
            sendingEOM = NO;
            NSLog(@"Sent: EOM");
        }
        return;
    }
    
    if (self.sendDataIndex >= self.dataToSend.length) {
        return;
    }
    
    BOOL didSend = YES;
    
    while (didSend) {
        
        NSInteger amountToSend = self.dataToSend.length - self.sendDataIndex;
        
        if (amountToSend > NOTIFY_MTU) amountToSend = NOTIFY_MTU;
        
        NSData *chunk = [NSData dataWithBytes:self.dataToSend.bytes+self.sendDataIndex length:amountToSend];
        
        //发送数据
        didSend = [self.peripheralManager updateValue:chunk forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
        
        if (!didSend) {
            return;
        }
        
        NSString *stringFromData = [[NSString alloc] initWithData:chunk encoding:NSUTF8StringEncoding];
        NSLog(@"Sent: %@", stringFromData);
        
        self.sendDataIndex += amountToSend;
        
        if (self.sendDataIndex >= self.dataToSend.length) {
            
            sendingEOM = YES;
            
            BOOL eomSent = [self.peripheralManager updateValue:[@"EOM" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
            
            if (eomSent) {
                sendingEOM = NO;
                NSLog(@"Sent: EOM");
            }
            return;
        }
    }
}

- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral {
    [self sendData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
