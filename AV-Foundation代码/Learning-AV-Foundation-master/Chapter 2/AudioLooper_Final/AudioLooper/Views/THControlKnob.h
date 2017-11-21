//
//  MIT License
//
//  Copyright (c) 2014 Bob McCune http://bobmccune.com/
//  Copyright (c) 2014 TapHarmonic, LLC http://tapharmonic.com/
//

@interface THControlKnob : UIControl

@property (nonatomic) float maximumValue;
@property (nonatomic) float minimumValue;
@property (nonatomic) float value;
@property (nonatomic) float defaultValue;

@end

@interface THGreenControlKnob : THControlKnob

@end

@interface THOrangeControlKnob : THControlKnob

@end

