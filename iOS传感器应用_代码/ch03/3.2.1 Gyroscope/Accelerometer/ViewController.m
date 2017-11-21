//
//  ViewController.m
//  Gyroscope
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
    self.motionManager.gyroUpdateInterval = 0.1;
    
    if ([self.motionManager isGyroAvailable]){
        
        [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue]
            withHandler:^(CMGyroData *gyroData, NSError *error) {
            
            if (error) {
                [self.motionManager stopGyroUpdates];
            } else {
                CMRotationRate rotate = gyroData.rotationRate;
                
                NSLog(@"x=%f", rotate.x);
                self.xLabel.text = [NSString stringWithFormat:@"%f", rotate.x];
                self.xBar.progress = ABS(rotate.x);
                
                NSLog(@"y=%f", rotate.y);
                self.yLabel.text = [NSString stringWithFormat:@"%f", rotate.y];
                self.yBar.progress = ABS(rotate.y);
                
                NSLog(@"z=%f", rotate.z);
                self.zLabel.text = [NSString stringWithFormat:@"%f", rotate.z];
                self.zBar.progress = ABS(rotate.z);
            }
        }];
    } else {
        NSLog(@"Gyroscope is not available.");
    }    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self.motionManager stopGyroUpdates];    
}

@end
