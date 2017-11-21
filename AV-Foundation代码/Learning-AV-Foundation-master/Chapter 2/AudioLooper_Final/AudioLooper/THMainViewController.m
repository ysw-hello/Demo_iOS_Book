//
//  MIT License
//
//  Copyright (c) 2014 Bob McCune http://bobmccune.com/
//  Copyright (c) 2014 TapHarmonic, LLC http://tapharmonic.com/
//


#import "THMainViewController.h"
#import "THPlayerController.h"
#import "THControlKnob.h"

@interface THMainViewController () <THPlayerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *playLabel;
@property (weak, nonatomic) IBOutlet THControlKnob *rateKnob;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutletCollection(THControlKnob) NSArray *panKnobs;
@property (strong, nonatomic) IBOutletCollection(THControlKnob) NSArray *volumeKnobs;
@property (strong, nonatomic) THPlayerController *controller;

@end

@implementation THMainViewController

- (void)viewDidLoad {
    self.controller = [[THPlayerController alloc] init];
    self.controller.delegate = self;

    self.rateKnob.minimumValue = 0.5f;
    self.rateKnob.maximumValue = 1.5f;
    self.rateKnob.value = 1.0f;
    self.rateKnob.defaultValue = 1.0f;

    // Panning L = -1, C = 0, R = 1
    for (THControlKnob *knob in self.panKnobs) {
        knob.minimumValue = -1.0f;
        knob.maximumValue = 1.0f;
        knob.value = 0.0f;
        knob.defaultValue = 0.0f;
    }

    // Volume Ranges from 0..1
    for (THControlKnob *knob in self.volumeKnobs) {
        knob.minimumValue = 0.0f;
        knob.maximumValue = 1.0f;
        knob.value = 1.0f;
        knob.defaultValue = 1.0f;
    }
}

- (IBAction)play:(UIButton *)sender {
    if (!self.controller.isPlaying) {
        [self.controller play];
        self.playLabel.text = NSLocalizedString(@"Stop", nil);
    } else {
        [self.controller stop];
        self.playLabel.text = NSLocalizedString(@"Play", nil);
    }
    self.playButton.selected = !self.playButton.selected;
}

- (IBAction)adjustRate:(THControlKnob *)sender {
    [self.controller adjustRate:sender.value];
}

- (IBAction)adjustPan:(THControlKnob *)sender {
    [self.controller adjustPan:sender.value forPlayerAtIndex:sender.tag];
}

- (IBAction)adjustVolume:(THControlKnob *)sender {
    [self.controller adjustVolume:sender.value forPlayerAtIndex:sender.tag];
}

#pragma mark - THPlayerControllerDelegate Methods

- (void)playbackStopped {
    self.playButton.selected = NO;
    self.playLabel.text = NSLocalizedString(@"Play", nil);
}

- (void)playbackBegan {
    self.playButton.selected = YES;
    self.playLabel.text = NSLocalizedString(@"Stop", nil);
}
//隐藏系统状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
