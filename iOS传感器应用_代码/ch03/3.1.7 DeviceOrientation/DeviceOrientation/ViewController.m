//
//  ViewController.m
//  DeviceOrientation
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) viewWillAppear:(BOOL) animated{
    [super viewWillAppear:animated];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedRotation:)
                                                 name:UIDeviceOrientationDidChangeNotification object:nil];
}


-(void) viewWillDisappear:(BOOL) animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}


-(void) receivedRotation:(NSNotification*) notification {
    
    UIDevice *device = [UIDevice currentDevice];
    
    switch (device.orientation) {
        case UIDeviceOrientationPortrait:
            _orientationLabel.text =  @"竖直向上";
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            _orientationLabel.text =  @"竖直向下";
            break;
        case UIDeviceOrientationLandscapeLeft:
            _orientationLabel.text =  @"水平向左";
            break;
        case UIDeviceOrientationLandscapeRight:
            _orientationLabel.text =  @"水平向右";
            break;
        case UIDeviceOrientationFaceUp:
            _orientationLabel.text =  @"面朝上";
            break;
        case UIDeviceOrientationFaceDown:
            _orientationLabel.text =  @"面朝下";
            break;
        case UIDeviceOrientationUnknown:
            _orientationLabel.text = @"未知";
            break;
        default:
            _orientationLabel.text = @"未知";
            break;
    }
}


@end
