//
//  ViewController.m
//  SwipeGestureRecognizer
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
     
    UISwipeGestureRecognizer *recognizer =[[UISwipeGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(foundTap:)];
    
    recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    recognizer.numberOfTouchesRequired = 2;
    
    [self.view addGestureRecognizer:recognizer];
}


- (void) foundTap:(UISwipeGestureRecognizer*)paramSender{
    
    NSLog(@"paramSender.direction = %i",paramSender.direction);
    
    if (paramSender.direction == UISwipeGestureRecognizerDirectionDown){
        NSLog(@"向下滑动");
    }
    if (paramSender.direction == UISwipeGestureRecognizerDirectionLeft){
        NSLog(@"向左滑动");
    }
    if (paramSender.direction == UISwipeGestureRecognizerDirectionRight){
        NSLog(@"向右滑动");
    }
    if (paramSender.direction == UISwipeGestureRecognizerDirectionUp){
        NSLog(@"向上滑动");
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
