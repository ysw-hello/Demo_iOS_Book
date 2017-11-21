//
//  ViewController.m
//  EventInfo
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
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)logTouchInfo:(UITouch *)touch {
    CGPoint locInSelf = [touch locationInView:self.view];
    CGPoint locInWin = [touch locationInView:nil];
    NSLog(@"    touch.locationInView = {%2.3f, %2.3f}", locInSelf.x, locInSelf.y);
    NSLog(@"    touch.locationInWin = {%2.3f, %2.3f}", locInWin.x, locInWin.y);
    NSLog(@"    touch.phase = %d", touch.phase);
    NSLog(@"    touch.tapCount = %d", touch.tapCount);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan - touch count = %d", [touches count]);
    for(UITouch *touch in event.allTouches) {
        [self logTouchInfo:touch];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesMoved - touch count = %d", [touches count]);
    for(UITouch *touch in event.allTouches) {
        [self logTouchInfo:touch];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesEnded - touch count = %d", [touches count]);
    for(UITouch *touch in event.allTouches) {
        [self logTouchInfo:touch];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesCancelled - touch count = %d", [touches count]);
    for(UITouch *touch in event.allTouches) {
        [self logTouchInfo:touch];
    }
}
*/

@end
