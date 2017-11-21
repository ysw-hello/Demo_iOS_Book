//
//  ViewController.m
//  PinchGestureRecognizer
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
    
    self.imageView.image = [UIImage imageNamed:@"Blend Trash Full.png"];
	pinchZoom = NO;
	previousDistance = 0.0f;
	zoomFactor = 1.0f;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if(event.allTouches.count == 2) {
		pinchZoom = YES;
		NSArray *touches = [event.allTouches allObjects];
		CGPoint pointOne = [[touches objectAtIndex:0] locationInView:self.view];
		CGPoint pointTwo = [[touches objectAtIndex:1] locationInView:self.view];
		previousDistance = sqrt(pow(pointOne.x - pointTwo.x, 2.0f) +
								pow(pointOne.y - pointTwo.y, 2.0f));
	} else {
		pinchZoom = NO;
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if(YES == pinchZoom && event.allTouches.count == 2) {
		NSArray *touches = [event.allTouches allObjects];
		CGPoint pointOne = [[touches objectAtIndex:0] locationInView:self.view];
		CGPoint pointTwo = [[touches objectAtIndex:1] locationInView:self.view];
		CGFloat distance = sqrt(pow(pointOne.x - pointTwo.x, 2.0f) +
								pow(pointOne.y - pointTwo.y, 2.0f));
		zoomFactor += (distance - previousDistance) / previousDistance;
        if (zoomFactor > 0 ) {
            previousDistance = distance;
            self.imageView.transform = CGAffineTransformMakeScale(zoomFactor, zoomFactor);
        }
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if(event.allTouches.count != 2) {
		pinchZoom = NO;
		previousDistance = 0.0f;
	}
}


@end
