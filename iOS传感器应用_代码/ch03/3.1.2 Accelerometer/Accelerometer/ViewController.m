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

@interface ViewController ()

@end

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
    NSLog(@"x=%f", acceleration.x);
    self.xLabel.text = [NSString stringWithFormat:@"%f", acceleration.x];
    self.xBar.progress = ABS(acceleration.x);
    
    NSLog(@"y=%f", acceleration.y);
    self.yLabel.text = [NSString stringWithFormat:@"%f", acceleration.y];
    self.yBar.progress = ABS(acceleration.y);
    
    NSLog(@"z=%f", acceleration.z);
    self.zLabel.text = [NSString stringWithFormat:@"%f", acceleration.z];
    self.zBar.progress = ABS(acceleration.z);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];    
     [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
}

@end
