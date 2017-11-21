//
//  MIT License
//
//  Copyright (c) 2014 Bob McCune http://bobmccune.com/
//  Copyright (c) 2014 TapHarmonic, LLC http://tapharmonic.com/
//


@interface THLevelMeterView : UIView

@property (nonatomic) CGFloat level;
@property (nonatomic) CGFloat peakLevel;

- (void)resetLevelMeter;

@end
