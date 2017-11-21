//
//  ViewController.m
//  Compass
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _locationManager = [[CLLocationManager alloc] init];
	_locationManager.delegate = self;
    
	if( [CLLocationManager headingAvailable])
	{
		[_locationManager startUpdatingHeading];
	} else {
		NSLog(@"不能获得航向数据。");
	}
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [_locationManager stopUpdatingHeading];
    _locationManager.delegate = nil;
}

- (void)locationManager:(CLLocationManager*)manager didUpdateHeading:(CLHeading*)newHeading {
    
	UIDevice *device = [UIDevice currentDevice];
  	
	if (newHeading.headingAccuracy > 0) {
        
		float magneticHeading = [self heading:newHeading.magneticHeading fromOrientation:device.orientation];
		float trueHeading = [self heading:newHeading.trueHeading fromOrientation:device.orientation];

		_magneticHeadingLabel.text = [NSString stringWithFormat:@"%.2f", magneticHeading];
		_trueHeadingLabel.text = [NSString stringWithFormat:@"%.2f", trueHeading];
		
		float heading = -1.0f * M_PI * newHeading.magneticHeading / 180.0f;
		_plateImage.transform = CGAffineTransformMakeRotation(heading);
	}
    
}


- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
    return YES;
}


-(float)heading:(float)heading fromOrientation:(UIDeviceOrientation) orientation {
	
	float realHeading = heading;
	switch (orientation) {
		case UIDeviceOrientationPortrait:
			break;
		case UIDeviceOrientationPortraitUpsideDown:
			realHeading = realHeading - 180.0f;
			break;
		case UIDeviceOrientationLandscapeLeft:
			realHeading = realHeading + 90.0f;
			break;
		case UIDeviceOrientationLandscapeRight:
			realHeading = realHeading - 90.0f;
			break;
		default:
			break;
	}
	if (realHeading > 360.0f) {
		realHeading -= 360;
	} else if (realHeading < 0.0f) {
        realHeading += 360;
    }
	return realHeading;
}



@end
