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
        
    UIPanGestureRecognizer *recognizer =[[UIPanGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(foundTap:)];
    
    recognizer.minimumNumberOfTouches = 1;
    recognizer.maximumNumberOfTouches = 1;
    

    /* Let's first create a label */
    CGRect frame = CGRectMake(96.0f,    /* X */
                                   68.0f,    /* Y */
                                   128.0f,  /* Width */
                                   128.0f); /* Height */
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.image = self.imageTrashFull;
    self.imageView.frame = frame;
    self.imageView.userInteractionEnabled = YES;
    
    [self.view addSubview:self.imageView];    

    [self.imageView addGestureRecognizer:recognizer];
}


- (void) foundTap:(UIPanGestureRecognizer*)paramSender{
    
    NSLog(@"拖动 state = %i",paramSender.state);
    
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
