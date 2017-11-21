//
//  ViewController.m
//  Accelerometer
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


@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:0.1];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
}


- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    
    
    //低通滤波
	CGFloat lowPassFilteredX = (acceleration.x * FILTERFACTOR) +
        (filteredAccelX * (1.0 - FILTERFACTOR));
	CGFloat lowPassFilteredY = (acceleration.y * FILTERFACTOR) +
        (filteredAccelY * (1.0 - FILTERFACTOR));
    CGFloat lowPassFilteredZ = (acceleration.z * FILTERFACTOR) +
        (filteredAccelZ * (1.0 - FILTERFACTOR));
    
    
    //高通滤波
	CGFloat highPassFilteredX = acceleration.x - lowPassFilteredX;
	CGFloat highPassFilteredY = acceleration.y - lowPassFilteredY;
    CGFloat highPassFilteredZ = acceleration.z - lowPassFilteredZ;
    
	switch (self.filterControl.selectedSegmentIndex) {
		case NO_FILTER:
			filteredAccelX = acceleration.x;
			filteredAccelY = acceleration.y;
            filteredAccelZ = acceleration.z;
			break;
		case LOW_PASS_FILTER:
			filteredAccelX = lowPassFilteredX;
			filteredAccelY = lowPassFilteredY;
            filteredAccelZ = lowPassFilteredZ;
			break;
		case HIGH_PASS_FILTER:
			filteredAccelX = highPassFilteredX;
			filteredAccelY = highPassFilteredY;
            filteredAccelZ = highPassFilteredZ;
	}
    
    NSLog(@"x=%f", filteredAccelX);
    self.xLabel.text = [NSString stringWithFormat:@"%f", filteredAccelX];
    self.xBar.progress = ABS(filteredAccelX);
    
    NSLog(@"y=%f", filteredAccelY);
    self.yLabel.text = [NSString stringWithFormat:@"%f", filteredAccelY];
    self.yBar.progress = ABS(filteredAccelY);
    
    NSLog(@"z=%f", filteredAccelZ);
    self.zLabel.text = [NSString stringWithFormat:@"%f", filteredAccelZ];
    self.zBar.progress = ABS(filteredAccelZ);
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
}

@end
