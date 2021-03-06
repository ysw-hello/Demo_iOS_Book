//
//  ViewController.m
//  RotationGestureRecognizer
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
    
    self.imageView.image = self.imageTrashFull;
    
    UIRotationGestureRecognizer *recognizer =[[UIRotationGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(foundTap:)];
    
    [self.view addGestureRecognizer:recognizer];

}


- (void) foundTap:(UIRotationGestureRecognizer*)paramSender{
    
    /* 上一次角度加上本次旋转的角度 */
    self.imageView.transform =  CGAffineTransformMakeRotation(rotationAngleInRadians + paramSender.rotation);
    
    /* 手势识别完成，保存旋转的角度 */
    if (paramSender.state == UIGestureRecognizerStateEnded){
        rotationAngleInRadians += paramSender.rotation;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
