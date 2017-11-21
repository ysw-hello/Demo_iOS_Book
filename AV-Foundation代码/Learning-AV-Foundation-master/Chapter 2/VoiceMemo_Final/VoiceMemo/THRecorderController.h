//
//  MIT License
//
//  Copyright (c) 2014 Bob McCune http://bobmccune.com/
//  Copyright (c) 2014 TapHarmonic, LLC http://tapharmonic.com/
//
#import <Foundation/Foundation.h>

@protocol THRecorderControllerDelegate <NSObject>

- (void)interruptionBegan;

@end

typedef void(^THRecordingStopCompletionHandler)(BOOL);
typedef void(^THRecordingSaveCompletionHandler)(BOOL, id);

@class THMemo;
@class THLevelPair;

@interface THRecorderController : NSObject

@property (nonatomic, readonly) NSString *formattedCurrentTime;
@property (weak, nonatomic) id <THRecorderControllerDelegate> delegate;

// Recorder methods
- (BOOL)record;

- (void)pause;

- (void)stopWithCompletionHandler:(THRecordingStopCompletionHandler)handler;

- (void)saveRecordingWithName:(NSString *)name
            completionHandler:(THRecordingSaveCompletionHandler)handler;

- (THLevelPair *)levels;

// Player methods
- (BOOL)playbackMemo:(THMemo *)memo;

@end
