//
//  ViewController.m
//  Teslameter
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
    self.motionManager.magnetometerUpdateInterval = 1/30;
    
    if ([self.motionManager isMagnetometerAvailable]){
        
        [self.motionManager startMagnetometerUpdatesToQueue:[NSOperationQueue mainQueue]
               withHandler:^(CMMagnetometerData *magnetometerData, NSError *error) {
                   if (error) {
                       [self.motionManager stopMagnetometerUpdates];
                   } else {
                       CMMagneticField heading= magnetometerData.magneticField;
                       
                       NSLog(@"x=%.2f", heading.x);
                       self.xLabel.text = [NSString stringWithFormat:@"%.2f", heading.x];
                       self.xBar.progress = ABS(heading.x/1000);
                       
                       NSLog(@"y=%.2f", heading.y);
                       self.yLabel.text = [NSString stringWithFormat:@"%.2f", heading.y];
                       self.yBar.progress = ABS(heading.y/1000);
                       
                       NSLog(@"z=.2%f", heading.z);
                       self.zLabel.text = [NSString stringWithFormat:@"%.2f", heading.z];
                       self.zBar.progress = ABS(heading.z/1000);
                       
                       CGFloat magnitude = sqrt(heading.x*heading.x + heading.y*heading.y + heading.z*heading.z);
                       self.magnitude.text = [NSString stringWithFormat:@"%.2f", magnitude];
                   }
               }];
    } else {
        NSLog(@"磁力计不可用.");
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self.motionManager stopMagnetometerUpdates];
}


@end
