//
//  MainViewController.m
//  PlumbBob
//
//  Created by 关东升 on 12-9-24.
//
//

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    if (screenHeight > 480) {
        //iPhone 5设备
        captureVideoPreviewLayer.frame = CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
    } else {
        captureVideoPreviewLayer.frame = CGRectMake(0,0,320,450);
    }
    
    CGFloat camScaleup = 1.5f;
    [captureVideoPreviewLayer setAffineTransform:CGAffineTransformMakeScale(camScaleup, camScaleup)];
    
    
    [self.view.layer insertSublayer:captureVideoPreviewLayer below:self.btnInfo.layer];
    
    
    
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [session startRunning];
    });
    
    
    // 设置PlumBob视图
    UIImage* image = [UIImage imageNamed:@"PlumbBob.png"];
    _plumbBobView = [[UIImageView alloc] initWithImage:image];
    _plumbBobView.layer.anchorPoint = CGPointMake(0.5, 0.0);
    
    if (screenHeight > 480) {
        //iPhone 5设备
        _plumbBobView.frame = CGRectMake(self.view.frame.size.width/2 - 20, 0, 40, 500);
    } else {
        _plumbBobView.frame = CGRectMake(self.view.frame.size.width/2 - 20, 0, 40, 450);
    }
    
    [self.view addSubview:_plumbBobView];
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = 1.0 / kAccelerometerFrequency;
    
    if ([self.motionManager isAccelerometerAvailable]){
        
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue]
                                                 withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                     
                                                     if (error) {
                                                         [self.motionManager stopAccelerometerUpdates];
                                                     } else {
                                                         [self rotatePlumbStringToDegree:-accelerometerData.acceleration.x* 30];
                                                     }
                                                 }];
    } else {
        NSLog(@"加速度计不可用");
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //设置状态栏风格
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

- (void)rotatePlumbStringToDegree:(CGFloat)positionInDegrees {
    
    [_plumbBobView.layer removeAllAnimations];
	
    CATransform3D rotationTransform = CATransform3DIdentity;
    rotationTransform = CATransform3DRotate(rotationTransform, DegreesToRadians(positionInDegrees), 0.0, 0.0, 1.0);
    _plumbBobView.layer.transform = rotationTransform;
}


@end
