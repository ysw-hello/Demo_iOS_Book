//
//  RootViewController.m
//  Ballon
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
    
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    captureVideoPreviewLayer.frame = CGRectMake(0,0,320,568);
    
    CGFloat camScaleup = 1.8;
    [captureVideoPreviewLayer setAffineTransform:CGAffineTransformMakeScale(camScaleup, camScaleup)];
    
    [self.view.layer addSublayer:captureVideoPreviewLayer];
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        NSLog(@"ERROR: trying to open camera: %@", error);
    }
    [session addInput:input];
    
    AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
    
    [session startRunning];    
    
    // 创建执行动画的Image View对象
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    
    
    NSMutableArray *array1 = [[NSMutableArray alloc] init];
    NSMutableArray *array2 = [[NSMutableArray alloc] init];
    
    for (int i =10; i <= 40; i++) {
        NSString *fileName1 = [[NSString alloc] initWithFormat:@"100%i.png",i];
        [array1 addObject:[UIImage imageNamed:fileName1]];
        
        NSString *fileName2 = [[NSString alloc] initWithFormat:@"100%i.png",(50-i)];
        [array2 addObject:[UIImage imageNamed:fileName2]];
    }
    
    [array1 addObjectsFromArray:array2];
    
    
    imageView.animationImages = array1;
    
    imageView.animationDuration = 1.75;
    imageView.animationRepeatCount = 0;
    
    // start animating
    [imageView startAnimating];
    [self.view addSubview:imageView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
