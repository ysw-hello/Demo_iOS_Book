//
//  ViewController.h
//  BLECentral
//
//  Created by tonyguan on 13-9-23.
//  Copyright (c) 2013年 tonyguan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>


#define TRANSFER_SERVICE_UUID           @"D63D44E5-E798-4EA5-A1C0-3F9EEEC2CDEB"
#define TRANSFER_CHARACTERISTIC_UUID    @"1652CAD2-6B0D-4D34-96A0-75058E606A98"


@interface ViewController : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) CBCentralManager      *centralManager;
@property (strong, nonatomic) CBPeripheral          *discoveredPeripheral;
@property (strong, nonatomic) NSMutableData         *data;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *scanLabel;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
