//
//  ViewController.m
//  AudioRecorder
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
    
    _label.text = @"停止";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)record:(id)sender {
    
    if (recorder == nil) {
        
        NSString *filePath =
        [NSString stringWithFormat:@"%@/rec_audio.caf", [self documentsDirectory]];
        NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
        
        NSError *error = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord
                                               error:&error];
        [[AVAudioSession sharedInstance] setActive:YES error:&error];
        
        NSMutableDictionary *settings = [NSMutableDictionary dictionary];
        [settings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM]
                    forKey:AVFormatIDKey];
        [settings setValue:[NSNumber numberWithFloat:44100.0]
                    forKey:AVSampleRateKey];
        [settings setValue:[NSNumber numberWithInt:1]
                    forKey:AVNumberOfChannelsKey];
        [settings setValue:[NSNumber numberWithInt:16]
                    forKey:AVLinearPCMBitDepthKey];
        [settings setValue:[NSNumber numberWithBool:NO]
                    forKey:AVLinearPCMIsBigEndianKey];
        [settings setValue:[NSNumber numberWithBool:NO]
                    forKey:AVLinearPCMIsFloatKey];
        
        recorder = [[AVAudioRecorder alloc]
                    initWithURL:fileUrl
                    settings:settings
                    error:&error];
        
        recorder.delegate = self;
    }
    
    
	if(recorder.isRecording) {
        return;
    }
    
    if(player && player.isPlaying) {
        [player stop];
    }
    
    [recorder record];
    
    _label.text = @"录制中...";
    
}



- (IBAction)play:(id)sender
{
    
	if(recorder.isRecording) {
        [recorder stop];
        recorder.delegate = nil;
        [recorder release];
        recorder = nil;
    }
    if(player.isPlaying) {
        [player stop];
        [player release];
    }
    
    NSString *filePath =
    [NSString stringWithFormat:@"%@/rec_audio.caf", [self documentsDirectory]];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                           error:&error];
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:&error];
    
    if(error) {
        NSLog(@"%@",[error description]);
    } else {
        [player play];
        _label.text = @"播放...";
    }
    
}

- (IBAction)stop:(id)sender {
    
    _label.text = @"停止...";
    
	if(recorder.isRecording) {
        [recorder stop];
        recorder.delegate = nil;
        [recorder release];
        recorder = nil;
    }
    if(player.isPlaying) {
        [player stop];
        [player release];
    }
}


-(NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"录制完成。");
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"录制错误发生: %@", [error localizedDescription]);
}


- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder
{
    NSLog(@"播放中断。");
}


- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags
{
    NSLog(@"中断返回。");
}


- (void)dealloc {
    [_label release];
    [super dealloc];
}

@end
