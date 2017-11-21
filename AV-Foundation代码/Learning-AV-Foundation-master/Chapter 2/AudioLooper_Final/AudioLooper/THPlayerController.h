//
//  MIT License
//
//  Copyright (c) 2014 Bob McCune http://bobmccune.com/
//  Copyright (c) 2014 TapHarmonic, LLC http://tapharmonic.com/
//


@protocol THPlayerControllerDelegate <NSObject>
- (void)playbackStopped;
- (void)playbackBegan;
@end

@interface THPlayerController : NSObject

@property (nonatomic, getter = isPlaying) BOOL playing;
@property (weak, nonatomic) id <THPlayerControllerDelegate> delegate;

// Global methods
- (void)play;
- (void)stop;
- (void)adjustRate:(float)rate;

// Player-specific methods
- (void)adjustPan:(float)pan forPlayerAtIndex:(NSUInteger)index;
- (void)adjustVolume:(float)volume forPlayerAtIndex:(NSUInteger)index;

@end
