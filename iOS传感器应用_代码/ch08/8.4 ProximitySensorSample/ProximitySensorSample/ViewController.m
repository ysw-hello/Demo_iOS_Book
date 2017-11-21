//
//  ViewController.m
//  TapGestureRecognizer
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
    
    NSBundle *bundle = [NSBundle mainBundle];
    
    self.imageTrashFull = [[UIImage alloc] initWithContentsOfFile:[bundle pathForResource:@"Blend Trash Full" ofType:@"png"]];
    self.imageTrashEmpty = [[UIImage alloc] initWithContentsOfFile:[bundle pathForResource:@"Blend Trash Empty" ofType:@"png"]];
    
    self.imageView.image = self.imageTrashFull;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    UIDevice *device =[UIDevice currentDevice];
    
    //开启接近传感器
    device.proximityMonitoringEnabled = YES;
    
    //设置通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(proximityDidChange:)
                                    name:UIDeviceProximityStateDidChangeNotification
                                               object:device];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    UIDevice *device =[UIDevice currentDevice];
    
    // 解除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                    name:UIDeviceProximityStateDidChangeNotification
                                                      object:nil];
    device.proximityMonitoringEnabled = NO;
}


- (void)proximityDidChange:(NSNotificationCenter *)notification
{
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        NSLog(@"用户接近");
        self.imageView.image = self.imageTrashEmpty;
    } else {
        NSLog(@"用户离开");
        self.imageView.image = self.imageTrashFull;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
