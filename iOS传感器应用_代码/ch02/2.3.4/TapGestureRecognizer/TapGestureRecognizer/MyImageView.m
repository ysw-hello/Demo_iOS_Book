//
//  MyImageView.m
//  TapGestureRecognizer
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

#import "MyImageView.h"

@implementation MyImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


-(void)awakeFromNib
{
    NSBundle *bundle = [NSBundle mainBundle];
    
    self.imageTrashFull = [[UIImage alloc] initWithContentsOfFile:[bundle pathForResource:@"Blend Trash Full" ofType:@"png"]];
    self.imageTrashEmpty = [[UIImage alloc] initWithContentsOfFile:[bundle pathForResource:@"Blend Trash Empty" ofType:@"png"]];
    
    boolTrashEmptyFlag = NO; //垃圾桶满
    
    self.image = self.imageTrashFull;
    
}

/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if(touch.tapCount == 1) {
        [self foundTap];
    }
}
*/

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if(touch.tapCount == 1) {
        [self foundTap];
    }
}


- (void) foundTap{
    NSLog(@"tap");
    if (boolTrashEmptyFlag) {
        self.image = self.imageTrashFull;
        boolTrashEmptyFlag = NO;
    } else {
        self.image = self.imageTrashEmpty;
        boolTrashEmptyFlag = YES;
    }
}


@end
