//
//  ViewController.m
//  PanGestureRecognizer
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

}


- (IBAction)foundTap:(id)sender {    
    
    UIPanGestureRecognizer* paramSender = (UIPanGestureRecognizer*)sender;
    
    NSLog(@"拖动 state = %li",(long)paramSender.state);
    
    if (paramSender.state != UIGestureRecognizerStateEnded &&
        paramSender.state != UIGestureRecognizerStateFailed){
        CGPoint location = [paramSender locationInView:paramSender.view.superview];
        paramSender.view.center = location;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
