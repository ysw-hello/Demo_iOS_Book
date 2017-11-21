//
//  ViewController.h
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

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>


#define TRANSFER_SERVICE_UUID           @"D63D44E5-E798-4EA5-A1C0-3F9EEEC2CDEB"
#define TRANSFER_CHARACTERISTIC_UUID    @"1652CAD2-6B0D-4D34-96A0-75058E606A98"

#define NOTIFY_MTU      20


@interface ViewController : UIViewController  <CBPeripheralManagerDelegate, UITextViewDelegate>

@property (strong, nonatomic) CBPeripheralManager       *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic   *transferCharacteristic;
@property (strong, nonatomic) NSData                    *dataToSend;
@property (nonatomic, readwrite) NSInteger              sendDataIndex;

@property (weak, nonatomic) IBOutlet UITextView *textView;

- (IBAction)valueChanged:(id)sender;

@end
