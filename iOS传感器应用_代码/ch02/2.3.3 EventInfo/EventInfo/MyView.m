//
//  MyView.m
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

#import "MyView.h"

@implementation MyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor brownColor];
    }
    return self;
}

- (void)logTouchInfo:(UITouch *)touch {
    CGPoint locInSelf = [touch locationInView:self];
    CGPoint locInWin = [touch locationInView:nil];
    NSLog(@"    touch.locationInView = {%2.3f, %2.3f}", locInSelf.x, locInSelf.y);
    NSLog(@"    touch.locationInWin = {%2.3f, %2.3f}", locInWin.x, locInWin.y);
    NSLog(@"    touch.phase = %ld", (long)touch.phase);
    NSLog(@"    touch.tapCount = %lu", (unsigned long)touch.tapCount);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan - touch count = %lu", (unsigned long)[touches count]);
    for(UITouch *touch in event.allTouches) {
        [self logTouchInfo:touch];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesMoved - touch count = %lu", (unsigned long)[touches count]);
    for(UITouch *touch in event.allTouches) {
        [self logTouchInfo:touch];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesEnded - touch count = %lu", (unsigned long)[touches count]);
    for(UITouch *touch in event.allTouches) {
        [self logTouchInfo:touch];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesCancelled - touch count = %lu", (unsigned long)[touches count]);
    for(UITouch *touch in event.allTouches) {
        [self logTouchInfo:touch];
    }
}

@end
