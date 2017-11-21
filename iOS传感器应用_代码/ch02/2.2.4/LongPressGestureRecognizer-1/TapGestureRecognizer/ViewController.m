//
//  ViewController.m
//  LongPressGestureRecognizer
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
    
    boolTrashEmptyFlag = NO; //垃圾桶满
    
    self.imageView.image = self.imageTrashFull;
    
    UILongPressGestureRecognizer *recognizer =[[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(foundTap:)];
    
    recognizer.allowableMovement = 100.0f;
    recognizer.minimumPressDuration = 1.0;
    
    [self.imageView addGestureRecognizer:recognizer];
}


- (void) foundTap:(UILongPressGestureRecognizer*)paramSender{
    
    NSLog(@"长按 state = %i",paramSender.state);
    if (paramSender.state == UIGestureRecognizerStateBegan) { //手势开始
        if (boolTrashEmptyFlag) {
            self.imageView.image = self.imageTrashFull;
            boolTrashEmptyFlag = NO;
        } else {
            self.imageView.image = self.imageTrashEmpty;
            boolTrashEmptyFlag = YES;
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
