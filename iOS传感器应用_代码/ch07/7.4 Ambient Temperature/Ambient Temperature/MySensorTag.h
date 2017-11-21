//
//  MySensorTag.h
//  Ambient Temperature
//
//  Created by tonyguan on 13-10-4.
//  Copyright (c) 2013年 tonyguan. All rights reserved.
//

#import "BLEDevice.h"
#import "BLEUtility.h"
#import "Sensors.h"

@interface MySensorTag : NSObject <CBCentralManagerDelegate,CBPeripheralDelegate>

@property (strong,nonatomic) BLEDevice *d;
@property NSMutableArray *sensorsEnabled;


//温度
@property (nonatomic,assign) float tempValue;

-(id) initWithSensorTag:(BLEDevice *)sensorTag;

-(void) configureSensorTag;
-(void) deconfigureSensorTag;

@end
