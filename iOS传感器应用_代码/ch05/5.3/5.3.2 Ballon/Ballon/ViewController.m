//
//  ViewController.m
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


    self.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.showsCameraControls = NO;
    
    CGFloat camScaleup = 1.8;
    self.cameraViewTransform = CGAffineTransformScale(self.cameraViewTransform, camScaleup, camScaleup);

    
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
    
    [imageView startAnimating];

    [self.view addSubview:imageView];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
