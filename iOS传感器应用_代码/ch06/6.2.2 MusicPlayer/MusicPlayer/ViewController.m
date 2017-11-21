//
//  ViewController.m
//  MusicPlayer
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [player release];
    [super dealloc];
}

- (IBAction)playSound:(id)sender
{
    
    NSLog(@"player %i",player.isPlaying);
    
    NSError *error = nil;
    if (player == nil) {
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:
                  [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                          pathForResource:@"test" ofType:@"caf"]] error:&error];
        player.delegate = self;
    }
    
    if(error) {
        NSLog(@"%@",[error description]);
    } else {
        [player play];
    }
    
}

- (IBAction)stopSound:(id)sender {
    if (player) {
        [player stop];
        player.delegate = nil;
        [player release];
        player = nil;
    }
}


- (IBAction)pauseSound:(id)sender {
    
    if (player && player.isPlaying) {
        [player pause];
    }
}

#pragma mark--实现AVAudioPlayerDelegate协议方法

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	NSLog(@"播放完成。");
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
	NSLog(@"播放错误发生: %@", [error localizedDescription]);
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    NSLog(@"中断返回。");
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    NSLog(@"播放中断。");
}


@end
