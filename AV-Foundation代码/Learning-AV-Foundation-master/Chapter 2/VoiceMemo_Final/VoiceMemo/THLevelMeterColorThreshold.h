//
//  MIT License
//
//  Copyright (c) 2014 Bob McCune http://bobmccune.com/
//  Copyright (c) 2014 TapHarmonic, LLC http://tapharmonic.com/
//


@interface THLevelMeterColorThreshold : NSObject

@property (nonatomic, readonly) CGFloat maxValue;
@property (nonatomic, strong, readonly) UIColor *color;
@property (nonatomic, copy, readonly) NSString *name;

+ (instancetype)colorThresholdWithMaxValue:(CGFloat)maxValue color:(UIColor *)color name:(NSString *)name;

@end
