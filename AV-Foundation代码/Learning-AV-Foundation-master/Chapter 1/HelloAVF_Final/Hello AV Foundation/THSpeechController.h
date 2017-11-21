//
//  MIT License
//
//  Copyright (c) 2014 Bob McCune http://bobmccune.com/
//  Copyright (c) 2014 TapHarmonic, LLC http://tapharmonic.com/
//

#import <AVFoundation/AVFoundation.h>

@interface THSpeechController : NSObject

@property (strong, nonatomic, readonly) AVSpeechSynthesizer *synthesizer;

+ (instancetype)speechController;
- (void)beginConversation;

@end
