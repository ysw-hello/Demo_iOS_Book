//
//  MIT License
//
//  Copyright (c) 2014 Bob McCune http://bobmccune.com/
//  Copyright (c) 2014 TapHarmonic, LLC http://tapharmonic.com/
//


#import "THPlayerController.h"
#import <AVFoundation/AVFoundation.h>

@interface THPlayerController () <AVAudioPlayerDelegate>
@property (strong, nonatomic) NSArray *players;
@end

@implementation THPlayerController

#pragma mark - Initialization

- (id)init {
    self = [super init];
    if (self) {
        AVAudioPlayer *guitarPlayer = [self playerForFile:@"guitar"];
        AVAudioPlayer *bassPlayer = [self playerForFile:@"bass"];
        AVAudioPlayer *drumsPlayer = [self playerForFile:@"drums"];

        guitarPlayer.delegate = self;

        _players = @[guitarPlayer, bassPlayer, drumsPlayer];

        NSNotificationCenter *nsnc = [NSNotificationCenter defaultCenter];
        [nsnc addObserver:self
                 selector:@selector(handleRouteChange:)
                     name:AVAudioSessionRouteChangeNotification
                   object:[AVAudioSession sharedInstance]];
    }
    return self;
}

- (AVAudioPlayer *)playerForFile:(NSString *)name {

    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:name
                                             withExtension:@"caf"];

    NSError *error;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL
                                                                   error:&error];
    if (player) {
        player.numberOfLoops = -1; // loop indefinitely
        player.enableRate = YES;
        [player prepareToPlay];
    } else {
        NSLog(@"Error creating player: %@", [error localizedDescription]);
    }

    return player;
}


#pragma mark - Global playback control methods

- (void)play {
    if (!self.playing) {
        NSTimeInterval delayTime = [self.players[0] deviceCurrentTime] + 0.01;
        for (AVAudioPlayer *player in self.players) {
            [player playAtTime:delayTime];
        }
        self.playing = YES;
    }
}

- (void)stop {
    if (self.playing) {
        for (AVAudioPlayer *player in self.players) {
            [player stop];
            player.currentTime = 0.0f;
        }
        self.playing = NO;
    }
}

- (void)adjustRate:(float)rate {
    for (AVAudioPlayer *player in self.players) {
        player.rate = rate;
    }
}


#pragma mark - Player-specific methods

- (void)adjustPan:(float)pan forPlayerAtIndex:(NSUInteger)index {
    if ([self isValidIndex:index]) {
        AVAudioPlayer *player = self.players[index];
        player.pan = pan;
    }
}

- (void)adjustVolume:(float)volume forPlayerAtIndex:(NSUInteger)index {
    if ([self isValidIndex:index]) {
        AVAudioPlayer *player = self.players[index];
        player.volume = volume;
    }
}

- (BOOL)isValidIndex:(NSUInteger)index {
    return index == 0 || index < self.players.count;
}


#pragma mark - Interruption Handlers

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    [self stop];
    if (self.delegate) {
        [self.delegate playbackStopped];
    }
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
                       withOptions:(NSUInteger)options {

    if (options == AVAudioSessionInterruptionOptionShouldResume) {
        [self play];
        if (self.delegate) {
            [self.delegate playbackBegan];
        }
    }
}

#pragma mark - Route Change Handler

- (void)handleRouteChange:(NSNotification *)notification {

    NSDictionary *info = notification.userInfo;

    AVAudioSessionRouteChangeReason reason =
        [info[AVAudioSessionRouteChangeReasonKey] unsignedIntValue];

    if (reason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        //耳机线路
        AVAudioSessionRouteDescription *previousRoute =
            info[AVAudioSessionRouteChangePreviousRouteKey];

        AVAudioSessionPortDescription *previousOutput = previousRoute.outputs[0];
        NSString *portType = previousOutput.portType;
        //耳机拔出
        if ([portType isEqualToString:AVAudioSessionPortHeadphones]) {
            [self stop];
            [self.delegate playbackStopped];
        }
    }
}

@end
