//
//  ViewController.m
//  MotionManager
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
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = 0.1;
    
    if ([self.motionManager isAccelerometerAvailable]){
        
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue]
            withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            
            if (error) {
                [self.motionManager stopAccelerometerUpdates];
            } else {
                NSLog(@"x=%f", accelerometerData.acceleration.x);
                self.xLabel.text = [NSString stringWithFormat:@"%f", accelerometerData.acceleration.x];
                self.xBar.progress = ABS(accelerometerData.acceleration.x);
                
                NSLog(@"y=%f", accelerometerData.acceleration.y);
                self.yLabel.text = [NSString stringWithFormat:@"%f", accelerometerData.acceleration.y];
                self.yBar.progress = ABS(accelerometerData.acceleration.y);
                
                NSLog(@"z=%f", accelerometerData.acceleration.z);
                self.zLabel.text = [NSString stringWithFormat:@"%f", accelerometerData.acceleration.z];
                self.zBar.progress = ABS(accelerometerData.acceleration.z);
            }
        }];
    } else {
        NSLog(@"Accelerometer is not available.");
    }    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self.motionManager stopAccelerometerUpdates];    
}

@end
